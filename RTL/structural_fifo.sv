
module structural_fifo #(parameter DATA_WIDTH = 8,DEPTH = 8)(clk_wr,clk_rd,reset_w,reset_r,W_en,R_en,data_in,data_out,full, empty);


    input clk_wr,clk_rd,reset_w,reset_r,W_en,R_en;
    input [DATA_WIDTH-1:0]data_in;
    output[DATA_WIDTH-1:0]data_out;
    output full, empty;

    wire sign_flag,data_flag,all;
    wire Full_flag,empty_flag,wr_ptr_enable,rd_ptr_enable ;
    wire [$clog2(DEPTH)  : 0] rd_ptr,wr_ptr ;
    wire [3:0] g_wptr,g_wptr_sync,g_rptr,g_rptr_sync ;

    FIFO_memory #(.depth(DEPTH) ) FIFO_MEM (.clk_wr(clk_wr),.clk_rd(clk_rd),.full(Full_flag),.empty(empty_flag),.write(W_en),
                                                  .read(R_en),.data_in(data_in),
                                                  .data_out(data_out)
                                                  ,.wr_ptr(wr_ptr[$clog2(DEPTH) -1 : 0])
                                                  ,.rd_ptr(rd_ptr[$clog2(DEPTH) -1 : 0]));



    FF_synchronizer #(4) wr_ptr_to_read_ctrl  (.clk(clk_rd),.D(g_wptr),.Q(g_wptr_sync),.rst(reset_r));
    FF_synchronizer #(4) rd_ptr_to_write_ctrl  (.clk(clk_wr),.D(g_rptr),.Q(g_rptr_sync),.rst(reset_w));



    Wr_ptr_ctrl #(.N(4)) wrPtrl(.g_rd_data_ptr(g_rptr_sync),.full(Full_flag),.write(W_en),.clk(clk_wr),.reset(reset_w),.g_wrptr(g_wptr),.b_wrPtr(wr_ptr));    
    Rr_ptr_ctrl #(.N(4)) rdPtrl(.read(R_en),.gray_write_ptr_data(g_wptr_sync),.clk(clk_rd),.reset(reset_r),.bin_Rd_ptr(rd_ptr),.gray_read_data(g_rptr),.empty(empty_flag));                                              

    assign full = Full_flag;
    assign empty= empty_flag ;                            
endmodule
