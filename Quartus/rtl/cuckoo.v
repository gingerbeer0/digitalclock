module cuckoo(
    input CLOCK_50,        // 50MHz 클럭 입력
    input play_sound,      // 소리 재생 트리거 (한 시간마다)
    output reg AUD_DACDAT, // Audio output data
    output AUD_XCK,        // Audio CODEC master clock
    output AUD_BCLK,       // Audio bit clock
    output AUD_DACLRCK     // Audio DAC LR clock
);

    reg [9:0] counter;
    reg [25:0] tone_counter;
    reg square_wave;
    reg playing;
    reg [2:0] sound_state;
    
    wire [9:0] tone_divisor1 = 659;
    wire [9:0] tone_divisor2 = 622;

    parameter TONE_DURATION = 10000000; // 0.3 second at 50 MHz clock
    parameter PAUSE_DURATION = 45000000; // 0.1 second pause

    // Tone generation and state management
    always @(posedge CLOCK_50) begin
        if (play_sound && !playing) begin
            // play_sound 신호가 트리거될 때 재생 시작
            playing <= 1'b1;
            sound_state <= 3'b000;
            tone_counter <= 0;
            counter <= 0;
            square_wave <= 0;
        end else if (playing) begin
            // 주파수 선택 및 사각파 생성
            if (sound_state == 3'b000 || sound_state == 3'b100) begin
                if (counter >= tone_divisor1) begin
                    counter <= 0;
                    square_wave <= ~square_wave;
                end else begin
                    counter <= counter + 1;
                end
            end else if (sound_state == 3'b010 || sound_state == 3'b110) begin
                if (counter >= tone_divisor2) begin
                    counter <= 0;
                    square_wave <= ~square_wave;
                end else begin
                    counter <= counter + 1;
                end
            end else begin
                square_wave <= 1'b0; // 간격 상태에서는 소리 비활성화
            end

            // 상태 전환 관리
            if (sound_state == 3'b000 || sound_state == 3'b010 || sound_state == 3'b100 || sound_state == 3'b110) begin
                if (tone_counter >= TONE_DURATION) begin
                    tone_counter <= 0;
                    sound_state <= sound_state + 1;
                end else begin
                    tone_counter <= tone_counter + 1;
                end
            end else if (sound_state == 3'b001 || sound_state == 3'b011 || sound_state == 3'b101) begin
                if (tone_counter >= PAUSE_DURATION) begin
                    tone_counter <= 0;
                    sound_state <= sound_state + 1;
                end else begin
                    tone_counter <= tone_counter + 1;
                end
            end else if (sound_state == 3'b111) begin
                playing <= 1'b0; // 네 번째 음 끝나면 재생 중지
                sound_state <= 3'b000;
            end
        end else begin
            // 재생 중이 아닐 때 초기화
            square_wave <= 1'b0;
            AUD_DACDAT <= 1'b0;
        end

        // Assign audio output
        AUD_DACDAT <= square_wave;
    end

    // Clock generation for audio CODEC
    reg [1:0] xck_div;
    always @(posedge CLOCK_50) begin
        xck_div <= xck_div + 1;
    end
    assign AUD_XCK = xck_div[1];

    // Generate AUD_BCLK (1.536 MHz) and AUD_DACLRCK (48 kHz)
    reg [5:0] bclk_div;
    always @(posedge AUD_XCK) begin
        bclk_div <= bclk_div + 1;
    end
    assign AUD_BCLK = bclk_div[2];
    assign AUD_DACLRCK = bclk_div[5];

endmodule 