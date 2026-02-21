
`include "UART_pkg.sv";
import UART_pkg::*;


module serializer(rst_n,CLK,P_DATA,ser_en,ser_data,ser_done);


input [DATA_WIDTH - 1 : 0 ] P_DATA;
input ser_en,CLK,rst_n;
output reg ser_data,ser_done;

bit [2:0] counter;
always@(posedge CLK or negedge rst_n)begin

    if(!rst_n)begin
        ser_data <= 0;
        ser_done <= 0;
    end
    else begin
        if(ser_en)begin

            ser_data <= P_DATA[counter];

            if(counter == 7)begin
               ser_done <= 1;     
               counter  <= 0;
            end
            else begin
               ser_done <= 0;     
               counter++ ;
            end

        end
        else begin
            counter <= 0;
            ser_data <= 0;
            ser_done <= 0;

        end
    end

end



endmodule