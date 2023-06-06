module top();

  parameter DATAWIDTH      = 8;
  parameter ADDRWIDTH      = 6;

  logic  clk;
  logic  reset;
  logic  [DATAWIDTH-1:0] D;
  logic  [$clog2(DATAWIDTH)-1:0] S;
  logic  MSBIn;
  logic  LSBIn;
  logic  [ADDRWIDTH-1:0] addr;
  logic  wr_en, rd_en;
  logic  scl;
  wire   sda;
  logic  sda_en;

  i2c_wrapper dut (.*);

  parameter CLOCKCYCLE = 20;
  parameter CLOCKWIDTH = CLOCKCYCLE/2;

	initial begin
		clk = '0;
		forever #CLOCKWIDTH clk = ~clk;
	end

	initial begin
		repeat(5) @(negedge clk);
		reset = '1;
		repeat(5) @(negedge clk);
		reset = '0;
		repeat(5) @(negedge clk);

		wr_en = '0;
		repeat(5) @(negedge clk);
		wr_en = '1;
		addr = 6'b00_1101;
		S = 3'd1; D = 8'b1110_0101;  MSBIn = 1'b1; LSBIn = 1'b0;
		repeat(1) @(negedge clk);
		wr_en = '0;
		repeat(35) @(negedge clk);

		rd_en = '1;
		addr = 6'b01_0011;

		repeat(1) @(negedge clk);
		rd_en = '0;

		repeat(25) @(negedge clk);

		$stop();

	end

	assign dut.sda = sda_en ? '0 : 'z;

	always @(posedge clk) begin
		if((dut.i2c.state == 'd5) && (dut.i2c.next_state == 'd5))
			sda_en = 1'b1;
		else
			sda_en = 1'b0;
	end



endmodule : top