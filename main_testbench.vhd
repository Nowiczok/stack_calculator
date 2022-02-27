LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;
 
ENTITY main_testbench IS
END main_testbench;
 
ARCHITECTURE behavior OF main_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT main
  Port ( push : in  STD_LOGIC;
			  backspace : in std_logic;
			  enter : in std_logic;
			  show : in std_logic;
			  compute : in std_logic;
           clk : in  STD_LOGIC;
           D_in_vec : in  STD_LOGIC_VECTOR (3 downto 0);
			  addr_vec: in STD_LOGIC_VECTOR(3 downto 0);
           display_out : out  STD_LOGIC_VECTOR (6 downto 0);
           sel_vec : out  STD_LOGIC_VECTOR (2 downto 0);
			  operator_flag : out std_logic);
    END COMPONENT;
    

   --Inputs
   signal push : std_logic := '0';
   signal backspace : std_logic := '0';
	signal enter : std_logic := '0';
   signal show : std_logic := '0';
	signal compute : std_logic := '0';
   signal clk : std_logic := '0';
	signal operator_flag : std_logic := '0';
   signal D_in_vec, addr_vec : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');

 	--Outputs
   signal display_out : std_logic_vector(6 downto 0);
   signal sel_vec : STD_LOGIC_VECTOR(2 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: main PORT MAP (
          push => push,
          backspace => backspace,
			 enter => enter,
			 show => show,
			 compute => compute,
          clk => clk,
          D_in_vec => D_in_vec,
			 addr_vec => addr_vec,
          display_out => display_out,
          sel_vec => sel_vec,
			 operator_flag => operator_flag
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
		wait for clk_period * 10;
--			compute <= '1';
--			wait for clk_period;
--			compute <= '0';
		addr_vec <= "0011";
		wait for clk_period;
		show <= '1';
		wait for clk_period * 2;
		show <= '0';

      wait;
   end process;

END;
