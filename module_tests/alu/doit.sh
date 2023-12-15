#!/bin/sh

verilator -Wall --cc --trace ../../rtl/alu/alu.sv --exe alu_tb.cpp
 
make -j -C obj_dir/ -f Valu.mk Valu

obj_dir/Valu

rm -rf obj_dir