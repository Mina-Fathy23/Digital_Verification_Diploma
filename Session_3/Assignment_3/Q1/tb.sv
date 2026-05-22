import testing_pkg::*;

module tb ();
    
    Transaction obj = new;

    byte operand1, operand2;
    logic clk, rst;
    opcode_e opcode;
    byte out;

    int error_count, correct_count;

    alu_seq DUT (.*);

    initial begin
        clk = 0;
        forever begin
            #1 clk = ~clk;
            obj.clk = clk;
        end
    end

    initial begin

        error_count = 0; correct_count = 0;
        
        reset_assert();

        repeat(80)begin                     //Increased the number of tests from 32 to 80
            assert(obj.randomize());
            operand1 = obj.operand1;
            operand2 = obj.operand2;
            opcode = obj.opcode;
            check_result();

        end

        //Additional test for 100% code coverage
        reset_assert();

        $display("Total Tests:%0d | Correct Tests:%0d | Error Test:%0d", correct_count + error_count, correct_count, error_count);  
        $stop;
    end

    task reset_assert();
        rst = 1;
        check_result();
        rst = ~rst;
    endtask

    task clac_result(output byte out_expected);

        if (rst)
		out_expected = 0;
	    else 
		case (opcode)
			ADD: out_expected = operand1 + operand2;
			SUB: out_expected = operand1 - operand2;
			MULT:out_expected = operand1 * operand2; 
			DIV: out_expected = operand1 / operand2;
			default: out_expected = 0;
		endcase
    endtask

    task check_result();

        byte out_expected;
        clac_result(out_expected);
        @(negedge clk);
        if(out !== out_expected) begin
            error_count++;
            $display("Expected:%d | DUT:%d <----Error", out_expected, out);
        end
        else begin
            $display("Expected:%d | DUT:%d", out_expected, out);
            correct_count++;
        end
    endtask



endmodule