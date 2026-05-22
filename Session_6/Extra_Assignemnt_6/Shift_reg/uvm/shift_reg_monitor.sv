package shift_reg_monitor_pkg;

    import uvm_pkg::*;
    import shift_reg_seq_item_pkg::*;
    import shift_reg_enums::*;

    `include "uvm_macros.svh"

    class shift_reg_monitor extends uvm_monitor;
        `uvm_component_utils(shift_reg_monitor)

        virtual shift_reg_if shift_reg_vif;
        shift_reg_seq_item seq_item;
        uvm_analysis_port #(shift_reg_seq_item) mon_ap;

        function new(string name = "shift_reg_monitor", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            mon_ap = new("mon_ap", this);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
    /*      shift_reg_vif.direction = 0;
            shift_reg_vif.mode = 0;
            shift_reg_vif.datain = 0;
            shift_reg_vif.serial_in = 0;
            shift_reg_vif.reset = 1;
            @(negedge shift_reg_vif.clk);
            shift_reg_vif.reset = 0;
            repeat(3) begin
            @(negedge shift_reg_vif.clk);
                shift_reg_vif.direction = $random;
                shift_reg_vif.mode = $random;
                shift_reg_vif.datain = $random;
                shift_reg_vif.serial_in = $random;
                // shift_reg_vif.reset = $random;
            end
    */
             forever begin
                seq_item = shift_reg_seq_item::type_id::create("seq_item");
                // @(negedge shift_reg_vif.clk);
                #2;
                seq_item.serial_in = shift_reg_vif.serial_in;
                seq_item.datain = shift_reg_vif.datain;
                seq_item.direction = direction_e'(shift_reg_vif.direction);
                seq_item.mode = mode_e'(shift_reg_vif.mode);
                seq_item.dataout = shift_reg_vif.dataout;
                mon_ap.write(seq_item);
            end
        endtask
    endclass
    
endpackage