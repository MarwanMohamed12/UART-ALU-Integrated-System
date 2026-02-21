`timescale 1ns/1ps

module Sync_FIFO_tb;

    // Parameters
    localparam WIDTH = 8;
    localparam DEPTH = 8;

    // DUT I/O
    reg clk;
    reg reset;
    reg W_en;
    reg R_en;
    reg [WIDTH-1:0] data_in;

    wire [WIDTH-1:0] data_out;
    wire full;
    wire empty;

    reg [DEPTH - 1 : 0]i ;
    // Instantiate DUT
    Sync_FIFO_structural #(WIDTH, DEPTH) DUT (
        .clk(clk),
        .reset(reset),
        .W_en(W_en),
        .R_en(R_en),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty)
    );

    // Clock generation
    always #5 clk = ~clk;  // 10 ns clock period

    // Test procedure
    initial begin
        $display("===== Starting Sync FIFO Testbench =====");

        // Init
        i = 0;
        clk = 0;
        reset = 0;
        W_en = 0;
        R_en = 0;
        data_in = 0;
        
        // Apply reset
        #10 reset = 1;

        // --------------------------
        // WRITE UNTIL FULL
        // --------------------------
        $display("\n--- Writing until FULL ---");
        W_en = 1;
        repeat (DEPTH + 2) begin  // attempt overfill
            @(posedge clk);

            data_in = 2 + i;
            i = i + 1 ;
        end
        W_en = 0;

        // --------------------------
        // READ UNTIL EMPTY
        // --------------------------
        $display("\n--- Reading until EMPTY ---");

        repeat (DEPTH + 10) begin  // attempt extra reads
            @(posedge clk);
            R_en = 1;

        end
        R_en =0;

        $stop;
    end

endmodule

