`timescale 1ns/1ps

module register_file_basic_tb;

    reg clk;
    reg reset;
    reg write_en;
    reg [1:0] write_addr;
    reg [7:0] write_data;
    reg [1:0] read_addr1;
    reg [1:0] read_addr2;

    wire [7:0] read_data1;
    wire [7:0] read_data2;

    register_file_basic dut (
        .clk(clk),
        .reset(reset),
        .write_en(write_en),
        .write_addr(write_addr),
        .write_data(write_data),
        .read_addr1(read_addr1),
        .read_addr2(read_addr2),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    always #5 clk = ~clk;

    task write_reg;
        input [1:0] addr;
        input [7:0] data;
        input [8*60-1:0] test_name;

        begin
            write_en = 1'b1;
            write_addr = addr;
            write_data = data;

            @(posedge clk);
            #1;

            write_en = 1'b0;

            $display("WRITE: %s | addr = %0d, data = %h", test_name, addr, data);
        end
    endtask

    task check_read;
        input [1:0] addr1;
        input [1:0] addr2;
        input [7:0] expected1;
        input [7:0] expected2;
        input [8*60-1:0] test_name;

        begin
            read_addr1 = addr1;
            read_addr2 = addr2;

            #1;

            if (read_data1 === expected1 && read_data2 === expected2) begin
                $display("PASS: %s | read_data1 = %h, read_data2 = %h",
                         test_name, read_data1, read_data2);
            end else begin
                $display("FAIL: %s | expected1 = %h, actual1 = %h | expected2 = %h, actual2 = %h",
                         test_name, expected1, read_data1, expected2, read_data2);
            end
        end
    endtask

    initial begin
        $dumpfile("waves/register_file_basic.vcd");
        $dumpvars(0, register_file_basic_tb);

        clk = 0;
        reset = 0;
        write_en = 0;
        write_addr = 2'b00;
        write_data = 8'h00;
        read_addr1 = 2'b00;
        read_addr2 = 2'b00;

        reset = 1'b1;
        @(posedge clk);
        #1;
        reset = 1'b0;

        check_read(2'b00, 2'b01, 8'h00, 8'h00, "After reset, regs[0] and regs[1] should be 0");
        check_read(2'b10, 2'b11, 8'h00, 8'h00, "After reset, regs[2] and regs[3] should be 0");

        write_reg(2'b00, 8'hA1, "Write A1 to regs[0]");
        check_read(2'b00, 2'b00, 8'hA1, 8'hA1, "Read regs[0] from both read ports");

        write_reg(2'b01, 8'hB2, "Write B2 to regs[1]");
        check_read(2'b00, 2'b01, 8'hA1, 8'hB2, "Read regs[0] and regs[1]");

        write_reg(2'b10, 8'hC3, "Write C3 to regs[2]");
        write_reg(2'b11, 8'hD4, "Write D4 to regs[3]");
        check_read(2'b10, 2'b11, 8'hC3, 8'hD4, "Read regs[2] and regs[3]");

        check_read(2'b01, 2'b01, 8'hB2, 8'hB2, "Both read ports read regs[1]");

        write_reg(2'b00, 8'h5A, "Overwrite regs[0] with 5A");
        check_read(2'b00, 2'b01, 8'h5A, 8'hB2, "Read updated regs[0] and unchanged regs[1]");

        $display("Register file basic test completed.");
        $finish;
    end

endmodule