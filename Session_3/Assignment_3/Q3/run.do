vlib work
vlog ALSU.v ALSU_Golden_2.v D_FF.v ALSU_tb.sv ALSU_pkg.sv +cover -covercells
vsim -voptargs=+acc work.ALSU_tb -cover
do wave.do
coverage save ALSU_tb.ucdb -onexit -du work.ALSU
run -all
coverage exclude -src ALSU.v -line 111 -code s
coverage exclude -src ALSU.v -line 111 -code b
#quit -sim
#vcover report ALSU_tb.ucdb -details -annotate -all -output coverage_rpt.txt