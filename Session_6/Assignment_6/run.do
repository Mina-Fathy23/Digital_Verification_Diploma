vlib work
vlog -f src_files.list \
    +incdir+uvm/inlcudes \
    +incdir+uvm \
    +incdir+rtl +cover -covercells
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all -cover
do wave.do
run 0
add wave -position insertpoint  \
sim:/uvm_root/uvm_test_top/env/sb/seq_item
add wave -position insertpoint  \
sim:/uvm_root/uvm_test_top/env/sb/out_ref
#add wave -position insertpoint  \
#sim:/uvm_root/uvm_test_top/env/sb/leds_ref

run -all