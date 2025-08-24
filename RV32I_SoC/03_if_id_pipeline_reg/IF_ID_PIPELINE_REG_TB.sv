
//======================================================================
// Project     : RV32I RISC-V SoC (First Project)
// Module Name : tb_if_id_pipeline_reg
// File        : tb_if_id_pipeline_reg.sv
// Author      : Gowtham Krishna
// Description :
//   Self-testing testbench for IF/ID pipeline register with automatic
//   PASS/FAIL checking.
//
//   Tests:
//   - Reset behavior
//   - Normal instruction transfer
//   - Stall behavior
//   - Flush behavior (branch taken)
//
// Notes:
//   - Uses simple clock generation
//   - Checks outputs automatically
//
// Revision History:
//   - Aug 2025: Initial release
//======================================================================

`timescale 1ns/1ps

module tb_if_id_pipeline_reg;

    // Testbench signals
    logic        clk;
    logic        rst;
    logic        stall;
    logic        flush;
    logic [31:0] if_pc;
    logic [31:0] if_instr;
    logic [31:0] id_pc;
    logic [31:0] id_instr;

    // Instantiate DUT
    if_id_pipeline_reg dut (
        .clk(clk),
        .rst(rst),
        .stall(stall),
        .flush(flush),
        .if_pc(if_pc),
        .if_instr(if_instr),
        .id_pc(id_pc),
        .id_instr(id_instr)
    );

    // Clock generation: 10ns period
    always #5 clk = ~clk;

    // Task to check expected values
    task check_output(input [31:0] expected_pc, input [31:0] expected_instr, input string test_name);
        if (id_pc === expected_pc && id_instr === expected_instr) begin
            $display("[%0t ns] PASS: %s", $time, test_name);
        end else begin
            $display("[%0t ns] FAIL: %s | Got PC=%h, INSTR=%h | Expected PC=%h, INSTR=%h",
                     $time, test_name, id_pc, id_instr, expected_pc, expected_instr);
        end
    endtask

    // Test procedure
    initial begin
        // Initialize signals
        clk      = 0;
        rst      = 1;
        stall    = 0;
        flush    = 0;
        if_pc    = 32'h00000000;
        if_instr = 32'h00000000;

        #10;
        rst = 0;

        $display("----- IF/ID Pipeline Register Self-Test (PASS/FAIL) -----");

        // 1) Normal instruction transfer
        if_pc    = 32'h00000004;
        if_instr = 32'h12345678;
        #10;
        check_output(32'h00000004, 32'h12345678, "Normal instruction transfer");

        // 2) Stall test: hold previous values
        stall = 1;
        if_pc    = 32'h00000008;
        if_instr = 32'h87654321;
        #10;
        check_output(32'h00000004, 32'h12345678, "Stall holds previous values");
        stall = 0;

        // 3) Flush test: simulate branch taken
        flush = 1;
        if_pc    = 32'h0000000C;
        if_instr = 32'hAAAAAAAA;
        #10;
        check_output(32'h00000000, 32'h00000013, "Flush inserts NOP");
        flush = 0;

        // 4) Another normal instruction
        if_pc    = 32'h00000010;
        if_instr = 32'hBBBBBBBB;
        #10;
        check_output(32'h00000010, 32'hBBBBBBBB, "Normal instruction after flush");

        $display("----- Self-Test Complete -----");
        $stop;
    end

endmodule
