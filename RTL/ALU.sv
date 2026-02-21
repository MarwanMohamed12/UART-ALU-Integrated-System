
import UART_pkg::* ;

module ALU(A,B,ALU_FUN,Enable,CLK,RST,ALU_OUT,OUT_VALID);

input [DATA_WIDTH - 1 :0]A,B;
input Alu_op_e ALU_FUN;
input Enable,CLK,RST;

output logic [(2*DATA_WIDTH) - 1 : 0]ALU_OUT;
output logic OUT_VALID;







always@(posedge CLK or negedge RST)begin

    if(!RST)begin
        OUT_VALID <= 0;
        ALU_OUT   <= 0;
        
    end
    else begin
        if(Enable)begin
            case (ALU_FUN)
                Addition:begin
                    ALU_OUT <= A + B ;
                    OUT_VALID <= 1 ;
                end
                Subtraction:begin
                    ALU_OUT <= A - B ;
                    OUT_VALID <= 1 ;
                end 
                Multiplication:begin
                    ALU_OUT <= A * B ;
                    OUT_VALID <= 1 ;
                end 
                Division:begin
                    ALU_OUT <=  A / B;
                    OUT_VALID <= 1 ;
                end 
                AND_e:begin
                    ALU_OUT <=  A & B;
                    OUT_VALID <= 1 ;
                end 
                OR_e:begin
                    ALU_OUT <= A | B ;
                    OUT_VALID <= 1 ;
                end 
                NAND_e:begin
                    ALU_OUT <= A &~ B ;
                    OUT_VALID <= 1 ;
                end 
                NOR_e:begin
                    ALU_OUT <= A |~ B ;
                    OUT_VALID <= 1 ;
                end 
                XOR_e:begin
                    ALU_OUT <= A ^ B ;
                    OUT_VALID <= 1 ;
                end 
                CMPH:begin
                    ALU_OUT <= (A == B) ;
                    OUT_VALID <= 1 ;
                end 
                SHIFTL:begin
                    ALU_OUT <=  (A >> 1);
                    OUT_VALID <= 1 ;
                end 
                SHIFTR:begin
                    ALU_OUT <= (A << 1) ;
                    OUT_VALID <= 1 ;
                end   
                default:begin
                    ALU_OUT <= 0 ;
                    OUT_VALID <= 0 ;
                end  
            endcase
        end
        else begin
            OUT_VALID <= 0;
            ALU_OUT   <= 0;
        
        end
    end

end





endmodule