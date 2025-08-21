//======================================================================
// Project     : RV32I RISC-V SoC 
// Testbench  : tb_instruction_memory
// File        : tb_instruction_memory.sv
// Author      : Gowtham Krishna
// Description :
//   Self-testing testbench for instruction_memory module
//
//   - Drives PC addresses (word aligned).
//   - Compares output instructions against expected encodings.
//   - Prints PASS/FAIL for each test.
//======================================================================

`timescale 1ns/1ps

module tb_instruction_memory;

    // DUT signals
    logic [31:0] addr;
    logic [31:0] instruction;

    // Instantiate DUT
    instruction_memory dut (
        .addr(addr),
        .instruction(instruction)
    );

    // Reference expected instructions
    logic [31:0] expected_instr;

    // Task to check output
    task check_instr(input [31:0] pc, input [31:0] exp);
        begin
            addr = pc;
            #1; // allow combinational logic to settle
            expected_instr = exp;
            if (instruction !== expected_instr) begin
                $error("FAIL: PC=%h | Got=%h | Expected=%h", pc, instruction, expected_instr);
            end else begin
                $display("PASS: PC=%h | Instr=%h", pc, instruction);
            end
        end
    endtask

    // Test sequence
    initial begin
        $display("===== Starting Instruction Memory Test =====");

        check_instr(32'h00, 32'h00500113); // addi x2, x0, 5
        check_instr(32'h04, 32'h00700193); // addi x3, x0, 7
        check_instr(32'h08, 32'h06310463); // beq  x2, x3, 0x20
        check_instr(32'h0C, 32'h003101b3); // add  x3, x2, x3
        check_instr(32'h10, 32'h003162b3); // or   x5, x2, x3
        check_instr(32'h14, 32'h003172b3); // and  x6, x2, x3
        check_instr(32'h18, 32'h003142b3); // xor  x7, x2, x3
        check_instr(32'h1C, 32'h00012503); // lw   x10, 0(x2)
        check_instr(32'h20, 32'h00a12223); // sw   x10, 4(x2)
        check_instr(32'h24, 32'h403143b3); // sub  x9, x2, x3

        // Check default (NOP)
        check_instr(32'h40, 32'h00000013); // nop

        $display("===== Instruction Memory Test Completed =====");
        $finish;
    end

endmodule

