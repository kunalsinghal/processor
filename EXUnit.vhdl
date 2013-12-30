-------------------------------------------------------
 --! @file EXUnit.vhdl
 --! @author Kunal Singhal and Swapnil Palash
 --! @brief This file is for the Arithmetic and logic Unit of the processor
 -------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--! This is the unit that implements the ALU and branch Unit.
entity EXUnit is
	port(
		--! Operand 1
		op1: in std_logic_vector(31 downto 0);
		--! Operand 2
		op2: in std_logic_vector(31 downto 0);
		--! The value of the immediate converted from 27 to 32 bit.
		immediate: in std_logic_vector(31 downto 0); 
		--! This vector marks the type of instruction.
		aluS: in std_logic_vector(2 downto 0); 
		--! This store the result of the arithmetic operation.
		aluR: out std_logic_vector(31 downto 0);
		--! boolean which states whether the instruction is 'mov' 
	    isMov: in boolean; 
		--! boolean which states whether the instruction is 'beq' 
		isBeq: in boolean; 
		--! boolean which states whether the instruction is 'bgt' 
		isBgt: in boolean; 
		--! boolean which states whether the instruction is a direct branching statement.
		isUBranch: in boolean; 
		--! boolean which states whether the instruction has an immediate. 
		isImmediate: in boolean; 
		--! boolean whether the branch is taken.
		isBranchTaken: out boolean);
end entity EXUnit;
--! OFU is the architectural description of the EX Unit.
architecture ALU_BU of EXUnit is
	--! a boolean signal storing the boolean value of equality operation
	signal E: boolean:=false;
	--! a boolean signal storing the boolean value of greater-than operation
	signal GT: boolean:=false;
	--! The first operand in the ALU
	signal A: std_logic_vector(31 downto 0); 
	--! The second operand in the ALU
	signal B: std_logic_vector(31 downto 0);
begin
	A<= op1 ;
	--! Whether the second operand is a register or an immediate value.
	B<= immediate when isImmediate else
	    op2;
	--! The arithmetic or logic operation is performed here.
	aluR<= std_logic_vector(unsigned(A)+ unsigned(B)) when aluS= "000" else
		     std_logic_vector(unsigned(A) - unsigned(B)) when ( aluS="001" or aluS="100") else
		     (A and B) when aluS="010" else
		     (A or B) when aluS="011" else
		     (not B) when aluS="101" else
		     std_logic_vector(shift_left(unsigned(A) ,to_integer(unsigned(B)))) when aluS="110" else
		     (B) when (isMov);
	--! If the instruction is 'beq', the signal E stores the boolean of the equality operation.
	E<= true when (aluS="100" and A=B) else
	    false when(aluS="100");
	--! If the instruction is 'bgt', the signal GT stores the boolean of the greater-than operation.
	GT<= true when (aluS="100" and (to_integer(unsigned(A)) > to_integer(unsigned(B))) ) else
	     false when (aluS="100");
	--! Whether the instruction is ret,call,b,beq or bgt, this boolean specifies whether the branch is actually taken.
	isBranchTaken<= (isBgt and GT) or (isBeq and E) or (isUBranch);
end ALU_BU;
