import shared_pkg::*;
import FIFO_transaction_pkg::*;
import FIFO_coverage_pkg::*;
import FIFO_scoreboard_pkg::*;

module fifo_monitor(fifo_if.monitor f_if);

    FIFO_transaction transaction_obj;
    FIFO_scoreboard scoreboard_obj;
    FIFO_coverage coverage_obj;
    initial begin

        transaction_obj = new;
        scoreboard_obj = new;
        coverage_obj = new;
        @(negedge f_if.clk);
       
        forever begin    
            @(negedge f_if.clk);
            wait(f_if.driving_finished.triggered);
            //sample data form interface and put inside transactions_obj
            transaction_obj.data_in    = f_if.data_in;
            transaction_obj.rst_n      = f_if.rst_n;
            transaction_obj.wr_en      = f_if.wr_en;
            transaction_obj.rd_en      = f_if.rd_en;
            transaction_obj.data_out   = f_if.data_out;
            transaction_obj.wr_ack     = f_if.wr_ack;
            transaction_obj.overflow   = f_if.overflow;
            transaction_obj.underflow  = f_if.underflow;
            transaction_obj.full       = f_if.full;
            transaction_obj.empty      = f_if.empty;
            transaction_obj.almostfull = f_if.almostfull;
            transaction_obj.almostempty= f_if.almostempty;
            ->f_if.driving_finished;
            fork
                //Proccess-1 (Sample Data) Sampling for coverage
                begin
                    coverage_obj.sample_data(transaction_obj);
                end

                //Process-2 (Check data with scoreboard)
                begin
                    scoreboard_obj.check_data(transaction_obj);
                end
            join


            if(test_finished)begin
                $display("--------------------\n Test Finished \n---------------------");
                $display("Total Tests:%0d | Correct Tests:%0d | Error Test:%0d", correct_count + error_count, correct_count, error_count);  
                $stop;
            end
        end
    end
    
endmodule