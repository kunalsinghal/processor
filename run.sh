#!/bin/bash
cp $1 input
make
ghdl -e SimpleRISC
ghdl -r SimpleRISC --stop-time=1500ns --wave=Check.ghw
gtkwave Check.ghw
