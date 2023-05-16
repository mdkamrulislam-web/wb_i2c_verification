onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_top/wb_intf/WB_CLK_I
add wave -noupdate /tb_top/wb_intf/WB_ADR_I
add wave -noupdate /tb_top/wb_intf/WB_DAT_I
add wave -noupdate /tb_top/wb_intf/WB_DAT_O
add wave -noupdate /tb_top/i2c_intf/TB_SCL
add wave -noupdate /tb_top/i2c_intf/TB_SDA
add wave -noupdate /tb_top/i2c_intf/SCL_PADOEN_O
add wave -noupdate /tb_top/i2c_intf/SDA_PADOEN_O
add wave -noupdate /tb_top/i2c_intf/SCL_PAD_I
add wave -noupdate /tb_top/i2c_intf/SDA_PAD_I
add wave -noupdate /tb_top/I2C_SLV_DUT/myReg0
add wave -noupdate /tb_top/I2C_SLV_DUT/myReg1
add wave -noupdate /tb_top/I2C_SLV_DUT/myReg2
add wave -noupdate /tb_top/I2C_SLV_DUT/myReg3
add wave -noupdate /tb_top/I2C_SLV_DUT/regAddr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {428726959 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 217
configure wave -valuecolwidth 40
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {500997 ns}
