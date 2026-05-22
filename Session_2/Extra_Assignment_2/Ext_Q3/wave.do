onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Inputs
add wave -noupdate -color Gold /FSM_010_tb/x
add wave -noupdate -divider Outputs
add wave -noupdate -color Magenta /FSM_010_tb/y_dut
add wave -noupdate -color Magenta /FSM_010_tb/y_golden
add wave -noupdate -color Magenta -radix unsigned /FSM_010_tb/users_count_dut
add wave -noupdate -color Magenta -radix unsigned /FSM_010_tb/users_count_golden
add wave -noupdate -divider {Ctrl Signals}
add wave -noupdate /FSM_010_tb/rst
add wave -noupdate /FSM_010_tb/clk
add wave -noupdate -divider Counters
add wave -noupdate -radix unsigned /FSM_010_tb/error_count
add wave -noupdate -radix unsigned /FSM_010_tb/correct_count
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {22 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {65 ns}
