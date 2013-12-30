-------------------------------------------------------
 --! @file CUnit.vhdl
 --! @author Kunal Singhal and Swapnil Palash
 --! @brief This file for the implementation of a Control Unit for the processor
 -------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

--!This is the unit that generates the control signals.
entity CUnit is
	port(
	--! The 32-bit instruction coming from the Instruction fetch Unit.
	Instruction: in std_logic_vector(31 downto 0);
	--! boolean which states whether the instruction is 'mov'
	isMov: out boolean;
	--! boolean which states whether the instruction is 'st' 
	isSt: out boolean; 
	--! boolean which states whether the instruction is 'ld' 
	isLd: out boolean; 
	--! boolean which states whether the instruction is 'beq' 
	isBeq: out boolean; 
	--! boolean which states whether the instruction is 'bgt' 
	isBgt: out boolean; 
	--! boolean which the instruction has an immediate as the arguments.
	isImmediate: out boolean; 
	--! boolean whether something has to be written into the register file.
	isWb: out boolean; 
	--! boolean whether the statement is a direct branching one(b, ret, call)
	isUBranch: out boolean; 
	--! boolean which states whether the instruction is 'ret' 
	isRet: out boolean; 
	--! boolean which states whether the instruction is 'call' 
	isCall: out boolean; 
	--! This vector stores all the states with each 3-bit value corresponding to one of the instructions.
	aluS: out std_logic_vector(2 downto 0));
end entity CUnit;
--! CU is the architectural description of the Control Unit
architecture CU of CUnit is
	--! A vector containing 5 bits of the instruction marking the instruction type.
	signal op_code: std_logic_vector(4 downto 0);
	--! The immediate bit
	signal I: std_logic;
begin
	--! Extracting the opcode from the 32-bit instruction.
	op_code<=Instruction(31 downto 27);
	--! Extracting the immediate bit from the 32-bit instruction.
	I<= Instruction(26);
	--! This part is executed whenever there is a change in op_code or I,ie, the type or argument changes.
	process (op_code, I)
	--! Comparing the op_code to the predefined values, storing it in aluS and generating the control signals is done via if-else.
	begin
		isMov<=false; isSt<=false; isLd<=false; isBeq<=false; isBgt<=false; isImmediate<=false; isWb<=false; isUBranch<=false;isRet<=false;isCall<=false;
		aluS<="111";
		if(I='1') then
			isImmediate<=true;
		else null;
		end if;
		if(op_code="00000") then --add
			aluS<="000";
			isWb<=true;
		elsif(op_code="00001") then --sub
			aluS<="001";
			isWb<=true;
		elsif(op_code="00101") then --cmp
			aluS<="100";
		elsif(op_code="00110") then --and
			aluS<="010";
			isWb<=true;
		elsif(op_code="00111") then --or
			aluS<="011";
			isWb<=true;
		elsif(op_code="01000") then --not
			aluS<="101";
			isWb<=true;
		elsif(op_code="01010") then --lsl
			aluS<="110";
			isWb<=true;
		elsif(op_code="01001") then --mov
			isMov<=true;
			isWb<=true;
		elsif(op_code="01110") then --ld
			isLd<=true;
			isWb<=true;
			aluS<="000";
		elsif(op_code="01111") then --st
			isSt<=true;
			aluS<="000";
		elsif(op_code="10000") then --beq
			isBeq<=true;
		elsif(op_code="10001") then --bgt
			isBgt<=true;
		elsif(op_code="10010") then --b
			isUBranch<=true;
		elsif(op_code="10011") then --call
			isCall<=true;isUBranch<=true;
		elsif(op_code="10100") then --ret
			isRet<=true;isUBranch<=true;
		else null;
		end if;
	end process;
end CU;
