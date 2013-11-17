library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity EXUnit is
	port(op1, op2, immediate: in std_logic_vector(31 downto 0); aluS: in std_logic_vector(2 downto 0); aluR: out std_logic_vector(31 downto 0);
	     isMov, isBeq, isBgt, isUBranch, isImmediate: in boolean; isBranchTaken: out boolean);
end entity EXUnit;

architecture ALU_BU of EXUnit is
	signal E: boolean:=false;
	signal GT: boolean:=false;
	signal A, B: std_logic_vector(31 downto 0);
begin
	A<= op1 ;
	B<= immediate when isImmediate else
	    op2;

	aluR<= std_logic_vector(unsigned(A)+ unsigned(B)) when aluS= "000" else
		     std_logic_vector(unsigned(A) - unsigned(B)) when ( aluS="001" or aluS="100") else
		     (A and B) when aluS="010" else
		     (A or B) when aluS="011" else
		     (not B) when aluS="101" else
		     std_logic_vector(shift_left(unsigned(A) ,to_integer(unsigned(B)))) when aluS="110" else
		     (B) when (isMov);

	E<= true when (aluS="100" and A=B) else
	    false when(aluS="100");
	GT<= true when (aluS="100" and (to_integer(unsigned(A)) > to_integer(unsigned(B))) ) else
	     false when (aluS="100");

	isBranchTaken<= (isBgt and GT) or (isBeq and E) or (isUBranch);
end ALU_BU;
