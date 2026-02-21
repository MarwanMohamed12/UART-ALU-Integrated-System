module Rr_ptr_ctrl #(parameter N = 4) (read,gray_write_ptr_data,clk,reset,bin_Rd_ptr,gray_read_data,empty);


input read,clk,reset;
input [N-1 : 0]gray_write_ptr_data;

output  [N - 1:0] bin_Rd_ptr,gray_read_data;
output empty;

wire [N-1 : 0] gray_write_ptr_data,bin_wr_ptr_data;
reg [N-1 : 0] bin_Rd_ptr_wire;

assign bin_Rd_ptr =bin_Rd_ptr_wire;

Bin_To_gray #(4) BTG(bin_Rd_ptr_wire,gray_read_data);
gray_to_bin #(4) GTB(gray_write_ptr_data,bin_wr_ptr_data);



assign empty = (bin_wr_ptr_data == bin_Rd_ptr_wire) ? 1 : 0 ;
always@(posedge clk)begin

    if(!reset)begin
        bin_Rd_ptr_wire <=0 ;
        
    end
    else begin

        if(read & (! empty))
            bin_Rd_ptr_wire <= bin_Rd_ptr_wire + 1 ;
        else
            bin_Rd_ptr_wire <= bin_Rd_ptr_wire;


    end


end


endmodule
