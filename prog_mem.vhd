library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity prog_mem is
    Port ( D_in : in  unsigned (9 downto 0);
           we : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           addr : in  unsigned (3 downto 0);
           D_out : out  unsigned (9 downto 0) := (others => '0'));
end prog_mem;

architecture Behavioral of prog_mem is
	type memory is array (15 downto 0) of unsigned(9 downto 0);
	signal mem: memory := ("0000000000", "0000000000", "0000000000", 
	"0000000000", "0000000000", "0000000000", "0000000000", "0000000000",
	"1111111100", "1111111110", "1000000000", "1111111101",
	 "0000000110", "1111111111","0000000111","0000001100");
begin

	process(clk)
	begin
		if rising_edge(clk) then
			if we = '1' then
				mem(to_integer(addr)) <= D_in;
			end if;
			
			D_out <= mem(to_integer(addr));
			
		end if;
	end process;

end Behavioral;

