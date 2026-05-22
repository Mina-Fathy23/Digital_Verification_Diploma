interface SPI_if (clk);

    input clk ;
    logic MOSI ;
    logic rst_n ; 
    logic SS_n ;
    logic [7:0] tx_data;
    logic tx_valid;

    // output for original design 
    logic [9:0] rx_data;
    logic rx_valid;
    logic MISO;

    // output for golden design 
    logic [9:0] rx_data_golden;
    logic rx_valid_golden;
    logic MISO_golden;
    

endinterface 