module main_clock (
    input wire clk,                  // 1Hz 클럭 입력
    input wire rst_n,                // 비동기 리셋 (active low)
    input wire set_mode,             // 설정 모드 활성화 (SW1)
    input wire key_next,             // 설정 항목 이동 (KEY3)
    input wire key_inc,              // 값 증가 (KEY2)
    input wire key_dec,              // 값 감소 (KEY1)
    output reg [5:0] seconds,        // 현재 초
    output reg [5:0] minutes,        // 현재 분
    output reg [4:0] hours,          // 현재 시간
    output reg [4:0] days,           // 현재 일
    output reg play_sound            // 한 시간마다 소리 재생 트리거
);

    // 설정 모드 항목 인덱스 (0: 초, 1: 분, 2: 시간, 3: 일)
    reg [1:0] set_index;
    reg key_next_prev;               // 이전 key_next 상태 저장
    reg key_inc_prev;                // 이전 key_inc 상태 저장
    reg key_dec_prev;                // 이전 key_dec 상태 저장
    reg hour_change;                 // 한 시간이 변경되는 순간 감지

    // 시간 설정 및 시계 동작 로직
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // 리셋 시 초기화
            seconds <= 6'd0;
            minutes <= 6'd0;
            hours <= 5'd0;
            days <= 5'd1;
            set_index <= 2'b00;
            key_next_prev <= 1'b1;
            key_inc_prev <= 1'b0;
            key_dec_prev <= 1'b0;
            hour_change <= 1'b0;
            play_sound <= 1'b0;
        end else begin
            if (set_mode) begin
                // 설정 모드일 때 시계 동작 멈춤

                // key_next를 통해 설정 항목 이동
                if (!key_next_prev && key_next) begin
                    set_index <= set_index + 1;
                    if (set_index == 2'b11) begin
                        set_index <= 2'b00; // 마지막 항목에서 다시 첫 번째 항목으로
                    end
                end
                key_next_prev <= key_next;

                // 설정 항목에 따라 값을 증가 또는 감소
                case (set_index)
                    2'b00: begin
                        // 초 설정
                        if (!key_inc_prev && key_inc) seconds <= (seconds < 6'd59) ? seconds + 1 : 6'd0;
                        if (!key_dec_prev && key_dec) seconds <= (seconds > 6'd0) ? seconds - 1 : 6'd59;
                    end
                    2'b01: begin
                        // 분 설정
                        if (!key_inc_prev && key_inc) minutes <= (minutes < 6'd59) ? minutes + 1 : 6'd0;
                        if (!key_dec_prev && key_dec) minutes <= (minutes > 6'd0) ? minutes - 1 : 6'd59;
                    end
                    2'b10: begin
                        // 시간 설정
                        if (!key_inc_prev && key_inc) hours <= (hours < 5'd23) ? hours + 1 : 5'd0;
                        if (!key_dec_prev && key_dec) hours <= (hours > 5'd0) ? hours - 1 : 5'd23;
                    end
                    2'b11: begin
                        // 일 설정 (1일 ~ 31일)
                        if (!key_inc_prev && key_inc) days <= (days < 5'd31) ? days + 1 : 5'd1;
                        if (!key_dec_prev && key_dec) days <= (days > 5'd1) ? days - 1 : 5'd31;
                    end
                endcase

                // 키 상태 업데이트
                key_inc_prev <= key_inc;
                key_dec_prev <= key_dec;
                play_sound <= 1'b0; // 설정 모드에서는 소리 재생 트리거 비활성화
                hour_change <= 1'b0; // 설정 모드에서는 시간 변경 감지 비활성화

            end else begin
                // 설정 모드가 아닐 때 시계 동작
                play_sound <= 1'b0; // 기본적으로 소리 재생 트리거 비활성화
                hour_change <= 1'b0; // 시간 변경 감지 초기화
                seconds <= (seconds < 6'd59) ? seconds + 1 : 6'd0;
                minutes <= (seconds == 6'd59) ? 
                    ((minutes < 6'd59) ? minutes + 1 : 6'd0) : minutes;
                hours <= (seconds == 6'd59 && minutes == 6'd59) ? 
                    ((hours < 5'd23) ? hours + 1 : 5'd0) : hours;
                days <= (seconds == 6'd59 && minutes == 6'd59 && hours == 5'd23) ? 
                    ((days < 5'd31) ? days + 1 : 5'd1) : days;
                if (seconds == 6'd59 && minutes == 6'd59) begin
                    hour_change <= 1'b1; // 시간 변경 감지
                end    

                // 한 시간이 지났을 때 play_sound 신호를 활성화
                if (hour_change) begin
                    play_sound <= 1'b1;
                end
            end
        end
    end

endmodule
