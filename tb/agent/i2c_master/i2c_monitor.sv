// ! Plan for I2C Monitor and how send expected item from Wishbone Monitor to Scoreboard.

// ! I2C Transmit Test
// * 1. Take a flag [1:0] wbMtrToScb, reg [7:0] mem_addr, reg [7:0] t_data, reg [7:0] r_data reg [6:0] i_slv_addr.

// * 2. During the 1st Wishbone Write Condition, Check if wb_addr_i is equal to `TXR, wb_dat_o[7:1] is equal to the I2C Slave Address, & wb_dat_o[0] is equal to `WR bit. Save wb_dat_o[7:1] to i_slv_addr.

// * 3. If the avobe check passes set wbMtrToScb to 1.

// * 4. During the 3nd Wishbone Write Condition, Check if wb_addr_i is equal to `TXR and save wb_dat_o to mem_addr.
