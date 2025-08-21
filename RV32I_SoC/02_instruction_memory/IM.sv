//======================================================================
// Project     : RV32I RISC-V SoC 
// Module Name : instruction_memory
// File        : instruction_memory.sv
// Author      : Gowtham Krishna
// Description :
//   Synthesizable ROM block that outputs 32-bit RISC-V instruction
//   based on PC address.
//
//   - Address is word-aligned (PC >> 2) to index instruction memory.
//
// Interface:
//   Input:
//     - addr        : Byte address from PC
//   Output:
//     - instruction : 32-bit instruction at that address
//
// Instruction Map:
//   0x00: addi x2,  x0, 5
//   0x04: addi x3,  x0, 7
//   0x08: beq  x2,  x3, 0x20
//   0x0C: add  x4,  x2, x3
//   0x10: or   x5,  x2, x3
//   0x14: and  x6,  x2, x3
//   0x18: xor  x7,  x2, x3
//   0x1C: lw   x10, 0(x2)
//   0x20: sw   x10, 4(x2)   (branch target)
//   0x24: sub  x9,  x2, x3
//======================================================================

module instruction_memory (
    input  logic [31:0] addr,           // Byte address from PC
    output logic [31:0] instruction     // 32-bit instruction
);

    always_comb begin
        case (addr[9:2])  // Word-aligned address (PC[9:2])
            8'd0: instruction = 32'h00500113; // addi x2, x0, 5
            8'd1: instruction = 32'h00700193; // addi x3, x0, 7
            8'd2: instruction = 32'h06310463; // beq  x2, x3, 0x20
            8'd3: instruction = 32'h003101b3; // add  x3, x2, x3
            8'd4: instruction = 32'h003162b3; // or   x5, x2, x3
            8'd5: instruction = 32'h003172b3; // and  x6, x2, x3
            8'd6: instruction = 32'h003142b3; // xor  x7, x2, x3
            8'd7: instruction = 32'h00012503; // lw   x10, 0(x2)
            8'd8: instruction = 32'h00a12223; // sw   x10, 4(x2) (label)
            8'd9: instruction = 32'h403143b3; // sub  x9, x2, x3
            default: instruction = 32'h00000013; // nop
        endcase
    end

endmodule

