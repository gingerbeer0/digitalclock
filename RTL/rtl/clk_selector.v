module clk_selector (
    input wire clk_in_1Hz,         // 1Hz 클럭 입력
    input wire clk_in_100Hz,       // 100Hz 클럭 입력
    input wire rst_n,              // 비동기 리셋 (active low)
    input wire debug_mode,         // 디버그 모드 활성화 신호
    input wire set_mode,           // 시간 설정 모드 활성화 신호
    output wire clk_out            // 출력 클럭 (선택된 1Hz 또는 100Hz)
);

    // 클럭 선택: debug_mode 또는 set_mode가 활성화되면 100Hz, 그렇지 않으면 1Hz
    assign clk_out = (debug_mode || set_mode) ? clk_in_100Hz : clk_in_1Hz;

endmodule
