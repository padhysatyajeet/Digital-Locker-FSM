module digital_locker (
    input clk,
    input reset,
    input submit,
    input [3:0] digit_in,
    output reg unlocked,
    output reg locked,
    output reg [1:0] attempts_left
);

    // State encoding using parameter
    parameter IDLE = 2'b00, COMPARE = 2'b01, UNLOCKED_STATE = 2'b10, LOCKED_STATE = 2'b11;
    reg [1:0] current_state, next_state;

    // Password storage
    reg [3:0] password [3:0];
    initial begin
        password[0] = 4'd1;
        password[1] = 4'd2;
        password[2] = 4'd3;
        password[3] = 4'd4;
    end

    // Digit entry buffer
    reg [1:0] digit_index;  // 2-bit is fine: values 0 to 3
    reg [3:0] input_digits [3:0];
    reg match_flag;

    // FSM and input capture
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            digit_index <= 0;
            attempts_left <= 2'd3;
            unlocked <= 0;
            locked <= 0;
        end else begin
            current_state <= next_state;

            // Capture digit on submit
            if (submit && current_state == IDLE) begin
                input_digits[digit_index] <= digit_in;

                if (digit_index == 2'd3)
                    next_state <= COMPARE;

                digit_index <= digit_index + 1;
            end
        end
    end

    // Next state logic and result check
    always @(*) begin
        next_state = current_state;
        match_flag = (
            input_digits[0] == password[0] &&
            input_digits[1] == password[1] &&
            input_digits[2] == password[2] &&
            input_digits[3] == password[3]
        );

        case (current_state)
            IDLE: begin
                unlocked = 0;
                locked = 0;
            end

            COMPARE: begin
                if (match_flag)
                    next_state = UNLOCKED_STATE;
                else if (attempts_left == 2'd1)
                    next_state = LOCKED_STATE;
                else
                    next_state = IDLE;
            end

            UNLOCKED_STATE: begin
                unlocked = 1;
            end

            LOCKED_STATE: begin
                locked = 1;
            end
        endcase
    end

    // Attempts and digit reset logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            attempts_left <= 2'd3;
        end else if (current_state == COMPARE && !match_flag) begin
            attempts_left <= attempts_left - 1;
            digit_index <= 0;
        end
    end

endmodule