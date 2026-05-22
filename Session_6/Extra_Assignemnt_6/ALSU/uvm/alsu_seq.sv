package aslu_seq_pkg;

    import uvm_pkg::*;
    import alsu_seq_item_pkg::*;
    `include "uvm_macros.svh"

    class alsu_reset_seq extends uvm_sequence #(alsu_seq_item);
    `uvm_object_utils(alsu_reset_seq)
    
        alsu_seq_item seq_item;
        function new(string name = "alsu_reset_seq");
            super.new(name);
        endfunction //new()

        virtual task body();
            seq_item = alsu_seq_item::type_id::create("seq_item");
            start_item(seq_item);
            seq_item.rst = 1;
            seq_item.opcode = OR;
            seq_item.A = 0;
            seq_item.B = 0;
            seq_item.bypass_A = 0;
            seq_item.bypass_B = 0;
            seq_item.red_op_A = 0;
            seq_item.red_op_B = 0;
            seq_item.direction = 0;
            seq_item.serial_in = 0;
            seq_item.cin = 0;
            finish_item(seq_item);
        endtask
    endclass //alsu_reset_seq extends uvm_sequence 

    class alsu_main_seq extends uvm_sequence #(alsu_seq_item);
        `uvm_object_utils(alsu_main_seq)

        alsu_seq_item seq_item;

        function new(string name = "alsu_main_seq");
            super.new(name);
        endfunction //new()

        virtual task body();
            repeat(1000)begin
                seq_item = alsu_seq_item::type_id::create("seq_item");
                start_item(seq_item);
                assert(seq_item.randomize());
                finish_item(seq_item);
            end
        endtask
    endclass //alsu_main_seq extends uvm_sequence

    class alsu_directed_seq extends uvm_sequence #(alsu_seq_item);
        `uvm_object_utils(alsu_directed_seq)
        
        alsu_seq_item seq_item;

        function new(string name = "alsu_directed_seq");
            super.new(name);
        endfunction //new()

        virtual task body();
            OPCODE_e opcode = OR;

            //Bins Transition in ALU_CP
            for(int i = 0; i <= 6; i++)begin
                seq_item = alsu_seq_item::type_id::create("seq_item");
                start_item(seq_item);
                assert(seq_item.randomize());
                seq_item.rst            = 0;
                seq_item.rst            = 0;
                seq_item.red_op_A       = 0;
                seq_item.red_op_B       = 0;
                seq_item.opcode         = opcode;
                finish_item(seq_item);
                opcode        = opcode.next;
            end

            //Cross coverage REP_OP_B_OR
            seq_item = alsu_seq_item::type_id::create("seq_item");
            start_item(seq_item);
            seq_item.rst = 0;
            seq_item.opcode = XOR;
            seq_item.A = 0;
            seq_item.B = 3'b001;
            seq_item.bypass_A = 0;
            seq_item.bypass_B = 0;
            seq_item.red_op_A = 0;
            seq_item.red_op_B = 1;
            seq_item.direction = 0;
            seq_item.serial_in = 0;
            seq_item.cin = 0;
            finish_item(seq_item);

            seq_item = alsu_seq_item::type_id::create("seq_item");
            start_item(seq_item);
            seq_item.rst = 0;
            seq_item.opcode = OR;
            seq_item.A = 0;
            seq_item.B = 3'b010;
            seq_item.bypass_A = 0;
            seq_item.bypass_B = 0;
            seq_item.red_op_A = 0;
            seq_item.red_op_B = 1;
            seq_item.direction = 0;
            seq_item.serial_in = 0;
            seq_item.cin = 0;
            finish_item(seq_item);

            //Assertion coverage
            seq_item = alsu_seq_item::type_id::create("seq_item");
            start_item(seq_item);
            seq_item.rst = 0;
            seq_item.opcode = OR;
            seq_item.A = 3'b011;
            seq_item.B = 3'b010;
            seq_item.bypass_A = 0;
            seq_item.bypass_B = 0;
            seq_item.red_op_A = 1;
            seq_item.red_op_B = 0;
            seq_item.direction = 0;
            seq_item.serial_in = 0;
            seq_item.cin = 0;
            finish_item(seq_item);

             seq_item = alsu_seq_item::type_id::create("seq_item");
            start_item(seq_item);
            seq_item.rst = 0;
            seq_item.opcode = OR;
            seq_item.A = 3'b001;
            seq_item.B = 3'b010;
            seq_item.bypass_A = 0;
            seq_item.bypass_B = 0;
            seq_item.red_op_A = 0;
            seq_item.red_op_B = 1;
            seq_item.direction = 0;
            seq_item.serial_in = 0;
            seq_item.cin = 0;
            finish_item(seq_item);


        endtask
    endclass //alsu_directed_seq extends uvm_sequence
    
endpackage