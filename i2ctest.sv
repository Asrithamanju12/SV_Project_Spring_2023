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
	//RESET
		repeat(5) @(negedge clk);
		reset = '1;
		repeat(5) @(negedge clk);
		reset = '0;
		repeat(5) @(negedge clk);
	//Asserting wr_en
		wr_en = '0;
		repeat(5) @(negedge clk);
		wr_en = '1
	//Stimulus for write operation
		repeat(10)
		begin
		addr = generateAddress();
		data = generateData();
		repeat(1) @(negedge clk);
		end
		
		wr_en = '0;
		repeat(35) @(negedge clk);
	
	//Stimulus for read operation
		rd_en = '1;
		repeat(10)
		begin
		addr = generateAddress();
		repeat(1) @(negedge clk);
		end
		
		rd_en = '0;

		repeat(25) @(negedge clk);

		$stop();

	end

	assign sda = sda_en ? '0 : 'z;

	//Acknowledge Signal Generation:
	//While Individually testing the I2C interface, the ack signal which should be received from the memory controller is generated in the test bench
	always @(posedge clk) begin
		if((i2c.state == 'd5) && (i2c.next_state == 'd5))
			sda_en = 1'b1;
		else
			sda_en = 1'b0;
	end


	function logic [ADDRWIDTH-1:0] generateAddress;
		generateAddress = $urandom_range(0, (1 << ADDRWIDTH));
	endfunction

	function logic [DATAWIDTH-1:0] generateData;
		generateData = $urandom_range(0,(1<<DATAWIDTH)));
	endfunction

endmodule : i2ctest
