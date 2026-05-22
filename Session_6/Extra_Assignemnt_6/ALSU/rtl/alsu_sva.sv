import alsu_seq_item_pkg::*;
module ALSU_SVA(A, B, cin, serial_in, red_op_A, red_op_B, opcode, bypass_A, bypass_B, clk, rst, direction, leds, out);

input logic clk, cin, rst, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
input logic [2:0] opcode;
input logic signed [2:0] A, B;
input logic [15:0] leds;
input logic signed [5:0] out;

logic invalid_opcode, invalid_red_op, invalid;

assign invalid_red_op = (red_op_A | red_op_B) & (opcode[1] | opcode[2]); 
assign invalid_opcode = opcode[1] & opcode[2];
assign invalid = invalid_red_op | invalid_opcode;

    // Reset behavior
      always_comb begin
         //5.When the asynchronous reset is asserted then the counter output is tied to low at the same instant.
        if(rst) begin
            assert final (out == 0);
            cover final (leds == 0);
        end

      end


    // Invalid case: out must be zero
    property p_invalid_out_zero;
        @(posedge clk) disable iff (rst) (invalid && !bypass_A && !bypass_B) |-> ##2 (out == 0);
    endproperty

    property p_valid_leds_zero;
        @(posedge clk) disable iff (rst) (!invalid) |=> (leds == 0);
    endproperty


    property bypassA_prop; 
        @(posedge clk) disable iff(rst) bypass_A |=>##1 (out ==$past(A,2));
    endproperty

    property bypassB_prop; 
        @(posedge clk) disable iff(rst) bypass_B && !bypass_A |=>##1 (out ==$past(B,2));
    endproperty


    sequence NO_bypass;
    !(bypass_A || bypass_B);
    endsequence

    // Red_op_A assertion
    property red_op_A_xor;
    @(posedge clk) disable iff(rst)
         NO_bypass |->(red_op_A && opcode==XOR) |=> ##1 (out == $past(^A,2));
    endproperty

    property red_op_A_or;
    @(posedge clk) disable iff(rst)
        NO_bypass |->(red_op_A && opcode==OR) |=> ##1 (out == $past(|A,2));
    endproperty


    // Red_op_B assertion - XOR
    property red_op_B_xor;
    @(posedge clk) disable iff(rst)
        NO_bypass |-> (!red_op_A && red_op_B && opcode==XOR) |=> ##1 (out == $past(^B,2));
    endproperty

    // Red_op_B assertion - OR
    property red_op_B_or;
    @(posedge clk) disable iff(rst)
        NO_bypass |-> (!red_op_A && red_op_B && opcode==OR) |=> ##1 (out == $past(|B,2));
    endproperty


    sequence NO_bypassANDred;
    !(bypass_A || bypass_B ||red_op_A||red_op_B );
    endsequence

    property OR_prop;
    @(posedge clk) disable iff(rst)
        NO_bypassANDred |-> (opcode==OR) |=> ##1 (out == ($past(A,2) | $past(B,2)));
    endproperty

    // Normal XOR (no reduction)
    property XOR_prop;
    @(posedge clk) disable iff(rst)
        NO_bypassANDred |-> (opcode==XOR) |=> ##1 (out == ($past(A,2) ^ $past(B,2)));
    endproperty

    // ADD
    property ADD_prop;
    @(posedge clk) disable iff(rst)
        NO_bypassANDred |-> (opcode==ADD) |=> ##1
        out == ($past(cin,2)? $past(A,2) + $past(B,2)+3'd1 :$past(A,2) + $past(B,2));
    endproperty
    
    // MUL
    property MUL_prop;
    @(posedge clk) disable iff(rst)
        NO_bypassANDred |-> (opcode==MULT ) |=> ##1
        (out == ($past(A,2) * $past(B,2)));
    endproperty
   
    // SHIFT (opcode = 100)
    property SHIFT_R_prop;
    @(posedge clk) disable iff(rst)
        NO_bypassANDred |-> (opcode==SHIFT && direction) |=> ##1
        (out == { $past(out[4:0],1), $past(serial_in,2) });
    endproperty
    
    // ROTATE (opcode = 101)
    property ROTATE_R_prop;
    @(posedge clk) disable iff(rst)
        NO_bypassANDred |-> (opcode==ROTATE && direction) |=> ##1
        (out == { $past(out[4:0],1), $past(out[5],1) });
    endproperty
    
    // SHIFT (opcode = 100)
    property SHIFT_L_prop;
    @(posedge clk) disable iff(rst)
        NO_bypassANDred |-> (opcode==SHIFT && !direction) |=> ##1
        (out == { $past(serial_in,2), $past(out[5:1],1) });
    endproperty
    

    // ROTATE (opcode = 101)
    property ROTATE_L_prop;
    @(posedge clk) disable iff(rst)
        NO_bypassANDred |-> (opcode==ROTATE && !direction) |=> ##1
        (out == { $past(out[0],1), $past(out[5:1],1) });
    endproperty
    

    property invalid_prop;
        @(posedge clk) disable iff(rst)
        (opcode== INVALID_6 || opcode==INVALID_7)
        ||((red_op_A||red_op_B)&& ~(opcode== OR ||opcode== XOR ))
        |=> ##1(leds == ~$past(leds));
    endproperty

    //------------------------------------
    // Assertions
    //------------------------------------

    p_invalid_out_zero_assertion              : assert property (p_invalid_out_zero);
    p_valid_leds_zero_assertion               : assert property (p_valid_leds_zero);
    bypassA_assertion                         : assert property( bypassA_prop);
    bypassB_assertion                         : assert property( bypassB_prop);
    red_op_A_xor_assertion                    : assert property(red_op_A_xor);
    red_op_A_or_assertion                     : assert property(red_op_A_or);
    red_op_B_xor_assertion                    : assert property(red_op_B_xor);
    red_op_B_or_assertion                     : assert property(red_op_B_or);
    OR_assertion                              : assert property(OR_prop);
    XOR_assertion                             : assert property(XOR_prop);
    ADD_assertion                             : assert property(ADD_prop);
    MUL_assertion                             : assert property(MUL_prop);
    SHIFT_R_assertion                         : assert property(SHIFT_R_prop);
    ROTATE_R_assertion                        : assert property(ROTATE_R_prop);
    SHIFT_L_assertion                         : assert property(SHIFT_L_prop);
    ROTATE_L_assertion                        : assert property(ROTATE_L_prop);
    invalid_assertion                         : assert property(invalid_prop);
    
    
    
    //------------------------------------
    // Coverage
    //------------------------------------

    p_invalid_out_zero_coverage              : cover property (p_invalid_out_zero);
    p_valid_leds_zero_coverage               : cover property (p_valid_leds_zero);
    bypassA_coverage                         : cover property( bypassA_prop);
    bypassB_coverage                         : cover property( bypassB_prop);
    red_op_A_xor_coverage                    : cover property(red_op_A_xor);
    red_op_A_or_coverage                     : cover property(red_op_A_or);
    red_op_B_xor_coverage                    : cover property(red_op_B_xor);
    red_op_B_or_coverage                     : cover property(red_op_B_or);
    OR_coverage                              : cover property(OR_prop);
    XOR_coverage                             : cover property(XOR_prop);
    ADD_coverage                             : cover property(ADD_prop);
    MUL_coverage                             : cover property(MUL_prop);
    SHIFT_R_coverage                         : cover property(SHIFT_R_prop);
    ROTATE_R_coverage                        : cover property(ROTATE_R_prop);
    SHIFT_L_coverage                         : cover property(SHIFT_L_prop);
    ROTATE_L_coverage                        : cover property(ROTATE_L_prop);
    invalid_coverage                        : cover property(invalid_prop);

    
endmodule