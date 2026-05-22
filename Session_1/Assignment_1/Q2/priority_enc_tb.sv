module priority_enc_tb();

logic  clk;
logic  rst;
logic  [3:0] D;	
logic  [1:0] Y_dut;	
logic  valid_dut;

int error_count, correct_count;

priority_enc dut (clk, rst, D, Y_dut, valid_dut);

initial begin
    clk = 0;
    forever
        #1 clk = ~clk;
end

task check_result(input logic valid_expected, [1:0] Y_expected);
    @(negedge clk);
    $display("Y: Expected:%d | DUT:%d || Valid: Expected:%d | DUT:%d", Y_expected, Y_dut, valid_expected, valid_dut);
    if(Y_dut !== Y_expected || valid_dut !== valid_expected)begin
        error_count++;
        $stop;
    end
    else begin
        correct_count++;
    end
endtask

task reset_assert();
    rst = 1;
    check_result(0, 0);
    rst = 0; 
endtask

initial begin

    correct_count = 0;
    error_count = 0;
    
    //Priority_Encoder_1
    reset_assert();

    //Priority_Encoder_2
    D = 4'b0000; check_result(0, 0); //Y_expected is Don't Care 
    D = 4'b1000; check_result(1, 0);

    D = 4'b0100; check_result(1, 1);
    D = 4'b1100; check_result(1, 1);

    D = 4'b0010; check_result(1, 2);
    D = 4'b0110; check_result(1, 2);
    D = 4'b1010; check_result(1, 2);
    D = 4'b1110; check_result(1, 2);

    D = 4'b0001; check_result(1, 3);
    D = 4'b0011; check_result(1, 3);
    D = 4'b0101; check_result(1, 3);
    D = 4'b0111; check_result(1, 3);
    D = 4'b1001; check_result(1, 3);
    D = 4'b1011; check_result(1, 3);
    D = 4'b1101; check_result(1, 3);
    D = 4'b1111; check_result(1, 3);

    D = 4'b1000; check_result(1, 0); //For 100% Code Coverage
    
    //Priority_Encoder_1
    reset_assert();

    $display("Total Tests:%d | Correct Tests:%d | Error Test:%d", correct_count + error_count, correct_count, error_count);
    $stop;

end

endmodule