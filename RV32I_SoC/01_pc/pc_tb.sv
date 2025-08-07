`timescale 1ns / 1ps

module pc_tb;

  // DUT signals
  logic clk;
  logic rst;
  logic pc_write;
  logic pc_flush;
  logic [31:0] pc_flush_val;
  logic [31:0] pc_next;
  logic [31:0] pc_current;

  // Instantiate DUT
  pc dut (
    .clk(clk),
    .rst(rst),
    .pc_write(pc_write),
    .pc_flush(pc_flush),
    .pc_flush_val(pc_flush_val),
    .pc_next(pc_next),
    .pc_current(pc_current)
  );

  // Clock generation
  always #5 clk = ~clk;

  // Test counters
  int pass_count = 0;
  int fail_count = 0;

  // Utility task: check result
  task automatic check(string testname, logic [31:0] expected);
    if (pc_current === expected) begin
      $display("[PASS] %s | pc_current = 0x%08h", testname, pc_current);
      pass_count++;
    end else begin
      $display("[FAIL] %s | pc_current = 0x%08h (expected: 0x%08h)", testname, pc_current, expected);
      fail_count++;
    end
  endtask

  // Stimulus task: initialize inputs
  task automatic init_inputs();
    rst = 0;
    pc_write = 0;
    pc_flush = 0;
    pc_flush_val = 32'h0;
    pc_next = 32'h0;
  endtask

  // Test sequence
  initial begin
    $display("===============================================");
    $display("       Starting PC Module Self-Testbench       ");
    $display("===============================================");
    clk = 0;
    init_inputs();

    // Test 1: Reset
    rst = 1;
    #10;
    rst = 0;
    #10;
    check("Reset Test", 32'h00000000);

    // Test 2: pc_write = 1, pc_next = 0x00000004
    pc_write = 1;
    pc_next = 32'h00000004;
    #10;
    check("PC Write Test (next=4)", 32'h00000004);

    // Test 3: pc_write = 1, pc_next = 0x00000008
    pc_next = 32'h00000008;
    #10;
    check("PC Write Test (next=8)", 32'h00000008);

    // Test 4: Stall (pc_write = 0), should retain previous PC
    pc_write = 0;
    pc_next = 32'h0000000C;
    #10;
    check("Stall Test (pc_write=0)", 32'h00000008);

    // Test 5: pc_flush = 1, pc_flush_val = 0xDEADBEEF
    pc_flush = 1;
    pc_flush_val = 32'hDEADBEEF;
    #10;
    pc_flush = 0;
    check("Flush Test (pc_flush_val=DEADBEEF)", 32'hDEADBEEF);

    // Test 6: Flush should override pc_write
    pc_flush = 1;
    pc_flush_val = 32'h12345678;
    pc_write = 1;
    pc_next = 32'h99999999;
    #10;
    pc_flush = 0;
    pc_write = 0;
    check("Flush Overrides Write", 32'h12345678);

    // Test 7: After flush, continue writing
    pc_write = 1;
    pc_next = 32'h1234567C;
    #10;
    check("Write After Flush", 32'h1234567C);

    // Final summary
    $display("\n===============================================");
    $display("             Test Summary Report               ");
    $display("===============================================");
    $display(" Passed: %0d", pass_count);
    $display(" Failed: %0d", fail_count);
    $display("===============================================");

    $finish;
  end

endmodule

