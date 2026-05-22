package wrapper_test_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import wrapper_env_pkg::*;
    import wrapper_config_pkg::*;
    import wrapper_seq_pkg::*;

    //Import Ram Env & Config pkg
    import pkg_env::*;
    import pkg_config::*;

    //Import Slave Env & Config pkg
    import SPI_env_pkg::*;
    import SPI_config_pkg::*;

    class wrapper_test extends uvm_test;
        `uvm_component_utils(wrapper_test)

        //Wrapper 
        wrapper_env my_wrapper_env;
        wrapper_config wrapper_config_obj_test;

        //Slave
        SPI_env my_slave_env;
        SPI_config SPI_config_obj_test;

        //RAM
        ram_env my_ram_env; 
        ram_config_obj ram_config_obj_test;

        //Sequences
        wrapper_reset_seq reset_seq;
        wrapper_write_only_sequence write_only_seq;
        wrapper_read_only_sequence read_only_seq;
        wrapper_write_read_sequence write_read_seq;

        function new(string name = "wrapper_test", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            
            my_wrapper_env = wrapper_env::type_id::create("my_wrapper_env", this);
            my_ram_env = ram_env::type_id::create("my_ram_env", this);
            my_slave_env = SPI_env::type_id::create("my_slave_env", this);
            
            reset_seq = wrapper_reset_seq::type_id::create("reset_seq");
            write_only_seq = wrapper_write_only_sequence::type_id::create("write_only_seq");
            read_only_seq = wrapper_read_only_sequence::type_id::create("read_only_seq");
            write_read_seq = wrapper_write_read_sequence::type_id::create("write_read_seq");
            
            wrapper_config_obj_test = wrapper_config::type_id::create("wrapper_config_obj_test");
            ram_config_obj_test = ram_config_obj::type_id::create("ram_config_obj_test");
            SPI_config_obj_test = SPI_config::type_id::create("SPI_config_obj_test");
            if(!uvm_config_db #(virtual wrapper_if)::get(this, "", "wrapper_vif",wrapper_config_obj_test.wrapper_config_vif))
                `uvm_fatal("build_phase", "Test - Unable to get WRAPPER Virtual Interface");
            
            //Get Config object for ram
            if(!uvm_config_db #(virtual ram_interface)::get(this, "", "ram_vif",ram_config_obj_test.ram_vif))
                `uvm_fatal("build_phase", "Test - Unable to get RAM Virtual Interface");

            //Get Config object for slave
            if(!uvm_config_db #(virtual SPI_if)::get(this, "", "slave_vif",SPI_config_obj_test.SPI_vif))
                `uvm_fatal("build_phase", "Test - Unable to get SLAVE Virtual Interface");
            
            wrapper_config_obj_test.is_active = UVM_ACTIVE;
            ram_config_obj_test.is_active = UVM_PASSIVE;
            SPI_config_obj_test.is_active = UVM_PASSIVE;

            uvm_config_db#(wrapper_config)::set(null, "*", "WRAPPER_CFG", wrapper_config_obj_test);
            //set configuration object in config data base for ram
            uvm_config_db#(ram_config_obj)::set(null, "*", "RAM_CFG", ram_config_obj_test);
            //set configuration object in config data base for slave
            uvm_config_db#(SPI_config)::set(null, "*", "SLAVE_CFG", SPI_config_obj_test);


        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);
            
            `uvm_info("run_phase", "Reset Asserted", UVM_MEDIUM);
            reset_seq.start(my_wrapper_env.agt.sqr);
            `uvm_info("run_phase", "Reset Deasserted", UVM_MEDIUM);

            `uvm_info("run_phase", "Write only Sequencer Begin", UVM_MEDIUM);
            write_only_seq.start(my_wrapper_env.agt.sqr);
            `uvm_info("run_phase", "Write only Sequencer end", UVM_MEDIUM);

            `uvm_info("run_phase", "Read only Sequencer Begin", UVM_MEDIUM);
            read_only_seq.start(my_wrapper_env.agt.sqr);
            `uvm_info("run_phase", "Read only Sequencer end", UVM_MEDIUM);

            `uvm_info("run_phase", "Write & Read Sequencer Begin", UVM_MEDIUM);
            write_read_seq.start(my_wrapper_env.agt.sqr);
            `uvm_info("run_phase", "Write & Read Sequencer end", UVM_MEDIUM);

            phase.drop_objection(this);
        endtask
    endclass

endpackage