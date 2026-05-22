module Sequence_detect #(
    parameter IDLE  = 2'b00,
    parameter ZERO  = 2'b01,
    parameter ONE   = 2'b10,
    parameter STORE = 2'b11
) (
    input            x,
    input            clk,
    input            rst,  //Acitve High Asynch
    output reg       y,
    output reg [9:0] count
);

reg [1:0] state, next_state;

//current state logic
always @(posedge clk or posedge rst) begin
    if(rst) begin
        state <= IDLE;
    end
    else
        state <= next_state;
end

//next state logic
always @(*) begin
    case (state)
        IDLE:
            if(x == 0)
                next_state = ZERO;
            else
                next_state = IDLE; 
        ZERO:
            if(x == 1)
                next_state = ONE;
            else
                next_state = ZERO;
        ONE:
            if(x == 0)
                next_state = STORE;
            else
                next_state = IDLE;
        STORE:
            if(x == 0)
                next_state = ZERO;
            else
                next_state = IDLE;
        default: next_state = IDLE;
    endcase
    
end

//output logic
always @(*)begin
    y = (state == STORE) ? 1'b1 : 1'b0;
end

always @(posedge clk)begin
    if(rst)
        count <= 0;
    else if(state == STORE)
        count <= count + 1;
end
    
endmodule