module gray_to_bin #(parameter N = 4 ) (gray,bin);

input [N-1 : 0]gray ;
output [N-1 : 0] bin;


generate
    genvar i ;

    assign bin[N-1] = gray[N-1];

    for (i =  N - 2; i >= 0 ; i = i - 1 ) begin :GEN_G

      assign  bin[i] = gray[i] ^ bin[i+1] ;

    end
endgenerate

endmodule

