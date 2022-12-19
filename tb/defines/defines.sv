/*#########################
Register Address Definition
#########################*/
`define PRER_LO 3'b000
`define PRER_HI 3'b001
`define CTR     3'b010
`define TXR     3'b011
`define CR      3'b100
`define RXR     3'b011
`define SR      3'b100
`define SLVADDR 7'b011_1100 
`define WR      1'b0  
`define RD      1'b1

/*########################
## DATAWIDTH Definition ##
########################*/
`define DATAWIDTH_64 64
`define DATAWIDTH_56 56
`define DATAWIDTH_48 48
`define DATAWIDTH_40 40
`define DATAWIDTH_32 32
`define DATAWIDTH_24 24
`define DATAWIDTH_16 16
`define DATAWIDTH_8  8

/*#########################
## SCOREBOARD Definition ##
#########################*/
`define DATADEPTH 8