

module CLK_gate(CLK,CLK_EN,GATED_CLK);

input CLK,CLK_EN;

output logic GATED_CLK;

assign GATED_CLK = (CLK_EN) ? CLK : 0 ;

endmodule