import UART_pkg::* ;

module ClkDiv(i_ref_clk,i_rst_n,i_clk_en,i_div_ratio,o_div_clk);



input i_ref_clk,i_rst_n,i_clk_en;
input [DIV_RATIO - 1 : 0]i_div_ratio;
output logic o_div_clk ;

logic [DIV_RATIO -1 :0]counter;
logic ODD ;
logic clk_reg ;
assign ODD = i_div_ratio[0];
assign o_div_clk = (i_div_ratio == 1)?i_ref_clk:  clk_reg ;

always@(posedge i_ref_clk or negedge i_rst_n)begin

    if(!i_rst_n)begin
        counter <= 0;
        clk_reg  <= 0;;

    end
    else begin

        if(i_clk_en)begin
            if(ODD)begin
                // missing
                if(counter == (i_div_ratio >> 1) -1 )begin
                    clk_reg =~ clk_reg;
                     counter <= counter + 1 ;
                end
                else if(counter == i_div_ratio - 1 )begin
                    clk_reg =~ clk_reg;
                    counter <= 0 ;

                end
                else 
                    counter <= counter + 1 ;

            end
            else begin

                
                if(counter == (i_div_ratio >> 1) -1 )begin
                    clk_reg =~ clk_reg;
                     counter <= counter + 1 ;
                end
                else if(counter == i_div_ratio - 1 )begin
                    clk_reg =~ clk_reg;
                    counter <= 0 ;

                end
                else 
                    counter <= counter + 1 ;

            end

        end
        else begin

            clk_reg <= clk_reg ;
        end

    end

end





endmodule