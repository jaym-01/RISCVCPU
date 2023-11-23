#!/bin/bash

# To be done later
task="task4"
top_name="f1_top"

sv_files=(
    "$task/$top_name.sv"
    "$task/f1_fsm.sv"
    "$task/clktick.sv"
    "$task/delay.sv"
    "$task/lfsr.sv"
)

rm -rf obj_dir

verilator -Wall --cc --trace "${sv_files[@]}" --exe $task/"$top_name"_tb.cpp
 
make -j -C obj_dir/ -f V$top_name.mk V$top_name

obj_dir/V"$top_name"