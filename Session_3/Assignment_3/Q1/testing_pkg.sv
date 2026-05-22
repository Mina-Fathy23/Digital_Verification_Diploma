package testing_pkg;

    typedef enum logic[1:0] {ADD, SUB, MULT, DIV} opcode_e;

    class Transaction;
        
        rand opcode_e opcode;
        rand byte operand1;
        rand byte operand2;
        bit clk;

        //To allow more chances for Crossing to happen
        constraint c_special_vals {
            operand1 dist { -128 := 10, 127 := 10, 0 := 10, [-127:126] := 1 };
        }

        constraint c_opcode {
            opcode dist {[ADD:SUB]:/80, [MULT: DIV]:/20 };
        }

        covergroup CovCode @(posedge clk);

            operand1_cp: coverpoint operand1{
                bins zero = {0};
                bins MAXNEG = {-128};
                bins MAXPOS = {127};
                bins misc = default;
            }

            opcode_cp: coverpoint opcode{
                bins add_sub = {ADD, SUB};
                bins add_to_sub = (ADD => SUB);
                illegal_bins no_DIV = {DIV};
                bins misc = default;
            }

            opcode_operand1: cross opcode_cp, operand1_cp {
                option.weight = 5;
                option.cross_auto_bin_max = 0;
                bins ADD_SUB_MAXPOS = binsof(opcode_cp.add_sub) && binsof(operand1_cp.MAXPOS);
                bins ADD_SUB_MAXNEG = binsof(opcode_cp.add_sub) && binsof(operand1_cp.MAXNEG);
            }

        endgroup

        function new();
            CovCode = new;
        endfunction

    endclass
endpackage