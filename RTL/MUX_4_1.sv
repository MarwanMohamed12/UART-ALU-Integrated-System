

module MUX_4_1(rst_n,ser_data,par_bit,mux_sel,TX_OUT);


input ser_data,par_bit,rst_n;
input [1:0]mux_sel;
output TX_OUT;

bit TX_OUT_wire ;

assign TX_OUT_wire = (mux_sel ==2'b00 ) ? 0 :
                     (mux_sel ==2'b01 ) ? 1  :   
                     (mux_sel ==2'b10 ) ? ser_data  :
                     (mux_sel ==2'b11 ) ? par_bit   : 0 ;   

assign TX_OUT = (!rst_n) ? 1 : TX_OUT_wire ; 


endmodule