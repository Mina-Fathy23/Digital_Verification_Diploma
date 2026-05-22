package alsu_test_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import alsu_env_pkg::*;
    import alsu_config_pkg::*;
    import aslu_seq_pkg::*;

    import shift_reg_env_pkg::*;
    import shift_reg_config_pkg::*;


    class alsu_test extends uvm_test;
        `uvm_component_utils(alsu_test)

        //ALSU 
        alsu_env my_alsu_env;
        alsu_config alsu_config_obj_test;

        //Shift reg
        shift_reg_env my_shift_reg_env;
        shift_reg_config shift_reg_config_obj_test;
        
        //
        alsu_reset_seq reset_seq;
        alsu_main_seq main_seq;
        alsu_directed_seq direct_seq;

        function new(string name = "alsu_test", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            my_alsu_env = alsu_env::type_id::create("my_alsu_env", this);
            my_shift_reg_env = shift_reg_env::type_id::create("my_shift_reg_env", this);
            reset_seq = alsu_reset_seq::type_id::create("reset_seq");
            main_seq = alsu_main_seq::type_id::create("main_seq");
            direct_seq = alsu_directed_seq::type_id::create("direct_seq");
            alsu_config_obj_test = alsu_config::type_id::create("alsu_config_obj_test");
            shift_reg_config_obj_test = shift_reg_config::type_id::create("shift_reg_config_obj_test");
            if(!uvm_config_db #(virtual alsu_if)::get(this, "", "alsu_vif",alsu_config_obj_test.alsu_config_vif))
                `uvm_fatal("build_phase", "Test - Unable to get Alsu Virtual Interface");
            
            if(!uvm_config_db #(virtual shift_reg_if)::get(this, "", "shift_vif",shift_reg_config_obj_test.shift_reg_vif))
                `uvm_fatal("build_phase", "Test - Unable to get Alsu Virtual Interface");
            
            alsu_config_obj_test.is_active = UVM_ACTIVE;
            shift_reg_config_obj_test.is_active = UVM_PASSIVE;

            uvm_config_db#(alsu_config)::set(null, "*", "ALSU_CFG", alsu_config_obj_test);
            uvm_config_db#(shift_reg_config)::set(null, "*", "SHIFT_REG_CFG", shift_reg_config_obj_test);

        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);
            
            `uvm_info("run_phase", "Reset Asserted", UVM_MEDIUM);
            reset_seq.start(my_alsu_env.agt.sqr);
            `uvm_info("run_phase", "Reset Deasserted", UVM_MEDIUM);

            `uvm_info("run_phase", "Main Sequencer Begin", UVM_MEDIUM);
            main_seq.start(my_alsu_env.agt.sqr);
            `uvm_info("run_phase", "Main Sequencer end", UVM_MEDIUM);

            `uvm_info("run_phase", "Directed Sequencer Begin", UVM_MEDIUM);
            direct_seq.start(my_alsu_env.agt.sqr);
            `uvm_info("run_phase", "Drirected Sequencer end", UVM_MEDIUM);

            phase.drop_objection(this);
        endtask
    endclass

endpackage