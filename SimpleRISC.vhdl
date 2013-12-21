Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SimpleRISC is
end entity SimpleRISC;

architecture main of SimpleRISC is

	component IFUnit is
		port (PC: in std_logic_vector(31 downto 0); instruction: out std_logic_vector (31 downto 0));
	end component IFUnit;

	component CUnit is
		port(Instruction: in std_logic_vector(31 downto 0);
		     isMov, isSt, isLd, isBeq, isBgt, isImmediate, isWb, isUBranch,isRet,isCall: out boolean; aluS: out std_logic_vector(2 downto 0));
	end component CUnit;

	component OFUnit is
		port(clk: in std_logic; Instruction, PC, aluR, ldR: in std_logic_vector(31 downto 0); isSt, isLd, isWb,isRet,isCall: in boolean;
		     immediate, branchTarget, op1, op2: out std_logic_vector(31 downto 0));
	end component OFUnit;

	component EXUnit is
		port(op1, op2, immediate: in std_logic_vector(31 downto 0); aluS: in std_logic_vector(2 downto 0); aluR: out std_logic_vector(31 downto 0);
	     	     isMov, isBeq, isBgt, isUBranch, isImmediate: in boolean; isBranchTaken: out boolean);
	end component EXUnit;

	component MAUnit is
		port(clk: in std_logic; op2, aluR: in std_logic_vector(31 downto 0); isSt, isLd: in boolean; ldResult: out std_logic_vector(31 downto 0));
	end component MAUnit;

	signal clk: std_logic:='0';
	signal PC: std_logic_vector(31 downto 0):=X"FFFFFFFC";
	signal instruction: std_logic_vector(31 downto 0);
	signal isMov, isSt, isLd, isBeq, isBgt, isImmediate, isWb, isUbranch, isBranchTaken,isRet,isCall: boolean:=false;
	signal aluS: std_logic_vector(2 downto 0);
	signal aluR, ldR, immediate, branchTarget, op1, op2: std_logic_vector(31 downto 0):=X"00000000";
begin
	iif: IFUnit port map(PC, instruction);
	icu: CUnit port map (instruction, isMov, isSt, isLd, isBeq, isBgt, isImmediate, isWb, isUBranch,isRet,isCall, aluS);
	iof: OFUnit port map(clk, instruction, PC, aluR, ldR, isSt, isLd, isWb,isRet,isCall, immediate, branchTarget, op1, op2);
	iex: EXUnit port map(op1, op2, immediate, aluS, aluR, isMov, isBeq, isBgt, isUBranch, isImmediate, isBranchTaken);
	ima: MAUnit port map(clk, op2, aluR, isSt, isLd, ldR);

	clk<= not clk after 6 ns;
	PC<= std_logic_vector(unsigned(PC)+4) when (clk'event and clk='1' and (not isBranchTaken)) else
	     branchTarget when (clk'event and clk='1' and isBranchTaken);
end main;
