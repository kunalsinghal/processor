-------------------------------------------------------
 --! @file fileRead.vhdl
 --! @author Kunal Singhal and Swapnil Palash
 --! @brief This file for the implementation of file reading function
 -------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

package fileRead is
	--! This function converts a char to std_logic
	function to_std_logic_from_char(data: character) return std_logic;
	--! This function converts a string to a vector.
	function to_std_logic_vector(data: string) return std_logic_vector;
end fileRead;

package body fileRead is

function to_std_logic_from_char(data: character) return std_logic is
		variable toReturn: std_logic:='0';
	begin
		if (data='0') then
			toReturn:='0';
		else toReturn:='1';
		end if;
		return toReturn;
	end to_std_logic_from_char;
	function to_std_logic_vector(data: string) return std_logic_vector is
		variable toReturn: std_logic_vector( (data'high - data'low) downto 0);
		variable i: integer:=data'high - data'low;
	begin
			for j in data'range loop
				toReturn(i):=to_std_logic_from_char(data(j));
				i:=i-1;
			end loop;
		return toReturn;
	end to_std_logic_vector;
end fileRead;