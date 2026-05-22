package wrapper_config_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class wrapper_config extends uvm_object;
        `uvm_object_utils(wrapper_config)
        // Configuration parameters
        virtual wrapper_if wrapper_config_vif;
        uvm_active_passive_enum is_active;

        function new(string name = "wrapper_config");
            super.new(name);
        endfunction
    endclass : wrapper_config
endpackage