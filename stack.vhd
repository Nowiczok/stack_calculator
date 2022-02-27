library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity stack is
    Port ( D_in : in  unsigned (9 downto 0) := (others => '0');
           push : in  STD_LOGIC := '0';
           pop : in  STD_LOGIC := '0';
			  clk : in std_logic := '0';
           D_out : out  unsigned (9 downto 0) := (others => '0'));
end stack;

architecture Behavioral of stack is

	type memory is array(7 downto 0) of unsigned(9 downto 0);
	signal mem : memory := (others => (others => '0'));
	signal stack_counter: unsigned(2 downto 0) := (others => '0');
	signal push_flag, pop_flag: std_logic := '0';
	
begin

	process(clk) --if data was pushed/popped, stack will perform another action after one extra clk cycle, because of stack_pointer increment/decrement
	begin
		if rising_edge(clk) then
			if push_flag = '0' and pop_flag = '0' then
				if push = '1' and pop = '0' then --push
					mem(to_integer(stack_counter)) <= D_in; --save data into memory
					push_flag <= '1'; --request stack_counter incrementation
				elsif push = '0' and pop = '1' then  --pop
					D_out <= mem(to_integer(stack_counter-1)); --output popped data
					pop_flag <= '1'; --request stack_pointer decrementation
				else --idle
					--do nothing
				end if;
			elsif push_flag = '1' and pop_flag = '0' then --if something was pushed
				stack_counter <= stack_counter + 1; --increment stack_pointer
				push_flag <= '0'; --clear flag
			else --if something was popped
				stack_counter <= stack_counter - 1; --decrement_stack_pointer
				pop_flag <= '0'; --clear flag
			end if;
		end if;
	end process;

end Behavioral;












