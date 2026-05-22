import uvm_pkg::*;
`include "uvm_macros.svh"

import SPI_test_pkg::*;

module top();

  bit clk ;

  initial begin
    forever 
    #1 clk = ~clk ; 
  end

SPI_if SPIif(clk);

SLAVE DUT (SPIif.MOSI, SPIif.MISO, SPIif.SS_n, SPIif.clk, SPIif.rst_n, 
                SPIif.rx_data, SPIif.rx_valid, SPIif.tx_data, SPIif.tx_valid);


SLAVE_golden_model golden (SPIif.clk, SPIif.SS_n , SPIif.rst_n , SPIif.MOSI , SPIif.tx_data , SPIif.tx_valid,
                            SPIif.MISO_golden , SPIif.rx_data_golden , SPIif.rx_valid_golden );
                      
bind DUT SLAVE_sva slave_bind (SPIif.MOSI, SPIif.MISO, SPIif.SS_n, SPIif.clk, SPIif.rst_n, 
                SPIif.rx_data, SPIif.rx_valid, SPIif.tx_data, SPIif.tx_valid);


  initial begin 
    uvm_config_db #(virtual SPI_if )::set (null , "uvm_test_top" , "SPI_IF" , SPIif );
    run_test("SPI_test");
  end


endmodule