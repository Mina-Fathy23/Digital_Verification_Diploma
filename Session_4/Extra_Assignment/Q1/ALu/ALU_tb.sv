module ALU_4_bit_tb();

logic  clk;
logic  reset;
logic  [1:0] Opcode;	// The opcode
logic  signed [3:0] A;	// Input data A in 2's complement
logic  signed [3:0] B;	// Input data B in 2's complement

logic signed [4:0] C_dut; // ALU output in 2's complement

localparam  MAXPOS = 7;
localparam  MAXNEG = -8;

localparam 	Add	            = 2'b00; // A + B
localparam  Sub	            = 2'b01; // A - B
localparam  Not_A	        = 2'b10; // ~A
localparam  ReductionOR_B   = 2'b11; // |B

int correct_count, error_count;

ALU_4_bit dut(clk, reset, Opcode, A, B, C_dut);

bind ALU_4_bit assertions_tb assertions_tb_inst(.clk(clk), .reset(reset), .Opcode(Opcode), .A(A), .B(B), .C(C));

initial begin
    clk = 0;
    forever
        #1 clk = ~clk;
end

task reset_assert();
    reset = 1;
    @(negedge clk);
    reset = ~reset;
endtask


initial begin
    A = 0;
    B = 0;
    Opcode = 0;

    correct_count = 0;
    error_count = 0;

    //ALU_1    
    reset_assert();
    //ALU_2
    A = MAXPOS; B = MAXPOS; Opcode = Add; @(negedge clk);
    //ALU_3
    A = MAXPOS; B = MAXNEG; Opcode = Add; @(negedge clk);
    //ALU_4
    A = MAXNEG; B = MAXPOS; Opcode = Add; @(negedge clk);
    //ALU_5
    A = MAXNEG; B = MAXNEG; Opcode = Add; @(negedge clk);
    //ALU_6
    A = MAXPOS; B = MAXPOS; Opcode = Sub; @(negedge clk);
    //ALU_7
    A = MAXPOS; B = MAXNEG; Opcode = Sub; @(negedge clk);
    //ALU_8
    A = MAXNEG; B = MAXPOS; Opcode = Sub; @(negedge clk);
    //ALU_9
    A = MAXNEG; B = MAXNEG; Opcode = Sub; @(negedge clk);
    //ALU_10
    A = 4'b1111; Opcode = Not_A; @(negedge clk);
    //ALU_11
    B = 4'b0000; Opcode = ReductionOR_B; @(negedge clk);
    B = 4'b0001; Opcode = ReductionOR_B; @(negedge clk);
    B = 4'b0010; Opcode = ReductionOR_B; @(negedge clk);
    B = 4'b0100; Opcode = ReductionOR_B; @(negedge clk);
    B = 4'b1000; Opcode = ReductionOR_B; @(negedge clk);
    B = 4'b1111; Opcode = ReductionOR_B; @(negedge clk);


    A = 4; B = -6; Opcode = Add; @(negedge clk);

    $display("Total Tests:%d | Correct Tests:%d | Error Test:%d", correct_count + error_count, correct_count, error_count);  
    $stop;

end

endmodule


module assertions_tb (
    input  logic clk,
    input  logic reset,
    input  logic [1:0] Opcode,
    input  logic signed [3:0] A,
    input  logic signed [3:0] B,
    input  logic signed [4:0] C
);

    // Property for Addition (Opcode = 00)
    property p_add;
        @(posedge clk) disable iff (reset)
            ($past(Opcode) == 2'b00) |-> (C == ($past(A) + $past(B)));
    endproperty

    // Property for Subtraction (Opcode = 01)
    property p_sub;
        @(posedge clk) disable iff (reset)
            ($past(Opcode) == 2'b01) |-> (C == ($past(A) - $past(B)));
    endproperty

    // Property for Bitwise NOT of A (Opcode = 10)
    property p_not_a;
        @(posedge clk) disable iff (reset)
            ($past(Opcode) == 2'b10) |-> (C == (~$past(A)));
    endproperty

    // Property for Reduction OR of B (Opcode = 11)
    property p_red_or_b;
        @(posedge clk) disable iff (reset)
            ($past(Opcode) == 2'b11) |-> (C == (|$past(B)));
    endproperty

    // Property for Reset behavior
    property p_reset;
        @(posedge clk)
            reset |-> (C == 5'b0);
    endproperty

    always_comb begin
        if (reset) begin
            assert final (C == 5'b0) else $error("Reset Assertion Failed: C is not zero on reset");
            cover  final (C == 5'b0);
        end
    end


    // Assertions
    Add_Assertion:       assert property (p_add)      else $error("Addition Assertion Failed");
    Sub_Assertion:       assert property (p_sub)      else $error("Subtraction Assertion Failed");
    Not_A_Assertion:     assert property (p_not_a)    else $error("NOT A Assertion Failed");
    Red_OR_B_Assertion:  assert property (p_red_or_b) else $error("Reduction OR of B Assertion Failed");
    Reset_Assertion:     assert property (p_reset)    else $error("Reset Assertion Failed");

    // Coverage
    Add_Coverage:        cover property (p_add);
    Sub_Coverage:        cover property (p_sub);
    Not_A_Coverage:      cover property (p_not_a);
    Red_OR_B_Coverage:   cover property (p_red_or_b);
    Reset_Coverage:      cover property (p_reset);

endmodule

