import wrapper_test_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
module top();

    bit clk;

    initial begin
        clk = 0;
        forever
            #1 clk = ~clk;
    end
    //wrapper interface Instance
    wrapper_if wrapperif (clk);
    //ram interface instance
    ram_interface ramif(clk);
    //slave interface instance
    SPI_if  slaveif(clk);

    WRAPPER DUT (.MOSI(wrapperif.MOSI), .MISO(wrapperif.MISO), .SS_n(wrapperif.SS_n),
                 .clk(clk), .rst_n(wrapperif.rst_n));

    wrapper_golden golden_model(.MOSI(wrapperif.MOSI), .MISO(wrapperif.MISO_golden), .SS_n(wrapperif.SS_n),
                 .clk(clk), .rst_n(wrapperif.rst_n));

    //bind the SVA module to the designs
    bind WRAPPER wrapper_SVA wrapper_SVA_inst(.MOSI(wrapperif.MOSI), .MISO(wrapperif.MISO), .SS_n(wrapperif.SS_n),
                                            .rx_valid(DUT.rx_valid), .rx_data(DUT.rx_data_din) , .tx_valid(DUT.tx_valid), 
                                            .clk(clk), .rst_n(wrapperif.rst_n));

    

    //Connect interface of the RAM and Salve to DUT internal signals
    //-----------------
    //Slave Interface connections
    //-----------------
    assign slaveif.MOSI = DUT.MOSI;
    assign slaveif.rst_n = DUT.rst_n;
    assign slaveif.SS_n = DUT.SS_n;
    assign slaveif.MISO = DUT.MISO;
    assign slaveif.MISO_golden = golden_model.MISO;
    assign slaveif.tx_data = DUT.tx_data_dout;
    assign slaveif.tx_valid = DUT.tx_valid;
    assign slaveif.rx_data = DUT.rx_data_din;
    assign slaveif.rx_valid = DUT.rx_valid;
    assign slaveif.rx_data_golden = golden_model.rx_data;
    assign slaveif.rx_valid_golden = golden_model.rx_valid;
    
    //------------------------
    // Ram Interface connections
    //------------------------
    assign ramif.rst_n = DUT.rst_n;
    assign ramif.dout = DUT.tx_data_dout;
    assign ramif.tx_valid = DUT.tx_valid;
    assign ramif.din = DUT.rx_data_din;
    assign ramif.rx_valid = DUT.rx_valid;

    initial begin
        uvm_config_db#(virtual wrapper_if)::set(null, "uvm_test_top", "wrapper_vif", wrapperif);
        //Set the interface in configuration data base for RAM and Slave
        uvm_config_db#(virtual ram_interface)::set(null, "uvm_test_top", "ram_vif", ramif);
        uvm_config_db#(virtual SPI_if)::set(null, "uvm_test_top", "slave_vif", slaveif);
        $readmemb("mem.dat", DUT.RAM_instance.MEM );//initializing memory
        run_test("wrapper_test");
    end

endmodule