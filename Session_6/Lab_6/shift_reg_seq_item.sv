package shift_reg_seq_item_pkg;

    import uvm_pkg::*;
    import shift_reg_enums::*;
    `include "uvm_macros.svh"

    class shift_reg_seq_item extends uvm_sequence_item;
        `uvm_object_utils(shift_reg_seq_item);

        rand logic reset;
        rand logic serial_in;
        rand direction_e direction;
        rand mode_e mode;
        rand logic [5:0] datain;
        logic [5:0] dataout;

        function new(string name = "shift_reg_seq_item");
            super.new(name);
        endfunction

        function string convert2string();
            return $sformatf("%s | reset = 0b%b, serial_in = 0b%b, direction = %s, mode = %s, data_in = 0b%b, data_out = 0b%b",
                                super.convert2string(), reset, serial_in, direction, mode, datain, dataout);
        endfunction

        function string convert2string_stimulus();
            return $sformatf(" reset = 0b%b, serial_in = 0b%b, direction = %s, mode = %s, data_in = 0b%b",
                                reset, serial_in, direction, mode, datain);
        endfunction

        constraint c_reset{
            reset dist {0:/90, 1:/10};
        }

    endclass
endpackage