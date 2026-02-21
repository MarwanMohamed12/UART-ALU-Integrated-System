`include "UART_pkg.sv";
import UART_pkg::*;

module RX_FSM(PAR_EN,rst_n,CLK,RX_IN,par_err,strt_glitch,stp_err,
              bit_cnt,edge_cnt,data_valid,deser_en,enable,dat_samp_en,
              par_chk_en,strt_chk_en ,stp_chk_en,Prescale,done);

input PAR_EN,rst_n,CLK,RX_IN,par_err,strt_glitch,stp_err;
input [5:0] bit_cnt,edge_cnt;
input [5:0] Prescale;
output bit data_valid,deser_en,enable,dat_samp_en,par_chk_en,strt_chk_en
            , stp_chk_en,done;



logic error  ;

assign error  = stp_err | par_err ;
UART_TX_e ps,ns ;
bit start ,par;
always @(posedge CLK or negedge rst_n) begin

    if(!rst_n)
        ps <= IDLE;
    else
        ps <= ns ;
end

always@* begin

    case (ps)
        IDLE:begin
            if(!RX_IN)begin
                start = 1; 
                par = PAR_EN;   
            end


            if(start )
                ns = START_BIT ;
            else 
                ns = IDLE ;
            
        end
        START_BIT:begin

            if(bit_cnt == 1)
                ns = SENDING;
            else
                ns = START_BIT ;

        end
        SENDING:begin

            if(bit_cnt == 9)begin
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

            if(bit_cnt == 10)
                ns = END_BIT;
            else
                ns = PARTIY ;
        end
        END_BIT:begin

            if( (bit_cnt == 11) && par)
                ns = IDLE ;
            else if( (bit_cnt == 10) && !par)
                ns = IDLE ;
            else 
                ns = END_BIT;


                    start =0;

        end
        default:begin
            ns = IDLE ;

        end

    endcase



end


always@* begin

    case (ps)
        IDLE:begin

            data_valid = 0;
            deser_en   = 0;

            if(start)
                enable     = 1;
            else 
                enable     = 0;

            dat_samp_en= 0;
            par_chk_en = 0;
            strt_chk_en= 0;
            stp_chk_en = 0;
            done       = 1;


        end
        START_BIT:begin

            data_valid = 0;
            deser_en   = 0;
            enable     = 1;
            dat_samp_en= 0;
            par_chk_en = 0;
            strt_chk_en= 1;
            stp_chk_en = 0;
            done       = 0;

        end
        SENDING:begin

            data_valid = 0;

            if(edge_cnt == (Prescale /2) + 2 )
                deser_en   = 1;
            else
                deser_en   = 0;

            enable     = 1;
            dat_samp_en= 1;
            par_chk_en = 0;
            strt_chk_en= 0;
            stp_chk_en = 0;
            done       = 0;

        end
        PARTIY:begin

            data_valid = 0;
            deser_en   = 0;
            enable     = 1;
            dat_samp_en= 0;
            par_chk_en = 1;
            strt_chk_en= 0;
            stp_chk_en = 0;
            done       = 0;
        end
        END_BIT:begin

            data_valid = !error;
            deser_en   = 0;
          //  if(edge_cnt > Prescale - 2)
              //  enable     = 0;
           // else 
                enable     = 1;
            dat_samp_en= 0;
            par_chk_en = 0;
            strt_chk_en= 0;
            stp_chk_en = 1;
            done       = 0;

        end
        default:begin

            data_valid = 0;
            deser_en   = 0;
            enable     = 0;
            dat_samp_en= 0;
            par_chk_en = 0;
            strt_chk_en= 0;
            stp_chk_en = 0;
            done       = 0;

        end

    endcase



end

endmodule