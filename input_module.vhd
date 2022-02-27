library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity input_module is
    Port ( D_in : in  unsigned (3 downto 0) := (others => '0');
           push : in  STD_LOGIC := '0';
           backspace : in  STD_LOGIC := '0';
           clk : in  STD_LOGIC := '0';
           digit_0 : out  unsigned (3 downto 0) := (others => '0');
           digit_1 : out  unsigned (3 downto 0) := (others => '0');
           digit_2 : out  unsigned (3 downto 0) := (others => '0'));
end input_module;

architecture Behavioral of input_module is

	type states is (idle, prep_push, prep_backspace, ex_push, ex_backspace);

	signal cur_state, next_state : states := idle;

	signal dig_0, dig_1, dig_2, n_dig_0, n_dig_1, n_dig_2 : unsigned(3 downto 0) := (others => '0');

begin
	
	state_update: process(clk)
	begin
		if rising_edge(clk) then
			cur_state <= next_state;
			
			digit_0 <= dig_0;
			digit_1 <= dig_1;
			digit_2 <= dig_2;
			
			n_dig_0 <= dig_0;
			n_dig_1 <= dig_1;
			n_dig_2 <= dig_2;
		end if;
	end process;
	
	combinational: process(n_dig_0, n_dig_1, n_dig_2, D_in, push, backspace, cur_state)
	begin
			case cur_state is
				
				when idle =>
				
					dig_0 <= n_dig_0;
					dig_1 <= n_dig_1;
					dig_2 <= n_dig_2;
					
					if push = '1' and backspace = '0' then
						next_state <= prep_push;
					elsif push = '0' and backspace = '1' then
						next_state <= prep_backspace;
					else
						next_state <= idle;
					end if;
				
				when prep_push =>
				
					dig_0 <= n_dig_0;
					dig_1 <= n_dig_1;
					dig_2 <= n_dig_2;
				
					if push = '0' and backspace = '0' then
						next_state <= ex_push;
					else
						next_state <= prep_push;
					end if;
					
				when prep_backspace =>
				
					dig_0 <= n_dig_0;
					dig_1 <= n_dig_1;
					dig_2 <= n_dig_2;
				
					if push = '0' and backspace = '0' then
						next_state <= ex_backspace;
					else
						next_state <= prep_backspace;
					end if;
					
				when ex_push =>
				
					dig_0 <= D_in;
					dig_1 <= n_dig_0;
					dig_2 <= n_dig_1;
				
					if push = '1' and backspace = '0' then
						next_state <= prep_push;
					elsif push = '0' and backspace = '1' then
						next_state <= prep_backspace;
					else
						next_state <= idle;
					end if;
					
				when ex_backspace =>
					
					dig_0 <= n_dig_1;
					dig_1 <= n_dig_2;
					dig_2 <= (others => '0');
					
					if push = '1' and backspace = '0' then
						next_state <= prep_push;
					elsif push = '0' and backspace = '1' then
						next_state <= prep_backspace;
					else
						next_state <= idle;
					end if;
						
			end case;
	end process;
	
	
end Behavioral;

