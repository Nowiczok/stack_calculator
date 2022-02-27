library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity display_module is
	 Generic (freq_div : integer);
    Port ( D_in : in  STD_LOGIC_VECTOR (9 downto 0);
           display : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           D_out : out  STD_LOGIC_VECTOR (6 downto 0);
           sel : out  unsigned (2 downto 0) := (others => '0');
			  operator_flag : out std_logic := '0');
end display_module;

architecture Behavioral of display_module is
	component bin_bcd_multi_digit is
		Port ( Din : in  STD_LOGIC_VECTOR (9 downto 0) := (others => '0');
           clk : in  STD_LOGIC := '0';
           ce : in  STD_LOGIC := '0';
			  convert : in std_logic := '0';
           Dout0 : out  STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
           Dout1 : out  STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
           Dout2 : out  STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
			  operator_flag : out std_logic);
	end component;
	
	component triple_seven_seg is
		 Port ( a0 : in  STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
           a1 : in  STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
           a2 : in  STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
			  ce : in STD_LOGIC;
			  sel_channel : out unsigned (2 downto 0) := (others => '0');
           clk : in  STD_LOGIC;
           output : out  STD_LOGIC_VECTOR (6 downto 0) := (others => '0'));
	end component;
	
	signal a0, a1, a2: std_logic_vector(3 downto 0) := (others => '0');
	signal ce: std_logic := '0';
	signal counter: unsigned(10 downto 0) := (others => '0'); --2k max 
	
begin
	
	converter: bin_bcd_multi_digit port map(Din => D_in, clk => clk, ce => '1', convert => display, Dout0 => a0, Dout1 => a1, Dout2 => a2, operator_flag => operator_flag);
	seven_seg: triple_seven_seg port map(a0 => a0, a1 => a1, a2 => a2, ce => ce, sel_channel => sel, clk => clk, output => D_out);
	
	clk_enabling: process(clk) --12 MHz is too much, so modules see every freq_div'th rising edge of clock
	begin
		if rising_edge(clk) then
			if counter < freq_div then
				counter <= counter + 1;
				ce <= '0';
			elsif counter = freq_div then
				counter <= (others => '0');
				ce <= '1';
			end if;
		end if;
	end process;

end Behavioral;

