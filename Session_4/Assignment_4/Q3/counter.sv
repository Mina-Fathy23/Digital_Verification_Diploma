////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: Counter Design 
// 
////////////////////////////////////////////////////////////////////////////////
module counter (counter_if.DUT c_if);
parameter WIDTH = 4;                //(Valid values: 4, 6, 8, default: 4)

always @(posedge c_if.clk or negedge c_if.rst_n) begin
    if (~c_if.rst_n)                     //Modification: changed comparison "!" to bitwise NOT "~"
        c_if.count_out <= 0;
    else if (~c_if.load_n)               //Modification: changed comparison "!" to bitwise NOT "~"
        c_if.count_out <= c_if.data_load;
    else if (c_if.ce)begin               //Fixed BUg: added Begin and End statments
        if (c_if.up_down)
            c_if.count_out <= c_if.count_out + 1;
        else 
            c_if.count_out <= c_if.count_out - 1;
    end
end

assign c_if.max_count = (c_if.count_out == {WIDTH{1'b1}})? 1:0;
assign c_if.zero = (c_if.count_out == 0)? 1:0;

endmodule