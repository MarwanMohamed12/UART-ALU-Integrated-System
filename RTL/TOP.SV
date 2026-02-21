import UART_pkg::* ;


module TOP (REF_CLK,RST,UART_CLK,RX_IN,TX_OUT,PAR_ERR,STP_ERR);

input REF_CLK,RST,UART_CLK;
input RX_IN;

output TX_OUT ,PAR_ERR,STP_ERR;

logic o_div_clk_Tx,o_div_clk_Rx,WrEn,RdEn,DATA_VALID,clk_div_en,CLK_EN,GATED_CLK,SYNC_RST,EN,SYNC_RST_UART;
logic enable_pulse_d,PULSE_SIG,full,data_valid,OUT_Valid,RdData_Valid,TX_D_VLD;
logic [3:0]Addr;
logic [7:0] TX_P_DATA,RX_P_DATA,WrData,RdData ,P_DATA_come,REG0,REG1,REG2,REG3,P_DATA;
logic [15:0]ALU_OUT;
Alu_op_e ALU_FUN;

SYS_CTRL u_SYS_CTRL (
    .CLK(REF_CLK),
    .RST(RST),
    .ALU_OUT(ALU_OUT),
    .OUT_Valid(OUT_Valid),
    .ALU_FUN(ALU_FUN),
    .EN(EN),
    .CLK_EN(CLK_EN),
    .Address(Addr),
    .WrEn(WrEn),
    .RdEn(RdEn),
    .WrData(WrData),
    .RdData(RdData),
    .RdData_Valid(RdData_Valid),
    .RX_P_DATA(RX_P_DATA),
    .RX_D_VLD(enable_pulse_d),
    .TX_P_DATA(TX_P_DATA),
    .TX_D_VLD(TX_D_VLD),
    .clk_div_en(clk_div_en),
    .full(full)
);

RegFile U0_RegFile (
    .CLK(REF_CLK),
    .RST(SYNC_RST),
    .Address(Addr),
    .WrEn(WrEn),
    .RdEn(RdEn),
    .WrData(WrData),
    .RdData(RdData),
    .RdData_valid(RdData_Valid),
    .REG0(REG0),
    .REG1(REG1),
    .REG2(REG2),
    .REG3(REG3)
);




TX_UART U0_UART (
    .P_DATA        (P_DATA),
    .Data_Valid    (empty),
    .CLK           (o_div_clk_Tx),
    .RST           (SYNC_RST_UART),
    .parity_type   (REG2[1]),
    .parity_enable (REG2[0]),
    .TX_OUT        (TX_OUT),
    .busy          (busy)
);



UART_RX U0_UART_rx (
    .RST           (SYNC_RST_UART),
    .CLK           (o_div_clk_Rx),
    .Prescale      (REG2[7:2]),
    .RX_IN         (RX_IN),
    .parity_type   (REG2[1]),
    .parity_enable (REG2[0]),
    .data_valid    (data_valid),
    .parity_error  (PAR_ERR),
    .framing_error (STP_ERR),
    .P_DATA        (P_DATA_come)
);



Data_sync u_Data_sync (
    .unsync_bus(P_DATA_come),
    .bus_enable(data_valid),
    .dest_clk(REF_CLK),
    .dest_rst(RST),
    .sync_bus(RX_P_DATA),
    .enable_pulse_d(enable_pulse_d)
);

PULSE_GEN u_PULSE_GEN (
    .RST(SYNC_RST_UART),
    .CLK(UART_CLK),
    .LVL_SIG(busy),
    .PULSE_SIG(PULSE_SIG)
);

ClkDiv u_ClkDivRx (
    .i_ref_clk(UART_CLK),
    .i_rst_n(SYNC_RST_UART),
    .i_clk_en(1'b1),
    .i_div_ratio(REG3/REG2[7:2]),
    .o_div_clk(o_div_clk_Rx)
);

ClkDiv u_ClkDivTX (
    .i_ref_clk(UART_CLK),
    .i_rst_n(SYNC_RST_UART),
    .i_clk_en(1'b1),
    .i_div_ratio((REG3)),
    .o_div_clk(o_div_clk_Tx)
);
CLK_gate u_CLK_gate (
    .CLK(REF_CLK),
    .CLK_EN(CLK_EN),
    .GATED_CLK(GATED_CLK)
);

ALU u_ALU (
    .A(REG0),
    .B(REG1),
    .ALU_FUN(ALU_FUN),
    .Enable(EN),
    .CLK(GATED_CLK),
    .RST(SYNC_RST),
    .ALU_OUT(ALU_OUT),
    .OUT_VALID(OUT_Valid)
);

Reset_sync u_Reset_sync_Reg (
    .RST(RST),
    .CLK(REF_CLK),
    .SYNC_RST(SYNC_RST)
);

Reset_sync u_Reset_sync_UART (
    .RST(RST),
    .CLK(UART_CLK),
    .SYNC_RST(SYNC_RST_UART)
);

structural_fifo #( 
    .DATA_WIDTH(8), 
    .DEPTH(8) 
) u_structural_fifo (
    .clk_wr(REF_CLK),
    .clk_rd(UART_CLK),
    .reset_w(SYNC_RST),
    .reset_r(SYNC_RST_UART),
    .W_en(TX_D_VLD),
    .R_en(PULSE_SIG),
    .data_in(TX_P_DATA),
    .data_out(P_DATA),
    .full(full),
    .empty(empty)
);









endmodule