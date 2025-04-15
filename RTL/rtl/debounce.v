module debounce (
    input wire clk,        // 1kHz 클럭 입력
    input wire rst_n,      // 비동기 리셋
    input wire button_in,  // 버튼 입력
    output reg button_out  // 디바운싱된 출력
);
    reg [0:0] counter;     // 1비트 카운터
    reg button_stable;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 1'b0;
            button_stable <= 1'b0;
            button_out <= 1'b0;
        end else begin
            if (button_in != button_stable) begin
                // 버튼 상태가 변경된 경우 카운터 시작
                counter <= counter + 1;
                if (counter == 1'b1) begin
                    // 카운터가 1에 도달하면 버튼 상태를 안정화 (1ms)
                    button_stable <= button_in;
                    button_out <= button_in;
                    counter <= 1'b0; // 카운터 초기화
                end
            end else begin
                counter <= 1'b0; // 버튼이 안정되면 카운터 초기화
            end
        end
    end
endmodule
