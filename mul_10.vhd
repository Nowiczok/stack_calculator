library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mul_10 is
    Port ( input : in  unsigned (9 downto 0) := (others => '0');
           output : out  unsigned (9 downto 0) := (others => '0'));
end mul_10;

architecture Behavioral of mul_10 is

begin

	with input select output <=
		"0000000000" when "0000000000",--0
		"0000001010" when "0000000001",--1
		"0000010100" when "0000000010",--2
		"0000011110" when "0000000011",--3
		"0000101000" when "0000000100",--4
		"0000110010" when "0000000101",--5
		"0000111100" when "0000000110",--6
		"0001000110" when "0000000111",--7
		"0001010000" when "0000001000",--8
		"0001011010" when others;--9

end Behavioral;

