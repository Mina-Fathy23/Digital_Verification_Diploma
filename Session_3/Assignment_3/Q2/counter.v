////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: Counter Design 
// 
////////////////////////////////////////////////////////////////////////////////
module counter (clk ,rst_n, load_n, up_down, ce, data_load, count_out, max_count, zero);
parameter WIDTH = 4;                //(Valid values: 4, 6, 8, default: 4)
input clk;
input rst_n;                        //(active low sync rst)
input load_n;                       //(active low load)
input up_down;                      //high then increment counter, else decrement
input ce;                           //(clock enable signal
input [WIDTH-1:0] data_load;        //(load data to count_out output when the load_n signal is asserted)    
output reg [WIDTH-1:0] count_out;  
output max_count;                   //counter reaches the maximum value, this signal is high, else low)
output zero;                        //counter reaches the minimum value, this signal is high, else low)

always @(posedge clk) begin
    if (~rst_n)                     //Modification: changed comparison "!" to bitwise NOT "~"
        count_out <= 0;
    else if (~load_n)               //Modification: changed comparison "!" to bitwise NOT "~"
        count_out <= data_load;
    else if (ce)begin               //Fixed BUg: added Begin and End statments
        if (up_down)
            count_out <= count_out + 1;
        else 
            count_out <= count_out - 1;
    end
end

assign max_count = (count_out == {WIDTH{1'b1}})? 1:0;
assign zero = (count_out == 0)? 1:0;

endmodule