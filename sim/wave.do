onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_top/wb_intf/WB_CLK_I
add wave -noupdate /tb_top/wb_intf/WB_RST_I
add wave -noupdate /tb_top/wb_intf/ARST_I
add wave -noupdate /tb_top/wb_intf/WB_ADR_I
add wave -noupdate /tb_top/wb_intf/WB_DAT_I
add wave -noupdate /tb_top/wb_intf/WB_DAT_O
add wave -noupdate /tb_top/wb_intf/WB_WE_I
add wave -noupdate /tb_top/wb_intf/WB_STB_I
add wave -noupdate /tb_top/wb_intf/WB_CYC_I
add wave -noupdate /tb_top/wb_intf/WB_ACK_O
add wave -noupdate /tb_top/wb_intf/WB_INTA_O
add wave -noupdate /tb_top/i2c_intf/CLK_I
add wave -noupdate -radix hexadecimal /tb_top/I2C_SLV_DUT/myReg0
add wave -noupdate -radix hexadecimal /tb_top/I2C_SLV_DUT/myReg1
add wave -noupdate -radix hexadecimal /tb_top/I2C_SLV_DUT/myReg2
add wave -noupdate -radix hexadecimal /tb_top/I2C_SLV_DUT/myReg3
add wave -noupdate -radix hexadecimal /tb_top/I2C_SLV_DUT/myReg4
add wave -noupdate -radix hexadecimal /tb_top/I2C_SLV_DUT/myReg5
add wave -noupdate -radix hexadecimal /tb_top/I2C_SLV_DUT/myReg6
add wave -noupdate -radix hexadecimal /tb_top/I2C_SLV_DUT/myReg7
add wave -noupdate -radix hexadecimal /tb_top/I2C_SLV_DUT/regAddr
add wave -noupdate /tb_top/i2c_intf/CLK_I
add wave -noupdate /tb_top/i2c_intf/TB_SDA
add wave -noupdate /tb_top/i2c_intf/TB_SDA_O_EN
add wave -noupdate /tb_top/i2c_intf/TB_SDA_O
add wave -noupdate /tb_top/i2c_intf/TB_SDA_I
add wave -noupdate /tb_top/i2c_intf/TB_SCL
add wave -noupdate /tb_top/i2c_intf/TB_SCL_O_EN
add wave -noupdate /tb_top/i2c_intf/TB_SCL_O
add wave -noupdate /tb_top/i2c_intf/TB_SCL_I
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {294659326 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 206
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
WaveRestoreZoom {0 ps} {899458 ps}
