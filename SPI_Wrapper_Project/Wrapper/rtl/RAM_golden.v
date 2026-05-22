module Ram( clk , rst_n , rx_valid , din , tx_valid , dout );

parameter MEM_DEPTH = 256 ; 
parameter ADDR_SIZE = 8   ;

input clk , rst_n , rx_valid ;
input [9:0] din ;

output reg tx_valid ;
output reg [7:0] dout ;

reg [7:0] mem [MEM_DEPTH-1:0] ;
reg [ADDR_SIZE-1:0] write_address ;
reg [ADDR_SIZE-1:0] read_address  ;


always @(posedge clk) begin
    if(~rst_n) begin 
        tx_valid      <= 0 ; 
        dout          <= 0 ;
        write_address <= {ADDR_SIZE{1'b0}} ; 
        read_address  <= {ADDR_SIZE{1'b0}} ;
    end
    else begin
        if(rx_valid) begin 
            case ( { din[9], din[8] } )
            // case 1
                2'b00: begin
                        write_address <= din[7:0];
                        tx_valid <= 0 ;
                end

            // case 2 
                2'b01: begin
                        mem[write_address] <= din[7:0];
                        tx_valid <= 0 ;
                end

            // case 3
                2'b10: begin
                        read_address <= din[7:0] ;
                        tx_valid <= 0 ;
                    
                end

            // case 4 
                2'b11: begin 
                        dout <= mem[read_address];
                        tx_valid <= 1 ;
                end
            endcase
        end
    end
end

endmodule