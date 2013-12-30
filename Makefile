all:
	@ghdl -a fileRead.vhdl
	@ghdl -a IFUnit.vhdl
	@ghdl -a CUnit.vhdl
	@ghdl -a OFUnit.vhdl
	@ghdl -a EXUnit.vhdl
	@ghdl -a MAUnit.vhdl
	@ghdl -a SimpleRISC.vhdl
	@chmod 777 *.sh