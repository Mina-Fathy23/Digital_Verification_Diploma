onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Inputs
add wave -noupdate -color gold -radix decimal /tb/operand1
add wave -noupdate -color gold -radix decimal /tb/operand2
add wave -noupdate -divider Outputs
add wave -noupdate -color magenta -radix decimal /tb/out
add wave -noupdate -divider {Ctrl Signals}
add wave -noupdate /tb/clk
add wave -noupdate -color cyan /tb/rst
add wave -noupdate -color cyan /tb/opcode
add wave -noupdate -divider Counters
add wave -noupdate -radix unsigned /tb/error_count
add wave -noupdate -radix unsigned /tb/correct_count
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {23 ns} 0}
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
WaveRestoreZoom {0 ns} {69 ns}
