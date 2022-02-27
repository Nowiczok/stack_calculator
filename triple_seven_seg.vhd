library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity triple_seven_seg is
    Port ( a0 : in  STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
           a1 : in  STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
           a2 : in  STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
			  ce : in STD_LOGIC;
			  sel_channel : out unsigned (2 downto 0) := (others => '0');
           clk : in  STD_LOGIC;
           output : out  STD_LOGIC_VECTOR (6 downto 0) := (others => '0'));
end triple_seven_seg;

architecture Behavioral of triple_seven_seg is

	component seven_seg is
    Port ( bcd : in  STD_LOGIC_VECTOR (3 downto 0);
           sev_seg : out  STD_LOGIC_VECTOR (6 downto 0));
	end component;

	signal counter : unsigned(1 downto 0) := (others => '0');
	signal seven_seg_in : std_logic_vector(3 downto 0) := (others => '0');
begin
	converter : seven_seg port map(bcd => seven_seg_in, sev_seg => output);
	 
	process(clk)
	begin
		if rising_edge(clk) and ce = '1' then
			if counter = "10" then
				counter <= "00";
			else
				counter <= counter + 1;
			end if;
			
		end if;
	end process;
	
	with counter select
	seven_seg_in <= a0 when "00",
						 a1 when "01",
						 a2 when others;
	
	with counter select
	sel_channel <= "110" when "00",
						"101" when "01",
						"011" when others;

end Behavioral;

