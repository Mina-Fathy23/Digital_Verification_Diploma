import shared_pkg::*;

interface fifo_if(input clk);

    parameter FIFO_WIDTH = 16;
    parameter FIFO_DEPTH = 8;
    event driving_finished, monitor_finished;

    logic [FIFO_WIDTH-1:0] data_in;
    logic  rst_n, wr_en, rd_en;
    logic [FIFO_WIDTH-1:0] data_out;
    logic wr_ack, overflow;
    logic full, empty, almostfull, almostempty, underflow;


    //Modports
    modport DUT (input clk, rst_n, wr_en, rd_en, data_in, 
                    output data_out, full, empty, almostfull, almostempty, wr_ack, overflow, underflow);

    modport test (input clk, data_out, full, empty, almostfull, almostempty, wr_ack, overflow, underflow, driving_finished, monitor_finished,
                    output rst_n, wr_en, rd_en, data_in);

    modport monitor (input clk, rst_n, wr_en, rd_en, data_in, driving_finished, monitor_finished,
                        data_out, full, empty, almostfull, almostempty, wr_ack, overflow, underflow);
    
endinterface