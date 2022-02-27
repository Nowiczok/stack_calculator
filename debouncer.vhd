library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity debouncer is
    Port ( input : in  STD_LOGIC := '0';
           clk : in  STD_LOGIC := '0';
           debounced : out  STD_LOGIC := '0');
end debouncer;

architecture Behavioral of debouncer is
	signal counter : unsigned(19 downto 0) := (others => '1');
begin
	
	process(clk) 
	begin
		if rising_edge(clk) then
			if(not input) = '0' then --if button is depressed
				counter <= (others => '1'); --get ready to count down
			else
				if counter /= 0 then
					counter <= counter - 1; --count down when is pressed
				end if;
			end if;
		end if;
	end process;

	debounced <= '1' when counter = 0 else '0'; --only after some time of stability output will be driven high

end Behavioral;

