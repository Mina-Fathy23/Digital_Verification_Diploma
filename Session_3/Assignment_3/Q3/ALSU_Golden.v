module ALSU_golden (
    input signed [2:0]  A,
    input signed [2:0]  B,
    input        clk,
    input        rst,
    input        cin,           //only valid to be used if the parameter FULL_ADDER is 'ON'
    input        serial_in,     //Used only in shift operation
    input        red_op_A,      //When High, Inditacted a reduction operation on A instead of A and B when OPCODE is AND or XOR
    input        red_op_B,      //When High, Inditacted a reduction operation on B instead of A and B when OPCODE is AND or XOR
    input [2:0]  opcode, 
    input        bypass_A,      //When High, Port A is registered to the output ignoring opcode operation 
    input        bypass_B,      //When High, Port B is registered to the output ignoring opcode operation 
    input        direction,     //When High, Shifting to Left, otherwise it's right
    
    output reg [15:0]     leds, //Blinks with every clk cycle in case of invalid operation
    output reg [5:0]       out  //Output of ALSU
);



parameter INPUT_PRIORITY = "A";   //The input to be bypassed if bypass_A and bypass_B are high and similarly red_op_A, red_op_B
parameter FULL_ADDER = "ON";

wire [2:0]   A_reg, B_reg;
wire         cin_reg;     
wire         serial_in_reg;     
wire         red_op_A_reg, red_op_B_reg;   
wire [2:0]   opcode_reg;
wire         bypass_A_reg, bypass_B_reg;  
wire         direction_reg;  

//Internal Signals
wire        invalid_red;

//Register Instantiations
D_FF #(.WIDTH(3))   A_FF        (.D(A),         .rst(rst), .CLK(clk), .Q(A_reg));
D_FF #(.WIDTH(3))   B_FF        (.D(B),         .rst(rst), .CLK(clk), .Q(B_reg));
D_FF #(.WIDTH(1))   cin_FF      (.D(cin),       .rst(rst), .CLK(clk), .Q(cin_reg));
D_FF #(.WIDTH(1))   serial_in_FF(.D(serial_in), .rst(rst), .CLK(clk), .Q(serial_in_reg));
D_FF #(.WIDTH(1))   red_op_A_FF (.D(red_op_A),  .rst(rst), .CLK(clk), .Q(red_op_A_reg));
D_FF #(.WIDTH(1))   red_op_B_FF (.D(red_op_B),  .rst(rst), .CLK(clk), .Q(red_op_B_reg));
D_FF #(.WIDTH(3))   opcode_FF   (.D(opcode),    .rst(rst), .CLK(clk), .Q(opcode_reg));
D_FF #(.WIDTH(1))   bypass_A_FF (.D(bypass_A),  .rst(rst), .CLK(clk), .Q(bypass_A_reg));
D_FF #(.WIDTH(1))   bypass_B_FF (.D(bypass_B),  .rst(rst), .CLK(clk), .Q(bypass_B_reg));
D_FF #(.WIDTH(1))   direction_FF(.D(direction), .rst(rst), .CLK(clk), .Q(direction_reg));

//Invalid_red flag
assign invalid_red = ((red_op_A_reg == 1 || red_op_B_reg == 1) && (opcode != 3'b000 && opcode != 3'b001));


always @(posedge clk, posedge rst) begin
    /*     
    | Opcode | Operation    |
    |--------|--------------|
    | 000    | AND          |
    | 001    | XOR          |
    | 010    | Addition     |
    | 011    | Multiplication |
    | 100    | Shift output by 1 bit |
    | 101    | Rotate output by 1 bit |
    | 110    | Invalid opcode |
    | 111    | Invalid opcode |
    */
    if(rst)begin
        out <= 0;
        leds <= 0;
    end
    else begin
        if(invalid_red) begin

            if (INPUT_PRIORITY == "A") begin
                out <= bypass_A_reg ? A_reg : 
                    bypass_B_reg ? B_reg : 0;
                leds <= ~(leds);
                
            end
            else begin // "B" priority
                out <= bypass_B_reg ? B_reg : 
                    bypass_A_reg ? A_reg : 0;
                leds <= ~(leds);
            end
        end
        else if(bypass_A_reg || bypass_B_reg) begin

            if (INPUT_PRIORITY == "A") begin
                out <= bypass_A_reg ? A_reg : 
                    bypass_B_reg ? B_reg : 0; 
            end
            else begin // "B" priority
                out <= bypass_B_reg ? B_reg : 
                    bypass_A_reg ? A_reg : 0;
            end

        end
        else begin
            case (opcode_reg)
                3'b000:  begin

                        if (INPUT_PRIORITY == "A") begin
                            out <= red_op_A_reg ? &(A_reg) : 
                                red_op_B_reg ? &(B_reg) : A_reg & B_reg;
                        end
                        else begin // "B" priority
                            out <= red_op_B_reg ? &(B_reg) : 
                                red_op_A_reg ? &(A_reg) : A_reg & B_reg;
                        end
                    end    
                3'b001:  begin

                        if (INPUT_PRIORITY == "A") begin
                            out <= red_op_A_reg ? ^(A_reg) : 
                                red_op_B_reg ? ^(B_reg) : A_reg ^ B_reg;
                            
                        end
                        else begin // "B" priority
                            out <= red_op_B_reg ? ^(B_reg) : 
                                red_op_A_reg ? ^(A_reg) : A_reg ^ B_reg;
                        end

                    end        
                3'b010:  out <= (FULL_ADDER == "ON") ? A_reg + B_reg + cin_reg: A_reg + B_reg; 
                3'b011:  out <= A_reg * B_reg;
                3'b100:  out <= (direction_reg == 1) ? {out[4:0], serial_in_reg} : {serial_in_reg, out[5:1]};
                3'b101:  out <= (direction_reg == 1) ? {out[4:0], out[5]} : {out[0], out[5:1]}; 
                3'b110,
                3'b111: begin

                        if (INPUT_PRIORITY == "A") begin
                            out <= bypass_A_reg ? A_reg : 
                                bypass_B_reg ? B_reg : 0;
                            leds <= ~(leds);
                            
                        end
                        else begin // "B" priority
                            out <= bypass_B_reg ? B_reg : 
                                bypass_A_reg ? A_reg : 0;
                            leds <= ~(leds);
                        end
                    end
            endcase
        end
    end
end

    
endmodule