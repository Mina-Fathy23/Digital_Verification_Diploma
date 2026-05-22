onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {ASLU SIGNALS}
add wave -noupdate -divider Input
add wave -noupdate -color gold -radix decimal /top/alsuif/A
add wave -noupdate -color gold -radix decimal /top/alsuif/B
add wave -noupdate -color gold /top/alsuif/cin
add wave -noupdate -color gold /top/alsuif/serial_in
add wave -noupdate -divider Outputs
add wave -noupdate -color magenta -radix decimal /top/alsuif/out
add wave -noupdate -color magenta /top/alsuif/leds
add wave -noupdate -divider {Ctrl Signals}
add wave -noupdate -color cyan /top/alsuif/opcode
add wave -noupdate -color cyan /top/alsuif/rst
add wave -noupdate -color cyan /top/alsuif/bypass_A
add wave -noupdate -color cyan /top/alsuif/bypass_B
add wave -noupdate -color cyan /top/alsuif/red_op_A
add wave -noupdate -color cyan /top/alsuif/red_op_B
add wave -noupdate -color cyan /top/alsuif/direction
add wave -noupdate -color cyan /top/alsuif/clk
add wave -noupdate -divider {SHIFT REG SIGNALS}
add wave -noupdate /top/shiftif/serial_in
add wave -noupdate /top/shiftif/direction
add wave -noupdate /top/shiftif/mode
add wave -noupdate /top/shiftif/datain
add wave -noupdate /top/shiftif/dataout
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1585 ns} 0}
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
WaveRestoreZoom {3923 ns} {4055 ns}
