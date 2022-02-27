LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY bin_to_bcd_multi_digit_testbench IS
END bin_to_bcd_multi_digit_testbench;
 
ARCHITECTURE behavior OF bin_to_bcd_multi_digit_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT bin_bcd_multi_digit
    PORT(
         Din : IN  std_logic_vector(9 downto 0);
         clk : IN  std_logic;
         ce : IN  std_logic;
         convert : IN  std_logic;
         Dout0 : OUT  std_logic_vector(3 downto 0);
         Dout1 : OUT  std_logic_vector(3 downto 0);
         Dout2 : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Din : std_logic_vector(9 downto 0) := (others => '0');
   signal clk : std_logic := '0';
   signal ce : std_logic := '0';
   signal convert : std_logic := '0';

 	--Outputs
   signal Dout0 : std_logic_vector(3 downto 0);
   signal Dout1 : std_logic_vector(3 downto 0);
   signal Dout2 : std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: bin_bcd_multi_digit PORT MAP (
          Din => Din,
          clk => clk,
          ce => ce,
          convert => convert,
          Dout0 => Dout0,
          Dout1 => Dout1,
          Dout2 => Dout2
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin
		wait for clk_period;
      Din <= "0000000111";
		ce <= '1';
		convert <= '1';
		wait for clk_period;
		convert <= '0';
      wait;
   end process;

END;
