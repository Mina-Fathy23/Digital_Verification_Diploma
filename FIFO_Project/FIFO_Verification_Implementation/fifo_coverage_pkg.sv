package FIFO_coverage_pkg;

    import shared_pkg::*;
    import FIFO_transaction_pkg::*;

    class FIFO_coverage;

        FIFO_transaction F_cvg_txn;

        covergroup CovCode;
            cp_wr_en  : coverpoint F_cvg_txn.wr_en;
            cp_rd_en  : coverpoint F_cvg_txn.rd_en;

            // output control signals
            cp_full        : coverpoint F_cvg_txn.full;
            cp_almostfull  : coverpoint F_cvg_txn.almostfull;
            cp_empty       : coverpoint F_cvg_txn.empty;
            cp_almostempty : coverpoint F_cvg_txn.almostempty;
            cp_overflow    : coverpoint F_cvg_txn.overflow;
            cp_underflow   : coverpoint F_cvg_txn.underflow;
            cp_wr_ack      : coverpoint F_cvg_txn.wr_ack;

            // 7 required crosses (wr_en × rd_en × each output control)
            // 1. Full flag cross
            cross_wr_rd_full : cross cp_wr_en, cp_rd_en, cp_full {
                ignore_bins write_when_full_and_rd = 
                binsof(cp_wr_en) intersect {1} && 
                binsof(cp_rd_en) intersect {1} && 
                binsof(cp_full)  intersect {1}; // overflow case handled separately

                ignore_bins read_when_full_and_wr_low = 
                binsof(cp_wr_en) intersect {0} && 
                binsof(cp_rd_en) intersect {1} && 
                binsof(cp_full)  intersect {1};
            }

            // 2. Almost full flag cross
            cross_wr_rd_almostfull : cross cp_wr_en, cp_rd_en, cp_almostfull;

            // 3. Empty flag cross
            cross_wr_rd_empty : cross cp_wr_en, cp_rd_en, cp_empty {
                ignore_bins read_when_empty_and_wr = 
                binsof(cp_wr_en) intersect {1} && 
                binsof(cp_rd_en) intersect {1} && 
                binsof(cp_empty) intersect {1}; // underflow case handled separately

                ignore_bins write_when_empty_and_rd_low = 
                binsof(cp_wr_en) intersect {1} && 
                binsof(cp_rd_en) intersect {0} && 
                binsof(cp_empty) intersect {1};
            }

            // 4. Almost empty flag cross
            cross_wr_rd_almostempty : cross cp_wr_en, cp_rd_en, cp_almostempty;

            // 5. Overflow signal cross
            cross_wr_rd_overflow : cross cp_wr_en, cp_rd_en, cp_overflow {
                ignore_bins impossible_no_write = 
                binsof(cp_wr_en) intersect {0} && 
                binsof(cp_overflow) intersect {1};
                ignore_bins read_only_overflow = 
                binsof(cp_rd_en) intersect {1} && 
                binsof(cp_overflow) intersect {1};
            }

            // 6. Underflow signal cross
            cross_wr_rd_underflow : cross cp_wr_en, cp_rd_en, cp_underflow {
                ignore_bins impossible_no_read = 
                binsof(cp_rd_en) intersect {0} && 
                binsof(cp_underflow) intersect {1};
                ignore_bins write_only_underflow = 
                binsof(cp_wr_en) intersect {1} && 
                binsof(cp_underflow) intersect {1};
            }

            // 7. Write Acknowledge cross
            cross_wr_rd_wr_ack : cross cp_wr_en, cp_rd_en, cp_wr_ack {
                ignore_bins wr_ack_without_write = 
                binsof(cp_wr_en) intersect {0} && 
                binsof(cp_wr_ack) intersect {1};
            }


        endgroup

        function new();
            F_cvg_txn = new;
            CovCode = new;
        endfunction

        function void sample_data(FIFO_transaction F_txn);
            this.F_cvg_txn.data_in      = F_txn.data_in;
            this.F_cvg_txn.rst_n        = F_txn.rst_n;
            this.F_cvg_txn.wr_en        = F_txn.wr_en;
            this.F_cvg_txn.rd_en        = F_txn.rd_en;
            this.F_cvg_txn.data_out     = F_txn.data_out;
            this.F_cvg_txn.wr_ack       = F_txn.wr_ack;
            this.F_cvg_txn.overflow     = F_txn.overflow;
            this.F_cvg_txn.underflow    = F_txn.underflow;
            this.F_cvg_txn.full         = F_txn.full;
            this.F_cvg_txn.empty        = F_txn.empty;
            this.F_cvg_txn.almostfull   = F_txn.almostfull;
            this.F_cvg_txn.almostempty  = F_txn.almostempty;
            CovCode.sample();
        endfunction
    endclass
    
endpackage