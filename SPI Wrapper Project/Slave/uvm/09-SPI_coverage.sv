package SPI_coverage_pkg;
import uvm_pkg::*;
import SPI_seq_item_pkg::*;
`include "uvm_macros.svh"

    class SPI_coverage extends uvm_component;
        `uvm_component_utils(SPI_coverage)

        uvm_analysis_export #(SPI_seq_item) cov_export ;
        uvm_tlm_analysis_fifo #(SPI_seq_item) cov_fifo;
        SPI_seq_item seq_item_cov;

        /// covergroups 
        covergroup SPI_cg;
            cp_rx: coverpoint seq_item_cov.rx_data[9:8] {
                bins all_values[] = {[0:3]};
                bins WRITE_ADD    = (2'b00=>2'b00=>2'b00);
                bins WRITE_DATA   = (2'b00=>2'b00=>2'b01);
                bins READ_ADD     = (2'b00=>2'b10=>2'b10);
                bins READ_DATA    = (2'b00=>2'b10=>2'b11);
            }
            cp_SS_n: coverpoint seq_item_cov.SS_n {
                bins normal_txn = (1 => 0 [*13] => 1);
                bins extended_txn = (1 => 0 [*23] => 1);
                bins start_comm = (1=>0);
                bins comm = {0};
            }
            cp_MOSI: coverpoint seq_item_cov.MOSI{
			    bins write_addr = (0=>0=>0);
			    bins write_data = (0=>0=>1);
			    bins read_addr  = (1=>1=>0);
			    bins read_data  = (1=>1=>1);
		    }

            // cross 
            cross cp_SS_n, cp_MOSI {
                ignore_bins invalid0 = binsof(cp_SS_n.extended_txn)
                                    && binsof(cp_MOSI.read_data) ;

                ignore_bins invalid1 = binsof(cp_SS_n.normal_txn) 
                                    && binsof(cp_MOSI.read_data);

                ignore_bins invalid2 = binsof(cp_SS_n.extended_txn)
                                    && binsof(cp_MOSI.write_data);    

                ignore_bins invalid3 = binsof(cp_SS_n.start_comm)
                                    && binsof(cp_MOSI.read_data);  
         
            }
        
        endgroup 

        /////////////

        function new(string name = "SPI_coverage" , uvm_component parent = null);
            super.new(name, parent);
            // create the covergroups 
            SPI_cg= new();
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            cov_export = new("cov_export" , this);
            cov_fifo = new("cov_fifo" , this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            cov_export.connect(cov_fifo.analysis_export);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                cov_fifo.get(seq_item_cov);
                // covergroup sample 
                SPI_cg.sample();
            end
        endtask
    endclass
endpackage