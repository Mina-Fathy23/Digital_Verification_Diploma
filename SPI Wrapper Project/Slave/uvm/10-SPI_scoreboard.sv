package SPI_scoreboard_pkg;
import uvm_pkg::*;
import SPI_seq_item_pkg::*;
`include "uvm_macros.svh"
    class SPI_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(SPI_scoreboard)

        uvm_analysis_export #(SPI_seq_item) sb_export;
        uvm_tlm_analysis_fifo #(SPI_seq_item) sb_fifo;

        SPI_seq_item seq_item_sb;

        int error_count   = 0 ;
        int correct_count = 0 ;

        function new(string name = "SPI_scoreboard", uvm_component parent = null);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            sb_export = new("sb_export", this);
            sb_fifo = new("sb_fifo", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            sb_export.connect(sb_fifo.analysis_export);
        endfunction 

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                sb_fifo.get(seq_item_sb);
                if( (seq_item_sb.rx_data_golden !== seq_item_sb.rx_data) || 
                (seq_item_sb.rx_valid !== seq_item_sb.rx_valid_golden) || 
                (seq_item_sb.MISO !== seq_item_sb.MISO_golden) ) begin 
                    error_count++;
                    `uvm_error("run_phase", $sformatf("error"));
                end
                else begin
                    correct_count++;
                end
            end
        endtask

        function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("report_phase",$sformatf("Total Successful Transactions: %0d",correct_count),UVM_MEDIUM);
            `uvm_info("report_phase",$sformatf("Total Failed Transactions: %0d",error_count),UVM_MEDIUM);
        endfunction

    endclass 
endpackage