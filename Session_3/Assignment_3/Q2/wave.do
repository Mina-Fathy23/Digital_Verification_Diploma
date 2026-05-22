onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Inputs
add wave -noupdate -color Gold /counter_tb/data_load
add wave -noupdate -divider Outputs
add wave -noupdate -color Magenta /counter_tb/count_out
add wave -noupdate -color Magenta /counter_tb/count_out_expected
add wave -noupdate -color Plum /counter_tb/max_count
add wave -noupdate -color Plum /counter_tb/zero
add wave -noupdate -divider {Ctrl Signals}
add wave -noupdate /counter_tb/ce
add wave -noupdate /counter_tb/up_down
add wave -noupdate /counter_tb/load_n
add wave -noupdate /counter_tb/rst_n
add wave -noupdate /counter_tb/clk
add wave -noupdate -divider Counters
add wave -noupdate -radix unsigned /counter_tb/error_count
add wave -noupdate -radix unsigned /counter_tb/correct_count
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
WaveRestoreCursors {{Cursor 1} {202 ns} 0}
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
WaveRestoreZoom {1 ns} {213 ns}
