module N_bit_up_down_Counter(clk, reset, en_load, clk_en, load, up_ndown, cnt);

parameter WIDTH = 3;
input clk, reset, en_load, up_ndown, clk_en;
input [WIDTH-1: 0] load;
output reg [WIDTH-1: 0] cnt;

always @(posedge clk) begin

    if (~reset)
        cnt <= 0;
    else if(~en_load)
        cnt <= load;
    else if(clk_en)begin
        if(up_ndown)
            cnt <= cnt + 1;
        else
            cnt <= cnt - 1;
    end
    
    
end



endmodule