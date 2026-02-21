module Reset_sync(RST,CLK,SYNC_RST);

input RST,CLK;
output SYNC_RST ;

logic reg1,reg2;

always_ff @( posedge CLK or negedge RST ) begin 
    
    if(!RST)begin

        reg1 <= 0;
        reg2 <= 0;

    end
    else begin

        reg1 <= 1;
        reg2 <= reg1;

    end
end

assign SYNC_RST = reg2 ;


endmodule