vlib work
vlog config_reg_pkg.sv config_reg_buggy_questa.svp config_reg_tb.sv +cover -covercells
vsim -voptargs=+acc work.Config_reg_tb -cover
do wave.do
coverage save config_reg.ucdb -onexit -du work.config_reg
run -all
#quit -sim
#vcover report config_reg.ucdb -details -annotate -all -output coverage_rpt.txt