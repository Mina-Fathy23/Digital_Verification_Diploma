vlib work
vlog FSM_010.v FSM_010_Golden.v FSM_010_pkg.sv FSM_010_tb.sv +cover -covercells
vsim -voptargs=+acc work.FSM_010_tb -cover
do wave.do
coverage save FSM_010_tb.ucdb -onexit -du work.FSM_010
run -all
coverage exclude -du FSM_010 -togglenode {users_count[2]}
coverage exclude -du FSM_010 -togglenode {users_count[3]}
coverage exclude -du FSM_010 -togglenode {users_count[4]}
coverage exclude -du FSM_010 -togglenode {users_count[5]}
coverage exclude -du FSM_010 -togglenode {users_count[6]}
coverage exclude -du FSM_010 -togglenode {users_count[7]}
coverage exclude -du FSM_010 -togglenode {users_count[8]}
coverage exclude -du FSM_010 -togglenode {users_count[9]}
coverage exclude -src FSM_010.v -line 42 -code s
coverage exclude -src FSM_010.v -line 42 -code b
#quit -sim
#vcover report FSM_010_tb.ucdb -details -annotate -all -output coverage_rpt.txt