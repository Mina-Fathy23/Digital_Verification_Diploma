import shared_pkg::*;

module top();
    
    bit clk;
    //CLock generation
    initial begin
        clk = 0;
        forever
            #1 clk = ~clk;
    end
    //Instantiate Interface Module
    fifo_if f_if(clk);

    //Instantiate Design, Testbench, and monitor
    FIFO DUT (f_if);
    fifo_tb tb (f_if);
    fifo_monitor monitor(f_if);

    //asynchronous reset Assertion
    property p_reset;
        @(posedge f_if.clk) (~f_if.rst_n)
        |-> (f_if.overflow == 0 && f_if.underflow == 0);
    endproperty

    async_reset_assertion: assert property(p_reset);
    async_reset_coverage : cover property(p_reset);


endmodule