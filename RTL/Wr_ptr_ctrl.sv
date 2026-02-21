module Wr_ptr_ctrl #(parameter N = 4) (g_rd_data_ptr,full,write,clk,reset,g_wrptr,b_wrPtr);


input write,clk,reset;
input [N-1 : 0 ]g_rd_data_ptr ;
output  full;
output  [N-1 :0] g_wrptr,b_wrPtr;

wire [N-1 : 0 ]b_rd_data_ptr ;
reg [N-1 : 0 ] b_wrPtr_wire;

assign b_wrPtr = b_wrPtr_wire;

Bin_To_gray #(4) BTG(b_wrPtr_wire,g_wrptr);
gray_to_bin #(4) GTB(g_rd_data_ptr,b_rd_data_ptr);


assign full = ( ( b_rd_data_ptr[N-1] != b_wrPtr_wire [N-1])  && (b_rd_data_ptr[N-2 : 0] == b_wrPtr_wire[N-2 : 0] ) ) ?  1:  0 ;
always@(posedge clk)begin

    if(!reset)begin
        b_wrPtr_wire <=0 ;
        
    end
    else begin

        if(write && !full)
            b_wrPtr_wire <= b_wrPtr_wire + 1 ;
        else
            b_wrPtr_wire <= b_wrPtr_wire;


    end


end


endmodule

