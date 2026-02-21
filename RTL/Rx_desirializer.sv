module Rx_desirializer(RX_clk,rst_n,sampled_bit,deser_en,P_DATA,done);


    input RX_clk,rst_n,sampled_bit,deser_en,done ;
    output bit[7:0] P_DATA;


bit [3:0] counter;
bit[7:0] data;
assign P_DATA  = data ;
always@(posedge RX_clk or negedge rst_n)begin

    if(done)begin
        counter  <= 0;
        data <= 0;

    end

    
    if(!rst_n)begin
        data <= 0;
    end
    else begin
        if(deser_en)begin

            data[counter] <= sampled_bit;
           /* if(done)begin
               counter  <= 0;
               data <= 0;

            end
            else begin*/
               counter++ ;
           // end

        end
        else begin
         //   counter <= 0;
         //   data <= 0;
            
        end
    end

end



endmodule