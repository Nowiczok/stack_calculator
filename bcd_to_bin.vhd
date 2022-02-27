library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity bcd_to_bin is
    Port ( d_in0 : in  unsigned (3 downto 0) := (others => '0');
           d_in1 : in  unsigned (3 downto 0) := (others => '0');
           d_in2 : in  unsigned (3 downto 0) := (others => '0');
           clk : in  STD_LOGIC;
           convert : in  STD_LOGIC;
           d_out : out  unsigned (9 downto 0) := (others => '0'));
end bcd_to_bin;

architecture Behavioral of bcd_to_bin is

component mul_10 is
    Port ( input : in  unsigned (9 downto 0);
           output : out  unsigned (9 downto 0));
end component;

component mul_100 is
    Port ( input : in  unsigned (9 downto 0);
           output : out  unsigned (9 downto 0));
end component;

	signal mul_10_in, mul_100_in, mul_10_out, mul_100_out : unsigned(9 downto 0) := (others => '0');
begin

m10: mul_10 port map (input => mul_10_in, output => mul_10_out);
m100: mul_100 port map (input => mul_100_in, output => mul_100_out);

mul_10_in <= "000000" & d_in1;
mul_100_in <= "000000" & d_in2;

next_state_proc: process(clk)
begin
	if rising_edge(clk) and convert = '1' then
		if d_in0 < 10 then
			d_out <= d_in0 + mul_10_out + mul_100_out;
		else
			case d_in0 is
				when "1010" => 
					d_out <= "1111111111"; -- '+'
				when "1011" => 
					d_out <= "1111111110"; -- '-'
				when "1100" => 
					d_out <= "1111111101"; -- '*'
				when others => 
					d_out <= "1111111100"; -- 'end'
			end case;
		end if;
	end if;
end process;

end Behavioral;

