import ALU_pkg::*;

module ALU_tb();

    logic clk;
    logic reset;
    OPCODE_e Opcode;	// The opcode
    logic signed [3:0] A;	// Input data A in 2's complement
    logic signed [3:0] B;	// Input data B in 2's complement

    logic signed [4:0] C; // ALU output in 2's complement

    ALU_Inputs inputs = new;

    int error_count, correct_count;

    ALU_4_bit DUT (.*);

    initial begin
        clk = 0;
        forever
            #1 clk = ~clk;
    end

    initial begin
        
        reset_assert();

        repeat(30)begin
            assert(inputs.randomize());
            reset = inputs.reset;
            Opcode = inputs.Opcode;
            A = inputs.A;
            B = inputs.B;
            if(reset)begin
                check_result(0);
            end
            else begin
                case(Opcode)
                    ADD: begin
                        check_result(A + B);
                    end
                    SUB: begin
                        check_result(A - B);
                    end
                    NOT_A: begin
                        check_result(~A);
                    end
                    ReductionOR_B: begin
                        if(|B)
                            check_result(1);
                        else
                            check_result(0);
                    end
                    default: begin
                        $display("Error ---> Invalid Opcode");
                        $stop;
                    end
                endcase
            end    
        end
        $display("Total Tests:%0d | Correct Tests:%0d | Error Test:%0d", correct_count + error_count, correct_count, error_count);  
        $stop;
    end

    task reset_assert();
        reset = 1;
        check_result(0);
        reset = ~reset;
    endtask

    task check_result(input logic signed [4:0] C_expected);
        @(negedge clk);
        if(C !== C_expected) begin
            $display("Expected:%d | DUT:%d <----- Error", C_expected, C);
            error_count++;
            $stop;
        end
        else begin
            $display("Expected:%d | DUT:%d", C_expected, C);
            correct_count++;
        end
    endtask
    
endmodule