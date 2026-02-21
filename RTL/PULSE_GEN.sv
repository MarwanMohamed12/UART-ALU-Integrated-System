module PULSE_GEN(RST,CLK,LVL_SIG,PULSE_SIG);

input RST,CLK,LVL_SIG;
output logic PULSE_SIG ;


logic LVL_SIG_d;   

always @(posedge CLK or negedge RST) begin
    if (!RST) begin
        LVL_SIG_d <= 1'b0;
        PULSE_SIG <= 1'b0;
    end
    else begin
        LVL_SIG_d <= LVL_SIG;
        PULSE_SIG <= LVL_SIG & ~LVL_SIG_d;  
    end
end







endmodule