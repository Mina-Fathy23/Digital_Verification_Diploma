package wrapper_seq_pkg;

    import uvm_pkg::*;
    import wrapper_seq_item_pkg::*;
    `include "uvm_macros.svh"

    //reset_sequence
    class wrapper_reset_seq extends uvm_sequence #(wrapper_seq_item);
    `uvm_object_utils(wrapper_reset_seq)
    
        wrapper_seq_item seq_item;
        function new(string name = "wrapper_reset_seq");
            super.new(name);
        endfunction //new()

        virtual task body();
            seq_item = wrapper_seq_item::type_id::create("seq_item");
            start_item(seq_item);
            seq_item.rst_n = 0;
            seq_item.MOSI = 0;
            seq_item.SS_n = 1;
            finish_item(seq_item);
        endtask
    endclass //wrapper_reset_seq extends uvm_sequence 

    //Write only Sequence
    class wrapper_write_only_sequence extends uvm_sequence #(wrapper_seq_item);
        `uvm_object_utils(wrapper_write_only_sequence)

        wrapper_seq_item seq_item;

        function new(string name = "wrapper_write_only_sequence");
            super.new(name);
        endfunction //new()

        virtual task body();
            seq_item = wrapper_seq_item::type_id::create("seq_item");
            repeat(1000)begin
                start_item(seq_item);
                seq_item.write_only_c.constraint_mode(1);
                seq_item.read_only_c.constraint_mode(0);
                seq_item.read_write_c.constraint_mode(0);
                assert(seq_item.randomize());
                finish_item(seq_item);
            end
        endtask
    endclass //wrapper_write_only_sequence extends uvm_sequence

    //Read only sequnece
    class wrapper_read_only_sequence extends uvm_sequence #(wrapper_seq_item);
        `uvm_object_utils(wrapper_read_only_sequence)

        wrapper_seq_item seq_item;

        function new(string name = "wrapper_read_only_sequence");
            super.new(name);
        endfunction //new()

        virtual task body();
            seq_item = wrapper_seq_item::type_id::create("seq_item");
            repeat(1000)begin
                start_item(seq_item);
                seq_item.write_only_c.constraint_mode(0);
                seq_item.read_only_c.constraint_mode(1);
                seq_item.read_write_c.constraint_mode(0);
                assert(seq_item.randomize());
                finish_item(seq_item);
            end
        endtask

    endclass //wrapper_read_only_sequence extends uvm_sequence

    //Read and Wrtie Sequence
    class wrapper_write_read_sequence extends uvm_sequence #(wrapper_seq_item);
        `uvm_object_utils(wrapper_write_read_sequence)

        wrapper_seq_item seq_item;

        function new(string name = "wrapper_write_read_sequence");
            super.new(name);
        endfunction //new()

        virtual task body();
            seq_item = wrapper_seq_item::type_id::create("seq_item");
            repeat(1000)begin
                start_item(seq_item);
                seq_item.write_only_c.constraint_mode(0);
                seq_item.read_only_c.constraint_mode(0);
                seq_item.read_write_c.constraint_mode(1);
                assert(seq_item.randomize());
                finish_item(seq_item);
            end
        endtask
    endclass //wrapper_write_read_sequence extends uvm_sequence
    
endpackage