module i2c_wrapper 
	#(parameter DATAWIDTH      = 8,
      parameter ADDRWIDTH      = 6)
	 (input clk,
	  input reset,
	  input [DATAWIDTH-1:0] D,
	  input [$clog2(DATAWIDTH)-1:0] S,
	  input MSBIn,
	  input LSBIn,
	  input [ADDRWIDTH-1:0] addr,
	  input wr_en, rd_en,
	  output logic [DATAWIDTH-1:0] dataout,
	  output logic DataValid);

	 logic [DATAWIDTH-1:0] data;
	 logic [ADDRWIDTH-1:0] addr_ff;
	 logic [ADDRWIDTH-1:0] mux_addr;
	 logic wr_en_ff;
	 logic scl;
	 wire sda;

	 logic mem_wr_en_in;
  	 logic mem_rd_en_in;
  	 logic [DATAWIDTH-1:0] mem_data_in;
	 logic [ADDRWIDTH-1:0] mem_addr_in;

	 assign mux_addr = wr_en_ff ? addr_ff : addr ;

	ShiftRegister SR(.Q(data), .Clock(clk), .Clear(~reset), .D(D), .S(S), .MSBIn(MSBIn), .LSBIn(LSBIn),
					 .wr_en(wr_en), .addr(addr), .addr_ff(addr_ff), .wr_en_ff(wr_en_ff));

	i2cController i2c(.wr_en(wr_en_ff), .addr(mux_addr), .*);

	memoryController mmc(.wr_en(mem_wr_en_in), .rd_en(mem_rd_en_in),
						 .addr(mem_addr_in),   .data(mem_data_in), .*);

	Memory mem (.wr_en(mem_wr_en_in), .rd_en(mem_rd_en_in), .addr(mem_addr_in), .datain(mem_data_in), .*);


endmodule : i2c_wrapper
