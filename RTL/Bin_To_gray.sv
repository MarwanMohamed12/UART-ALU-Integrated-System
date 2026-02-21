module Bin_To_gray #(parameter N = 4 ) (bin,gray);

input [N-1 : 0]bin ;
output [N-1 : 0] gray;


generate
    genvar i ;

    assign gray[N-1] = bin[N-1];

    for (i =  N - 2; i >= 0 ; i = i - 1 ) begin : GEN_R
      assign  gray[i] = bin[i+1] ^ bin[i] ;

    end
endgenerate

endmodule
