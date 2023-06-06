onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top/dut/clk
add wave -noupdate /top/dut/reset
add wave -noupdate /top/dut/D
add wave -noupdate /top/dut/data
add wave -noupdate /top/dut/addr_ff
add wave -noupdate /top/dut/mux_addr
add wave -noupdate /top/dut/S
add wave -noupdate /top/dut/MSBIn
add wave -noupdate /top/dut/LSBIn
add wave -noupdate /top/dut/addr
add wave -noupdate /top/dut/wr_en
add wave -noupdate /top/dut/rd_en
add wave -noupdate /top/dut/wr_en_ff
add wave -noupdate /top/dut/sda
add wave -noupdate /top/dut/scl
add wave -noupdate /top/dut/i2c/tx_byte
add wave -noupdate /top/dut/i2c/state
add wave -noupdate /top/dut/i2c/data_tx
add wave -noupdate /top/dut/i2c/mem_addr_tx
add wave -noupdate /top/dut/i2c/slv_addr_tx
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {630 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 201
configure wave -valuecolwidth 66
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {0 ns} {1736 ns}
