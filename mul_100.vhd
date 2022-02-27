library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mul_100 is
    Port ( input : in  unsigned (9 downto 0) := (others => '0');
           output : out  unsigned (9 downto 0) := (others => '0'));
end mul_100;

architecture Behavioral of mul_100 is

begin

	with input select output <=
		"0000000000" when "0000000000",--0
		"0001100100" when "0000000001",--1
		"0011001000" when "0000000010",--2
		"0100101100" when "0000000011",--3
		"0110010000" when "0000000100",--4
		"0111110100" when "0000000101",--5
		"1001011000" when "0000000110",--6
		"1010111100" when "0000000111",--7
		"1100100000" when "0000001000",--8
		"1110000100" when others;--9


end Behavioral;

