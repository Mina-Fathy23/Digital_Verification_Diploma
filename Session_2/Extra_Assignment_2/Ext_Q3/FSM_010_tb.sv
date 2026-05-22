import FSM_010_pkg::*;

module FSM_010_tb();
    
    logic clk, rst, x;
	logic y_dut, y_golden;
	logic [9:0] users_count_dut, users_count_golden;

    fsm_transaction inputs = new;

    int error_count, correct_count;

    FSM_010         dut     (.x(x), .clk(clk), .rst(rst), .y(y_dut), .users_count(users_count_dut));
    Sequence_detect Golden  (.x(x), .clk(clk), .rst(rst), .y(y_golden), .count(users_count_golden));

    initial begin
        clk = 0;
        forever begin
            #1 clk = ~clk;
            inputs.clk = clk;
        end
    end

    initial begin
        error_count = 0; correct_count = 0;
        //FSM_1
        reset_assert();

        //FSM_2
        repeat(30)begin
            assert(inputs.randomize());
            rst = inputs.rst;
            x   = inputs.x;
            check_result();
        end

        //Extra Tests for 100% coverage
        reset_assert();
        rst = 0; x = 0; check_result(); //0
        rst = 0; x = 1; check_result(); //10
        rst = 0; x = 0; check_result(); //010
        rst = 0; x = 1; check_result(); //1010

        $display("Total Tests:%0d | Correct Tests:%0d | Error Test:%0d", correct_count + error_count, correct_count, error_count);  
        $stop;
    end

    task reset_assert();
        rst = 1;
        check_result;
        rst = ~rst;
    endtask

    task check_result();
        @(negedge clk);
        if(y_dut !== y_golden || users_count_dut != users_count_golden) begin
            error_count++;
            $display("Expected: Y:%0d, Count:%0d | DUT: Y:%0d, Count:%0d <---Error", y_golden, users_count_golden, y_dut, users_count_dut);
            $stop;
        end
        else begin
            $display("Expected: Y:%0d, Count:%0d | DUT: Y:%0d, Count:%0d", y_golden, users_count_golden, y_dut, users_count_dut);
            correct_count++;
        end
    endtask

endmodule