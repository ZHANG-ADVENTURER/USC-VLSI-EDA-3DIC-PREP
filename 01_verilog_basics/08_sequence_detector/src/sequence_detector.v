module sequence_detector(
    input clk,
    input reset,
    input bit_in,
    output reg detected
);

    localparam S_IDLE = 3'b000;
    localparam S_1    = 3'b001;
    localparam S_10   = 3'b010;
    localparam S_101  = 3'b011;
    localparam S_1011 = 3'b100;

    reg [2:0] current_state;
    reg [2:0] next_state;

    always @(posedge clk) begin
        if (reset)
            current_state <= S_IDLE;
        else
            current_state <= next_state;
    end

    always @(*) begin
        next_state = current_state;

        case (current_state)
            S_IDLE: begin
                if (bit_in)
                    next_state = S_1;
                else
                    next_state = S_IDLE;
            end

            S_1: begin
                if (bit_in)
                    next_state = S_1;
                else
                    next_state = S_10; 
            end

            S_10: begin
                if (bit_in)
                    next_state = S_101;
                else
                    next_state = S_IDLE;
            end

            S_101: begin
                if (bit_in)
                    next_state = S_1011;
                else
                    next_state = S_10;
            end

            S_1011: begin
                if (bit_in)
                    next_state = S_1;
                else
                    next_state = S_10;
            end

            default: begin
                next_state = S_IDLE;
            end
        endcase
    end

    always @(*) begin
        detected = 1'b0;

        case (current_state)
            S_1011: begin
                detected = 1'b1;
            end

            default: begin
                detected = 1'b0;
            end
        endcase
    end

endmodule