module D_FF(D, rst_n, CLK, Q);

parameter WIDTH = 1;
input rst_n, CLK; 
input [WIDTH-1: 0] D;
output reg [WIDTH-1: 0] Q;

always @(posedge CLK) begin
    
    if(~rst_n)begin
        Q <= 0; 
    end
    else begin
        Q <= D;
    end

end

endmodule