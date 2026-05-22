module priority_enc_tb();

logic  clk;
logic  rst;
logic  [3:0] D;	
logic  [1:0] Y_dut;	
logic  valid_dut;


priority_enc dut (.clk(clk), .rst(rst), .D(D), .Y(Y_dut), .valid(valid_dut));
bind priority_enc assertions_tb assertions_inst(
    .clk(clk),
    .rst(rst),
    .D(D),
    .Y(Y),
    .valid(valid)
);


initial begin
    clk = 0;
    forever
        #1 clk = ~clk;
end


task reset_assert();
    rst = 1;
    @(negedge clk);
    assert (Y_dut == 2'b00 && valid_dut == 1'b0) else $error("Reset Failed");
    rst = 0; 
endtask

initial begin

    
    //Priority_Encoder_1
    reset_assert();

    //Priority_Encoder_2
    D = 4'b0000; @(negedge clk); //Y_expected is Don't Care 
    D = 4'b1000; @(negedge clk);

    D = 4'b0100; @(negedge clk);
    D = 4'b1100; @(negedge clk);

    D = 4'b0010; @(negedge clk);
    D = 4'b0110; @(negedge clk);
    D = 4'b1010; @(negedge clk);
    D = 4'b1110; @(negedge clk);

    D = 4'b0001; @(negedge clk);
    D = 4'b0011; @(negedge clk);
    D = 4'b0101; @(negedge clk);
    D = 4'b0111; @(negedge clk);
    D = 4'b1001; @(negedge clk);
    D = 4'b1011; @(negedge clk);
    D = 4'b1101; @(negedge clk);
    D = 4'b1111; @(negedge clk);

    D = 4'b1000; @(negedge clk); //For 100% Code Coverage
    
    //Priority_Encoder_1
    reset_assert();

    $stop;

end

endmodule

module assertions_tb(input logic clk, input logic rst, input logic [3:0] D, input logic [1:0] Y, input logic valid);

    property p_D_bit_3;
    @(posedge clk) disable iff (rst) (D[3] && !D[2] && !D[1] && !D[0]) |=> (Y == 2'b00 && valid == 1'b1);
    endproperty

    property p_D_bit_2;
    @(posedge clk) disable iff (rst) (!D[3] && D[2] && !D[1] && !D[0]) |=> (Y == 2'b01 && valid == 1'b1);
    endproperty

    property p_D_bit_1;
    @(posedge clk) disable iff (rst) (!D[3] && !D[2] && D[1] && !D[0]) |=> (Y == 2'b10 && valid == 1'b1);
    endproperty

    property p_D_bit_0;
    @(posedge clk) disable iff (rst) (!D[3] && !D[2] && !D[1] && D[0]) |=> (Y == 2'b11 && valid == 1'b1);
    endproperty

    property p_invalid;
    @(posedge clk) disable iff (rst) (D == 4'b0000) |=> (valid == 1'b0);
    endproperty



    D_bit_3_Assertion: assert property (p_D_bit_3) else $error("D[3] Assertion Failed");
    D_bit_2_Assertion: assert property (p_D_bit_2) else $error("D[2] Assertion Failed");
    D_bit_1_Assertion: assert property (p_D_bit_1) else $error("D[1] Assertion Failed");
    D_bit_0_Assertion: assert property (p_D_bit_0) else $error("D[0] Assertion Failed");
    Invalid_Assertion: assert property (p_invalid) else $error("Invalid Assertion Failed");

    D_bit_3_Coverage: cover property (p_D_bit_3);
    D_bit_2_Coverage: cover property (p_D_bit_2);
    D_bit_1_Coverage: cover property (p_D_bit_1); 
    D_bit_0_Coverage: cover property (p_D_bit_0);
    Invalid_Coverage: cover property (p_invalid); 
endmodule