module wrapper_SVA(MOSI, MISO, SS_n, rx_valid, rx_data, tx_valid , clk, rst_n);

    parameter INACTIVE = 0;

    input logic MOSI, SS_n, rx_valid, tx_valid, clk, rst_n;
    input logic [9:0] rx_data;
    input logic MISO;


    //1.Reset behavior
    property p_reset_MISO;
        @(posedge clk) (~rst_n) |=> (MISO == INACTIVE);
    endproperty

    property p_reset_rx_valid;
        @(posedge clk) (~rst_n) |=> (rx_valid == INACTIVE);
    endproperty

    property p_reset_rx_data;
        @(posedge clk) (~rst_n) |=> (rx_data == INACTIVE);
    endproperty

    //2.Stable MISO in case of non-read operation
    property p_MISO_stable;
        @(posedge clk) disable iff (~rst_n) !tx_valid |=> (MISO == $stable(MISO) [->1]);
    endproperty

    //------------------------------------
    // Assertions
    //------------------------------------
    p_reset_MISO_assertion               : assert property (p_reset_MISO);
    p_reset_rx_valid_assertion           : assert property (p_reset_rx_valid);
    p_reset_rx_data_assertion            : assert property (p_reset_rx_data);
    p_MISO_stable_assertion              : assert property (p_MISO_stable);
    
    
    
    //------------------------------------
    // Coverage
    //------------------------------------
    p_reset_MISO_coverage               : cover property (p_reset_MISO);
    p_reset_rx_valid_coverage           : cover property (p_reset_rx_valid);
    p_reset_rx_data_coverage            : cover property (p_reset_rx_data);
    p_MISO_stable_coverage              : cover property (p_MISO_stable);

    
endmodule