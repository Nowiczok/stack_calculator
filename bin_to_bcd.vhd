library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity bin_to_bcd is
    Port ( Din : in  STD_LOGIC := '0';
           clk : in  STD_LOGIC := '0';
           clear : in  STD_LOGIC := '0';
           ce : in  STD_LOGIC := '0';
           Dout : out  STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
			  Cout : out STD_LOGIC := '0');
end bin_to_bcd;

architecture Behavioral of bin_to_bcd is
	type states is (zero, one, two, three, four, five, six, seven, eight, nine);
	signal current_state : states := zero;	
begin

	decide_next_state: process (clk)
	begin
		if rising_edge(clk) then
			if ce = '1' then
				if clear = '1' then
					current_state <= zero;					
				else
					case current_state is 
						when zero => 
							if Din = '0' then
								current_state <= zero;
							else
								current_state <= one;
							end if;
							
						when one => 
							if Din = '0' then
								current_state <= two;
							else
								current_state <= three;
							end if;
							
						when two => 
							if Din = '0' then
								current_state <= four;
							else
								current_state <= five;
							end if;
							
						when three => 
							if Din = '0' then
								current_state <= six;
							else
								current_state <= seven;
							end if;
							
						when four => 
							if Din = '0' then
								current_state <= eight;
							else
								current_state <= nine;
							end if;
						
						when five => 
							if Din = '0' then
								current_state <= zero;								
							else
								current_state <= one;
							end if;
						
						when six => 
							if Din = '0' then
								current_state <= two;								
							else
								current_state <= three;
							end if;
						
						when seven => 
							if Din = '0' then
								current_state <= four;								
							else
								current_state <= five;
							end if;
						
						when eight => 
							if Din = '0' then
								current_state <= six;								
							else
								current_state <= seven;
							end if;
						
						when others => 
							if Din = '0' then
								current_state <= eight;								
							else
								current_state <= nine;
							end if;
						
					end case;
				end if;
			end if;
		end if;
	end process;

	with current_state select Dout <=
		"0000" when zero,
		"0001" when one,
		"0010" when two,
		"0011" when three,
		"0100" when four,
		"0101" when five,
		"0110" when six,
		"0111" when seven,
		"1000" when eight,
		"1001" when nine;
		
	with current_state select Cout <=
		'0' when zero,
		'0' when one,
		'0' when two,
		'0' when three,
		'0' when four,
		'1' when five,
		'1' when six,
		'1' when seven,
		'1' when eight,
		'1' when nine;

end Behavioral;

