module traffic_light_fsm(
    input clk,
    input reset,
    input timer_done,
    output reg [1:0] ns_light,
    output reg [1:0] ew_light
);

    localparam RED    = 2'b00;
    localparam YELLOW = 2'b01;
    localparam GREEN  = 2'b10;

    localparam S_NS_GREEN  = 2'b00;
    localparam S_NS_YELLOW = 2'b01;
    localparam S_EW_GREEN  = 2'b10;
    localparam S_EW_YELLOW = 2'b11;

    reg [1:0] current_state;
    reg [1:0] next_state;

    always @(posedge clk) begin
        if (reset)
            current_state <= S_NS_GREEN;
        else
            current_state <= next_state;
    end

    always @(*) begin
        next_state = current_state;

        case (current_state)
            S_NS_GREEN: begin
                if (timer_done)
                    next_state = S_NS_YELLOW;
            end

            S_NS_YELLOW: begin
                if (timer_done)
                    next_state = S_EW_GREEN;
            end

            S_EW_GREEN: begin
                if (timer_done)
                    next_state = S_EW_YELLOW;
            end

            S_EW_YELLOW: begin
                if (timer_done)
                    next_state = S_NS_GREEN;
            end

            default: begin
                next_state = S_NS_GREEN;
            end
        endcase
    end

    always @(*) begin
        ns_light = RED;
        ew_light = RED;

        case (current_state)
            S_NS_GREEN: begin
                ns_light = GREEN;
                ew_light = RED;
            end

            S_NS_YELLOW: begin
                ns_light = YELLOW;
                ew_light = RED;
            end

            S_EW_GREEN: begin
                ns_light = RED;
                ew_light = GREEN;
            end

            S_EW_YELLOW: begin
                ns_light = RED;
                ew_light = YELLOW;
            end

            default: begin
                ns_light = GREEN;
                ew_light = RED;
            end
        endcase
    end

endmodule