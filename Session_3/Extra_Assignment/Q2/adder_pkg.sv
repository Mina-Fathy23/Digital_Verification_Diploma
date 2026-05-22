package adder_pkg;

    typedef enum {MAXNEG = -8, ZERO = 0, MAXPOS = 7} CORNERS_e;

    class Adder_inputs;

        rand logic  clk;
        rand logic  reset;
        rand logic  signed [3:0] A;	// Input data A in 2's complement
        rand logic  signed [3:0] B;	// Input data B in 2's complement

        constraint c_reset{
            reset dist {0:/90, 1:/10};
        }

        constraint c_adder_inputs{
            A dist {MAXNEG:/30, ZERO:/30, MAXPOS:/30, [-7:6]:/10};
            B dist {MAXNEG:/30, ZERO:/30, MAXPOS:/30, [-7:6]:/10};
        }

        covergroup Covgrp_A;

            Val_A: coverpoint A{
                bins data_0 = {ZERO};
                bins data_max = {MAXPOS};
                bins data_min = {MAXNEG};
                bins data_default = default;
            }

            TRANS_A: coverpoint A {
                bins data_0max = (0 => MAXPOS);
                bins data_maxmin = (MAXPOS => MAXNEG);
                bins data_minmax = (MAXNEG => MAXPOS);
            }

        endgroup

        covergroup Covgrp_B;

            Val_B: coverpoint B{
                bins data_0 = {ZERO};
                bins data_max = {MAXPOS};
                bins data_min = {MAXNEG};
                bins data_default = default;
            }

            TRANS_B: coverpoint B {
                bins data_0max = (0 => MAXPOS);
                bins data_maxmin = (MAXPOS => MAXNEG);
                bins data_minmax = (MAXNEG => MAXPOS);
            }

        endgroup

        function new();
            Covgrp_A = new;
            Covgrp_B = new;
        endfunction

        task sample();
            if(~reset)begin
                Covgrp_A.sample();
                Covgrp_B.sample();
            end
        endtask

    endclass
    
endpackage