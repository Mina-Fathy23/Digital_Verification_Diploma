vlib work
vlog -f src_files.list +cover -covercells +define+SIM
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all -cover
do wave.do
run 0
add wave -position insertpoint  \
sim:/top/monitor/transaction_obj
coverage save tb_FIFO.ucdb -onexit -du work.FIFO
run -all