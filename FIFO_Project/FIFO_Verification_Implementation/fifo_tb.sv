import shared_pkg::*;
import FIFO_transaction_pkg::*;

module fifo_tb(fifo_if.test f_if);
    
    FIFO_transaction transaction_obj;

    initial begin

        transaction_obj = new();
        //Reset the Design
        f_if.rst_n    = 0;
        f_if.wr_en    = 0;
        f_if.rd_en    = 0;
        f_if.data_in  = '0;
        repeat (2) @(negedge f_if.clk);
        f_if.rst_n    = 1;

        //A special test for underflow
        f_if.rst_n = 0;
        repeat (2) @(negedge f_if.clk);
        f_if.rst_n = 1;
        @(posedge f_if.clk);

        repeat (4) begin
            f_if.rd_en   = 1;
            f_if.wr_en   = 0;
            f_if.data_in = '0;

            -> f_if.driving_finished;

            @(posedge f_if.clk);
        end

        f_if.rd_en = 0;
        f_if.wr_en = 0;

        // Main stimulus loop
        repeat (100000) begin
            assert(transaction_obj.randomize());

            // Drive inputs
            f_if.wr_en   = transaction_obj.wr_en;
            f_if.rd_en   = transaction_obj.rd_en;
            f_if.data_in = transaction_obj.data_in;

            // trigger after driving inputs
            -> f_if.driving_finished;

            // wait for clock edge before next drive
            @(negedge f_if.clk);
        end

        // Signal the monitor to stop
        test_finished = 1;
        -> f_if.driving_finished;

        // optional delay to allow monitor to print summary
        repeat(2) @(negedge f_if.clk);
        $display("TB: Simulation finished driving transactions.");

    end

endmodule
