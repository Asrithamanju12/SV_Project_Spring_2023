import definitions::*;

module top_Assertions
	 (// Inputs
	  input clk,
	  input reset,
	  input [DATAWIDTH-1:0] D,
	  input [$clog2(DATAWIDTH)-1:0] S,
	  input MSBIn,
	  input LSBIn,
	  input [ADDRWIDTH-1:0] addr,
	  input wr_en, rd_en,
	  // Outputs
	  input logic [DATAWIDTH-1:0] dataout,
	  input logic DataValid,
	  // Internal signals
	  input mem_wr_en_in,
	  input [DATAWIDTH-1:0] mem_data_in,
	  input [ADDRWIDTH-1:0] mem_addr_in,
	  input Q_data);

	 // Reset properties
	 property p_rst_all_inp_0;
	 	@(posedge clk)
	 	   (reset) |-> ({D, S, MSBIn, LSBIn, addr, wr_en, rd_en} !== '1);
	 endproperty
	 	a_rst_all_inp_0: assert property (p_rst_all_inp_0);

	 property p_rst_all_out_0;
	 	@(posedge clk)
	 	   (reset) |-> ({dataout, DataValid} == '0);
	 endproperty
	 	a_rst_all_out_0: assert property (p_rst_all_out_0);

	 // Non-reset behaviour
	 property p_wr_enable_lat;
	 	@(posedge clk) disable iff (reset)
	 	wr_en |-> ##WRITE_LAT mem_wr_en_in;
	 endproperty
	 	a_wr_enable_lat: assert property (p_wr_enable_lat);

	 property p_rd_dataValid;
	 	@(posedge clk) disable iff (reset)
	 	rd_en |-> ##READ_LAT DataValid;
	 endproperty
	 	a_rd_dataValid: assert property (p_rd_dataValid); 

	 property p_dataV_imp_dataknown;
	 	@(posedge clk) disable iff (reset)
	 	DataValid |-> (!$isunknown(dataout));
	 endproperty
	 	a_dataV_imp_dataknown: assert property (p_dataV_imp_dataknown);

	 // Write address check
	 property p_wr_addr_check;
	 	@(posedge clk) disable iff (reset)
	 	(wr_en) |-> ##WRITE_LAT (mem_addr_in === $past(addr,WRITE_LAT) );
	 endproperty
	 	a_wr_addr_check: assert property (p_wr_addr_check);

	 // Read address check
	 property p_rd_addr_check;
	 	@(posedge clk) disable iff (reset)
	 	(rd_en) |-> ##READ_LAT (mem_addr_in === $past(addr,READ_LAT) );
	 endproperty
	 	a_rd_addr_check: assert property (p_rd_addr_check);

	 // Data integrity checks

	 property p_noOps_data_intg;
	 	@(posedge clk) disable iff (reset)
	 	(wr_en && (S == 'd0)) |-> ##WRITE_LAT (mem_data_in === $past(Q_data,WRITE_LAT) );
	 endproperty
	 	a_noOps_data_intg: assert property (p_noOps_data_intg);

	 property p_IIload_data_intg;
	 	@(posedge clk) disable iff (reset)
	 	(wr_en && (S == 'd1)) |-> ##WRITE_LAT (mem_data_in === $past(D, WRITE_LAT) );
	 endproperty
	 	a_IIload_data_intg: assert property (p_IIload_data_intg);

	 property p_LSR_data_intg;
	 	@(posedge clk) disable iff (reset)
	 	(wr_en && (S == 'd2)) |-> ##WRITE_LAT (mem_data_in == {$past(MSBIn, WRITE_LAT),$past(Q_data[7:1], WRITE_LAT)});
	 endproperty
	 	a_LSR_data_intg: assert property (p_LSR_data_intg);











endmodule : top_Assertions
