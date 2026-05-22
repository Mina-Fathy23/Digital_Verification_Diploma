package alsu_seq_item_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    typedef enum logic [2:0]  {OR, XOR, ADD, MULT, SHIFT, ROTATE, INVALID_6, INVALID_7} OPCODE_e;

    parameter INPUT_PRIORITY = "A";
    parameter FULL_ADDER = "ON";
    parameter MAXPOS = 3'b011;
    parameter MAXNEG = 3'b100;
    parameter ZERO = 3'b000;


    class alsu_seq_item extends uvm_sequence_item;
        `uvm_object_utils(alsu_seq_item)
        
        rand logic cin, rst, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
        rand OPCODE_e opcode;
        rand logic signed [2:0] A, B;
        rand logic [15:0] leds;
        logic signed [5:0] out;

        constraint c_rst{
            rst dist{0:/95, 1:/5};
        }

        constraint c_inputs{
            if(opcode != SHIFT || opcode != ROTATE){
                //ALSU_2
                A dist{MAXNEG:/30, ZERO:/30, MAXPOS:/30, [-3:-1]:/10, [1:2]:/10};
                B dist{MAXNEG:/30, ZERO:/30, MAXPOS:/30, [-3:-1]:/10, [1:2]:/10};

                if(((opcode == OR) || (opcode == XOR) && red_op_A)){
                    |A == 1;
                    B == 3'b000;
                }

                if(((opcode == OR) || (opcode == XOR) && red_op_B)){
                    |B == 1;
                    A == 3'b000;
                }
            }
        }

        constraint c_opcode{
            opcode dist{[OR:ROTATE]:/90, [INVALID_6: INVALID_7]:/10};
        }

        constraint c_bypass{
            bypass_A dist{0:/90, 1:/10};
            bypass_B dist{0:/90, 1:/10};
        }

        function new(string name = "alsu_seq_item");
            super.new(name);
        endfunction //new()

        function string convert2string();
            return $sformatf("%s | rst = 0b%b, cin = 0b%b, red_op_A = 0b%b, red_op_B = 0b%b, bypass_A = 0b%b, bypass_B = 0b%b, direction = 0b%b, serial_in = 0b%b, opcode = %s, A = %0d, B = %0d, leds = 0b%b, out = %0d",
                                super.convert2string(), rst, cin, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in, opcode, A, B, leds, out);
        endfunction

        function string convert2string_stimulus();
            return $sformatf(" rst = 0b%b, cin = 0b%b, red_op_A = 0b%b, red_op_B = 0b%b, bypass_A = 0b%b, bypass_B = 0b%b, direction = 0b%b, serial_in = 0b%b, opcode = %s, A = %0d, B = %0d",
                                rst, cin, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in, opcode, A, B);
        endfunction

    endclass //alsu_seq_item extends uvm_sequence_item
endpackage