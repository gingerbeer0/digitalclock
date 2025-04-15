module stopwatch (
    input wire clk,               // 1Hz 클럭 입력
	input wire clk_1m,            // 1kHz 클럭 입력
    input wire rst_n,             // 비동기 리셋 (active low)
    input wire sw_start_stop,     // 스톱워치 시작/정지 스위치 (KEY3)
    input wire sw_mode,           // 스톱워치 모드 활성화 스위치 (SW2)
    output reg [5:0] sw_seconds,  // 스톱워치 초 (0-59)
    output reg [5:0] sw_minutes,  // 스톱워치 분 (0-59)
    output reg [4:0] sw_hours,    // 스톱워치 시간 (0-23)
    output reg [4:0] sw_days      // 스톱워치 일 (0-31)
);

    // 스톱워치 상태
    reg running;                  // 스톱워치 동작 상태
    reg sw_start_stop_prev;       // 이전 시작/정지 상태 저장

    // 스톱워치 동작 로직
    always @(posedge clk_1m or negedge rst_n) begin
        if (!rst_n) begin
            // 리셋 시 초기화
            running <= 1'b0;
            sw_start_stop_prev <= 1'b1;
        end else begin
            // 스톱워치 모드가 해제되면 리셋
            if (!sw_mode) begin
                running <= 1'b0;
                sw_start_stop_prev <= 1'b1;
            end else begin
                // 시작/정지 스위치 토글 감지
                if (!sw_start_stop_prev && sw_start_stop) begin
                    running <= ~running;  // 상태 반전
                end
                sw_start_stop_prev <= sw_start_stop;
            end
        end
    end


    // 스톱워치 동작 로직
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // 리셋 시 초기화
            sw_seconds <= 6'd0;
            sw_minutes <= 6'd0;
            sw_hours <= 5'd0;
            sw_days <= 5'd0;       // 날짜를 0으로 초기화
        end else begin
            // 스톱워치 모드가 해제되면 리셋
            if (!sw_mode) begin
                sw_seconds <= 6'd0;
                sw_minutes <= 6'd0;
                sw_hours <= 5'd0;
                sw_days <= 5'd0;   // 날짜를 0으로 초기화
            end else begin

                // 스톱워치 동작 시 시간 증가
                if (running) begin
                sw_seconds <= (sw_seconds == 6'd59) ? 6'd0 : sw_seconds + 1;
                sw_minutes <= (sw_seconds == 6'd59) ? 
                    ((sw_minutes == 6'd59) ? 6'd0 : sw_minutes + 1) : sw_minutes;
                sw_hours <= (sw_seconds == 6'd59 && sw_minutes == 6'd59) ? 
                    ((sw_hours == 5'd23) ? 5'd0 : sw_hours + 1) : sw_hours;
                sw_days <= (sw_seconds == 6'd59 && sw_minutes == 6'd59 && sw_hours == 5'd23) ? 
                    ((sw_days == 5'd31) ? 5'd0 : sw_days + 1) : sw_days;
                end
            end
        end
    end


endmodule