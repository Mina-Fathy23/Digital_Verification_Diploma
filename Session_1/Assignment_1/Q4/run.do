vlib work
vlog DSP.v DSP_tb.sv DSP_Golden.v D_FF.v  +cover -covercells
vsim -voptargs=+acc work.DSP_tb -cover
add wave *
coverage save DSP.ucdb -onexit -du work.DSP
run -all
#quit -sim
#vcover report DSP.ucdb -details -annotate -all -output coverage_rpt.txt