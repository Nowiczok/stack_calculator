LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;
 
ENTITY display_module_testbench IS
END display_module_testbench;
 
ARCHITECTURE behavior OF display_module_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT display_module
	 Generic (freq_div : integer);
    PORT(
         D_in : IN  std_logic_vector(9 downto 0);
         display : IN  std_logic;
         clk : IN  std_logic;
         D_out : OUT  std_logic_vector(6 downto 0);
         sel : OUT  unsigned(2 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal D_in : std_logic_vector(9 downto 0) := (others => '0');
   signal display : std_logic := '0';
   signal clk : std_logic := '0';

 	--Outputs
   signal D_out : std_logic_vector(6 downto 0);
   signal sel : unsigned(2 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: display_module 
	generic map(freq_div => 4)
	PORT MAP (
          D_in => D_in,
          display => display,
          clk => clk,
          D_out => D_out,
          sel => sel
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
			D_in <= "0001110011";
		wait for clk_period*1.25;
			display <= '1';
		wait for clk_period;
			display <= '0';
      wait;
   end process;

END;
