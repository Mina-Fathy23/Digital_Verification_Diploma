vlib work
vlog ALU.v ALU_tb.sv ALU_pkg.sv +cover -covercells
vsim -voptargs=+acc work.ALU_tb -cover
do wave.do
coverage save ALU_tb.ucdb -onexit -du work.ALU_4_bit
run -all
coverage exclude -src ALU.v -line 26 -code s
coverage exclude -src ALU.v -line 26 -code b
quit -sim
vcover report ALU_tb.ucdb -details -annotate -all -output coverage_rpt.txt