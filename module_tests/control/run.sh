verilator -Wall --cc ../../rtl/control/control_unit.sv --exe control_unit_tb.cpp
 
make -j -C obj_dir/ -f Vcontrol_unit.mk Vcontrol_unit

obj_dir/Vcontrol_unit

rm -rf obj_dir