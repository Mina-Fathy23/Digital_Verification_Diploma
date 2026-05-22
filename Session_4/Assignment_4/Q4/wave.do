onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Inputs
add wave -noupdate -color Gold /Config_reg_tb/data_in
add wave -noupdate -color Gold /Config_reg_tb/address
add wave -noupdate -divider {Ctrl Signals}
add wave -noupdate /Config_reg_tb/reset
add wave -noupdate /Config_reg_tb/write
add wave -noupdate /Config_reg_tb/clk
add wave -noupdate -divider Outputs
add wave -noupdate /Config_reg_tb/data_out
add wave -noupdate -divider {Debug Signals}
add wave -noupdate -expand /Config_reg_tb/obj
add wave -noupdate /Config_reg_tb/data
add wave -noupdate -divider Counters
add wave -noupdate -radix unsigned /Config_reg_tb/error_count
add wave -noupdate -radix unsigned /Config_reg_tb/correct_count
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {5 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 94
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
WaveRestoreZoom {0 ns} {16 ns}
