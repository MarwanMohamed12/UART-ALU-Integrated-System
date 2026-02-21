
import UART_pkg::* ;

module RegFile(CLK,RST,Address,WrEn,RdEn,WrData,RdData,RdData_valid,
                REG0,REG1,REG2,REG3);

input CLK,RST,WrEn,RdEn;
input [ADDRESS_WIDTH - 1 : 0]Address;
input [DATA_WIDTH - 1 : 0]WrData;

output logic RdData_valid ;
output logic [DATA_WIDTH - 1 : 0]RdData;
output logic [DATA_WIDTH - 1 : 0]REG0,REG1,REG2,REG3;


logic [DATA_WIDTH - 1 : 0] REGFILE_R [0 : (2**ADDRESS_WIDTH )- 1] ;

assign REG0 = REGFILE_R[0];
assign REG1 = REGFILE_R[1];
assign REG2 = REGFILE_R[2];
assign REG3 = REGFILE_R[3];

always@(posedge CLK or negedge RST)begin

    if(!RST)begin

        for(int i =0 ; i< DATA_WIDTH ; i++)begin
            
            if(i == 2)
                REGFILE_R[i] <=8'b10000001;
            else if( i == 3)
                REGFILE_R[i] <=8'b00100000;
            else 
                REGFILE_R[i] <=0;

        end        
        RdData <=0 ;
    end
    else begin

        if(WrEn)begin

            REGFILE_R[Address] <= WrData ;
        end
        else begin
            REGFILE_R[Address] <= REGFILE_R[Address] ;
        end

        if (RdEn) begin
            RdData_valid <= 1 ;
            RdData <= REGFILE_R[Address];
        end
        else begin
            RdData_valid <= 0 ;
            RdData <= REGFILE_R[Address];
        end

    end

end





endmodule