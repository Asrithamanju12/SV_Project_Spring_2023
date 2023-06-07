import definitions::*;

`define STALL(n) repeat(n) @(negedge clk)

`define MEM_WRITE(adr, d) \
      wr_en = 1; addr = adr; D = d; \
      `STALL(1);  \
      wr_en = 0;


module top();

  parameter DATAWIDTH      = 8;
  parameter ADDRWIDTH      = 6;

  	logic clk;
	  logic reset;
	  logic [DATAWIDTH-1:0] D;
	  logic [$clog2(DATAWIDTH)-1:0] S;
	  logic MSBIn;
	  logic LSBIn;
	  logic [ADDRWIDTH-1:0] addr;
	  logic wr_en, rd_en;
	  logic [DATAWIDTH-1:0] dataout;
	  logic DataValid;

	  int i, error;

  i2c_wrapper dut (.*);
  

  parameter CLOCKCYCLE = 20;
  parameter CLOCKWIDTH = CLOCKCYCLE/2;

	initial begin
		clk = '0;
		forever #CLOCKWIDTH clk = ~clk;
	end

//	initial begin
//		repeat(5) @(negedge clk);
//		reset = '1;
//		repeat(5) @(negedge clk);
//		reset = '0;
//		repeat(5) @(negedge clk);
//
//		wr_en = '0;
//		repeat(5) @(negedge clk);
//		wr_en = '1;
//		addr = 6'b00_1101;
//		S = 3'd1; D = 8'b1110_0101;  MSBIn = 1'b1; LSBIn = 1'b0;
//		repeat(1) @(negedge clk);
//		wr_en = '0;
//		repeat(40) @(negedge clk);
//
//		rd_en = '1;
//		addr = 6'b00_1101;
//
//		repeat(1) @(negedge clk);
//		rd_en = '0;
//
//		repeat(30) @(negedge clk);
//
//		$stop();
//
//	end

	// assign dut.sda = sda_en ? '0 : 'z;

	// always @(posedge clk) begin
	// 	if((i2c_dut.i2c.state == 'd5) && (i2c_dut.i2c.next_state == 'd5))
	// 		sda_en = 1'b1;
	// 	else
	// 		sda_en = 1'b0;
	// end

	initial begin
		 reset = 1;
      `STALL(5);
      reset = 0;
      
      ////////// Memory Initialization
 
      repeat(2**ADDRWIDTH-1) @(negedge clk) begin
      	wr_en = 1; 
      	for(i=0; i<256; i++) begin
      	S = 3'd1; MSBIn = 1'b0; LSBIn = 1'b0; // Parallel Load Operation
        `MEM_WRITE(i,i); 
        `STALL(1);
      	end
      	wr_en = '0;
      end

      $stop();


	end



endmodule : top
