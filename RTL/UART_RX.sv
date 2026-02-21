module UART_RX(RST,CLK,Prescale,RX_IN,parity_type,parity_enable,data_valid,parity_error,framing_error,P_DATA);

input RST,CLK,RX_IN,parity_type,parity_enable;
input [5:0]Prescale;
output data_valid,parity_error,framing_error;
output [7:0] P_DATA ;

wire par_err,strt_glitch,stp_err,deser_en,enable,dat_samp_en,
     par_chk_en,strt_chk_en,stp_chk_en,sampled_bit,done;

wire logic [5:0] bit_cnt,edge_cnt;
assign framing_error = stp_err;
assign parity_error = par_err;
RX_FSM RxFSM(.PAR_EN(parity_enable),.rst_n(RST),.CLK(CLK),.RX_IN(RX_IN),.par_err(par_err),.strt_glitch(strt_glitch),
        .stp_err(stp_err),.bit_cnt(bit_cnt),.edge_cnt(edge_cnt),.data_valid(data_valid),.deser_en(deser_en),
        .enable(enable),.dat_samp_en(dat_samp_en),
        .par_chk_en (par_chk_en),.strt_chk_en(strt_chk_en) ,.stp_chk_en(stp_chk_en),.Prescale(Prescale),.done(done));

Rx_edge_bit_counter edge_ctr(.enable(enable),.clk(CLK),.rst(RST),.bit_cnt(bit_cnt),.edge_cnt(edge_cnt),.Prescale(Prescale),.done(done));

Rx_desirializer Rx_desirial(.RX_clk(CLK),.rst_n(RST),.sampled_bit(sampled_bit),.deser_en(deser_en),.P_DATA(P_DATA),.done(done));

Rx_data_sampling RxDataSampling(.edge_cnt(edge_cnt),.dat_samp_en(dat_samp_en),.fast_clk(CLK),.rst(RST),
                                .RX_IN(RX_IN),.Prescale(Prescale),.sampled_bit(sampled_bit));

Rx_stop_check RxStopCheck (.stp_chk_en(stp_chk_en),.sampled_bit(RX_IN),.stp_err(stp_err))  ;

Rx_start_chk  RxStartCheck (.strt_chk_en(strt_chk_en),.sampled_bit(sampled_bit),.strt_glitch(strt_glitch));

Rx_parity_check RxParityCheck(.sampled_bit(sampled_bit),.par_chk_en(par_chk_en),.PAR_TYP(parity_type),.par_err(par_err));

endmodule