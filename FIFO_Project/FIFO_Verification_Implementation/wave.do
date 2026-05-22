onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Inputs
add wave -noupdate /top/f_if/data_in
add wave -noupdate -divider {Reference Output}
add wave -noupdate -expand /top/monitor/scoreboard_obj
add wave -noupdate -divider Outputs
add wave -noupdate /top/f_if/data_out
add wave -noupdate /top/f_if/wr_ack
add wave -noupdate /top/f_if/overflow
add wave -noupdate /top/f_if/full
add wave -noupdate /top/f_if/empty
add wave -noupdate /top/f_if/almostfull
add wave -noupdate /top/f_if/almostempty
add wave -noupdate /top/f_if/underflow
add wave -noupdate -divider {Ctrl Signals}
add wave -noupdate /top/f_if/wr_en
add wave -noupdate /top/f_if/rd_en
add wave -noupdate /top/f_if/rst_n
add wave -noupdate /top/f_if/clk
add wave -noupdate -divider {Interal Ptrs}
add wave -noupdate /top/DUT/wr_ptr
add wave -noupdate /top/DUT/rd_ptr
add wave -noupdate /top/DUT/count
add wave -noupdate -divider Memory
add wave -noupdate /top/DUT/mem
add wave -noupdate /top/monitor/transaction_obj
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2124 ns} 0}
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
WaveRestoreZoom {0 ns} {2239 ns}
