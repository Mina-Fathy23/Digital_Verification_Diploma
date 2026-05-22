onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -color Gold /ALU_4_bit_tb/A
add wave -noupdate -color Gold /ALU_4_bit_tb/B
add wave -noupdate -color Gold /ALU_4_bit_tb/Opcode
add wave -noupdate -color Magenta /ALU_4_bit_tb/C_dut
add wave -noupdate /ALU_4_bit_tb/clk
add wave -noupdate /ALU_4_bit_tb/reset
add wave -noupdate -radix unsigned /ALU_4_bit_tb/correct_count
add wave -noupdate -radix unsigned /ALU_4_bit_tb/error_count
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {378 ns} 0}
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
WaveRestoreZoom {0 ns} {38 ns}
