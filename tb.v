`timescale 1ns/1ps

module tb;

    reg clk;
    reg rst;
    reg d_in;
    reg submit;
    reg reset_sys;

    wire locked;
    wire unlocked;

    locker dut(
        .clk(clk),
        .rst(rst),
        .d_in(d_in),
        .submit(submit),
        .reset_sys(reset_sys),
        .locked(locked),
        .unlocked(unlocked)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Monitor
    initial begin
    $monitor("T=%0t | ps=%0d ns=%0d count=%0d | d_in=%b submit=%b rst=%b reset_sys=%b | locked=%b unlocked=%b",
              $time,
              dut.ps,
              dut.ns,
              dut.count,
              d_in,
              submit,
              rst,
              reset_sys,
              locked,
              unlocked);
end
    initial begin

    //--------------------------------------------------
    // INITIALIZATION
    //--------------------------------------------------
    rst       = 0;
    reset_sys = 0;
    d_in      = 0;
    submit    = 0;

    #10;

    //--------------------------------------------------
    // TEST 1 : Correct Password 1101
    //--------------------------------------------------
    $display("\n===== TEST 1 : CORRECT PASSWORD =====");

    d_in=1; #10;
    d_in=1; #10;
    d_in=0; #10;
    d_in=1; #10;

    submit=1; #10;
    submit=0; #10;

    //--------------------------------------------------
    // TEST 2 : Wrong Password Attempt #1
    //--------------------------------------------------
    $display("\n===== TEST 2 : WRONG PASSWORD #1 =====");

    d_in=1; #10;
    d_in=0; #10;    // wrong bit -> error

    submit=1; #10;
    submit=0; #10;

    //--------------------------------------------------
    // TEST 3 : Wrong Password Attempt #2
    //--------------------------------------------------
    $display("\n===== TEST 3 : WRONG PASSWORD #2 =====");

    d_in=0; #10;    // immediate error

    submit=1; #10;
    submit=0; #10;

    //--------------------------------------------------
    // TEST 4 : Wrong Password Attempt #3
    // Should enter BLOCKED
    //--------------------------------------------------
    $display("\n===== TEST 4 : WRONG PASSWORD #3 =====");

    d_in=1; #10;
    d_in=1; #10;
    d_in=1; #10;    // wrong third bit

    submit=1; #10;
    submit=0; #10;

    //--------------------------------------------------
    // TEST 5 : Try correct password after BLOCKED
    //--------------------------------------------------
    $display("\n===== TEST 5 : TRY AFTER BLOCKED =====");

    d_in=1; #10;
    d_in=1; #10;
    d_in=0; #10;
    d_in=1; #10;

    submit=1; #10;
    submit=0; #10;

    //--------------------------------------------------
    // TEST 6 : reset_sys clears blocked state
    //--------------------------------------------------
    $display("\n===== TEST 6 : SYSTEM RESET =====");

    reset_sys=1;
    #10;
    reset_sys=0;
    #10;

    //--------------------------------------------------
    // TEST 7 : Correct Password After reset_sys
    //--------------------------------------------------
    $display("\n===== TEST 7 : CORRECT PASSWORD AGAIN =====");

    d_in=1; #10;
    d_in=1; #10;
    d_in=0; #10;
    d_in=1; #10;

    submit=1; #10;
    submit=0; #10;

    //--------------------------------------------------
    // TEST 8 : rst during entry
    //--------------------------------------------------
    $display("\n===== TEST 8 : CLEAR ENTRY =====");

    d_in=1; #10;
    d_in=1; #10;

    rst=1;
    #10;
    rst=0;

    #10;

    // Password must be re-entered
    d_in=1; #10;
    d_in=1; #10;
    d_in=0; #10;
    d_in=1; #10;

    submit=1; #10;
    submit=0; #10;

    //--------------------------------------------------
    $display("\n===== SIMULATION COMPLETE =====");
    #20;
    $finish;

    end

endmodule