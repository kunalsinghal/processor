library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity OFUnit is
	port(clk: in std_logic; Instruction, PC, aluR, ldR: in std_logic_vector(31 downto 0); isSt, isLd, isWb: in boolean;
	     immediate, branchTarget, op1, op2: out std_logic_vector(31 downto 0));
end entity OFUnit;

architecture OFU of OFUnit is
	type regvec is array(15 downto 0) of std_logic_vector(31 downto 0);
	signal reg: regvec;
	signal temp: std_logic_vector(31 downto 0);
begin
	immediate<=std_logic_vector(resize(signed(Instruction(15 downto 0)),immediate'length));
	temp<=std_logic_vector(resize(signed(Instruction(26 downto 0)),temp'length));
	
	branchTarget<= std_logic_vector(unsigned(std_logic_vector(shift_left(unsigned(temp),2)))+unsigned(PC));

	op1<= reg( to_integer(unsigned(Instruction(21 downto 18)))) when (reg'event or Instruction(21 downto 18)'event);
	op2<= reg(to_integer(unsigned(Instruction(25 downto 22)))) when ((isSt)  and (reg'event or Instruction(25 downto 22)'event or isSt'event))else
	      reg(to_integer(unsigned(Instruction(17 downto 14)))) when (reg'event or Instruction(17 downto 14)'event);

	process
	begin
		wait until (isWb'stable(6 ns) and isLd'stable(6 ns) and aluR'stable(6 ns) and ldR'stable(6 ns) and Instruction(25 downto 22)'stable(6 ns));

		if (isWb and (not isLd) and clk'event and clk='0') then
			reg(to_integer(unsigned(Instruction(25 downto 22)))) <= aluR;
		elsif( isWb and isLd and clk'event and clk='0') then
			reg(to_integer(unsigned(Instruction(25 downto 22)))) <= ldR;
		else null;
		end if;
	end process;
end OFU;
