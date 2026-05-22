module dff_t2_tb();

parameter USE_EN = 1;
logic clk, rst, d, en;
logic q_dut;

int correct_count, error_count;

dff #(.USE_EN(USE_EN)) dut (clk, rst, d, q_dut, en);

initial begin
    clk = 0;
    forever
        #1 clk = ~clk;
end

task reset_assert();
    rst = 1;
    check_result(0);
    rst = 0;
endtask

task check_result(input logic q_expected);
    @(negedge clk);
    $display("Expected:%d | DUT:%d", q_expected, q_dut);
    if(q_dut !== q_expected) begin
        error_count++;
        $stop;
    end
    else begin
        correct_count++;
    end
endtask

initial begin
    en = 0; d = 0;
    error_count = 0;
    correct_count = 0;

    //D_FF_1
    reset_assert();

    //D_FF_2
    en = 0; d = 0; check_result(0);
    en = 0; d = 1; check_result(0);

    //D_FF_2
    en = 1; d = 0; check_result(0);
    en = 1; d = 1; check_result(1);
    //Additional Test Vectors for 100% Code Coverage
    reset_assert();

    en = 0; d = 0; check_result(0);

    $display("Total Tests:%d | Correct Tests:%d | Error Test:%d", correct_count + error_count, correct_count, error_count);  
    $stop;
end
    
endmodule