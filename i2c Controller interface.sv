module i2cController 
	#(parameter DATAWIDTH      = 8,
  	  parameter ADDRWIDTH      = 6,
	  parameter SLV_ADDR_SIZE  = 7,
	  parameter SLV_ADDR_PARAM = 7'b101_1001)
	 
	 (input logic clk, reset, wr_en, rd_en, 
	  input logic [DATAWIDTH-1:0] data, 
	  input logic [ADDRWIDTH-1:0] addr,  
	  inout sda, output logic scl);

localparam CHUNK_SIZE    = 8;


logic [SLV_ADDR_SIZE-1:0] slv_addr;
logic [CHUNK_SIZE-1:0] tx_byte;
logic slv_addr_tx, mem_addr_tx, data_tx;

logic [3:0] cnt, delay; // max value should be 8

logic scl_clk_en, scl_out_val;
logic sda_out_en, sda_out_val;
logic sda_sample;

 logic [DATAWIDTH-1:0] data_sample;
 logic [ADDRWIDTH-1:0] addr_sample;
 logic rw;


enum logic [2:0] {IDLE, START1, START2, TX_INIT, TRANSMIT, WAIT_ACK, STOP1, STOP2} state, next_state;

assign slv_addr = SLV_ADDR_PARAM;

always_ff @(posedge clk) begin
	if (delay != 0)
		if (cnt == 0)
			cnt <= delay - 1;
		else 
			cnt <= cnt - 1;
	else cnt <= 0;
	end


always_ff @(posedge clk)
begin
if (reset)
	state <= IDLE;
else
	state <= next_state;
end

always_comb begin
		next_state = state;

		case (state)
			IDLE: begin
				{tx_byte, delay} = '0;
				{slv_addr_tx, mem_addr_tx, data_tx} = '0;

				if (wr_en == 1 || rd_en == 1) begin
					next_state = START1;
					addr_sample = addr;
					data_sample = data;		
					rw          = wr_en ? 1'b0 : 1'b1;		
				end	
			end

			START1: begin
				next_state = START2;
			end

			START2: begin
				next_state = TX_INIT;
			end

			TX_INIT: begin
				next_state = TRANSMIT;
				delay = CHUNK_SIZE-1;

				if({slv_addr_tx, mem_addr_tx} == '0)
					tx_byte = {slv_addr, rw};
				else if({slv_addr_tx, mem_addr_tx} == 2'b10)
					tx_byte = {{CHUNK_SIZE-ADDRWIDTH{1'b0}},addr_sample};
				else begin
					data_tx = '1;
					tx_byte = data_sample;
				end
			end

			TRANSMIT: begin
				if(slv_addr_tx == '1)
					mem_addr_tx = '1;

				if(cnt == 0) begin
					next_state = WAIT_ACK;
					delay = '0;
				end
			end

			WAIT_ACK: begin
				slv_addr_tx = '1;
			
				if(sda_sample == 0) // The ack from slave (mem_intf)
					if ((data_tx == '0 && rw == '0) || mem_addr_tx == '0)
						next_state = TX_INIT; // mem data not yet transmitted
					else if ((rw == '1 && mem_addr_tx == '1) || data_tx == '1)
						next_state = STOP1;   // mem data transmitted
					else
						next_state = STOP1;   // default case; although shouldn't be reachable
			end

			STOP1: begin
				next_state <= STOP2;
			end

			STOP2: begin
				next_state <= IDLE;
			end

		endcase // state
	end


assign sda        = sda_out_en ? sda_out_val : 'z;
assign sda_sample = sda_out_en ? '1 : sda;

assign scl        = scl_clk_en ? clk : scl_out_val;

always_comb begin
	case (state)
		IDLE: 
				begin
					{sda_out_en, sda_out_val, scl_out_val} = '1;
					scl_clk_en = '0;
				end
	
 		START1: 
 		 		begin
 		 			sda_out_val = '0;
 		 		end
		START2:
				begin
					scl_out_val = '0;
				end

		TX_INIT:
				begin
					sda_out_en = '1;
					sda_out_val = tx_byte[CHUNK_SIZE-1];
				end
 		TRANSMIT:
 				begin
 					sda_out_en = '1;
 					scl_clk_en = '1;
					sda_out_val = tx_byte[cnt];
 				end
		WAIT_ACK:
				begin
					sda_out_en = '0;
				end
		STOP1:
				begin
					scl_clk_en  = '0;
					scl_out_val = '1;
					sda_out_en  = '1;
					sda_out_val = '0;
				end
		STOP2:
				begin
					sda_out_en  = '1;
					sda_out_val = '1;
				end
	endcase
end

endmodule : i2cController
