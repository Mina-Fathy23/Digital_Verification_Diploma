module assertions();

    //1
    property p_a_rise_b;
        @(posedge clk) $rose(a) |-> ##2 (b);
    endproperty

    //2
    property p_a_rise_b;
        @(posedge clk) (a && b) |-> ##[1:3] c;
    endproperty

    //3
    sequence p_s11b;
        @(posedge clk) 1 |-> ##2 (!b);
    endsequence

    //4
    property p_3_8_decoder_Y;
        @(posedge clk) $onehot(Y);
    endproperty

    property p_4_to_2_priority_encode_valid;
        @(posedge clk) (~D) |=> (~valid);
    endproperty

endmodule