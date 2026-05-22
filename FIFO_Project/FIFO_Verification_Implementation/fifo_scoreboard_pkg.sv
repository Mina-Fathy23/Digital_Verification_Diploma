package FIFO_scoreboard_pkg;

    import shared_pkg::*;
    import FIFO_transaction_pkg::*;

    class FIFO_scoreboard #(parameter FIFO_WIDTH = 16, parameter FIFO_DEPTH = 8);

        bit [FIFO_WIDTH-1:0] data_out_ref;

        reg [FIFO_WIDTH-1:0] fifo_q [$]; // dynamic queue to mimic FIFO memory

        function new();
            fifo_q.delete();
        endfunction 


        function void check_data(FIFO_transaction transaction_chk);
           
            //call reference_model(transaction_chk)
            reference_model(transaction_chk);

            //compare DUT outputs with reference model outputs
            if( transaction_chk.data_out !== data_out_ref) begin
                $display("time: %0t Data Mismatch! Expected: %0h, Got: %0h", $time,data_out_ref, transaction_chk.data_out);
                error_count++;
            end
            else begin
                correct_count++;
            end

        endfunction

        function void reference_model(input FIFO_transaction transaction_chk);
            //assign correct value to ref_signals
            // -------------------------
            //Reset Sequence
            // -------------------------
            if(!transaction_chk.rst_n)begin
                fifo_q.delete();
                data_out_ref = 0;
            end
            // Handle Read Operation
            else if({transaction_chk.wr_en, transaction_chk.rd_en} == 2'b01 && fifo_q.size() > 0)begin
                data_out_ref = fifo_q.pop_front();
            end
            // Handle Write Operation
            else if({transaction_chk.wr_en, transaction_chk.rd_en} == 2'b10 && fifo_q.size() < FIFO_DEPTH)begin
                fifo_q.push_back(transaction_chk.data_in);
            end
            // Handle Write/Read Operation
            else if ({transaction_chk.wr_en, transaction_chk.rd_en} == 2'b11) begin
                if(fifo_q.size() == FIFO_DEPTH) begin
                    data_out_ref = fifo_q.pop_front();
                end
                else if(fifo_q.size() == 0) begin
                    fifo_q.push_back(transaction_chk.data_in);
                end
                else begin
                    data_out_ref = fifo_q.pop_front();
                    fifo_q.push_back(transaction_chk.data_in);
                end   
            end

        endfunction

    endclass
endpackage