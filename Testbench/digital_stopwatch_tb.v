`timescale 1ns/1ps

module digital_stopwatch_tb;

    reg clk;
    reg reset;
    reg start;
    reg stop;

    wire [3:0] sec_ones;
    wire [3:0] sec_tens;
    wire [3:0] min_ones;
    wire [3:0] min_tens;

    digital_stopwatch #(
        .CLK_FREQ_HZ(10)
    ) uut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .stop(stop),
        .sec_ones(sec_ones),
        .sec_tens(sec_tens),
        .min_ones(min_ones),
        .min_tens(min_tens)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        start = 0;
        stop = 0;

        $dumpfile("../Simulation/digital_stopwatch.vcd");
        $dumpvars(0, digital_stopwatch_tb);

        $display("Starting Stopwatch Test");

        repeat(2) @(posedge clk);
        #1 reset = 0;

        // Start stopwatch
        @(negedge clk);
        start = 1;
        @(negedge clk);
        start = 0;

        // Wait for one simulated second
        repeat(10) @(posedge clk);
        #1;
        $display("After 1 second: %0d%0d:%0d%0d",
                 min_tens, min_ones, sec_tens, sec_ones);

        // Stop stopwatch
        @(negedge clk);
        stop = 1;
        @(negedge clk);
        stop = 0;

        repeat(20) @(posedge clk);
        #1;
        $display("After Stop: %0d%0d:%0d%0d",
                 min_tens, min_ones, sec_tens, sec_ones);

        // Reset stopwatch
        @(negedge clk);
        reset = 1;
        @(negedge clk);
        reset = 0;

        #1;
        $display("After Reset: %0d%0d:%0d%0d",
                 min_tens, min_ones, sec_tens, sec_ones);

        $display("Stopwatch Test Completed");

        $finish;
    end

endmodule
