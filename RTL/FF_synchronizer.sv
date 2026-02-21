module FF_synchronizer #( parameter N = 4)(clk,D,Q,rst);

input clk,rst;
input [N-1 : 0]D;
output [N-1 : 0] Q ;

reg [N-1 : 0] ff1,ff2 ;

always @(posedge clk) begin

    if(!rst)begin

        ff1 <= 0 ;
        ff2 <= 0 ;

    end
    else begin
        ff1 <= D;
        ff2 <= ff1;
    end
    
end

assign Q = ff2 ;

endmodule
