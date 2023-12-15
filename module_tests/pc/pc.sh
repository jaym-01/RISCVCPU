#!/bin/sh

#run Verilator to translate Verilog into C++
verilator -Wall --cc --trace ../../rtl/pc/pc.sv --exe pc_tb.cpp
 
make -j -C obj_dir/ -f Vpc.mk Vpc
# run executable simulation file
obj_dir/Vpc

rm -rf obj_dir
