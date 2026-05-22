package wrapper_sequencer_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import wrapper_seq_item_pkg::*;

    class wrapper_sequencer extends uvm_sequencer #(wrapper_seq_item);
        `uvm_component_utils(wrapper_sequencer)
        function new(string name = "alsu_sequencer", uvm_component parent = null);
            super.new(name, parent);
        endfunction //new()
    endclass //wrapper_sequencer extends uvm_sequencer
endpackage