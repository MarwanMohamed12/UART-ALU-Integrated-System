module Rx_parity_check(sampled_bit,par_chk_en,PAR_TYP,par_err);


input sampled_bit,par_chk_en,PAR_TYP;
output par_err;


assign par_err =  ((PAR_TYP ^ sampled_bit) && par_chk_en) ; // even PAR_TYP = 0 else ODD



endmodule