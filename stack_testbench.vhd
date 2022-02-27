LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;
 
ENTITY stack_testbench IS
END stack_testbench;
 
ARCHITECTURE behavior OF stack_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT stack
    PORT(
         D_in : IN  unsigned(9 downto 0);
         push : IN  std_logic;
         pop : IN  std_logic;
         clk : IN  std_logic;
         D_out : OUT  unsigned(9 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal D_in : unsigned(9 downto 0) := (others => '0');
   signal push : std_logic := '0';
   signal pop : std_logic := '0';
   signal clk : std_logic := '0';

 	--Outputs
   signal D_out : unsigned(9 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: stack PORT MAP (
          D_in => D_in,
          push => push,
          pop => pop,
          clk => clk,
          D_out => D_out
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
      D_in <= "1100010110";
		push <= '1';
		wait for clk_period * 2;
		D_in <= "1000000010";
		wait for clk_period * 2;
		push <= '0';
		pop <= '1';
		
		wait;
   end process;

END;
