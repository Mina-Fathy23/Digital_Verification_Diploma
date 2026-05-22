package alsu_driver_pkg;

    import uvm_pkg::*;
    import alsu_config_pkg::*;
    `include "uvm_macros.svh"

    class alsu_driver extends uvm_driver;
        `uvm_component_utils(alsu_driver);

        virtual alsu_if alsu_driver_vif;
        alsu_config alsu_config_obj_test;


        function new(string name = "alsu_driver", uvm_component parent);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            if (!uvm_config_db #(alsu_config)::get(this, "", "CFG", alsu_config_obj_test)) 
                `uvm_fatal("build_phase", "Driver - alsu_config_obj_test was not found in the uvm_config_db")
            endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            alsu_driver_vif = alsu_config_obj_test.alsu_config_vif;
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            alsu_driver_vif.rst = 1;
            alsu_driver_vif.cin = 0;
            alsu_driver_vif.red_op_A = 0;
            alsu_driver_vif.red_op_B = 0;
            alsu_driver_vif.bypass_A = 0;
            alsu_driver_vif.bypass_B = 0;
            alsu_driver_vif.direction = 0;
            alsu_driver_vif.serial_in = 0;
            alsu_driver_vif.opcode = 3'b000;
            alsu_driver_vif.A = 3'b000;
            alsu_driver_vif.B = 3'b000;
            @(negedge alsu_driver_vif.clk);
            forever begin
                alsu_driver_vif.rst = 0;
                alsu_driver_vif.cin = $random;
                alsu_driver_vif.red_op_A = $random;
                alsu_driver_vif.red_op_B = $random;
                alsu_driver_vif.bypass_A = $random;
                alsu_driver_vif.bypass_B = $random;
                alsu_driver_vif.direction = $random;
                alsu_driver_vif.serial_in = $random;
                alsu_driver_vif.opcode = $random;
                alsu_driver_vif.A = $random;
                alsu_driver_vif.B = $random;
                @(negedge alsu_driver_vif.clk);
            end
        endtask
    endclass 

endpackage