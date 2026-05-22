vlib work
vlog testing_pkg.sv alu.sv tb.sv +cover -covercells
vsim -voptargs=+acc work.tb -cover
do wave.do
coverage save alu.ucdb -onexit -du work.alu_seq
run -all
coverage exclude -src alu.sv -line 18 -code s
coverage exclude -src alu.sv -line 18 -code b
#quit -sim
#vcover report alu.ucdb -details -annotate -all -output coverage_rpt.txt