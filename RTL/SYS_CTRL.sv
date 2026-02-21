
import UART_pkg::* ;

module SYS_CTRL(CLK,RST,ALU_OUT,OUT_Valid,ALU_FUN,EN,CLK_EN
                ,Address,WrEn,RdEn,WrData,RdData,RdData_Valid,
                RX_P_DATA,RX_D_VLD,TX_P_DATA,TX_D_VLD,clk_div_en,full);

input CLK,RST ,OUT_Valid,RdData_Valid,RX_D_VLD,full;

input [15:0]ALU_OUT ;
input [7:0]RdData,RX_P_DATA;

output logic [3:0]Address;
output Alu_op_e ALU_FUN;
output logic EN,CLK_EN,WrEn,RdEn,TX_D_VLD,clk_div_en;
output logic [7:0]WrData,TX_P_DATA;

logic [15:0]ALU_OUT_RESULT_s ;
bit [1:0]alu_valid ;
SYS_CTRL_e ps,ns ;
logic [3:0]Address_w ;
always@(posedge CLK or negedge RST)begin

    if(!RST)begin
        ps <= IDLE_e;

    end
    else begin
        ps <= ns;

    end


    if((ps == ALU_FUN1) || (ps == ALU_FUN2))begin
         alu_valid++;          

    end
    else begin
        alu_valid =0;
    end

end


always@(*)begin


    case (ps)
        IDLE_e:begin
            if( RX_D_VLD && RX_P_DATA == 8'hAA )begin
                ns = WR_CMD ;
            end
            else if(RX_D_VLD && RX_P_DATA == 8'hBB)begin
                ns = RD_CMD ;
            end
            else if(RX_D_VLD && RX_P_DATA == 8'hCC )begin
                ns = ALU_OP4 ;
            end
            else if(RX_D_VLD && RX_P_DATA == 8'hDD)begin
                ns = ALU_OP2 ;
            end
            else begin
                ns = IDLE_e;
            end

        end
        WR_CMD:begin

            if(RX_D_VLD)begin
                ns = WR_ADD ;
            end
            else begin
                ns = WR_CMD ;
            end

        end
        WR_ADD:begin
            if(RX_D_VLD)begin
                ns = WR_DATA ;
            end
            else begin
                ns = WR_ADD ;
            end
        end
        WR_DATA:begin
           // if(RX_D_VLD)begin
                ns = IDLE_e ;
            /*end
            else begin
                ns <= WR_DATA ;

            end*/
        end
        RD_CMD:begin

            if(RX_D_VLD)begin
                ns = RD_ADD ;
            end
            else begin
                ns = RD_CMD ;
            end

        end
        RD_ADD:begin
            if(!full)begin
                ns = IDLE_e ;
            end
            else begin
                ns = RD_ADD ;
            end       
         end
        ALU_OP4:begin
            if(RX_D_VLD)begin
                ns = READ_OP1 ;
            end
            else begin
                ns = ALU_OP4 ;
            end

        end
        READ_OP1:begin
            if(RX_D_VLD)begin
                ns = READ_OP2 ;
            end
            else begin
                ns = READ_OP1 ;
            end

        end
        READ_OP2:begin
            if(RX_D_VLD)begin
                ns = ALU_FUN1 ;
            end
            else begin
                ns = READ_OP2 ;
            end

        end
        ALU_FUN1:begin
                
            if(!full && (alu_valid == 2))begin
                ns = IDLE_e ;
            end
            else begin
                ns = ALU_FUN1 ;
            end       
         
        end
        ALU_OP2:begin
            if(RX_D_VLD)begin
                ns = ALU_FUN2 ;
            end
            else begin
                ns = ALU_OP2 ;
            end
        end
        ALU_FUN2:begin
            if(!full && (alu_valid == 2))begin
                ns = IDLE_e ;
            end
            else begin
                ns = ALU_FUN2 ;
            end 
        end 
        default:begin
                ns = IDLE_e ;
        end

    endcase
end

// update output 
always@(*)begin

    case (ps)
        IDLE_e:begin
            Address = 0;
            ALU_FUN = Addition;
            EN = 0;
            CLK_EN = 0;
            WrEn = 0;
            RdEn = 0;
            clk_div_en = 0;
            WrData = 0;
            Address_w = 0;
                TX_P_DATA =  0;
                TX_D_VLD  = 0;
           // alu_valid = 0;
        end
        WR_CMD:begin
            // regfile
            if(RX_D_VLD)begin
                Address_w = RX_P_DATA;
            end
            else begin
                Address_w = 0;
            end
            WrEn    = 0;
            RdEn    = 0;
            WrData  = 0;
            Address =0 ;
            // ALU
            ALU_FUN = Addition;
            EN = 0;

            //clk gate
            CLK_EN = 0;
            //UART tx
            TX_D_VLD = 0;
            clk_div_en = 0;
            TX_P_DATA = 0;
        end
        WR_ADD:begin
            // regfile
            if(RX_D_VLD)begin
                WrData  = RX_P_DATA;
                WrEn    = 1;
                Address = Address_w;
            end
            else begin
                WrData  = 0;
                WrEn    = 0;
                Address = 0;

            end
            RdEn    = 0;
            // ALU
            ALU_FUN = Addition;
            EN = 0;

            //clk gate
            CLK_EN = 0;
            //UART tx
            TX_D_VLD = 0;
            clk_div_en = 0;
            TX_P_DATA = 0;
            //Address_w =0;
        end
        WR_DATA:begin
            Address = 0;
            ALU_FUN = Addition;
            EN = 0;
            CLK_EN = 0;
            WrEn = 0;
            RdEn = 0;
            TX_D_VLD = 0;
            clk_div_en = 0;
            WrData = 0;
            TX_P_DATA = 0;
            //Address_w = 0;
        end
        RD_CMD:begin //read address 
            // regfile
            if(RX_D_VLD)begin
                RdEn      = 1;
                Address = RX_P_DATA;
            end
            else begin
                Address = 0;
                RdEn      = 0;
            end
            WrEn      = 0;
            WrData    = 0;
            Address_w = 0 ;
            // ALU
            ALU_FUN = Addition;
            EN = 0;

            //clk gate
            CLK_EN = 0;
            //UART tx
            TX_D_VLD = 0;
            clk_div_en = 0;
            TX_P_DATA = 0;
        end
        RD_ADD:begin
            Address = 0;
            ALU_FUN = Addition;
            EN = 0;
            CLK_EN = 0;
            WrEn = 0;
            RdEn = 0;
            Address_w = 0;
            clk_div_en = 0;
            WrData = 0;
            if(!full && RdData_Valid)begin
                TX_P_DATA = RdData;
                TX_D_VLD = 1;
            end
            else begin
                TX_P_DATA = 0;
                TX_D_VLD = 0;
            end

        end
        ALU_OP4:begin
            // regfile

            if(RX_D_VLD)begin
                WrData  = RX_P_DATA;
                WrEn    = 1;
                Address = 0;
            end
            else begin
                WrData  = 0;
                WrEn    = 0;
                Address = 0;

            end
            RdEn      = 0;
            Address_w = 0 ;
            // ALU
            ALU_FUN = Addition;
            EN = 0;

            //clk gate
            CLK_EN = 0;
            //UART tx
            clk_div_en = 0;
            alu_valid = 0;
                TX_P_DATA = 0;
                TX_D_VLD = 0;
            //end

        end
        READ_OP1:begin
            // regfile
            if(RX_D_VLD)begin
                WrData  = RX_P_DATA;
                WrEn    = 1;
                Address = 1;
            end
            else begin
                WrData  = 0;
                WrEn    = 0;
                Address = 0;

            end
            alu_valid = 0;

            RdEn      = 0;
            Address_w = 0 ;
            // ALU
            ALU_FUN = Addition;
            EN = 0;

            //clk gate
            CLK_EN = 0;
            //UART tx
            clk_div_en = 0;
 
                TX_P_DATA = 0;
                TX_D_VLD = 0;
        end
        READ_OP2:begin

            // regfile
            alu_valid = 0;

            Address = 0;
            WrEn      = 0;
            RdEn      = 0;
            WrData    = 0;
            Address_w = 0 ;
            // ALU
            if(RX_D_VLD)begin
                ALU_FUN = Alu_op_e'(RX_P_DATA);
                EN = 1;

                //clk gate
                CLK_EN = 1;
            end else begin
                ALU_FUN = Alu_op_e'(RX_P_DATA);
                EN = 0;

                //clk gate
                CLK_EN = 0;
            end

            //UART tx
            TX_D_VLD = 0;
            clk_div_en = 0;
            TX_P_DATA = 0;
        end
        ALU_FUN1:begin
            Address = 0;
            ALU_FUN = Addition;
            EN = 1;
            CLK_EN = 1;
            WrEn = 0;
            RdEn = 0;
            Address_w = 0;
            clk_div_en = 0;
            WrData = 0;
            if(!full && OUT_Valid && (alu_valid <= 1))begin
                ALU_OUT_RESULT_s = ALU_OUT;
                TX_P_DATA = ALU_OUT_RESULT_s[alu_valid*8 +: 8];
                TX_D_VLD = 1;
              //  alu_valid++;
            end
            else begin
                TX_P_DATA = 0;
                TX_D_VLD = 0;
            end
        end
        ALU_OP2:begin
            // regfile

            Address = 0;
            WrEn      = 0;
            RdEn      = 0;
            WrData    = 0;
            Address_w = 0 ;
            // ALU
            if(RX_D_VLD)begin
                ALU_FUN = Alu_op_e'(RX_P_DATA);
                EN = 1;

                //clk gate
                CLK_EN = 1;
            end else begin
                ALU_FUN = Alu_op_e'(RX_P_DATA);
                EN = 0;

                //clk gate
                CLK_EN = 0;
            end

            //UART tx
            TX_D_VLD = 0;
            clk_div_en = 0;
            TX_P_DATA = 0;

        end
        ALU_FUN2:begin

            Address = 0;
            ALU_FUN = Addition;
            EN = 1;
            CLK_EN = 1;
            WrEn = 0;
            RdEn = 0;
            Address_w = 0;
            clk_div_en = 0;
            WrData = 0;
            if(!full && OUT_Valid && (alu_valid <= 1))begin
                ALU_OUT_RESULT_s = ALU_OUT;
                TX_P_DATA = ALU_OUT_RESULT_s[alu_valid*8 +: 8];
                TX_D_VLD = 1;
              //  alu_valid++;
            end
            else begin
                TX_P_DATA = 0;
                TX_D_VLD = 0;
            end


        end 
        default:begin
            Address = 0;
            ALU_FUN = Addition;
            EN = 0;
            CLK_EN = 0;
            WrEn = 0;
            RdEn = 0;
            TX_D_VLD = 0;
            clk_div_en = 0;
            WrData = 0;
            TX_P_DATA = 0;
            Address_w = 0;
        end
         
    endcase

end


endmodule