
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity seven_seg is
    Port ( bcd : in  STD_LOGIC_VECTOR (3 downto 0);
           sev_seg : out  STD_LOGIC_VECTOR (6 downto 0));
end seven_seg;

architecture Behavioral of seven_seg is

begin
	--"ABCDEFG"
	with bcd select
	sev_seg <= "0000001" when "0000",
				  "1001111" when "0001",
				  "0010010" when "0010",
				  "0000110" when "0011",
				  "1001100" when "0100",
				  "0100100" when "0101",
				  "0100000" when "0110",
				  "0001111" when "0111",
				  "0000000" when "1000",
				  "0000100" when "1001",
				  "1111111" when others;

end Behavioral;

