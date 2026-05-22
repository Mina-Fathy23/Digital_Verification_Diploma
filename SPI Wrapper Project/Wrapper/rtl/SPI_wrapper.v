module WRAPPER (MOSI, MISO, SS_n, clk, rst_n);

input  MOSI, SS_n, clk, rst_n;
output MISO;

wire [9:0] rx_data_din;
wire       rx_valid;
wire       tx_valid;
wire [7:0] tx_data_dout;

RAM   RAM_instance   (.clk(clk), .din(rx_data_din), .rst_n(rst_n), .rx_valid(rx_valid), .tx_valid(tx_valid), .dout(tx_data_dout));
SLAVE SLAVE_instance (.MOSI(MOSI), .MISO(MISO), .SS_n(SS_n), .clk(clk),
                        .rst_n(rst_n), .rx_data(rx_data_din), .rx_valid(rx_valid), .tx_data(tx_data_dout), .tx_valid(tx_valid));

endmodule