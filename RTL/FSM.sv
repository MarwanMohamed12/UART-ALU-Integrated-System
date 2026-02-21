`include "UART_pkg.sv";
import UART_pkg::*;


module FSM(rst_n,CLK,DATA_VALID,ser_done,PAR_EN,ser_en,mux_sel,busy);

input DATA_VALID,ser_done,PAR_EN,rst_n,CLK;
output reg ser_en =0,busy =0;
output reg [1:0]mux_sel;

logic flag = 0 ;
bit   size ;

UART_TX_e ps,ns ;

always @(posedge CLK or negedge rst_n) begin

    if(!rst_n)
        ps <= IDLE;
    else
        ps <= ns ;

        size <= DATA_VALID;
end

always@* begin

    case (ps)
        IDLE:begin
            if(flag |!size )
                ns = START_BIT ;
            else 
                ns = IDLE ;
            
            if(DATA_VALID)begin
                flag = 1;
            end
            else begin
                flag = 0;
            end
        end
        START_BIT:begin
            ns = SENDING ;
            flag = 0;

        end
        SENDING:begin
            flag = 0;

            if(ser_done)begin
                if(PAR_EN)
                    ns = PARTIY ;
                else
                    ns = END_BIT ;
            end
            else begin
                ns = SENDING ;

            end

        end
        PARTIY:begin
            flag = 0;

            ns = END_BIT;
        end
        END_BIT:begin
            flag = 0;
            ns = IDLE ;
        end
        default:begin
            ns = IDLE ;

        end

    endcase



end


always@* begin

    case (ps)
        IDLE:begin

            ser_en = 0 ;
            busy   = 0 ;
            mux_sel= 2'b00 ;

        end
        START_BIT:begin

            ser_en =  1;
            busy   =  1;
            mux_sel=  2'b00;

        end
        SENDING:begin

            ser_en =  1;
            busy   =  0;
            mux_sel=  2'b10;
        end
        PARTIY:begin

            ser_en =  1;
            busy   =  0;
            mux_sel=  2'b11;
        end
        END_BIT:begin

            ser_en =  1;
            busy   =  0;
            mux_sel=  2'b01;

        end
        default:begin

            ser_en =  0;
            busy   =  0;
            mux_sel=  0;

        end

    endcase



end

endmodule