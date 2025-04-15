module display_controller (
    input wire rst_n,                    // 비동기 리셋 (active low)
    input wire [5:0] main_seconds,       // 메인 시계 초
    input wire [5:0] main_minutes,       // 메인 시계 분
    input wire [4:0] main_hours,         // 메인 시계 시간
    input wire [4:0] main_days,          // 메인 시계 일
    input wire [5:0] sw_seconds,         // 스톱워치 초
    input wire [5:0] sw_minutes,         // 스톱워치 분
    input wire [4:0] sw_hours,           // 스톱워치 시간
    input wire [4:0] sw_days,            // 스톱워치 일
    input wire [5:0] timer_seconds,      // 타이머 초
    input wire [5:0] timer_minutes,      // 타이머 분
    input wire [4:0] timer_hours,        // 타이머 시간
    input wire [4:0] timer_days,         // 타이머 일
    input wire main_clock_active,        // 메인 시계 활성화 상태
    input wire time_setting_mode,        // 시간 설정 모드
    input wire stopwatch_running,        // 스톱워치 활성화 상태
    input wire sw_timer,                 // 타이머 모드 활성화 상태
    output reg [6:0] seg_data0,          // 7세그먼트 디스플레이 데이터 0 (1의 자리)
    output reg [6:0] seg_data1,          // 7세그먼트 디스플레이 데이터 1 (10의 자리)
    output reg [6:0] seg_data2,          // 7세그먼트 디스플레이 데이터 2 (1의 자리)
    output reg [6:0] seg_data3,          // 7세그먼트 디스플레이 데이터 3 (10의 자리)
    output reg [6:0] seg_data4,          // 7세그먼트 디스플레이 데이터 4 (1의 자리)
    output reg [6:0] seg_data5,          // 7세그먼트 디스플레이 데이터 5 (10의 자리)
    output reg [6:0] seg_data6,          // 7세그먼트 디스플레이 데이터 6 (1의 자리)
    output reg [6:0] seg_data7           // 7세그먼트 디스플레이 데이터 7 (10의 자리)
);

    // 7세그먼트 디스플레이 인코딩 함수
    function [6:0] encode_segment(input [3:0] value);
        case (value)
            4'd0: encode_segment = 7'b1000000; // 0
            4'd1: encode_segment = 7'b1111001; // 1
            4'd2: encode_segment = 7'b0100100; // 2
            4'd3: encode_segment = 7'b0110000; // 3
            4'd4: encode_segment = 7'b0011001; // 4
            4'd5: encode_segment = 7'b0010010; // 5
            4'd6: encode_segment = 7'b0000010; // 6
            4'd7: encode_segment = 7'b1111000; // 7
            4'd8: encode_segment = 7'b0000000; // 8
            4'd9: encode_segment = 7'b0010000; // 9
            default: encode_segment = 7'b1111111; // 빈 상태
        endcase
    endfunction

    // 자리값 계산 함수
    function [3:0] calc_tens(input [5:0] value);
        calc_tens = value / 10;
    endfunction

    function [3:0] calc_ones(input [5:0] value);
        calc_ones = value % 10;
    endfunction

    // 디스플레이 출력 로직
    always @(*) begin
        if (!rst_n) begin
            seg_data0 = 7'b1111111;
            seg_data1 = 7'b1111111;
            seg_data2 = 7'b1111111;
            seg_data3 = 7'b1111111;
            seg_data4 = 7'b1111111;
            seg_data5 = 7'b1111111;
            seg_data6 = 7'b1111111;
            seg_data7 = 7'b1111111;
        end else if ((main_clock_active && time_setting_mode) || 
                     (main_clock_active && stopwatch_running) || 
                     (main_clock_active && sw_timer) ||
                     (time_setting_mode && stopwatch_running) ||
                     (time_setting_mode && sw_timer) ||
                     (stopwatch_running && sw_timer)) begin
            // 두 모드가 동시에 켜져 있는 경우 오류 표시 ('E')
            seg_data0 = 7'b0000110; // E
            seg_data1 = 7'b0000110; // E
            seg_data2 = 7'b0000110; // E
            seg_data3 = 7'b0000110; // E
            seg_data4 = 7'b0000110; // E
            seg_data5 = 7'b0000110; // E
            seg_data6 = 7'b0000110; // E
            seg_data7 = 7'b0000110; // E
        end else if (main_clock_active) begin
            // 메인 시계 모드
            seg_data0 = encode_segment(calc_ones(main_seconds));
            seg_data1 = encode_segment(calc_tens(main_seconds));
            seg_data2 = encode_segment(calc_ones(main_minutes));
            seg_data3 = encode_segment(calc_tens(main_minutes));
            seg_data4 = encode_segment(calc_ones(main_hours));
            seg_data5 = encode_segment(calc_tens(main_hours));
            seg_data6 = encode_segment(calc_ones(main_days));
            seg_data7 = encode_segment(calc_tens(main_days));
        end else if (time_setting_mode) begin
            // 시간 설정 모드에서는 현재 메인 시계 값을 표시
            seg_data0 = encode_segment(calc_ones(main_seconds));
            seg_data1 = encode_segment(calc_tens(main_seconds));
            seg_data2 = encode_segment(calc_ones(main_minutes));
            seg_data3 = encode_segment(calc_tens(main_minutes));
            seg_data4 = encode_segment(calc_ones(main_hours));
            seg_data5 = encode_segment(calc_tens(main_hours));
            seg_data6 = encode_segment(calc_ones(main_days));
            seg_data7 = encode_segment(calc_tens(main_days));
        end else if (stopwatch_running) begin
            // 스톱워치 모드
            seg_data0 = encode_segment(calc_ones(sw_seconds));
            seg_data1 = encode_segment(calc_tens(sw_seconds));
            seg_data2 = encode_segment(calc_ones(sw_minutes));
            seg_data3 = encode_segment(calc_tens(sw_minutes));
            seg_data4 = encode_segment(calc_ones(sw_hours));
            seg_data5 = encode_segment(calc_tens(sw_hours));
            seg_data6 = encode_segment(calc_ones(sw_days));
            seg_data7 = encode_segment(calc_tens(sw_days));
        end else if (sw_timer) begin
            // 타이머 모드
            seg_data0 = encode_segment(calc_ones(timer_seconds));
            seg_data1 = encode_segment(calc_tens(timer_seconds));
            seg_data2 = encode_segment(calc_ones(timer_minutes));
            seg_data3 = encode_segment(calc_tens(timer_minutes));
            seg_data4 = encode_segment(calc_ones(timer_hours));
            seg_data5 = encode_segment(calc_tens(timer_hours));
            seg_data6 = encode_segment(calc_ones(timer_days));
            seg_data7 = encode_segment(calc_tens(timer_days));
        end else begin
            // 기본적으로 모든 디스플레이를 끄기
            seg_data0 = 7'b1111111;
            seg_data1 = 7'b1111111;
            seg_data2 = 7'b1111111;
            seg_data3 = 7'b1111111;
            seg_data4 = 7'b1111111;
            seg_data5 = 7'b1111111;
            seg_data6 = 7'b1111111;
            seg_data7 = 7'b1111111;
        end
    end

endmodule
