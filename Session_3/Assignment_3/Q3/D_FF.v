module D_FF(D, rst, CLK, Q);

parameter WIDTH = 1;
input rst, CLK; 
input [WIDTH-1: 0] D;
output reg [WIDTH-1: 0] Q;

always @(posedge CLK, posedge rst) begin
    
    if(rst)begin
        Q <= 0; 
    end
    else begin
        Q <= D;
    end

end

endmodule