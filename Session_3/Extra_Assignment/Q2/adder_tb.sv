import adder_pkg::*;

module adder_tb();
    
    localparam MAXPOS = 7;
    localparam MAXNEG = -8;
    
    logic  CLK;
    logic  reset;
    logic  signed [3:0] A;	// Input data A in 2's complement
    logic  signed [3:0] B;	// Input data B in 2's complement
    logic  signed [4:0] C_dut; // Adder output in 2's complement

    int error_count, correct_count;

    adder DUT (CLK, reset, A, B, C_dut);

    Adder_inputs inputs = new;

    initial begin
       CLK = 0;
       forever
           #1 CLK = ~CLK;
   end

   task reset_assert();
    reset = 1;
    check_result(0);
    reset = 0;
   endtask
    
    task check_result(input logic signed [4:0] C_expected);
        @(negedge CLK);
        $display("Expected:%d | DUT: %d", C_expected, C_dut);
        if(C_dut !== C_expected) begin
            error_count++;
            $stop;
        end
        else begin
            correct_count++;
        end
    endtask

    always @(posedge CLK) begin
        inputs.sample();
    end

  
    initial begin
        A = 0; 
        B = 0;
        correct_count = 0;
        error_count = 0;

        repeat(1000)begin
            assert(inputs.randomize());
            reset = inputs.reset;
            A = inputs.A;
            B = inputs.B;
            @(negedge CLK);
        end
        //Adder_1
        reset_assert();

        //Adder_2
        A = MAXNEG; B = MAXNEG; check_result(-16);
        //Adder_3
        A = MAXNEG; B = 0; check_result(MAXNEG);
        //Adder_4
        A = MAXNEG; B = MAXPOS; check_result(-1);

        //Adder_5
        A = MAXPOS; B = MAXNEG; check_result(-1);
        //Adder_6
        A = MAXPOS; B = 0; check_result(MAXPOS);
        //Adder_7
        A = MAXPOS; B = MAXPOS; check_result(14);
        
        //Adder_8
        A = 0; B = MAXNEG; check_result(MAXNEG);
        //Adder_9
        A = 0; B = 0; check_result(0);
        //Adder_10
        A = 0; B = MAXPOS; check_result(MAXPOS);
        
        //Adder_11
        reset_assert();

        $display("Test Finished | Correct_Count =%d | Error_Count=%d", correct_count, error_count);
        $stop;

    end

endmodule