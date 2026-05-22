package shift_reg_coverage_pkg;
    import uvm_pkg::*;
    import shift_reg_seq_item_pkg::*;
    `include "uvm_macros.svh"

    class shift_reg_coverage extends uvm_component;
        `uvm_component_utils(shift_reg_coverage)
        uvm_analysis_export #(shift_reg_seq_item) cov_export;
        uvm_tlm_analysis_fifo #(shift_reg_seq_item) cov_fifo;
        shift_reg_seq_item seq_item_cov;

        covergroup CovCode;

            serial_in_CP: coverpoint seq_item_cov.serial_in;
    
            direction_CP: coverpoint seq_item_cov.direction;

            mode_cp: coverpoint seq_item_cov.mode;
        endgroup

        function new(string name = "shift_reg_coverage", uvm_component parent = null);
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
                cov_fifo.get(seq_item_cov);
                CovCode.sample();
            end
        endtask

    endclass //shift_reg_coverage extends uvm_coverage

    endpackage