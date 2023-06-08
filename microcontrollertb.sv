import definitions::*;

module memoryController_tb;

  
  logic clk;
  logic reset;
  logic sda;
  logic scl;

  // Instantiate memoryController module
  memoryController dut (
    .clk(clk),
    .reset(reset),
    .sda(sda),
    .scl(scl),
    .wr_en(),
    .rd_en(),
    .data(),
    .addr()
  );

logic [3:0] IDLE, START, RECEIVE_INIT, RECEIVE, SEND_ACK, WAIT_STOP1, WAIT_STOP2;
  
  always begin
    clk = 1;
    #5;
    clk = 0;
    #5;
  end

  initial begin
    // Initialize signals
    reset = 1;
    sda = 1;
    scl = 1;

    // Reset the module
    @(posedge clk);
    reset = 0;
    @(posedge clk);

    // Apply start condition
    sda = 0;
    @(posedge clk);
    sda = 1;
    @(posedge clk);

    // receive condition and data
    scl = 0;
    @(posedge clk);
    sda = 0;
    @(posedge clk);
    sda = 1;
    @(posedge clk);
    sda = 0;
    @(posedge clk);
    sda = 1;
    @(posedge clk);

    // stop condition
    scl = 1;
    @(posedge clk);
    sda = 1;
    @(posedge clk);
	
    $finish;
  end

  // Assertions
  
  property p1;
  @(posedge clk) disable iff (reset)
   (dut.state == IDLE && dut.sda == 0 && $fell(dut.scl)) |-> dut.next_state == RECEIVE_INIT;
	endproperty
	check1: assert property (p1);
   
   property p2;
   @(posedge clk) disable iff (reset)
    (dut.state == RECEIVE && dut.sda == dut.sda_sample && $changed(dut.scl) && dut.scl == 0 && dut.cnt == 0) |-> dut.next_state == SEND_ACK;
  endproperty
	check2: assert property (p2);
	
   
   property  p3;
   @(posedge clk) disable iff (reset)
    (dut.state == SEND_ACK) |-> (dut.slv_addr_rx == 1'b1 && dut.mem_addr_rx == 1'b0) || (dut.slv_addr_rx == 1'b1 && dut.mem_addr_rx == 1'b1 && ((dut.rw_reg == 1'b0 && dut.data_rx == 1'b0) || (dut.rw_reg == 1'b1)));
  endproperty
  check3: assert property (p3);
  
  
   property p4;
   @(posedge clk) disable iff (reset)
    (dut.state == WAIT_STOP2 && $changed(dut.sda) && dut.sda == 1 && $changed(dut.scl) && dut.scl == 1) |-> dut.next_state == IDLE;
   endproperty
  check4: assert property (p4);
  
  
  property p5;
  @(posedge clk) disable iff (reset)
    (dut.state == RECEIVE) |-> (dut.rx_byte == {dut.sda_sample, dut.rx_byte[dut.CHUNK_SIZE-1:1]});
   endproperty
  check5: assert property (p5);
  
  
  property p6;
  @(posedge clk) disable iff (reset)
    (dut.state == WAIT_STOP2) |-> (dut.rd_en ^ dut.wr_en);
   endproperty
  check: assert property (p6);
  
  
   property p7;
   @(posedge clk) disable iff (reset)
    (dut.state == WAIT_STOP2 && dut.wr_en) |-> ($stable(dut.addr) && $stable(dut.data));
   endproperty
  check7: assert property (p7);
  
  
   property p8;
   @(posedge clk) disable iff (reset)
    (dut.state == WAIT_STOP2 && dut.rd_en) |-> $stable(dut.addr);
 endproperty
  check8: assert property (p8);
  
  
endmodule 