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
	  input wr_en, rd_en);

	 logic [DATAWIDTH-1:0] data;
	 logic [ADDRWIDTH-1:0] addr_ff;
	 logic [ADDRWIDTH-1:0] mux_addr;
	 logic wr_en_ff;
	 logic scl;
	 wire sda;

	 assign mux_addr = wr_en_ff ? addr_ff : addr ;

	ShiftRegister SR(.Q(data), .Clock(clk), .Clear(~reset), .D(D), .S(S), .MSBIn(MSBIn), .LSBIn(LSBIn), .wr_en(wr_en), .addr(addr), .addr_ff(addr_ff), .wr_en_ff(wr_en_ff));

	i2cController i2c(.wr_en(wr_en_ff), .addr(mux_addr), .*);

endmodule : i2c_wrapper
