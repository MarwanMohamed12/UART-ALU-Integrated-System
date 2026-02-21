module Rx_stop_check(stp_chk_en,sampled_bit,stp_err);


input  stp_chk_en,sampled_bit;
output stp_err;


assign stp_err =  (!sampled_bit) && stp_chk_en;

endmodule