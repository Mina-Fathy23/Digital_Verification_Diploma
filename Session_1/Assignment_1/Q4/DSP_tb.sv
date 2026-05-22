module DSP_tb ();

parameter OPERATION = "ADD";
logic  [17:0] A, B, D;
logic  [47:0] C;
logic  clk, rst_n;
wire   [47:0] P_dut;
wire  [47:0] P_golden;

int correct_count, error_count;

DSP       #(OPERATION) dut    (A, B, C, D, clk, rst_n, P_dut);
DSP48A1_S #(OPERATION) golden (A, B, C, D, clk, rst_n, P_golden);

initial begin
    clk = 0;
    forever
        #1 clk = ~clk;
end

task reset_assert();
    rst_n = 0;
    check_result();
    rst_n = 1;
endtask

task check_result();
        repeat(4)@(negedge clk);
        $display("Expected:%d | DUT:%d", P_golden, P_dut);
        if(P_dut !== P_golden) begin
            error_count++;
            $stop;
        end
        else begin
            correct_count++;
        end
endtask

int i;

initial begin
    A = 0; B = 0; C = 0; D = 0; //P_golden = 0;

    correct_count = 0;
    error_count = 0;
    //DSP_1
    reset_assert();
    //DSP_2
    for(i = 0; i < 8; i++)begin
        A = $urandom; B = $urandom; C = $urandom; D = $urandom; 
        check_result();

    end

    //Additional Test Vectors for 100% Code Coverage
    reset_assert();

    $display("Total Tests:%d | Correct Tests:%d | Error Test:%d", correct_count + error_count, correct_count, error_count);  
    $stop;
end


endmodule
