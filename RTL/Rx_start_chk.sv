module Rx_start_chk(strt_chk_en,sampled_bit,strt_glitch);


input  strt_chk_en,sampled_bit;
output strt_glitch;


assign strt_glitch =  strt_chk_en | strt_glitch;



endmodule