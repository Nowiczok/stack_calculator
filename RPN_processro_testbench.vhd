LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;
 
ENTITY RPN_processro_testbench IS
END RPN_processro_testbench;
 
ARCHITECTURE behavior OF RPN_processro_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT RPN_processor
    Port ( clk : in  STD_LOGIC;
           compute : in  STD_LOGIC;
           D_in : in  unsigned (9 downto 0);
           addr : out  unsigned (3 downto 0);
           D_out : out  unsigned (9 downto 0);
			  ready : out std_logic);
    END COMPONENT;
    
	 component prog_mem is
		Port ( D_in : in  unsigned (9 downto 0);
           we : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           addr : in  unsigned (3 downto 0);
           D_out : out  unsigned (9 downto 0));
	 end component;

   --Inputs
   signal clk : std_logic := '0';
   signal compute : std_logic := '0';
   signal D_in, mem_D_in : unsigned(9 downto 0) := (others => '0');

 	--Outputs
   signal addr : unsigned(3 downto 0);
   signal D_out : unsigned(9 downto 0);
	signal ready: std_logic := '0';

   -- Clock period definitions
   constant clk_period : time := 10 ns;
	
	
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: RPN_processor PORT MAP (
          clk => clk,
          compute => compute,
          D_in => D_in,
          addr => addr,
          D_out => D_out,
			 ready => ready
        );
	
	test_mem: prog_mem port map (D_in => mem_D_in, we => '0', clk => clk, addr => addr, D_out => D_in);
	
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
		compute <= '1';
		wait for clk_period;
		compute <= '0';

      wait;
   end process;

END;
