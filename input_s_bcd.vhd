library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity input_s_bcd is
    Port ( D_in : in  unsigned (3 downto 0);
           push : in  STD_LOGIC;
           backspace : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           D_out : out  unsigned (9 downto 0));
end input_s_bcd;

architecture Behavioral of input_s_bcd is

	component input_module is
		Port ( D_in : in  unsigned (3 downto 0) := (others => '0');
				  push : in  STD_LOGIC := '0';
				  backspace : in  STD_LOGIC := '0';
				  clk : in  STD_LOGIC := '0';
				  digit_0 : out  unsigned (3 downto 0) := (others => '0');
				  digit_1 : out  unsigned (3 downto 0) := (others => '0');
				  digit_2 : out  unsigned (3 downto 0) := (others => '0'));
	end component;

	component bcd_to_bin is
		Port ( d_in0 : in  unsigned (3 downto 0) := (others => '0');
           d_in1 : in  unsigned (3 downto 0) := (others => '0');
           d_in2 : in  unsigned (3 downto 0) := (others => '0');
           clk : in  STD_LOGIC;
           convert : in  STD_LOGIC;
           d_out : out  unsigned (9 downto 0) := (others => '0'));
	end component;

	signal digit_0, digit_1, digit_2 : unsigned(3 downto 0) := (others => '0');

begin
	input: input_module port map (D_in => D_in, push => push, backspace => backspace, clk => clk, digit_0 => digit_0, digit_1 => digit_1, digit_2 => digit_2);
	converter: bcd_to_bin port map(d_in0 => digit_0, d_in1 => digit_1, d_in2 => digit_2, clk => clk, convert => '1', d_out => D_out);


end Behavioral;

