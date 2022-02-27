library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity main is
    Port ( push : in  STD_LOGIC;
			  backspace : in std_logic;
			  enter : in std_logic;
			  show : in std_logic;
			  compute : in std_logic;
           clk : in  STD_LOGIC;
           D_in_vec : in  STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
			  addr_vec: in STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
           display_out : out  STD_LOGIC_VECTOR (6 downto 0) := (others => '0');
           sel_vec : out  STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
			  operator_flag : out std_logic);
end main;

architecture Behavioral of main is

component debouncer is
Port ( input : in  STD_LOGIC := '0';
       clk : in  STD_LOGIC := '0';
       debounced : out  STD_LOGIC := '0');
end component;

component display_module is
	 Generic (freq_div : integer);
    Port ( D_in : in  STD_LOGIC_VECTOR (9 downto 0);
           display : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           D_out : out  STD_LOGIC_VECTOR (6 downto 0);
           sel : out  unsigned (2 downto 0);
			  operator_flag : out std_logic);
end component;

component input_s_bcd is
	 Port ( D_in : in  unsigned (3 downto 0);
           push : in  STD_LOGIC;
           backspace : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           D_out : out  unsigned (9 downto 0));
end component;

component prog_mem is
	Port ( D_in : in  unsigned (9 downto 0);
           we : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           addr : in  unsigned (3 downto 0);
           D_out : out  unsigned (9 downto 0));
end component;

component RPN_processor is
	Port ( clk : in  STD_LOGIC;
           compute : in  STD_LOGIC;
           D_in : in  unsigned (9 downto 0);
           addr : out  unsigned (3 downto 0);
           D_out : out  unsigned (9 downto 0);
			  ready : out std_logic);
end component;

signal D_in, addr: unsigned(3 downto 0);
signal sel: unsigned(2 downto 0);

signal push_debounced, backspace_debounced, enter_debounced, show_debounced, compute_debounced, display, prepare, ready : std_logic := '0';
signal addr_from_user: std_logic := '1';
signal converted_input, computed_num, display_buf, mem_buf: unsigned(9 downto 0) := (others => '0');
signal addr_buf, addr_proc: unsigned(3 downto 0) := (others => '0');
signal counter: unsigned(2 downto 0) := (others => '0');

type trig_source is (memory, input, comp);
signal trig: trig_source;


begin

D_in <= unsigned(D_in_vec);
addr <= unsigned(addr_vec);
sel_vec <= std_logic_vector(sel);

	push_debouncer: debouncer port map(input => push, clk => clk, debounced => push_debounced);
	backspace_debouncer: debouncer port map(input => backspace, clk => clk, debounced => backspace_debounced);
	enter_debouncer: debouncer port map(input => enter, clk => clk, debounced => enter_debounced);
	show_debouncer: debouncer port map(input => show, clk => clk, debounced => show_debounced);
	compute_debouncer: debouncer port map (input => compute, clk => clk, debounced => compute_debounced);
	
	dis_mod: display_module generic map(freq_div => 1000) port map(D_in => std_logic_vector(display_buf), display => display, clk => clk, D_out => display_out, sel => sel, operator_flag => operator_flag);
	input_mod: input_s_bcd port map(D_in => D_in, push => push_debounced, backspace => backspace_debounced, clk => clk, D_out => converted_input);
--	dis_mod: display_module generic map(freq_div => 1) port map(D_in => std_logic_vector(display_buf), display => display, clk => clk, D_out => display_out, sel => sel, operator_flag => operator_flag);
--	input_mod: input_s_bcd port map(D_in => D_in, push => push, backspace => backspace, clk => clk, D_out => converted_input);

	mem: prog_mem port map(D_in => converted_input, we => enter_debounced, clk => clk, addr => addr_buf, D_out => mem_buf);
	processor: RPN_processor port map(clk => clk, compute => compute_debounced, D_in => mem_buf, addr => addr_proc, D_out => computed_num, ready => ready);
--	mem: prog_mem port map(D_in => converted_input, we => enter, clk => clk, addr => addr_buf, D_out => mem_buf);
--	processor: RPN_processor port map(clk => clk, compute => compute, D_in => mem_buf, addr => addr_proc, D_out => computed_num, ready => ready);
	
	display_proc: process(clk)
	begin
		if rising_edge(clk) then
			if push_debounced = '1' or backspace_debounced = '1' or show_debounced = '1' or ready = '1' then --trigger
				prepare <= '1';
				counter <= (others => '0');
				if push_debounced = '1' or backspace_debounced = '1' then --trigger from input
					trig <= input;
				elsif show_debounced = '1' then --trigger form memory
					trig <= memory;
				else --triggrt from computation
					trig <= comp;
				end if;
			elsif push_debounced = '0' and backspace_debounced = '0' and show_debounced = '0' and ready = '0' and prepare = '1' then --start counting
				counter <= counter + 1;
				prepare <= '0';
			elsif counter > 0 then
				if counter < 4 then
					counter <= counter + 1;
				else
					if trig = memory then
						display_buf <= mem_buf;
					elsif trig = input then
						display_buf <= converted_input;
					else
						display_buf <= computed_num;
					end if;
					display <= '1';
					counter <= (others => '0');
				end if;
			else
				display_buf <= display_buf; --hold data
				display <= '0';
			end if;
		end if;
	end process;
	
	addr_process: process(clk)
	begin
		if rising_edge(clk) then
			if compute_debounced = '1' and ready = '0' then --computation starts, memory takes address from porcessor
				addr_from_user <= '0';
			elsif compute_debounced = '0' and ready = '1' then --computation finished, memory takes address from user
				addr_from_user <= '1';
			else --something is running, so hold source
				addr_from_user <= addr_from_user;
			end if;
		end if;
	end process;
	
	with addr_from_user select addr_buf <=
		addr when '1',
		addr_proc when others;

--addr_process: process(clk)
--	begin
--		if rising_edge(clk) then
--			if compute = '1' and ready = '0' then --computation starts, memory takes address from porcessor
--				addr_from_user <= '0';
--			elsif compute = '0' and ready = '1' then --computation finished, memory takes address from user
--				addr_from_user <= '1';
--			else --something is running, so hold source
--				addr_from_user <= addr_from_user;
--			end if;
--		end if;
--	end process;
--	
--display_proc: process(clk)
--	begin
--		if rising_edge(clk) then
--			if push = '1' or backspace = '1' or show = '1' or ready = '1' then --trigger
--				prepare <= '1';
--				counter <= (others => '0');
--				if push = '1' or backspace = '1' then --trigger from input
--					trig <= input;
--				elsif show = '1' then --trigger form memory
--					trig <= memory;
--				else --trigger from computation
--					trig <= comp;
--				end if;
--			elsif push = '0' and backspace = '0' and show = '0' and ready = '0' and prepare = '1' then --start counting
--				counter <= counter + 1;
--				prepare <= '0';
--			elsif counter > 0 then
--				if counter < 4 then
--					counter <= counter + 1;
--				else
--					if trig = memory then
--						display_buf <= mem_buf;
--					elsif trig = input then
--						display_buf <= converted_input;
--					else
--						display_buf <= computed_num;
--					end if;
--					display <= '1';
--					counter <= (others => '0');
--				end if;
--			else
--				display_buf <= display_buf; --hold data
--				display <= '0';
--			end if;
--		end if;
--	end process;

end Behavioral;

