library ieee;
use ieee.std_logic_1164.all;

entity CUnit is
	port(Instruction: in std_logic_vector(31 downto 0);
	     isMov, isSt, isLd, isBeq, isBgt, isImmediate, isWb, isUBranch: out boolean; aluS: out std_logic_vector(2 downto 0));
end entity CUnit;

architecture CU of CUnit is
	signal op_code: std_logic_vector(4 downto 0);
	signal I: std_logic;
begin
	op_code<=Instruction(31 downto 27);
	I<= Instruction(26);

	process (op_code, I)
	begin
		isMov<=false; isSt<=false; isLd<=false; isBeq<=false; isBgt<=false; isImmediate<=false; isWb<=false; isUBranch<=false;
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
		else null;
		end if;
	end process;
end CU;
