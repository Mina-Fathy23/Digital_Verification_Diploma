vlib work
vlog priority_enc.v priority_enc_tb.sv  +cover -covercells
vsim -voptargs=+acc work.priority_enc_tb -cover
add wave *
coverage save priority_enc.ucdb -onexit -du work.priority_enc
run -all
#quit -sim
#vcover report priority_enc.ucdb -details -annotate -all -output coverage_rpt.txt