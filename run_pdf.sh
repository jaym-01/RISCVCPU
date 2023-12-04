#!/bin/bash

dir="rtl"
top_name="riscv_top"

sv_files=(
    "$dir/$top_name.sv"
    "$dir/alu/alu.sv"
    "$dir/alu/regfile.sv"
    "$dir/control/control_unit.sv"
    "$dir/control/data_memory.sv"
    "$dir/control/extend.sv"
    "$dir/control/extend.sv"
    "$dir/control/instruction_memory.sv"
    "$dir/pc/pc.sv"
)

rm -rf obj_dir

verilator -Wall --cc --trace "${sv_files[@]}" --exe $dir/pdf_riscv_tb.cpp
 
make -j -C obj_dir/ -f V$top_name.mk V$top_name

echo "starting simulation"

sudo obj_dir/V"$top_name"

echo "ending simulation"