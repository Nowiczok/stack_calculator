library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity bin_bcd_multi_digit is
    Port ( Din : in  STD_LOGIC_VECTOR (9 downto 0) := (others => '0');
           clk : in  STD_LOGIC := '0';
           ce : in  STD_LOGIC := '0';
			  convert : in std_logic := '0';
           Dout0 : out  STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
           Dout1 : out  STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
           Dout2 : out  STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
			  operator_flag : out std_logic);
end bin_bcd_multi_digit;

architecture Behavioral of bin_bcd_multi_digit is
	component bin_to_bcd is
		Port(Din : in  STD_LOGIC := '0';
           clk : in  STD_LOGIC := '0';
           clear : in  STD_LOGIC := '0';
           ce : in  STD_LOGIC := '0';
           Dout : out  STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
			  Cout : out STD_LOGIC := '0');
	end component;
	
	signal Din_0, Din_1, Din_2, Din_3, clear, ce_int : std_logic := '0';
	signal input_buffer : std_logic_vector(9 downto 0) := (others => '0');
	signal counter : unsigned(3 downto 0) := (others => '0');
	
	type states is (idle, prepare, conversion);
	signal current_state : states := idle;
	
begin

digit0 : bin_to_bcd port map(Din => Din_0, clk => clk, clear => clear, ce => ce_int, Dout => Dout0, Cout => Din_1);
digit1 : bin_to_bcd port map(Din => Din_1, clk => clk, clear => clear, ce => ce_int, Dout => Dout1, Cout => Din_2);
digit2 : bin_to_bcd port map(Din => Din_2, clk => clk, clear => clear, ce => ce_int, Dout => Dout2, Cout => Din_3);
	

next_state: process(clk)
begin
	if rising_edge(clk) and ce = '1' then
			case current_state is
				when idle =>
					if convert = '1' then
						current_state <= prepare;
					else
						current_state <= idle;
					end if;
				
				when prepare =>
					if convert = '0' then
						current_state <= conversion;
					else
						current_state <= prepare;
					end if;

				when conversion =>
					if counter = 9 then
						current_state <= idle;
					else
						current_state <= conversion;
					end if;	
			end case;
	end if;
end process;

decode_state: process(clk)
begin
	if rising_edge(clk) and ce = '1' then
		case current_state is
				when idle =>
					ce_int <= '0'; --do nothing
				
				when prepare =>
					ce_int <= '1';
					clear <= '1';
					counter <= (others => '0');
					input_buffer <= Din;
					
					if unsigned(Din) > 999 then
						operator_flag <= '1';
					else
						operator_flag <= '0';
					end if;

				when conversion =>
					clear <= '0';
					Din_0 <= input_buffer(9);
					input_buffer <= input_buffer(8 downto 0) & '0';
					counter <= counter + 1;
			end case;
		end if;
end process;

end Behavioral;

