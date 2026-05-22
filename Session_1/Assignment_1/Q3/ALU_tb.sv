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

initial begin
    clk = 0;
    forever
        #1 clk = ~clk;
end

task reset_assert();
    reset = 1;
    check_result(0);
    reset = ~reset;
endtask

task check_result(input logic signed [4:0] C_expected);
    @(negedge clk);
    $display("Expected:%d | DUT:%d", C_expected, C_dut);
    if(C_dut !== C_expected) begin
        error_count++;
        $stop;
    end
    else begin
        correct_count++;
    end
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
    A = MAXPOS; B = MAXPOS; Opcode = Add; check_result(14);
    //ALU_3
    A = MAXPOS; B = MAXNEG; Opcode = Add; check_result(-1);
    //ALU_4
    A = MAXNEG; B = MAXPOS; Opcode = Add; check_result(-1);
    //ALU_5
    A = MAXNEG; B = MAXNEG; Opcode = Add; check_result(-16);
    //ALU_6
    A = MAXPOS; B = MAXPOS; Opcode = Sub; check_result(0);
    //ALU_7
    A = MAXPOS; B = MAXNEG; Opcode = Sub; check_result(15);
    //ALU_8
    A = MAXNEG; B = MAXPOS; Opcode = Sub; check_result(-15);
    //ALU_9
    A = MAXNEG; B = MAXNEG; Opcode = Sub; check_result(0);
    //ALU_10
    A = 4'b1111; Opcode = Not_A; check_result(0);
    //ALU_11
    B = 4'b0000; Opcode = ReductionOR_B; check_result(0);
    B = 4'b0001; Opcode = ReductionOR_B; check_result(1);
    B = 4'b0010; Opcode = ReductionOR_B; check_result(1);
    B = 4'b0100; Opcode = ReductionOR_B; check_result(1);
    B = 4'b1000; Opcode = ReductionOR_B; check_result(1);
    B = 4'b1111; Opcode = ReductionOR_B; check_result(1);

    //Additional Test Vectors for 100% Code Coverage
    reset_assert();

    A = 4; B = -6; Opcode = Add; check_result(-2);

    $display("Total Tests:%d | Correct Tests:%d | Error Test:%d", correct_count + error_count, correct_count, error_count);  
    $stop;

end

endmodule