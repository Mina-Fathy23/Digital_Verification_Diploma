package FIFO_transaction_pkg;

    import shared_pkg::*;

    class FIFO_transaction #(parameter FIFO_WIDTH = 16, parameter FIFO_DEPTH = 8);

        //Inputs 
        rand logic [FIFO_WIDTH-1:0] data_in;
        rand logic rst_n, wr_en, rd_en;
        //Outputs
        logic [FIFO_WIDTH-1:0] data_out;
        logic wr_ack, overflow;
        logic full, empty, almostfull, almostempty, underflow;

        int RD_EN_ON_DIST, WR_EN_ON_DIST;

        function new(RD_EN_ON_DIST = 30, WR_EN_ON_DIST = 70);
            this.RD_EN_ON_DIST = 30;
            this.WR_EN_ON_DIST = 70;
        endfunction

        constraint c_rst_n{
            rst_n dist{1:/90, 0:/10};
        }

        constraint c_rd_en{
            rd_en dist{1:/RD_EN_ON_DIST, 0:/(100 - RD_EN_ON_DIST)};
        }

        constraint c_wr_en{
            wr_en dist {1:/WR_EN_ON_DIST, 0:/(100 - WR_EN_ON_DIST)};
        }
    endclass

endpackage