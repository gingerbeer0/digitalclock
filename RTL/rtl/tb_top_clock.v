module tb_top_clock;

    // Inputs
    reg clk_1ms;         // 1ms(1kHz) 클럭 입력 (테스트를 위해 사용)
    reg rst_n;           // 비동기 리셋 (active low)
    reg sw_set;          // 설정 모드 스위치
    reg sw_stopwatch;    // 스톱워치 모드 스위치
    reg sw_timer;        // 타이머 모드 스위치
    reg sw_london;       // 런던 시간 표시 스위치
    reg sw_ny;           // 뉴욕 시간 표시 스위치
    reg sw_12_24;        // 12시간/24시간 전환 스위치
    reg key3;            // 공용으로 사용하는 KEY3 입력
    reg key_inc;         // 값 증가 (KEY2)
    reg key_dec;         // 값 감소 (KEY1)
    reg key_start;       // 타이머 시작 (KEY0)
    reg debug_mode;      // 디버그 모드 스위치

    // Outputs
    wire [6:0] seg_data0, seg_data1, seg_data2, seg_data3, seg_data4, seg_data5, seg_data6, seg_data7;
    wire led16, led17, ledg0;
    wire AUD_DACDAT, AUD_XCK, AUD_BCLK, AUD_DACLRCK;

    // Instantiate the Unit Under Test (UUT)
    top_clock uut (
        .clk_50MHz(clk_1ms),  // 실제로는 50MHz 클럭이지만, 테스트 벤치에서는 1ms 클럭 사용
        .rst_n(rst_n),
        .sw_set(sw_set),
        .sw_stopwatch(sw_stopwatch),
        .sw_timer(sw_timer),
        .sw_london(sw_london),
        .sw_ny(sw_ny),
        .sw_12_24(sw_12_24),
        .key3(key3),
        .key_inc(key_inc),
        .key_dec(key_dec),
        .key_start(key_start),
        .debug_mode(debug_mode),
        .seg_data0(seg_data0),
        .seg_data1(seg_data1),
        .seg_data2(seg_data2),
        .seg_data3(seg_data3),
        .seg_data4(seg_data4),
        .seg_data5(seg_data5),
        .seg_data6(seg_data6),
        .seg_data7(seg_data7),
        .led16(led16),
        .led17(led17),
        .ledg0(ledg0),
        .AUD_DACDAT(AUD_DACDAT),
        .AUD_XCK(AUD_XCK),
        .AUD_BCLK(AUD_BCLK),
        .AUD_DACLRCK(AUD_DACLRCK)
    );

    // 1ms clock generation for testing (instead of 50MHz for real use)
    always #0.5 clk_1ms = ~clk_1ms;  // 1ms 주기 클럭 생성 (0.5ms 간격으로 토글)

    initial begin
        // Initialize Inputs
        clk_1ms = 0;
        rst_n = 0;
        sw_set = 0;
        sw_stopwatch = 0;
        sw_timer = 0;
        sw_london = 0;
        sw_ny = 0;
        sw_12_24 = 0;
        key3 = 0;
        key_inc = 0;
        key_dec = 0;
        key_start = 0;
        debug_mode = 0;

        // Apply reset for 1ms
        #5;  // 1ms 동안 리셋
        rst_n = 1;
        #5;
        // Test case 1: 시간 설정 모드에서 59분 59초 설정
        sw_set = 1;
        #5;
        key_dec = 1;
        #5;  // 1ms 대기
        key_dec = 0;
        #5;  // 1ms 대기
        key3 = 1;  // 분 설정으로 이동
        #5;
        key3 = 0;
        key_dec = 0;
        #5;  // 1ms 대기
        key_dec = 1;
        #5;  // 1ms 대기
        key_dec = 0;



        // 설정 모드 종료
        sw_set = 0;

        // 3초 대기 후 1시 00분 00초가 되는지 확인
        #3_000;  // 3초 대기

        // Test case 2: 세계 시간 전환 테스트 (런던 -> 뉴욕)
        sw_london = 1;  // 런던 시간 표시
        #3_000;  // 3초 대기
        sw_london = 0;
        sw_ny = 1;  // 뉴욕 시간 표시
        #3_000;  // 3초 대기
        sw_ny = 0;

        // Test case 3: 스톱워치 기능 테스트
        sw_stopwatch = 1;
        #5;
        key3 = 1;  // 스톱워치 시작
        #3_000;  // 1초 대기
        key3 = 0;
        #5;  // 1초 대기
        key3 = 1;  // 스톱워치 정지
        #3_000;  // 3초 대기
        key3 = 0;
        #5;
        key3 = 1;  // 스톱워치 재시작
        #3_000;  // 3초 대기
        key3 = 0;
        sw_stopwatch = 0;
        #5;
        //debug_mode
        debug_mode = 1;
        #3_000;
        debug_mode = 0;
        #5;

        // Test case 4: 타이머 기능 테스트
        sw_timer = 1;
        #1_000;
        key_dec = 1;  
        #1_000;
        key_dec = 0;
        #1_000;
        key_start = 1;  // 타이머 시작
        #3_000;  
        key_start = 0;
        #1_000;
        key_start = 1;  // 타이머 정지
        #3_000;  
        key_start = 0;
        #1_000;
        key_start = 1;  // 타이머 재시작
        #3_000;  
        key_start = 0;
        #1_000;
        key_start = 1;  
        #1_000;
        key_start = 0;
        sw_timer = 0;

        // Test case 5: 12시간/24시간 모드 전환 테스트
        #1_000;
        sw_set = 1;
        #1_000;  
        key3 = 1; 
        #1_000;
        key3 = 0;
        key_dec = 1;
        #1_000;  
        key_dec = 0;
        #1_000;  

        sw_12_24 = 1;  // 24시간 모드
        #3_000;  // 3초 대기
        sw_12_24 = 0;  // 12시간 모드

        // Stop simulation after sufficient time
        #5_000;  
        $finish;
    end

endmodule
