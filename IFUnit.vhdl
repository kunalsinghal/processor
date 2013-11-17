library ieee;
use ieee.std_logic_1164.all;

library std;
use std.textio.all;
use ieee.numeric_std.all;

entity IFUnit is
	port (PC: in std_logic_vector(31 downto 0); instruction: out std_logic_vector (31 downto 0));
end entity IFUnit;

architecture IM of IFUnit is
	type memorydef is array(integer range<>) of std_logic_vector (31 downto 0);
	signal memory: memorydef(0 to 499);
	signal instructionCount: integer;
	
begin
	process (PC)
		variable flag: boolean:=false;
		variable num : integer:= 0;
	begin
		if( not flag) then
			memory(0) <= X"4C000032";
			memory(1) <= X"0C000005";
			memory(2) <= X"2C000000";
			memory(3) <= X"8FFFFFFE";
			instructionCount <= 4	;
			flag:=true;
		else null;
		end if;
		num := 0;
		for i in 31 downto 2 loop
			num := num*2;
			if(PC(i) = '1') then
				num := num + 1;
			end if;
		end loop;
		if(num < instructionCount) then
			instruction<= memory(num);
		elsif(num >=instructionCount) then
			instruction<=X"68000000";
		else null;
		end if;
	end process;
end IM;
