library ieee;
use ieee.std_logic_1164.all;

library std;
use std.textio.all;
use ieee.numeric_std.all;
use work.fileRead.all;

entity IFUnit is
	port (PC: in std_logic_vector(31 downto 0); instruction: out std_logic_vector (31 downto 0));
end entity IFUnit;

architecture IM of IFUnit is
	type memorydef is array(integer range<>) of std_logic_vector (31 downto 0);
	signal memory: memorydef(0 to 499);
	signal maxCount: integer;
	
begin
	process (PC)
		variable flag: boolean:=false;
		variable num : integer:= 0;
		variable tpc: integer:=0;
		file insFile: text is in "input";
		variable insLine: line;
		variable insStr: string (1 to 32);
	begin
		if( not flag) then
			while (not endfile(insFile)) loop
				readline(insFile, insLine);
				read(insLine, insStr);
				memory(tpc)<= to_std_logic_vector(insStr);
				tpc:=tpc+1;
			end loop;
			maxCount<=tpc*4;
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
		if(num < maxCount) then
			instruction<= memory(num);
		elsif(num >=maxCount) then
			instruction<=X"68000000";
		else null;
		end if;
	end process;
end IM;
