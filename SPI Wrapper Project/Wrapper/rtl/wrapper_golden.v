module wrapper_golden(MOSI , SS_n , clk , rst_n , MISO );

input MOSI , SS_n , clk , rst_n ;
output MISO ;

wire [7:0] tx_data ;
wire tx_valid ;

wire [9:0] rx_data ;
wire rx_valid ; 


SPI_slave spi_inst(.clk(clk) , .SS_n(SS_n) , .rst_n(rst_n) , .MOSI(MOSI) , 
.tx_data(tx_data) , .tx_valid(tx_valid) , .MISO(MISO) , .rx_data(rx_data) 
, .rx_valid(rx_valid) );


Ram ram_inst ( .clk(clk) , .rst_n(rst_n) , .rx_valid(rx_valid) 
, .din(rx_data) , .tx_valid(tx_valid) , .dout(tx_data) );



endmodule