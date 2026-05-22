import counter_pkg::*;

interface counter_if(input clk);

    // the internal signals of the interface
    logic rst_n;                        //(active low sync rst)
    logic load_n;                       //(active low load)
    logic up_down;                      //high then increment counter, else decrement
    logic ce;                           //(clock enable signal
    logic [WIDTH-1:0] data_load;        //(load data to count_out output when the load_n signal is asserted)    
    logic [WIDTH-1:0] count_out;  
    logic max_count;                   //counter reaches the maximum value, this signal is high, else low)
    logic zero;                        //counter reaches the minimum value, this signal is high, else low)

    //Modports
    modport DUT (input clk, rst_n, load_n, up_down, ce, data_load,
                    output count_out, max_count, zero);

    modport TEST (input clk, count_out, max_count, zero,
                    output rst_n, load_n, up_down, ce, data_load);

    modport MONITOR (input clk, count_out, max_count, zero,
                        rst_n, load_n, up_down, ce, data_load);
    
    

    
endinterface