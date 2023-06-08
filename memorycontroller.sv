import definitions::*;

module memoryController
  (input logic clk, reset,
   inout sda, 
   input logic scl,
   output logic wr_en, rd_en,
   output logic [DATAWIDTH-1:0] data,
   output logic [ADDRWIDTH-1:0] addr);

  localparam CHUNK_SIZE    = 8;

  logic [SLV_ADDR_SIZE-1:0] slv_addr;
  logic [CHUNK_SIZE-1:0] rx_byte;
  logic slv_addr_rx, mem_addr_rx, data_rx;

  logic [3:0] cnt, delay; 


  logic sda_out_en;
  logic sda_sample;

 
  logic rw_reg;

  enum logic [3:0] {IDLE, START, RECEIVE_INIT, RECEIVE, SEND_ACK, WAIT_STOP1, WAIT_STOP2} state, next_state;

  assign slv_addr = SLV_ADDR_PARAM;

  always @(posedge clk) begin
    if (delay != 0)
      if (cnt == 0)
        cnt <= delay - 1;
      else 
        cnt <= cnt - 1;
    else cnt <= 0;
  end

  always_ff @(posedge clk) begin
    if (reset)
      state <= IDLE;
    else
      state <= next_state;
  end

  always_ff @(posedge clk)
    if (sda_out_en) 
      sda_sample <= '0;
    else
      sda_sample <= sda;

  always_comb begin
    next_state = state;

    case (state)
      IDLE:
        begin
          
          {rx_byte, delay} = '0;
          {slv_addr_rx, mem_addr_rx, data_rx} = '0;

          if (scl == '1 && sda == '0) 
            next_state = START;
         
        end

      START:
        begin
        
          if (scl == '0 && sda == '0) begin
            next_state = RECEIVE_INIT;
          end 
          else if (sda == '1) 
            next_state = IDLE;
        end

     

      RECEIVE_INIT:
        begin
            rx_byte = '0;
            next_state = RECEIVE;
            delay = CHUNK_SIZE;
            if ((slv_addr_rx == '1) && (mem_addr_rx == '1))
              data_rx = '1;
         
        end

      RECEIVE:
        begin

          rx_byte[cnt] = sda_sample;
          
          if (slv_addr_rx == '0) begin
            if (cnt != 0) begin
              if (sda_sample != slv_addr[cnt-1]) 
                next_state = IDLE;
              end
            else
              rw_reg = sda_sample;
          end

          else  
            mem_addr_rx = '1;
            
          if (cnt == '0) begin
            next_state = SEND_ACK;
            delay = '0;
          end


        end

      SEND_ACK:
        begin
          slv_addr_rx = '1;
          if (mem_addr_rx == '0)
            next_state = RECEIVE_INIT;
          else if ((rw_reg == '0) && (data_rx == '0)) begin
            addr = rx_byte[ADDRWIDTH-1:0];
            next_state = RECEIVE_INIT;
          end
          else begin
            if(rw_reg == '0)
              data = rx_byte;
            else
              addr = rx_byte;
            next_state = WAIT_STOP1;
          end
       
        end

      WAIT_STOP1: 
        begin
          if (scl == '1)
            next_state = WAIT_STOP2;
        end

      WAIT_STOP2:
        begin
          if (sda == '1) 
            next_state = IDLE;

          end
    endcase // state
  end

  

  assign sda = sda_out_en ? '0 : 'z;

always_comb begin

    {sda_out_en, wr_en, rd_en} = '0;
    case (state)
    
      SEND_ACK:
        begin
          
          sda_out_en = '1;

        end

      WAIT_STOP2:
        begin
          wr_en = ~rw_reg;
          rd_en =  rw_reg;
        end
    endcase
  end

endmodule : memoryController
