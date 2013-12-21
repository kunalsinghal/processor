library ieee;
use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;

entity MAUnit is
	port(clk: in std_logic; op2, aluR: in std_logic_vector(31 downto 0); isSt, isLd: in boolean; ldResult: out std_logic_vector(31 downto 0));
end entity MAUnit;

architecture DM of MAUnit is
	signal memory: std_logic_vector(32767 downto 0);
begin
	ldResult<=memory(to_integer(unsigned(aluR))*8+31 downto to_integer(unsigned(aluR))*8) when (isLd and (memory'event or aluR'event or isLd'event));
	process
	begin
		wait until ( op2'stable(6 ns) and aluR'stable(6 ns) and isSt'stable(6 ns) and isLd'stable(6 ns));

		if (isSt and clk'event and clk='0') then 
		memory(to_integer(unsigned(aluR))*8+31 downto to_integer(unsigned(aluR))*8)<= op2;
		else null;
		end if;
	end process;
end DM;
