module registered_input_Adder(in1, in2, rst_n, clk, out);

    parameter WIDTH_IN1 = 18;
    parameter WIDTH_IN2 = 18;
    localparam WIDTH_OUT = (WIDTH_IN1 >= WIDTH_IN2 ) ? WIDTH_IN1: WIDTH_IN2;
    parameter OPERATION = "ADD";
    input clk, rst_n;
    input [WIDTH_IN1-1:0] in1;
    input [WIDTH_IN2-1:0] in2;
    output reg [WIDTH_OUT-1:0] out;

    reg [WIDTH_IN1-1:0] in1_reg;
    reg [WIDTH_IN2-1:0] in2_reg;

    //D_FF for inputs
    always @(posedge clk) begin
        
        if(~rst_n)begin
            in1_reg <= 0; 
            in2_reg <= 0;
        end
        else begin
            in1_reg <= in1; 
            in2_reg <= in2;
        end

    end

    //Combinational output
    always @(*) begin
    
        if(OPERATION == "ADD")
            out = in1_reg + in2_reg;
        else if(OPERATION == "SUBTRACT")
            out = in1_reg - in2_reg;
        
    end
endmodule

module DSP48A1_S(
    input [17:0]      A,
    input [17:0]      B,
    input [47:0]      C,
    input [17:0]      D,
    input             clk,
    input             rst_n,
    output reg [47:0] P
);

parameter OPERATION = "ADD";  //ADD or SUBTRACT

wire [17:0] A_reg;
wire [17:0] adder1_out;
wire [47:0] multiplier_out, adder2_out;


D_FF #(.WIDTH(18)) A_FF (A, rst_n, clk, A_reg);
registered_input_Adder #(.WIDTH_IN1(18), .WIDTH_IN2(18)) ADDER_1 (D, B, rst_n, clk, adder1_out);
registered_input_MUL #(.WIDTH_IN1(18), .WIDTH_IN2(18)) MUL (adder1_out, A_reg, rst_n, clk, multiplier_out);
registered_input_Adder #(.WIDTH_IN1(36), .WIDTH_IN2(48)) ADDER_2 (multiplier_out, C, rst_n, clk, adder2_out);


always @(posedge clk) begin
    
    if(~rst_n)
        P <= 0;
    else
        P <= adder2_out;
end

endmodule

module registered_input_MUL(in1, in2, rst_n, clk, out);

    parameter WIDTH_IN1 = 18;
    parameter WIDTH_IN2 = 18;
    localparam WIDTH_OUT = WIDTH_IN1 + WIDTH_IN2;

    input clk, rst_n;
    input [WIDTH_IN1-1:0] in1;
    input [WIDTH_IN2-1:0] in2;
    output reg [WIDTH_OUT-1:0] out;

    reg [WIDTH_IN1-1:0] in1_reg;
    reg [WIDTH_IN2-1:0] in2_reg;

    //D_FF for inputs
    always @(posedge clk) begin
        
        if(~rst_n)begin
            in1_reg <= 0; 
            in2_reg <= 0;
        end
        else begin
            in1_reg <= in1; 
            in2_reg <= in2;
        end

    end

    //Combinational output
    always @(*) begin
    
        out = in1_reg * in2_reg;
    end
endmodule
