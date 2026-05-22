vlib work
vlog -f Shift_reg/src_files.list\
    +incdir+Shift_reg/uvm/inlcudes \
    +incdir+Shift_reg/uvm \
    +incdir+Shift_reg/rtl  +cover -covercells

vlog -f  ALSU/src_files.list +incdir+ALSU/uvm/inlcudes +cover -covercells

vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all -cover
do wave.do
coverage save ALSU_tb.ucdb -onexit -du work.ALSU
run -all
#quit -sim
#vcover report ALSU_tb.ucdb -details -annotate -all -output ALSU_coverage_rpt.txt
#vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all -cover
#coverage save Shift_reg_tb.ucdb -onexit -du work.shift_reg
#run -all
#quit -sim
#vcover report Shift_reg_tb.ucdb -details -annotate -all -output Shift_reg_coverage_rpt.txt