module shift_nonblocking(
    input clk,
    input reset,
    input d,
    output reg q1,
    output reg q2,
    output reg q3
);

    always @(posedge clk) begin
        if (reset) begin
            q1 <= 1'b0;
            q2 <= 1'b0;
            q3 <= 1'b0;
        end else begin
            q1 <= d;
            q2 <= q1;
            q3 <= q2;
        end
    end

endmodule