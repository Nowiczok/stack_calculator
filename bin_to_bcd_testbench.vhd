LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY bin_to_bcd_testbench IS
END bin_to_bcd_testbench;
 
ARCHITECTURE behavior OF bin_to_bcd_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT bin_to_bcd
    PORT(
         Din : IN  std_logic;
         clk : IN  std_logic;
         clear : IN  std_logic;
         ce : IN  std_logic;
         Dout : OUT  std_logic_vector(3 downto 0);
         Cout : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal Din : std_logic := '0';
   signal clk : std_logic := '0';
   signal clear : std_logic := '0';
   signal ce : std_logic := '0';

 	--Outputs
   signal Dout : std_logic_vector(3 downto 0);
   signal Cout : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
	-- testbench signals
	signal test_number : std_logic_vector(3 downto 0) := "1110";
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: bin_to_bcd PORT MAP (
          Din => Din,
          clk => clk,
          clear => clear,
          ce => ce,
          Dout => Dout,
          Cout => Cout
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
      ce <= '1';
		wait for clk_period * 1.25;
		
		for k in 0 to 3 loop
			Din <= test_number(3 - k);
			wait for clk_period;
		end loop;
		ce <= '0';
		wait;
   end process;

END;
