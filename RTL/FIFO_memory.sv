module FIFO_memory#(parameter width = 8 ,depth = 8) (clk_wr,clk_rd,full,empty,write,read,data_in,data_out,wr_ptr,rd_ptr);

input clk_wr,clk_rd,write,read;
input full,empty;
input [width - 1 : 0]data_in;
input [$clog2(depth) - 1 : 0]wr_ptr,rd_ptr;
output reg [width - 1: 0]data_out;

reg [width - 1 : 0] FIFO_mem [0 : depth - 1];




always@(posedge clk_wr )begin



        if(write && (!full))begin

            FIFO_mem[wr_ptr] <= data_in;
        end


end

always@(posedge clk_rd )begin



     if(read && (!empty))begin

            data_out <= FIFO_mem[rd_ptr] ;

        end


end




endmodule
