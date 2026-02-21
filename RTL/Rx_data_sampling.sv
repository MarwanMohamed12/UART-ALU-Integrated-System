module Rx_data_sampling (edge_cnt,dat_samp_en,fast_clk,rst,RX_IN,Prescale,sampled_bit);
    
   input dat_samp_en,fast_clk,rst;
   input [5:0]edge_cnt;
   input [5:0]Prescale;
   input bit RX_IN ;
   output bit sampled_bit/*,valid_bit*/;

   bit [2:0]counter ;
   bit [1:0] bit_0,bit_1;
   always @(posedge fast_clk or negedge rst) begin

    if(!rst)begin
        sampled_bit <= 0;
        counter     <= 0;
    end
    else begin
        if(dat_samp_en && ( (edge_cnt == Prescale/2 -1 )|| (edge_cnt == Prescale/2 ) || (edge_cnt == Prescale/2 +1)) )begin
            
            if(RX_IN)
                bit_1++ ;
            else    
                bit_0++;

            if((edge_cnt == Prescale/2 +1) && (bit_1 > bit_0 ) )begin
                sampled_bit <= 1;
                bit_0 <= 0;
                bit_1 <= 0;
               // valid_bit <= 1;
            end
            else if((edge_cnt == Prescale/2 +1) && (bit_1 < bit_0 ))begin
                sampled_bit <= 0;
                bit_0 <= 0;
                bit_1 <= 0;
               // valid_bit <= 1;

            end
            else begin
                sampled_bit <= 0;
               // valid_bit   <= 0;

            end



        end
        else begin
            sampled_bit <= sampled_bit;
            bit_0       <= bit_0;
            bit_1       <= bit_1;
           // valid_bit   <= 0;

        end
    end

   end
endmodule