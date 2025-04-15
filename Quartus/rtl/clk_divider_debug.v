module clk_divider_debug (
    input wire clk_in,            // 입력 클럭 (1ms 클럭 = 1kHz)
    input wire rst_n,             // 비동기 리셋 (active low)
    output reg clk_out_100HZ      // 출력 클럭 (100Hz)
);

    reg [8:0] counter;

    always @(posedge clk_in or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 9'd1;
            clk_out_100HZ <= 1'b0;
        end else begin
            counter <= (counter == 9'd5) ? 9'd1 : counter + 1;
            clk_out_100HZ <= (counter == 9'd5) ? ~clk_out_100HZ : clk_out_100HZ;
        end
    end

endmodule
