//======================================================================
// Project     : RV32I RISC-V SoC 
// Module Name : if_id_pipeline_reg
// File        : if_id_pipeline_reg.sv
// Author      : Gowtham Krishna
// Description :
//   IF/ID pipeline register for 5-stage RISC-V pipeline.
//
//   - Holds the PC and instruction fetched from instruction memory.
//   - Supports flush (branch/jump) to clear invalid instruction.
//   - Supports stall to hold current values.
//
// Interface:
//   Inputs:
//     - clk       : Clock input
//     - rst       : Synchronous reset (active high)
//     - stall     : Stall signal (hold current values)
//     - flush     : Flush signal (kill instruction)
//     - if_pc     : PC from IF stage
//     - if_instr  : Instruction from instruction memory
//
//   Outputs:
//     - id_pc     : PC to ID stage
//     - id_instr  : Instruction to ID stage
//
// Notes:
//   - flush is asserted when a branch/jump is taken (controlled by EX stage)
//   - stall is asserted when pipeline hazard is detected
//
// Revision History:
//   - Aug 2025: Initial release
//======================================================================

module if_id_pipeline_reg (
    input  logic        clk,       // System clock
    input  logic        rst,       // Synchronous reset (active high)
    input  logic        stall,     // Stall signal
    input  logic        flush,     // Flush signal

    input  logic [31:0] if_pc,     // PC from IF stage
    input  logic [31:0] if_instr,  // Instruction from IF stage

    output logic [31:0] id_pc,     // PC to ID stage
    output logic [31:0] id_instr   // Instruction to ID stage
);

    // Sequential logic: update IF/ID pipeline register
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            id_pc    <= 32'h00000000;
            id_instr <= 32'h00000000;
        end else if (flush) begin
            id_pc    <= 32'h00000000;   // Kill instruction (NOP)
            id_instr <= 32'h00000013;   // NOP instruction in RISC-V (ADDI x0,x0,0)
        end else if (!stall) begin
            id_pc    <= if_pc;
            id_instr <= if_instr;
        end
        // else: hold values (stall)
    end

endmodule

