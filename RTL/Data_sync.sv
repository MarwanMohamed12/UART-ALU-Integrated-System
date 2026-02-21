module Data_sync(unsync_bus,bus_enable,dest_clk,dest_rst,sync_bus,enable_pulse_d);

input bus_enable,dest_clk,dest_rst;
input [7:0]unsync_bus ;

output logic [7:0] sync_bus ;
output logic enable_pulse_d;
logic reg1,reg2;
logic enable_sync2_d;

always_ff @( posedge dest_clk or negedge dest_rst ) begin 
    
    if(!dest_rst)begin

        reg1 <= 0;
        reg2 <= 0;
        sync_bus<=0;
    end
    else begin

        reg1 <= bus_enable;
        reg2 <= reg1;
        sync_bus <= unsync_bus ;
    end
end




always @(posedge dest_clk or negedge dest_rst) begin
    if (!dest_rst)
        enable_sync2_d <= 1'b0;
    else
        enable_sync2_d <= reg2;
end

assign enable_pulse_d = reg2 & ~enable_sync2_d;



endmodule