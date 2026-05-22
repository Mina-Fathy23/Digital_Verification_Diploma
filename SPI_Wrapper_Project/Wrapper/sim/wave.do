onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Inputs
add wave -noupdate -color gold /top/wrapperif/MOSI
add wave -noupdate -divider Outputs
add wave -noupdate -color magenta /top/wrapperif/MISO
add wave -noupdate -color magenta /top/wrapperif/MISO_golden
add wave -noupdate -divider {Ctrl Signals}
add wave -noupdate -color Cyan /top/wrapperif/SS_n
add wave -noupdate -color Cyan /top/wrapperif/rst_n
add wave -noupdate -color Cyan /top/wrapperif/clk
add wave -noupdate -divider {Seq Item}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {5864 ns} 0}
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
WaveRestoreZoom {5750 ns} {6015 ns}
