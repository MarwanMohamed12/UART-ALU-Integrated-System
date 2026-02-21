vdel -all
vlib work
vlog *.sv
vsim -voptargs="+acc" work.SYS_TOP_TBBBB

add wave -position insertpoint  \
sim:/SYS_TOP_TBBBB/DATA_WIDTH_TB \
sim:/SYS_TOP_TBBBB/ADDR_WIDTH_TB \
sim:/SYS_TOP_TBBBB/REF_CLK_PER \
sim:/SYS_TOP_TBBBB/UART_CLK_PER \
sim:/SYS_TOP_TBBBB/WR_CMD \
sim:/SYS_TOP_TBBBB/RD_CMD \
sim:/SYS_TOP_TBBBB/ALU_WOP_CMD \
sim:/SYS_TOP_TBBBB/ALU_WNOP_CMD \
sim:/SYS_TOP_TBBBB/RST_N \
sim:/SYS_TOP_TBBBB/UART_CLK \
sim:/SYS_TOP_TBBBB/REF_CLK \
sim:/SYS_TOP_TBBBB/UART_RX_IN \
sim:/SYS_TOP_TBBBB/UART_TX_O \
sim:/SYS_TOP_TBBBB/parity_error \
sim:/SYS_TOP_TBBBB/framing_error

run -all 