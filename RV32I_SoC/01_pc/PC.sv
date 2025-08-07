//======================================================================
// Project     : RV32I RISC-V SoC (First Project)
// Module Name : pc
// File        : pc.sv
// Author      : Gowtham Krishna
// Description :
//   Program Counter module for instruction address generation.
//
//   - On reset, PC is initialized to 0.
//   - If a branch/jump is taken (pc_flush asserted), the PC is
//     updated with the flush value (pc_flush_val).
//   - If no flush occurs and pc_write is high, the PC is updated
//     with the next sequential value (pc_next).
//   - If neither occurs, the PC retains its current value.
//
// Interface:
//   Inputs:
//     - clk           : Clock input
//     - rst           : Asynchronous reset (active high)
//     - pc_write      : Write enable for PC (controls stalling)
//     - pc_flush      : Flush control (used during branch/jump)
//     - pc_flush_val  : New PC value when flushing
//     - pc_next       : Next PC value (usually PC + 4)
//
//   Output:
//     - pc_current    : Current PC value (address to fetch instruction)
//
// Notes:
//   - Supports pipeline hazards by allowing hold (stall) via pc_write
//   - Supports misprediction recovery via pc_flush
//
// Revision History:
//   - Jul 2025: Initial release
//======================================================================

module pc (
    input  logic        clk,           // System clock
    input  logic        rst,           // Asynchronous reset (active high)
    input  logic        pc_write,      // PC update enable
    input  logic        pc_flush,      // Branch/jump flush enable
    input  logic [31:0] pc_flush_val,  // Flush target PC
    input  logic [31:0] pc_next,       // Next PC value (normal case)
    output logic [31:0] pc_current     // Current PC value
);

    // Sequential logic: update PC on rising edge of clk or reset
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            pc_current <= 32'h00000000;         // Reset to address 0
        end else if (pc_flush) begin
            pc_current <= pc_flush_val;         // Branch/jump target
        end else if (pc_write) begin
            pc_current <= pc_next;              // Next instruction address
        end
        // else: retain current PC (stall condition)
    end

endmodule
