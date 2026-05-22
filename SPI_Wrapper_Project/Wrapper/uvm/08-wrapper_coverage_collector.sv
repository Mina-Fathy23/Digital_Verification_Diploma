package wrapper_CovCollector_pkg;
    
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import wrapper_seq_item_pkg::*;

    class wrapper_covcollector extends uvm_component;
        `uvm_component_utils(wrapper_covcollector)

        uvm_analysis_export #(wrapper_seq_item) cov_export;
        uvm_tlm_analysis_fifo #(wrapper_seq_item) cov_fifo; 
        wrapper_seq_item seq_item;

        
        covergroup CovCode;

            cp_SS_n: coverpoint seq_item.SS_n{
                bins normal_txn = (1=> 0[*13] => 1);
                bins extended_txn = (1=> 0[*23] => 1);
            }
            
            cp_MOSI: coverpoint seq_item.MOSI iff (seq_item.rst_n && !seq_item.SS_n){
                bins write_addr = (0=>0=>0);
                bins write_data = (0=>0=>1);
                bins read_addr  = (1=>1=>0);
                bins read_data  = (1=>1=>1);
            }

        endgroup

        function new(string name = "wrapper_covcollector", uvm_component parent = null);
            super.new(name, parent);
            CovCode = new;
        endfunction //new()

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            cov_export = new("cov_export", this);
            cov_fifo = new("cov_fifo", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            cov_export.connect(cov_fifo.analysis_export);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                cov_fifo.get(seq_item);
                CovCode.sample();
            end
        endtask

    endclass //wrapper_CovCollector extends uvm_component

endpackage