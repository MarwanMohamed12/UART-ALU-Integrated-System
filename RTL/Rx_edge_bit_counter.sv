//module Rx_edge_bit_counter (Prescale,enable,clk,rst,bit_cnt,edge_cnt,done);
    
module Rx_edge_bit_counter (
    input  logic [5:0] Prescale,
    input  logic       enable,
    input  logic       clk,
    input  logic       rst,
    input  logic       done,
    output logic [5:0] bit_cnt,
    output logic [5:0] edge_cnt
);

   bit [5:0]counter ;

   always @(posedge clk or negedge rst) begin

    if(!rst)begin
        edge_cnt <=0;
        bit_cnt  <= 0;
        counter  <= 0;
    end
    else begin
        if(enable )begin            
            
            if(counter == Prescale  -1)begin
                bit_cnt++;
                counter <= 0;
                edge_cnt<= 0;
            end
            else begin
                counter++ ;
                edge_cnt++;
            end 

            if(done)begin

                bit_cnt <= 0;
                //edge_cnt<= 0;
            end

        end
        else begin
            bit_cnt  <= 0   ;
            edge_cnt <= 0   ;
            counter  <= 0   ;
        end
    end

   end
endmodule