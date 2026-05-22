vlib work
vlog counter_pkg.sv counter.v counter_golden.v counter_tb.sv +cover -covercells
vsim -voptargs=+acc work.counter_tb -cover
do wave.do
coverage save counter_tb.ucdb -onexit -du work.counter
run -all
#quit -sim
#vcover report counter_tb.ucdb -details -annotate -all -output coverage_rpt.txt