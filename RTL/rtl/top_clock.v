module top_clock (
    input wire clk_50MHz,            // 50MHz 입력 클럭
    input wire rst_n,                // 비동기 리셋 (active low)
    input wire sw_set,               // 설정 모드 스위치 (SW1)
    input wire sw_stopwatch,         // 스톱워치 모드 스위치 (SW2)
    input wire sw_timer,             // 타이머 모드 스위치 (SW4)
    input wire sw_london,            // 런던 시간 표시 스위치 (SW17)
    input wire sw_ny,                // 뉴욕 시간 표시 스위치 (SW16)
    input wire sw_12_24,             // 12시간/24시간 전환 스위치 (SW15)
    input wire key3,                 // 공용으로 사용하는 KEY3 입력
    input wire key_inc,              // 값 증가 (KEY2)
    input wire key_dec,              // 값 감소 (KEY1)
    input wire key_start,            // 타이머 시작 (KEY0)
    input wire debug_mode,           // 디버그 모드 스위치
    output wire [6:0] seg_data0,     // 7세그먼트 디스플레이 데이터 0
    output wire [6:0] seg_data1,     // 7세그먼트 디스플레이 데이터 1
    output wire [6:0] seg_data2,     // 7세그먼트 디스플레이 데이터 2
    output wire [6:0] seg_data3,     // 7세그먼트 디스플레이 데이터 3
    output wire [6:0] seg_data4,     // 7세그먼트 디스플레이 데이터 4
    output wire [6:0] seg_data5,     // 7세그먼트 디스플레이 데이터 5
    output wire [6:0] seg_data6,     // 7세그먼트 디스플레이 데이터 6
    output wire [6:0] seg_data7,     // 7세그먼트 디스플레이 데이터 7
    output wire led16,               // 뉴욕 시간 모드 표시 LED
    output wire led17,               // 런던 시간 모드 표시 LED
    output wire ledg0,               // PM 표시 LED
    output wire AUD_DACDAT,          // 오디오 출력 데이터
    output wire AUD_XCK,             // 오디오 CODEC 마스터 클럭
    output wire AUD_BCLK,            // 오디오 비트 클럭
    output wire AUD_DACLRCK          // 오디오 DAC LR 클럭
);

    // 디바운싱된 키 신호들
    wire debounced_key3, debounced_key_inc, debounced_key_dec, debounced_key_start;

    // 디바운싱 모듈 인스턴스화
    debounce db_key3 (
        .clk(clk_50MHz),
        .rst_n(rst_n),
        .button_in(key3),
        .button_out(debounced_key3)
    );

    debounce db_key_inc (
        .clk(clk_50MHz),
        .rst_n(rst_n),
        .button_in(key_inc),
        .button_out(debounced_key_inc)
    );

    debounce db_key_dec (
        .clk(clk_50MHz),
        .rst_n(rst_n),
        .button_in(key_dec),
        .button_out(debounced_key_dec)
    );

    debounce db_key_start (
        .clk(clk_50MHz),
        .rst_n(rst_n),
        .button_in(key_start),
        .button_out(debounced_key_start)
    );

    // 모드에 따른 KEY 역할 설정
    wire key_next = (sw_set || sw_timer) ? debounced_key3 : 1'b0;
    wire key_inc_signal = (sw_set || sw_timer) ? debounced_key_inc : 1'b0;
    wire key_dec_signal = (sw_set || sw_timer) ? debounced_key_dec : 1'b0;
    wire start_stop = sw_stopwatch ? debounced_key3 : 1'b0;
    wire timer_start = sw_timer ? debounced_key_start : 1'b0;

    // 클럭 신호
    wire clk_out, clk_1m, clk_1Hz, clk_100Hz;

    // 1Hz 클럭 생성
    clk_divider u_clk_divider (
        .clk_in(clk_50MHz),
        .rst_n(rst_n),
        .clk_out_1HZ(clk_1Hz)
    );

    // 100Hz 클럭 생성
    clk_divider_debug u_clk_divider_debug (
        .clk_in(clk_50MHz),
        .rst_n(rst_n),
        .clk_out_100HZ(clk_100Hz)
    );

    // 클럭 선택기
    clk_selector clk_sel (
        .clk_in_1Hz(clk_1Hz),
        .clk_in_100Hz(clk_100Hz),
        .rst_n(rst_n),
        .debug_mode(debug_mode),
        .set_mode(sw_set),
        .clk_out(clk_out)
    );

    // 메인 시계 및 스톱워치 관련 신호
    wire [5:0] main_seconds, main_minutes, sw_seconds, sw_minutes;
    wire [4:0] main_hours, main_days, sw_hours, sw_days;
    reg [4:0] adjusted_hours; // 시간 조정값
    reg [4:0] display_hours;  // 12시간/24시간 변환 후 시간
    reg pm;                   // PM 표시 상태

    // 타이머 신호
    wire [5:0] timer_seconds, timer_minutes;
    wire [4:0] timer_hours, timer_days;

    // 메인 시계
    main_clock main_clk (
        .clk(clk_out),
        .rst_n(rst_n),
        .set_mode(sw_set),
        .key_next(key_next),              // 디바운싱된 key_next 신호 전달
        .key_inc(key_inc_signal),         // 디바운싱된 key_inc 신호 전달
        .key_dec(key_dec_signal),         // 디바운싱된 key_dec 신호 전달
        .seconds(main_seconds),
        .minutes(main_minutes),
        .hours(main_hours),
        .days(main_days),
        .play_sound(play_sound)
    );

    // 오디오 출력 (소리)
    cuckoo audio (
        .CLOCK_50(clk_50MHz),
        .play_sound(play_sound),
        .AUD_DACDAT(AUD_DACDAT),
        .AUD_XCK(AUD_XCK),
        .AUD_BCLK(AUD_BCLK),
        .AUD_DACLRCK(AUD_DACLRCK)
    );

    // 스톱워치
    stopwatch sw (
        .clk(clk_out),
        .clk_1m(clk_50MHz),
        .rst_n(rst_n),
        .sw_start_stop(start_stop),       // 디바운싱된 start_stop 신호 전달
        .sw_mode(sw_stopwatch),
        .sw_seconds(sw_seconds),
        .sw_minutes(sw_minutes),
        .sw_hours(sw_hours),
        .sw_days(sw_days)
    );

    // 타이머
    timer tm (
        .clk(clk_out),
        .rst_n(rst_n),
        .sw_timer(sw_timer),
        .key_next(key_next),              // 디바운싱된 key_next 신호 전달
        .key_inc(key_inc_signal),         // 디바운싱된 key_inc 신호 전달
        .key_dec(key_dec_signal),         // 디바운싱된 key_dec 신호 전달
        .key_start(timer_start),          // 디바운싱된 timer_start 신호 전달
        .timer_seconds(timer_seconds),
        .timer_minutes(timer_minutes),
        .timer_hours(timer_hours),
        .timer_days(timer_days)
    );

    // 시간 조정 로직 (세계 시간)
    always @(*) begin
        adjusted_hours = main_hours;
        if (sw_london) begin
            adjusted_hours = (main_hours >= 8) ? (main_hours - 8) : (main_hours + 24 - 8);
        end else if (sw_ny) begin
            adjusted_hours = (main_hours >= 13) ? (main_hours - 13) : (main_hours + 24 - 13);
        end
    end

    // 12시간/24시간 변환 로직
    always @(*) begin
        if (sw_12_24) begin
            // 12시간 모드
            pm = (adjusted_hours >= 12);
            if (adjusted_hours == 0) begin
                display_hours = 5'd12; // 0시는 12AM
            end else if (adjusted_hours > 12) begin
                display_hours = adjusted_hours - 5'd12; // 13시 이상은 PM
            end else begin
                display_hours = adjusted_hours;
            end
        end else begin
            // 24시간 모드
            pm = 1'b0;
            display_hours = adjusted_hours;
        end
    end

    // LED 표시
    assign led17 = sw_london;
    assign led16 = sw_ny;
    assign ledg0 = pm; // PM일 때 LEDG0 켜기

    // 디스플레이 제어
    display_controller disp_ctrl (
        .rst_n(rst_n),
        .main_seconds(main_seconds),
        .main_minutes(main_minutes),
        .main_hours(display_hours),
        .main_days(main_days),
        .sw_seconds(sw_seconds),
        .sw_minutes(sw_minutes),
        .sw_hours(sw_hours),
        .sw_days(sw_days),
        .timer_seconds(timer_seconds),
        .timer_minutes(timer_minutes),
        .timer_hours(timer_hours),
        .timer_days(timer_days),
        .main_clock_active(~sw_set && ~sw_stopwatch && ~sw_timer),
        .time_setting_mode(sw_set),
        .stopwatch_running(sw_stopwatch),
        .sw_timer(sw_timer),
        .seg_data0(seg_data0),
        .seg_data1(seg_data1),
        .seg_data2(seg_data2),
        .seg_data3(seg_data3),
        .seg_data4(seg_data4),
        .seg_data5(seg_data5),
        .seg_data6(seg_data6),
        .seg_data7(seg_data7)
    );

endmodule
