--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:10:34 03/02/2021
-- Design Name:   
-- Module Name:   C:/Users/Public/myFPGAprojects/stackCalculator/ALU_testbench.vhd
-- Project Name:  stackCalculator
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ALU
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;
 
ENTITY ALU_testbench IS
END ALU_testbench;
 
ARCHITECTURE behavior OF ALU_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ALU
    PORT(
         clk : IN  std_logic;
         operation : IN  unsigned(2 downto 0);
         D1 : IN  unsigned(9 downto 0);
         D2 : IN  unsigned(9 downto 0);
         S : OUT  unsigned(9 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal operation : unsigned(2 downto 0) := (others => '0');
   signal D1 : unsigned(9 downto 0) := (others => '0');
   signal D2 : unsigned(9 downto 0) := (others => '0');

 	--Outputs
   signal S : unsigned(9 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ALU PORT MAP (
          clk => clk,
          operation => operation,
          D1 => D1,
          D2 => D2,
          S => S
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
			D1 <= "0000001110";
			D2 <= "0000000111";
			operation <= "000";
		wait for clk_period;
			operation <= "001";
		wait for clk_period;
			operation <= "010";
      wait;
   end process;

END;
