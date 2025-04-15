module timer (
    input wire clk,                  // 1Hz 클럭 입력
    input wire rst_n,                // 비동기 리셋 (active low)
    input wire sw_timer,             // 타이머 모드 활성화 스위치 (SW4)
    input wire key_next,             // 설정 항목 이동 (KEY3)
    input wire key_inc,              // 값 증가 (KEY2)
    input wire key_dec,              // 값 감소 (KEY1)
    input wire key_start,            // 타이머 시작/정지 (KEY0)
    output reg [5:0] timer_seconds,  // 타이머 초 (0-59)
    output reg [5:0] timer_minutes,  // 타이머 분 (0-59)
    output reg [4:0] timer_hours,    // 타이머 시간 (0-23)
    output reg [4:0] timer_days      // 타이머 일 (0-31)
);

    reg running;                     // 타이머 동작 상태
    reg key_start_prev;              // 이전 KEY0 상태 저장
    reg [1:0] set_index;             // 설정 항목 인덱스
    reg key_next_prev, key_inc_prev, key_dec_prev; // 키 상태 저장

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // 리셋 시 모든 값을 초기화
            timer_seconds <= 6'd0;
            timer_minutes <= 6'd0;
            timer_hours <= 5'd0;
            timer_days <= 5'd0;
            running <= 1'b0;
            set_index <= 2'b00;
            key_next_prev <= 1'b1;
            key_start_prev <= 1'b1;   // key_start_prev 초기화 (0으로 설정)
            key_inc_prev <= 1'b0;
            key_dec_prev <= 1'b0;
        end else if (sw_timer) begin
            if (!running) begin
                // 타이머 모드 최초 진입 시 key_prev 상태 동기화 (처음에 눌린 것으로 인식되지 않게)
                if (key_inc_prev !== key_inc || key_dec_prev !== key_dec || key_start_prev !== key_start) begin
                    // 키 입력 상태 동기화
                    key_inc_prev <= key_inc;
                    key_dec_prev <= key_dec;
                    key_start_prev <= key_start;
                end

                // 설정 모드일 때, 설정 항목 이동
                if (!key_next_prev && key_next) begin
                    set_index <= set_index + 1;
                    if (set_index == 2'b11) set_index <= 2'b00; // 설정 항목 순환
                end
                key_next_prev <= key_next;

                // 설정 항목에 따라 값 증가/감소
                case (set_index)
                    2'b00: begin
                        if (!key_inc_prev && key_inc) 
                            timer_seconds <= (timer_seconds < 6'd59) ? timer_seconds + 1 : 6'd0;
                        if (!key_dec_prev && key_dec) 
                            timer_seconds <= (timer_seconds > 6'd0) ? timer_seconds - 1 : 6'd59;
                    end
                    2'b01: begin
                        if (!key_inc_prev && key_inc) 
                            timer_minutes <= (timer_minutes < 6'd59) ? timer_minutes + 1 : 6'd0;
                        if (!key_dec_prev && key_dec) 
                            timer_minutes <= (timer_minutes > 6'd0) ? timer_minutes - 1 : 6'd59;
                    end
                    2'b10: begin
                        if (!key_inc_prev && key_inc) 
                            timer_hours <= (timer_hours < 5'd23) ? timer_hours + 1 : 5'd0;
                        if (!key_dec_prev && key_dec) 
                            timer_hours <= (timer_hours > 5'd0) ? timer_hours - 1 : 5'd23;
                    end
                    2'b11: begin
                        if (!key_inc_prev && key_inc) 
                            timer_days <= (timer_days < 5'd31) ? timer_days + 1 : 6'd0;
                        if (!key_dec_prev && key_dec) 
                            timer_days <= (timer_days > 5'd0) ? timer_days - 1 : 6'd31;
                    end
                endcase

                // 플래그 상태 업데이트
                key_inc_prev <= key_inc;
                key_dec_prev <= key_dec;
            end

            // 시작/정지 키를 누르면 타이머 동작 상태를 토글
            if (!key_start_prev && key_start) begin
                running <= ~running;
            end
            key_start_prev <= key_start;

            // 타이머 동작 시 카운트 다운
            if (running) begin
                if (timer_seconds > 0) begin
                    timer_seconds <= timer_seconds - 1;
                end else if (timer_minutes > 0 || timer_hours > 0 || timer_days > 0) begin
                    timer_seconds <= 6'd59;
                    if (timer_minutes > 0) begin
                        timer_minutes <= timer_minutes - 1;
                    end else if (timer_hours > 0) begin
                        timer_minutes <= 6'd59;
                        timer_hours <= timer_hours - 1;
                    end else if (timer_days > 0) begin
                        timer_hours <= 5'd23;
                        timer_days <= timer_days - 1;
                    end
                end else begin
                    // 시간이 다 지나면 0 상태 유지
                    running <= 1'b0;
                end
            end
        end else begin
            // 타이머 모드가 해제되면 모든 값 초기화
            timer_seconds <= 6'd0;
            timer_minutes <= 6'd0;
            timer_hours <= 5'd0;
            timer_days <= 6'd0;
            running <= 1'b0;
        end
    end
endmodule
