--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:46:54 02/20/2021
-- Design Name:   
-- Module Name:   C:/Users/Public/myFPGAprojects/stackCalculator/prog_mem_tb.vhd
-- Project Name:  stackCalculator
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: prog_mem
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
 
ENTITY prog_mem_tb IS
END prog_mem_tb;
 
ARCHITECTURE behavior OF prog_mem_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT prog_mem
    PORT(
         D_in : IN  unsigned(9 downto 0);
         we : IN  std_logic;
         clk : IN  std_logic;
         addr : IN  unsigned(3 downto 0);
         D_out : OUT  unsigned(9 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal D_in : unsigned(9 downto 0) := (others => '0');
   signal we : std_logic := '0';
   signal clk : std_logic := '0';
   signal addr : unsigned(3 downto 0) := (others => '0');
   signal D_out : unsigned(9 downto 0) := (others => '0');

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: prog_mem PORT MAP (
          D_in => D_in,
          we => we,
          clk => clk,
          addr => addr,
          D_out => D_out
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '1';
		wait for clk_period/2;
		clk <= '0';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin	
			we <= '1';
			addr <= (others => '0');
			D_in <= "0000001110";
		wait for clk_period;
			addr <= "0010";
			D_in <= "0000001000";
		wait for clk_period;
			we <= '0';
		
		for k in 0 to 15 loop
				addr <= to_unsigned(k, addr'length);
			wait for clk_period;
		end loop;
		
		wait;
   end process;

END;
