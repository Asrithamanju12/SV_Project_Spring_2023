onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /i2ctest/i2c/clk
add wave -noupdate /i2ctest/i2c/reset
add wave -noupdate /i2ctest/i2c/wr_en
add wave -noupdate /i2ctest/i2c/rd_en
add wave -noupdate /i2ctest/i2c/data
add wave -noupdate -divider SDA
add wave -noupdate /i2ctest/i2c/addr
add wave -noupdate /i2ctest/i2c/sda
add wave -noupdate /i2ctest/i2c/sda_out_en
add wave -noupdate /i2ctest/i2c/sda_sample
add wave -noupdate /i2ctest/i2c/sda_out_val
add wave -noupdate -divider SCL
add wave -noupdate /i2ctest/i2c/scl
add wave -noupdate /i2ctest/i2c/scl_clk_en
add wave -noupdate /i2ctest/i2c/scl_out_val
add wave -noupdate -divider REGISTERS
add wave -noupdate /i2ctest/i2c/tx_byte
add wave -noupdate /i2ctest/i2c/cnt
add wave -noupdate /i2ctest/i2c/slave_addr_tx
add wave -noupdate /i2ctest/i2c/mem_addr_tx
add wave -noupdate /i2ctest/i2c/delay
add wave -noupdate /i2ctest/i2c/state
add wave -noupdate /i2ctest/i2c/next_state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {388 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 207
configure wave -valuecolwidth 100
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
WaveRestoreZoom {244 ns} {732 ns}
bookmark add wave bookmark0 {{256 ns} {768 ns}} 0
