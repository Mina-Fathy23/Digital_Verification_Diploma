package SPI_test_pkg;

import uvm_pkg::*;
import SPI_env_pkg::*;
import SPI_config_pkg::*;
import SPI_main_seq_pkg::*;
import SPI_reset_seq_pkg::*;
`include "uvm_macros.svh"

    class SPI_test extends uvm_test;
        `uvm_component_utils(SPI_test)

        SPI_env env;
        SPI_config SPI_cfg;
        virtual SPI_if SPI_vif;
        SPI_main_seq main_seq;
        SPI_reset_seq reset_Seq;

        function new(string name = "SPI_test" , uvm_component parent = null);
            super.new(name,parent);
        endfunction 

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            env = SPI_env::type_id::create("env",this);
            SPI_cfg = SPI_config::type_id::create("SPI_cfg");
            main_seq = SPI_main_seq::type_id::create("main_seq");
            reset_Seq = SPI_reset_seq::type_id::create("reset_Seq");

            if(!uvm_config_db #(virtual SPI_if)::get( this , "" , "SPI_IF" , SPI_cfg.SPI_vif ))
                `uvm_fatal("build_phase", "test-unable to get the virtual interface");

            SPI_cfg.is_active = UVM_ACTIVE;
            uvm_config_db #(SPI_config)::set(this , "*" , "SLAVE_CFG" , SPI_cfg);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);

            reset_Seq.start(env.agt.sqr);
            main_seq.start(env.agt.sqr);

            phase.drop_objection(this);
        endtask

    endclass
endpackage