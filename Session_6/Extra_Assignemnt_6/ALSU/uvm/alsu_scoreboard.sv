package alsu_scoreboard_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import alsu_seq_item_pkg::*;
    parameter INPUT_PRIORITY = "A";
    parameter FULL_ADDER = "ON";

    class alsu_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(alsu_scoreboard)
        
        uvm_analysis_export #(alsu_seq_item) sb_export;
        uvm_tlm_analysis_fifo #(alsu_seq_item) sb_fifo; 
        alsu_seq_item seq_item;
        // logic [15:0] leds_ref = 0;
        logic signed [5:0] out_ref = 0;

        int error_count = 0;
        int correct_count = 0;

        function new(string name = "alsu_scoreboard", uvm_component parent = null);
            super.new(name, parent);
        endfunction //new()

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
                sb_fifo.get(seq_item);
                ref_model(seq_item);
                if(seq_item.out != out_ref)begin
                    `uvm_error("run_phase", "Mismatch is scoreboard output");
                    error_count++;
                end
                else begin
                    correct_count++;
                end
            end
        endtask

        function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("report_phase", $sformatf("total successful transactions: %d", correct_count),UVM_MEDIUM);
            `uvm_info("report_phase", $sformatf("total Failed transactions: %d", error_count),UVM_MEDIUM);
        endfunction

        function void ref_model(alsu_seq_item seq_item_chk);

            //Invalid handling
            
            
            // invalid_red_op = (seq_item_chk.red_op_A | seq_item_chk.red_op_B) & (seq_item_chk.opcode[1] | seq_item_chk.opcode[2]); 
            // invalid_opcode = seq_item_chk.opcode[1] & seq_item_chk.opcode[2];
            // invalid = invalid_red_op | invalid_opcode;

            //ALSU output processing
             if(seq_item_chk.rst) begin
                out_ref = 0;
            end
            else begin
                if (seq_item_chk.bypass_A && seq_item_chk.bypass_B)
                    out_ref = (INPUT_PRIORITY == "A")? seq_item_chk.A: seq_item_chk.B;
                else if (seq_item_chk.bypass_A)
                    out_ref = seq_item_chk.A;
                else if (seq_item_chk.bypass_B)
                    out_ref = seq_item_chk.B;
                else if ((seq_item_chk.opcode[1] & seq_item_chk.opcode[2]) | ((seq_item_chk.red_op_A | seq_item_chk.red_op_B) & (seq_item_chk.opcode[1] | seq_item_chk.opcode[2]))) 
                    out_ref = 0;
                else begin
                    case (seq_item_chk.opcode)                           //Fixed Bug: changed incorrect checking opcode to opcode
                    3'h0: begin 
                        if (seq_item_chk.red_op_A && seq_item_chk.red_op_B)
                        out_ref = (INPUT_PRIORITY == "A")? |seq_item_chk.A: |seq_item_chk.B;
                        else if (seq_item_chk.red_op_A) 
                        out_ref = |seq_item_chk.A;
                        else if (seq_item_chk.red_op_B)
                        out_ref = |seq_item_chk.B;
                        else 
                        out_ref = seq_item_chk.A | seq_item_chk.B;
                    end
                    3'h1: begin
                        if (seq_item_chk.red_op_A && seq_item_chk.red_op_B)
                        out_ref = (INPUT_PRIORITY == "A")? ^seq_item_chk.A: ^seq_item_chk.B;
                        else if (seq_item_chk.red_op_A) 
                        out_ref = ^seq_item_chk.A;
                        else if (seq_item_chk.red_op_B)
                        out_ref = ^seq_item_chk.B;
                        else 
                        out_ref = seq_item_chk.A ^ seq_item_chk.B;
                    end
                    3'h2: out_ref = (FULL_ADDER == "ON")? seq_item_chk.A + seq_item_chk.B + seq_item_chk.cin : seq_item_chk.A + seq_item_chk.B ; //Fixed Bug: added FULL_ADDER checker
                    3'h3: out_ref = seq_item_chk.A * seq_item_chk.B;
                    3'h4: begin
                        if (seq_item_chk.direction)
                        out_ref = {out_ref[4:0], seq_item_chk.serial_in};
                        else
                        out_ref = {seq_item_chk.serial_in, out_ref[5:1]}; 
                    end
                    3'h5: begin
                        if (seq_item_chk.direction)
                        out_ref = {out_ref[4:0], out_ref[5]};
                        else
                        out_ref = {out_ref[0], out_ref[5:1]};
                    end
                    default: out_ref = 0;
                    endcase
                end 
            end

        endfunction
    endclass //alsu_scoreboard extends uvm_scoreboard

endpackage