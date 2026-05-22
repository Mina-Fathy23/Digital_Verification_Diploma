package shift_reg_driver_pkg;

    import uvm_pkg::*;
    import shift_reg_seq_item_pkg::*;
    `include "uvm_macros.svh"

    class shift_reg_driver extends uvm_driver #(shift_reg_seq_item);
        `uvm_component_utils(shift_reg_driver)

        virtual shift_reg_if shift_reg_vif;
        shift_reg_seq_item seq_item;

        function new(string name = "shift_reg_driver", uvm_component parent = null);
            super.new(name, parent);
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
                seq_item_port.get_next_item(seq_item);
                shift_reg_vif.reset     = seq_item.reset;
                shift_reg_vif.serial_in = seq_item.serial_in;
                shift_reg_vif.datain   = seq_item.datain;
                shift_reg_vif.direction = seq_item.direction;
                shift_reg_vif.mode      = seq_item.mode;
                @(negedge shift_reg_vif.clk);
                seq_item_port.item_done();

            end
        endtask
    endclass
    
endpackage