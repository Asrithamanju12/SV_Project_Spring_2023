module ShiftRegister
#(parameter N = 8,
  parameter ADDRWIDTH = 6)
 (output logic [N-1:0] Q,
 input Clock,
 input Clear,
 input [N-1:0] D,
 input [$clog2(N)-1:0] S,
 input MSBIn,
 input LSBIn,
 input wr_en,
 input [ADDRWIDTH-1:0] addr,
 output [ADDRWIDTH-1:0] addr_ff,
 output wr_en_ff);


wire w0, w1, w2, w3, w4, w5, w6, w7;

	Mux8to1 Mux_0 (.V({1'b0,  Q[1],  Q[7],  Q[1],  LSBIn,  Q[1],   D[0],  Q[0]}), .S(S), .Y(w0));

	Mux8to1 Mux_1 (.V({Q[0],  Q[2],  Q[0],  Q[2],  Q[0],   Q[2],   D[1],  Q[1]}), .S(S), .Y(w1));

	Mux8to1 Mux_2 (.V({Q[1],  Q[3],  Q[1],  Q[3],  Q[1],   Q[3],   D[2],  Q[2]}), .S(S), .Y(w2));

	Mux8to1 Mux_3 (.V({Q[2],  Q[4],  Q[2],  Q[4],  Q[2],   Q[4],   D[3],  Q[3]}), .S(S), .Y(w3));

	Mux8to1 Mux_4 (.V({Q[3],  Q[5],  Q[3],  Q[5],  Q[3],   Q[5],   D[4],  Q[4]}), .S(S), .Y(w4));

	Mux8to1 Mux_5 (.V({Q[4],  Q[6],  Q[4],  Q[6],  Q[4],   Q[6],   D[5],  Q[5]}), .S(S), .Y(w5));

	Mux8to1 Mux_6 (.V({Q[5],  Q[7],  Q[5],  Q[7],  Q[5],   Q[7],   D[6],  Q[6]}), .S(S), .Y(w6));

	Mux8to1 Mux_7 (.V({Q[6],  Q[7],  Q[6],  Q[0],  Q[6],   MSBIn,  D[7],  Q[7]}), .S(S), .Y(w7));


	DFF     DFF_0 (.Q(Q[0]), .Clock(Clock), .Clear(Clear), .D(w0));
	DFF     DFF_1 (.Q(Q[1]), .Clock(Clock), .Clear(Clear), .D(w1));
	DFF     DFF_2 (.Q(Q[2]), .Clock(Clock), .Clear(Clear), .D(w2));
	DFF     DFF_3 (.Q(Q[3]), .Clock(Clock), .Clear(Clear), .D(w3));
	DFF     DFF_4 (.Q(Q[4]), .Clock(Clock), .Clear(Clear), .D(w4));
	DFF     DFF_5 (.Q(Q[5]), .Clock(Clock), .Clear(Clear), .D(w5));
	DFF     DFF_6 (.Q(Q[6]), .Clock(Clock), .Clear(Clear), .D(w6));
	DFF     DFF_7 (.Q(Q[7]), .Clock(Clock), .Clear(Clear), .D(w7));

	DFF     DFF_wr_en_ff (.Q(wr_en_ff), .Clock(Clock), .Clear(Clear), .D(wr_en));
	DFF     #(.WIDTH(ADDRWIDTH)) DFF_addr_ff (.Q(addr_ff), .Clock(Clock), .Clear(Clear), .D(addr));


endmodule : ShiftRegister





