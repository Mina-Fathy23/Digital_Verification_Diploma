onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -color Gold /adder_tb/A
add wave -noupdate -color Gold /adder_tb/B
add wave -noupdate -color Magenta /adder_tb/C_dut
add wave -noupdate /adder_tb/CLK
add wave -noupdate /adder_tb/reset
add wave -noupdate -radix unsigned /adder_tb/error_count
add wave -noupdate -radix unsigned /adder_tb/correct_count
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
WaveRestoreZoom {0 ns} {23 ns}
