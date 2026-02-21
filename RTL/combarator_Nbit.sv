module combarator_Nbit #(parameter N)(A,B,C);

input [N-1:0] A,B ;
output C;

assign C = (A == B ) ? 1 : 0;


endmodule
