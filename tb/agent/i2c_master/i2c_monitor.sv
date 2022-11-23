// ! Plan for I2C Monitor and how send expected item from Wishbone Monitor to Scoreboard.

// ! Flags & Registers
// * 1. bit [1:0] i2c_wr_flag
// * 3. reg [7:0] exp_mem_addr
// * 4. reg [7:0] exp_transmit_data
// * 6. reg [7:0] exp_slv_addr_wr_bit

// ! Wishbone Write 1
    //? a. Check if wb_addr_i is equal to `TXR.
    //? b. Check if wb_dat_o[7:1] == `SLVADDR & wb_dat_o[0] == `WR.
    //? c. Save wb_dat_o[7:0] to exp_slv_addr_wr_bit.
    //? d. i2c_wr_flag = i2c_wr_flag + 1

// ! Wishbone Write 2
    //? a. Check if wb_addr_i is equal to `CR.
    //? b. Check if wb_dat_o[7] == 1 & wb_dat_o[4] == 1.
    //? c. i2c_wr_flag = i2c_wr_flag + 1

// ! Wishbone Write 3
    //? a. Check if wb_addr_i is equal to `TXR.
    //? b. Save wb_dat_o[7:0] to exp_mem_addr.
    //? c. i2c_wr_flag = i2c_wr_flag + 1

// ! Wishbone Write 4
    //? a. Check if wb_addr_i is equal to `CR.
    //? b. Check if wb_dat_o[4] == 1.
    //? c. i2c_wr_flag = i2c_wr_flag + 1

// ! Wishbone Write 5
    //? a. Check if wb_addr_i is equal to `TXR.
    //? b. Save wb_dat_o[7:0] to exp_transmit_data.
    //? c. i2c_wr_flag = i2c_wr_flag + 1

// ! Wishbone Write 6
    //? a. Check if wb_addr_i is equal to `CR.
    //? b. Check if wb_dat_o[4] == 1 & wb_dat_o[6] == 1.
    //? c. i2c_wr_flag = i2c_wr_flag + 1