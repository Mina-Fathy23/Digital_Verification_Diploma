module RAM (input bit clk, bit [9:0] din, bit rst_n, bit rx_valid,  output logic tx_valid, logic [7:0] dout);

reg [7:0] MEM [255:0];
reg [7:0] Rd_Addr, Wr_Addr;

always @(posedge clk) begin
    if (!rst_n) begin
        dout <= 0;
        tx_valid <= 0;
        Rd_Addr <= 0;
        Wr_Addr <= 0;
    end
    else  begin  //put begin & end                                    
        if (rx_valid) begin
            case (din[9:8])
                2'b00 : begin
                    Wr_Addr <= din[7:0];
                    tx_valid <= 0;
                end 
                2'b01 : begin 
                    MEM[Wr_Addr] <= din[7:0];
                    tx_valid <= 0;
                end 
                2'b10 : begin
                    Rd_Addr <= din[7:0];
                    tx_valid <= 0;
                end 
                2'b11 : begin
                    dout <= MEM[Rd_Addr]; //bug MEM[Rd_Addr] instead of MEM[Wr_Addr]
                    tx_valid <= 1;
                end 
                default : tx_valid <= 0;
            endcase
        end
    end
end       

endmodule