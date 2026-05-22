onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Inputs
add wave -noupdate -color Gold -radix decimal /ALSU_tb/A
add wave -noupdate -color Gold -radix decimal /ALSU_tb/B
add wave -noupdate -color Gold /ALSU_tb/cin
add wave -noupdate -color Gold /ALSU_tb/serial_in
add wave -noupdate -divider Outputs
add wave -noupdate -color Magenta /ALSU_tb/leds
add wave -noupdate -color Magenta /ALSU_tb/leds_expected
add wave -noupdate -color Magenta -radix decimal /ALSU_tb/out
add wave -noupdate -color Magenta -radix decimal /ALSU_tb/out_expected
add wave -noupdate -divider {Crtl Signals}
add wave -noupdate -color Cyan /ALSU_tb/opcode
add wave -noupdate -color Cyan /ALSU_tb/red_op_A
add wave -noupdate -color Cyan /ALSU_tb/red_op_B
add wave -noupdate -color Cyan /ALSU_tb/bypass_A
add wave -noupdate -color Cyan /ALSU_tb/bypass_B
add wave -noupdate -color Cyan /ALSU_tb/direction
add wave -noupdate /ALSU_tb/rst
add wave -noupdate /ALSU_tb/clk
add wave -noupdate -divider Counters
add wave -noupdate -radix unsigned /ALSU_tb/error_count
add wave -noupdate -radix unsigned /ALSU_tb/correct_count
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {19 ns} 0}
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
WaveRestoreZoom {0 ns} {76 ns}
