// edge triggered D flip flop with an asynchronous clear
module DFF(Q, Clock, Clear, D);

parameter WIDTH = 1;
output logic [WIDTH-1:0] Q;
input Clock;
input Clear;
input [WIDTH-1:0] D;

always_ff @(posedge Clock or negedge Clear) begin : dff
	if(~Clear)
		 Q <= '0;
	else
		 Q <= D ;
	end

endmodule : DFF



