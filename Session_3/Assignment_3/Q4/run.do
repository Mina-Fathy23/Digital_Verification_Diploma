vlib work
vlog memory.sv memory_tb.sv +cover -covercells
vsim -voptargs=+acc work.my_mem_tb -cover
do wave.do
coverage save memory_tb.ucdb -onexit -du work.my_mem
run -all
#quit -sim
#vcover report memory_tb.ucdb -details -annotate -all -output coverage_rpt.txt