import definitions::*;

`define STALL(n) repeat(n) @(negedge clk)
`define ADDR_RNG ADDRWIDTH-1:0
`define DATA_RNG DATAWIDTH-1:0

module top();

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

	  ref_mem memModel;

	  int i, error;

  i2c_wrapper dut (.*);

  bind i2c_wrapper top_Assertions wrap_assert 
  			(clk,
	  		 reset,
	  		 D,
	  		 S,
	  		 MSBIn,
	  		 LSBIn,
	  		 addr,
	  		 wr_en, rd_en,
	  		 dataout,
	  		 DataValid,
	  		 mem_wr_en_in,
	  		 mem_data_in,
	  		 mem_addr_in,
	  		 data);


	initial begin
		clk = '0;
		forever #CLOCKWIDTH clk = ~clk;
	end

  task automatic wrMem(input [`ADDR_RNG] adr, input [`DATA_RNG] d);
        wr_en = 1; 
        addr = adr; 
        D = d; 
        memModel.write(adr, d);
        `STALL(1);
        wr_en = '0;
        `STALL(WRITE_LAT); 
    endtask

	task automatic rdMem(input [`ADDR_RNG] adr, output [`DATA_RNG] dout);
      rd_en = 1; 
      addr  = adr;
      `STALL(1);
      rd_en = 0;
      wait(DataValid);
      dout = dataout;
      `STALL(1);
  endtask

  task automatic mem_chk_full();
  	  logic [`DATA_RNG] dout;
		  error = 0; 

      	for(int i=0; i<(1 << (ADDRWIDTH)); i++) begin
      		rdMem(i, dout);
      		// $display("%d", dout);
					if (dout != memModel.read(i)) begin
           error = 1;
           $display("Error in Memory read at address = %d, value = %d", i, dout);
        	end
        	`STALL(1);
      	end

      	if (error == 0) $display("-- Memory chk thru i2c successful--");
 	endtask

	function automatic logic [DATAWIDTH-1:0] mem_val(logic [ADDRWIDTH-1:0] addr);
    mem_val = dut.mem.mem[addr];
  endfunction

	initial begin

		  data_rand #(DATAWIDTH) randData;
    	addr_rand #(ADDRWIDTH) randAddr;
    	logic [`DATA_RNG] dout;

		  ///////// Reset ////////
		  memModel = new;
		  reset = 1; wr_en = '0; rd_en = '0;
      `STALL(5);
      reset = 0;
      
      ////////// Memory Initialization(Write operation)//////////
      wr_en = 1; 
      S = 3'd1; MSBIn = 1'b0; LSBIn = 1'b0; // Parallel Load Operation
      for(i=0; i<(1 << (ADDRWIDTH)); i++) begin
       	wrMem(i,i); 
      end

      `STALL(10);

       $display("Checking intialized memory against the addr provided");

      error = 0; 
      	for(i=0; i<(1 << (ADDRWIDTH)); i++) begin
        if (mem_val(i) != i) begin
          error = 1;
          $display("Error in Memory initialization at address = %d, value = %d", i, mem_val(i));
        	end
        `STALL(1);
      	end
      	if (error == 0) $display("-- Memory initialization done --");

       `STALL(5);

       ////////// Memory Initialization chk (Read operation)//////////
       $display("Checking intialized memory against associative array");
       
		   mem_chk_full();

       ////////// Checking result by giving Random Values //////////

       randData = new;
			 randAddr = new;

    	 for(i=0; i<(1 << (ADDRWIDTH)); i++) begin
    	 		assert(randData.randomize()) else $error("Data randomization failed");
    	 		assert(randAddr.randomize()) else $error("Addr randomization failed");
					wrMem(randAddr.addr, randData.data); 
       end

       `STALL(5);

       $display("Checking randomly populated memory");
       mem_chk_full();

       $stop();

  end


endmodule : top
