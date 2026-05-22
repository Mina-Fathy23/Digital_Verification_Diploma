vlib work
vlog counter_pkg.sv
vlog *v  +cover
vsim -voptargs=+acc counter_top -cover
add wave *
coverage save counter_tb.ucdb -onexit -du work.counter
run -all
#quit -sim
#vcover report counter_tb.ucdb -details -annotate -all -output coverage_rpt.txt