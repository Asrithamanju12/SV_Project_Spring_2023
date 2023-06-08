interface memorysubsystem (input logic clk,rst);
parameter DATAWIDTH=8;
parameter ADDRWIDTH=7;
localparam CHUNK_SIZE    = 8;

logic sda;
logic scl;
logic wr_en, rd_en;
logic [DATAWIDTH-1:0] data;
logic [ADDRWIDTH-1:0] addr;


logic [3:0] cnt, delay; // max value should be 8
logic [SLV_ADDR_SIZE-1:0] slv_addr;
logic [3:0] cnt, delay;
logic sda_out_en;
logic sda_sample;
 


modport i2c_master(
	inout sda, 
	output scl
	input wr_en, 
	input rd_en, 
	input [DATAWIDTH-1:0] data, 
	input [ADDRWIDTH-1:0] addr,  
);

modport mc_slave (
   inout sda, 
   input scl,
   output wr_en, 
   output rd_en,
   output [DATAWIDTH-1:0] data,
   output [ADDRWIDTH-1:0] addr,
);

endinterface