interface wrapper_if(clk);
    input clk;
    //Inputs
    logic  MOSI, SS_n, clk, rst_n;
    //outputs   
    logic MISO;
    //Golden Outputs
    logic MISO_golden;
endinterface : wrapper_if