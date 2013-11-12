--  A testbench has no ports.
     use std.textio.all; --  Imports the standard textio package.
    
     entity adder_tb is
     end adder_tb;
     
     architecture behav of adder_tb is
        --  Declaration of the component that will be instantiated.
        component adder
          port (i0, i1 : in bit; ci : in bit; s : out bit; co : out bit);
        end component;
	signal a,b,c:bit;
	signal x,y:bit;
    begin
	blah:adder port map(a,b,c,x,y); 
    process
	variable outline:line;
	variable aa,bb,cc:bit;
	begin
	  readline(input,outline); 
	  read(outline,aa);
	  readline(input,outline); 
	  read(outline,bb);
	  readline(input,outline); 
	  read(outline,cc);
	  a <= aa;
	  b <= bb; 
	  c <= cc;
	  wait for 20 ns; 
	  write(outline,y); 
	  write(outline,x); 
	  writeline(output,outline);
	  wait;
    end process;
    end behav;