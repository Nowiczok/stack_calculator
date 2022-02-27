library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RPN_processor is
    Port ( clk : in  STD_LOGIC;
           compute : in  STD_LOGIC;
           D_in : in  unsigned (9 downto 0);
           addr : out  unsigned (3 downto 0) := (others => '0');
           D_out : out  unsigned (9 downto 0) := (others => '0');
			  ready : out std_logic);
end RPN_processor;

architecture Behavioral of RPN_processor is
	component stack is
		Port ( D_in : in  unsigned (9 downto 0) := (others => '0');
           push : in  STD_LOGIC := '0';
           pop : in  STD_LOGIC := '0';
			  clk : in std_logic := '0';
           D_out : out  unsigned (9 downto 0) := (others => '0'));
	end component;
	
	component ALU is
		Port ( clk : in  STD_LOGIC;
           operation : in  unsigned (2 downto 0);
           D1 : in  unsigned (9 downto 0);
           D2 : in  unsigned (9 downto 0);
           S : out  unsigned (9 downto 0));
	end component; 
	
	signal push, pop, delay, delay_n: std_logic := '0';
	signal data_to_stack, data_from_stack, D1, D1_n, D2, D2_n, S, D_out_n, A, A_n, D_out_buf: unsigned(9 downto 0) := (others => '0');
	signal operation, operation_n: unsigned(2 downto 0) := (others => '0');
	signal prog_counter, prog_counter_n: unsigned(3 downto 0) := (others => '0');
	
	type states is (idle, prep, fetch, decide, pop1, pop2, exec, to_stack, end_comp);
	signal curr_state, next_state: states := idle;
	
begin

	stack1: stack port map(D_in => data_to_stack, push => push, pop => pop, clk => clk, D_out => data_from_stack);
	ALU1: ALU port map(clk => clk, operation => operation, D1 => D1, D2 => D2, S => S);
	
	synch_proc: process(clk)
	begin
		if rising_edge(clk) then
			D_out_buf <= D_out_n;
			curr_state <= next_state;
			addr <= prog_counter_n;
			prog_counter <= prog_counter_n;
			A <= A_n;
			operation <= operation_n;
			D1 <= D1_n;
			D2 <= D2_n;
			delay <= delay_n;
		end if;
	end process;
	
	D_out <= D_out_buf;
	
	comb_proc: process(compute, D_in, curr_state, A, data_from_stack, prog_counter, delay, S, operation, D1, D2, D_out_buf)
	begin
		case curr_state is
		
			when idle =>
				operation_n <= operation;
				D1_n <= D1;
				D2_n <= D2;
				D_out_n <= data_from_stack;
				ready <= '0';
				pop <= '0';
				push <= '0';
				delay_n <= '0';
				prog_counter_n <= (others => '0');
				ready <= '0';
				A_n <= A;
				if compute = '1' then
					next_state <= prep;
				else
					next_state <= idle;
				end if;
				
			when prep =>
				operation_n <= operation;
				D_out_n <= D_out_buf;
				D1_n <= D1;
				D2_n <= D2;
				prog_counter_n <= prog_counter;
				pop <= '0';
				push <= '0';
				delay_n <= '0';
				ready <= '0';
				A_n <= A;
				if compute = '0' then
					next_state <= fetch;
				else
					next_state <= prep;
				end if;
			
			when fetch =>
				operation_n <= operation;
				D_out_n <= D_out_buf;
				D1_n <= D1;
				D2_n <= D2;
				prog_counter_n <= prog_counter;
				A_n <= D_in; --Collect data from memory
				pop <= '0';
				push <= '0';
				delay_n <= '0';
				ready <= '0';
				next_state <= decide;
			
			when decide =>
				prog_counter_n <= prog_counter + 1; --prepare next address
				D_out_n <= D_out_buf;
				D1_n <= D1;
				D2_n <= D2;
				push <= '0';
				delay_n <= '0';
				ready <= '0';
				A_n <= A;
				if A < 1000 then
					next_state <= to_stack; --number, push to stack
					operation_n <= operation;
					pop <= '0';
				elsif A = 1023 then
					operation_n <= "000"; --operator, set ALU control register
					pop <= '1';
					next_state <= pop1;
				elsif A = 1022 then
					operation_n <= "001";
					pop <= '1';
					next_state <= pop1;
				elsif A = 1021 then
					operation_n <= "010";
					pop <= '1';
					next_state <= pop1;
				else --end computation
					pop <= '0';
					next_state <= end_comp;
					operation_n <= operation;
				end if;
					
			when pop1 =>
				operation_n <= operation;
				D_out_n <= D_out_buf;
				prog_counter_n <= prog_counter;
				D2_n <= D2;
				D1_n <= data_from_stack; --data is waiting
				pop <= '1';
				push <= '0';
				ready <= '0';
				A_n <= A;
				if delay = '0' then --wait one cycle
					next_state <= pop1;
					delay_n <= '1';
				else
					next_state <= pop2;
					delay_n <= '0';
				end if;
			
			when pop2 => 
				operation_n <= operation;
				D_out_n <= D_out_buf;
				D1_n <= D1;
				prog_counter_n <= prog_counter;
				D2_N <= data_from_stack;
				pop <= '0'; --perform two pops
				push <= '0';
				delay_n <= '0';
				ready <= '0';
				A_n <= A;
				next_state <= exec;
			
			when exec =>
				operation_n <= operation;
				D_out_n <= D_out_buf;
				D1_n <= D1;
				D2_n <= D2;
				prog_counter_n <= prog_counter;
				A_n <= S; --solution should be ready
				pop <= '0';
				push <= '0';
				delay_n <= '0';
				ready <= '0';
				if delay = '0' then
					delay_n <= '1';
					next_state <= exec;
				else
					next_state <= to_stack;
					delay_n <= '0';
				end if;
				
			when to_stack =>
				operation_n <= operation;
				D_out_n <= D_out_buf;
				D1_n <= D1;
				D2_n <= D2;
				prog_counter_n <= prog_counter;			
				pop <= '0';
				push <= '1';
				delay_n <= '0';
				ready <= '0';
				A_n <= A;
				next_state <= fetch;
				
			when end_comp =>
				operation_n <= operation;
				D_out_n <= D_out_buf;
				D1_n <= D1;
				D2_n <= D2;
				prog_counter_n <= prog_counter;
				pop <= '1';
				push <= '0'; 
				delay_n <= '0';
				ready <= '1';
				A_n <= A;
				next_state <= idle;				
				
		end case; 
	end process;
	
	data_to_stack <= A;
	
end Behavioral;
















