
`include "UART_pkg.sv";
import UART_pkg::*;


module Parity_calc(P_DATA,DATA_VALID,PAR_TYP,par_bit);


input [DATA_WIDTH - 1 : 0 ] P_DATA;
input DATA_VALID,PAR_TYP;
output par_bit;


assign par_bit = ( PAR_TYP == 1'b0 ) ? ^P_DATA : ~(^P_DATA) ; // even PAR_TYP = 0 else ODD



endmodule