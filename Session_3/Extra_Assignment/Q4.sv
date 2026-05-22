module processor_memory();

  // Parameters
  localparam WORD_WIDTH = 24;
  localparam ADDR_WIDTH = 20;
  localparam MEM_SIZE   = 1 << ADDR_WIDTH; // 2^20 words

  // Associative array with explicit index type
  logic [WORD_WIDTH-1:0] mem [logic [ADDR_WIDTH-1:0]];

  // Addresses
  localparam logic [ADDR_WIDTH-1:0] RESET_ADDR = 20'h0;
  localparam logic [ADDR_WIDTH-1:0] START_ADDR = 20'h400;
  localparam logic [ADDR_WIDTH-1:0] ISR_ADDR   = MEM_SIZE-1;

  initial begin
    // Initialize memory
    mem[RESET_ADDR]   = 24'hA50400;   // Reset instruction
    mem[START_ADDR]   = 24'h123456;   // Instruction 1
    mem[START_ADDR+1] = 24'h789ABC;   // Instruction 2
    mem[ISR_ADDR]     = 24'h0F1E2D;   // ISR

    // Print number of initialized elements
    $display("Number of memory elements initialized: %0d", mem.num());

    // Print each element using foreach
    foreach(mem[i]) begin
      $display("Address %h : Data %h", i, mem[i]);
    end
  end

endmodule
