onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Inputs
add wave -noupdate -color gold /my_mem_tb/data_in
add wave -noupdate -color gold -radix unsigned /my_mem_tb/address
add wave -noupdate -divider Outputs
add wave -noupdate -color magenta /my_mem_tb/data_out
add wave -noupdate -divider {Ctrl Signal}
add wave -noupdate -color cyan /my_mem_tb/write
add wave -noupdate -color cyan /my_mem_tb/read
add wave -noupdate -color cyan /my_mem_tb/clk
add wave -noupdate -divider Counters
add wave -noupdate -radix unsigned /my_mem_tb/error_count
add wave -noupdate -radix unsigned /my_mem_tb/correct_count
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {219 ns} 0}
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
WaveRestoreZoom {0 ns} {420 ns}
