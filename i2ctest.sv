parameter DATAWIDTH = 8;
parameter ADDRWIDTH = 6;

module i2ctest();
	logic clk, reset, wr_en, rd_en;
	logic [DATAWIDTH-1:0] data;
	logic [ADDRWIDTH-1:0] addr;  
	wire sda;
	logic scl;

	logic sda_en;

	i2cController i2c(.*);

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
		data = 8'b1001_1011;
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

	assign sda = sda_en ? '0 : 'z;

	always @(posedge clk) begin
		if((i2c.state == 'd5) && (i2c.next_state == 'd5))
			sda_en = 1'b1;
		else
			sda_en = 1'b0;
	end


endmodule : i2ctest
