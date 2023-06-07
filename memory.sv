import definitions::*;

module Memory
 (input  logic clk, reset,
  input  logic  wr_en, rd_en,
  input  logic  [ADDRWIDTH-1:0] addr,
  input  logic  [DATAWIDTH-1:0]  datain,
  output logic  [DATAWIDTH-1:0]  dataout,
  output logic DataValid);

logic [DATAWIDTH-1:0] mem [2**ADDRWIDTH-1:0];

  always_ff @(posedge clk)
  begin
  	if (reset)
  		for (int i; i<2**ADDRWIDTH; i++)
  			mem[i] = '0;
    else if (wr_en) 
    	mem[addr] <= datain;
  end 

  always_comb 
  begin
  	if (rd_en) begin
  		dataout = mem[addr];
  		DataValid = '1;
  	end

  	else begin
  		dataout = '0;
  		DataValid = '0;
  	end
  end
   
endmodule
