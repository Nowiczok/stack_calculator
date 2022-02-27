library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
    Port ( clk : in  STD_LOGIC;
           operation : in  unsigned (2 downto 0) := (others => '0');
           D1 : in  unsigned (9 downto 0) := (others => '0');
           D2 : in  unsigned (9 downto 0) := (others => '0');
           S : out  unsigned (9 downto 0) := (others => '0'));
end ALU;

architecture Behavioral of ALU is
	signal aux: unsigned(19 downto 0) := (others => '0');
	signal add: unsigned(9 downto 0) := (others => '0');
	signal subt: unsigned(9 downto 0) := (others => '0');
	signal mul: unsigned(9 downto 0) := (others => '0');
begin
	process(clk)
	begin
		if rising_edge(clk) then
			if operation = "000" then
				S <= add;
			elsif operation = "001" then
				S <= subt;
			else
				S <= mul;
			end if;
		end if;
	end process;
	
add <= D1 + D2;
subt <= D1 - D2;
aux <= D1 * D2;
mul <= aux(9 downto 0);

end Behavioral;

