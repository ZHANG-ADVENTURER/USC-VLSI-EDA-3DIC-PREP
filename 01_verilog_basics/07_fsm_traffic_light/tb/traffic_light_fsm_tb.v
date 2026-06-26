`timescale 1ns/1ps

module traffic_light_fsm_tb;

    reg clk;
    reg reset;
    reg timer_done;

    wire [1:0] ns_light;
    wire [1:0] ew_light;

    localparam RED = 2'b00;
    localparam YELLOW = 2'b01;
    localparam GREEN = 2'b10;

    traffic_light_fsm dut(
        .clk(clk),
        .reset(reset),
        .timer_done(timer_done),
        .ns_light(ns_light),
        .ew_light(ew_light)
    );

    always #5 clk = ~clk;

    task check_lights;
        input [1:0] exp_ns;
        input [1:0] exp_ew;
        input [319:0] test_name;

        begin
            #1;

            if (ns_light == exp_ns && ew_light == exp_ew) begin
                $display ("pass | %-s | ns_light is %b | ew_light is %b", 
                          test_name, ns_light, ew_light);
            end else begin
                 $display("fail | %-s | ns_light is %b | ew_light is %b | expected_ns is %b | expected_ew is %b",
                         test_name, ns_light, ew_light, exp_ns, exp_ew);
            end
        end
    endtask

    initial begin
        $dumpfile("waves/traffic_light_fsm.vcd");
        $dumpvars(0, traffic_light_fsm_tb);
        
        clk = 0;
        reset = 1;
        timer_done = 0;

        @(posedge clk);
        check_lights(GREEN, RED, "Reset to S_NS_GREEN");

        reset = 0;

        @(posedge clk);
        check_lights(GREEN, RED, "Hold S_NS_GREEN");

        timer_done = 1;
        @(posedge clk);
        check_lights(YELLOW, RED, "S_NS_GREEN to S_NS_YELLOW");

        timer_done = 0;
        @(posedge clk);
        check_lights(YELLOW, RED, "Hold S_NS_YELLOW");

        timer_done = 1;
        @(posedge clk);
        check_lights(RED, GREEN, "S_NS_YELLOW to S_EW_GREEN");

        timer_done = 0;
        @(posedge clk);
        check_lights(RED, GREEN, "Hold S_EW_GREEN");

        timer_done = 1;
        @(posedge clk);
        check_lights(RED, YELLOW, "S_EW_GREEN to S_EW_YELLOW");

        timer_done = 0;
        @(posedge clk);
        check_lights(RED, YELLOW, "Hold S_EW_YELLOW");

        timer_done = 1;
        @(posedge clk);
        check_lights(GREEN, RED, "S_EW_YELLOW to S_NS_GREEN");

        timer_done = 0;
        @(posedge clk);
        check_lights(GREEN, RED, "Hold S_NS_GREEN again");

        $finish;
    end

endmodule