-------------------------------------------------------
 --! @file IFUnit.vhdl
 --! @author Kunal Singhal and Swapnil Palash
 --! @brief This file for the implementation of a Instruction Fetch Unit for the processor
 -------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
library std;
use std.textio.all;
use ieee.numeric_std.all;
--! This import contains the manually defined function to take input from a file.
use work.fileRead.all;
--! This is the unit that implements the Instruction fetch Unit.
entity IFUnit is
	port (
	--! The program counter.
	PC: in std_logic_vector(31 downto 0); 
	--! The 32-bit instruction corresponding to the program counter.
	instruction: out std_logic_vector (31 downto 0));
end entity IFUnit;
--! IM is the architectural description of the Instruction Fetch Unit.
architecture IM of IFUnit is
	--! A custom data type for the memory.
	type memorydef is array(integer range<>) of std_logic_vector (31 downto 0);
	--! The memory is a 500-length array of 32-bit vectors,ie, it can handle upto 500 instructions.
	signal memory: memorydef(0 to 499);
	--! Marks the maximum Program counter.
	signal maxCount: integer;
	
begin
	--! Executes only when the program counter is changed.
	process (PC)
		--! A temp variable needed to make sure file is read only once.
		variable flag: boolean:=false;
		--! A temp variable
		variable num : integer:= 0;
		--! Keeps the current instruction count while reading the file.
		variable tpc: integer:=0;
		--! Accessing the file named 'input'
		file insFile: text is in "input";
		--! A temp variable storing each line of the file.
		variable insLine: line;
		--! A temp variable storing each string of the line.
		variable insStr: string (1 to 32);
	--! Reading the instruction from the file and inserting them into memory.
	begin
		if( not flag) then
			while (not endfile(insFile)) loop
				readline(insFile, insLine);
				read(insLine, insStr);
				memory(tpc)<= to_std_logic_vector(insStr);
				tpc:=tpc+1;
			end loop;
			--! Sets the max Program counter.
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
		--! Reading the current instruction from memory.
		if(num < maxCount) then
			instruction<= memory(num);
		--! When the program counter goes over the maximum, null instruction(s) are passed.
		elsif(num >=maxCount) then
			instruction<=X"68000000";
		else null;
		end if;
	end process;
end IM;
