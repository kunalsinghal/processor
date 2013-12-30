-------------------------------------------------------
 --! @file OFUnit.vhdl
 --! @author Kunal Singhal and Swapnil Palash
 --! @brief Operand Fetch unit as well as register read and write operations implemented. 
 -------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--! This the Operand Fetch Unit which also contains the register file implementation
entity OFUnit is
	port(
		--! CLOCK for the unit
		clk: in std_logic; 
		--! Complete 32 bit instruction code
		Instruction: in std_logic_vector(31 downto 0); 
		--! Program Counter
		PC: in std_logic_vector(31 downto 0); 
		--! ALU Result that is to be written in register in case of an alu instrcution
		aluR: in std_logic_vector(31 downto 0); 
		--! Load Result that is to be written in register in case of a load instrcution
		ldR: in std_logic_vector(31 downto 0); 
		--! boolean for store instruction
		isSt: in boolean;
		--! boolean for load instruction
		isLd: in boolean;
		--! boolean for writeback that is its true when something is to be written in the register file
		isWb: in boolean;
		--! boolean which states whether the instruction is 'ret' 
		isRet: in boolean;
		--! boolean which states whether the instruction is 'call'
		isCall: in boolean;
		--! 32 bit immediate that has to be computed
	    immediate: out std_logic_vector(31 downto 0);
	    --! This is the branch target which is used in case of a branch or call instruction
        branchTarget: out std_logic_vector(31 downto 0);
	    --! First pperand
        op1: out std_logic_vector(31 downto 0); 
	    --! Second Operand
	    op2: out std_logic_vector(31 downto 0));
end entity OFUnit;

--! OFU is the architectural description of the operand fetch unit and register file
architecture OFU of OFUnit is
	--! A custom data type which is a 16 x 32 array or vector of bits
	type regvec is array(15 downto 0) of std_logic_vector(31 downto 0);
	--! reg is the register file of data type regvec that is it has 16  32-bit vector fields
	signal reg: regvec;
	--! temp is the signal which is used for signed extension of offset, offset is Instruction(26 downto 0)
	signal temp: std_logic_vector(31 downto 0);
begin
	--! First of all immediate is computed after sign extesnion, if 17th bit of the instruction is 1 then sign extension is not done and if the 
	--! 18th bit is 1 then the 16-bit immediate is shifted left by 16 bits to get the modified immidiate. 
	--! The branch targeet is computer as < program counter + 4 * offset > offset is stored as Instruction(15 downto 0).
	--! Frst operand is computer as reg(rs1) where rs1 is stored in Instruction(21 downto 18).
	--! Second operand is either reg(rs2) where rs1 is stored in Instruction(17 downto 14) or it is reg(rd) in case of a store instruction where rd
	--! is stored as Instruction(25 downto 22).


	immediate <=
	--! case when U = 1
	std_logic_vector(resize(unsigned(Instruction(15 downto 0)),immediate'length))
        when (Instruction(16) = '1') else 
    --! case when H = 1                            
    std_logic_vector(shift_left(unsigned(Instruction) ,16))
        when (Instruction(17) = '1') else
    --! case when U = 1 and H = 1 that is no modifiers
	std_logic_vector(resize(signed(Instruction(15 downto 0)),immediate'length)); 

	--! Just sign extension of offset 
	temp<=std_logic_vector(resize(signed(Instruction(26 downto 0)),temp'length));
	
	--! BranchTarget = 4 * offset + PC
	branchTarget<= std_logic_vector(unsigned(std_logic_vector(shift_left(unsigned(temp),2)))+unsigned(PC));


	op1<= reg(15) when (isRet) else
		reg( to_integer(unsigned(Instruction(21 downto 18)))) when (reg'event or Instruction(21 downto 18)'event);

	op2<= 
	--! When a store instruction
	reg(to_integer(unsigned(Instruction(25 downto 22)))) 
		when ((isSt)  and (reg'event or Instruction(25 downto 22)'event or isSt'event))else
	--! When the instruction is not store instruction
	reg(to_integer(unsigned(Instruction(17 downto 14)))) when (reg'event or Instruction(17 downto 14)'event);

	process
	begin
		--! Wait for the signals to stablize
		wait until (isWb'stable(6 ns) and isLd'stable(6 ns) and aluR'stable(6 ns) and ldR'stable(6 ns) and Instruction(25 downto 22)'stable(6 ns));

		--! Write in register file on the negative edge of the clock
		if (isWb and (not isLd) and clk'event and clk='0' and (not isCall)) then
			reg(to_integer(unsigned(Instruction(25 downto 22)))) <= aluR;
		elsif( isWb and isLd and clk'event and clk='0' and (not isCall)) then
			reg(to_integer(unsigned(Instruction(25 downto 22)))) <= ldR;
		elsif(clk'event and clk='0' and isCall) then
			reg(15)<=std_logic_vector(unsigned(PC)+4);
		end if;
	end process;
end OFU;
