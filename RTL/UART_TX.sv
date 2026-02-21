
`include "UART_pkg.sv"
import UART_pkg::*;


module TX_UART (P_DATA,Data_Valid,CLK,RST,parity_type,parity_enable,TX_OUT,busy);
    

    input [DATA_WIDTH - 1 : 0 ] P_DATA;
    input Data_Valid,CLK,RST,parity_type,parity_enable;
    output TX_OUT,busy ;


    logic ser_done,ser_en,ser_data,par_bit;
    logic [1:0]mux_sel ;

    FSM FSM_dut(.rst_n(RST),
                .CLK(CLK),
                .DATA_VALID(Data_Valid),
                .ser_done(ser_done),
                .PAR_EN(parity_enable),
                .ser_en(ser_en),
                .mux_sel(mux_sel),
                .busy(busy));


    serializer serializer_dut (.rst_n(RST),
                               .CLK(CLK),
                               .P_DATA(P_DATA),
                               .ser_en(ser_en),
                               .ser_data(ser_data),
                               .ser_done(ser_done));

    MUX_4_1 MUX_4_1_dut(.rst_n(ser_en),
                        .ser_data(ser_data),
                        .par_bit(par_bit),
                        .mux_sel(mux_sel),
                        .TX_OUT(TX_OUT));

    Parity_calc Parity_calc_dut (.P_DATA(P_DATA),
                .DATA_VALID(Data_Valid),
                .PAR_TYP(parity_type),
                .par_bit(par_bit) );
    
endmodule