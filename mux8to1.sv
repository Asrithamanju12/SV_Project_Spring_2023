module Mux8to1(Y, V, S);
  parameter N = 8;
 
  output logic Y;
  input [N-1:0] V;
  input [$clog2(N)-1:0] S;

  assign Y = V[S];

endmodule : Mux8to1
