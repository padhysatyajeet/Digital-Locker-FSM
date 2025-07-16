`timescale 1ns / 1ps

module digital_locker_tb;

    reg clk, reset, submit;
    reg [3:0] digit_in;
    wire unlocked, locked;
    wire [1:0] attempts_left;

    digital_locker uut (
        .clk(clk), .reset(reset), .submit(submit), .digit_in(digit_in),
        .unlocked(unlocked), .locked(locked), .attempts_left(attempts_left)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    task enter_code(input [3:0] d0, d1, d2, d3);
    begin
        digit_in = d0; submit = 1; #10; submit = 0; #10;
        digit_in = d1; submit = 1; #10; submit = 0; #10;
        digit_in = d2; submit = 1; #10; submit = 0; #10;
        digit_in = d3; submit = 1; #10; submit = 0; #10;
    end
    endtask

    initial begin
        $dumpfile("locker.vcd");
        $dumpvars(0, digital_locker_tb);

        reset = 1; submit = 0; digit_in = 0; #20;
        reset = 0; #10;

        // Correct password
        enter_code(4'd1, 4'd2, 4'd3, 4'd4);
        #50;

        // Reset to try again
        reset = 1; #10; reset = 0; #10;

        // Incorrect attempts
        enter_code(4'd0, 4'd0, 4'd0, 4'd0);
        #20;
        enter_code(4'd9, 4'd9, 4'd9, 4'd9);
        #20;
        enter_code(4'd8, 4'd8, 4'd8, 4'd8);
        #50;

        $finish;
    end

endmodule