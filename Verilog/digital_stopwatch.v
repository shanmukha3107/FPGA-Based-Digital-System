module digital_stopwatch #(
    parameter CLK_FREQ_HZ = 50000000
)(
    input clk,
    input reset,
    input start,
    input stop,

    output reg [3:0] sec_ones,
    output reg [3:0] sec_tens,
    output reg [3:0] min_ones,
    output reg [3:0] min_tens
);

    localparam DIV_WIDTH =
        (CLK_FREQ_HZ <= 1) ? 1 : $clog2(CLK_FREQ_HZ);

    reg [DIV_WIDTH-1:0] div_count;
    reg running;

    always @(posedge clk) begin
        if (reset) begin
            div_count <= 0;
            running   <= 0;
            sec_ones  <= 0;
            sec_tens  <= 0;
            min_ones  <= 0;
            min_tens  <= 0;
        end
        else begin
            if (start)
                running <= 1'b1;

            if (stop)
                running <= 1'b0;

            if (running) begin
                if (div_count == CLK_FREQ_HZ - 1) begin
                    div_count <= 0;

                    if (sec_ones == 9) begin
                        sec_ones <= 0;

                        if (sec_tens == 5) begin
                            sec_tens <= 0;

                            if (min_ones == 9) begin
                                min_ones <= 0;

                                if (min_tens == 9)
                                    min_tens <= 0;
                                else
                                    min_tens <= min_tens + 1;
                            end
                            else
                                min_ones <= min_ones + 1;
                        end
                        else
                            sec_tens <= sec_tens + 1;
                    end
                    else
                        sec_ones <= sec_ones + 1;
                end
                else begin
                    div_count <= div_count + 1;
                end
            end
            else begin
                div_count <= 0;
            end
        end
    end

endmodule
