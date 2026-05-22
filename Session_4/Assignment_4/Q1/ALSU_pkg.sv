package ALSU_pkg;

    typedef enum logic [2:0]  {OR, XOR, ADD, MULT, SHIFT, ROTATE, INVALID_6, INVALID_7} OPCODE_e;

    parameter INPUT_PRIORITY = "A";
    parameter FULL_ADDER = "ON";
    parameter MAXPOS = 3'b011;
    parameter MAXNEG = 3'b100;
    parameter ZERO = 3'b000;


    class ALSU_inputs;

        rand logic cin; 
        rand logic rst; 
        rand logic red_op_A; 
        rand logic red_op_B; 
        rand logic bypass_A; 
        rand logic bypass_B; 
        rand logic direction; 
        rand logic serial_in;
        rand OPCODE_e opcode;
        rand logic signed [2:0] A, B;
        rand OPCODE_e array[6];
        bit clk;

        //ALSU_1
        constraint c_rst{
            rst dist{0:/95, 1:/5};
        }

        constraint c_inputs{
            if(opcode != SHIFT || opcode != ROTATE){
                //ALSU_2
                A dist{MAXNEG:/30, ZERO:/30, MAXPOS:/30, [-3:-1]:/10, [1:2]:/10};
                B dist{MAXNEG:/30, ZERO:/30, MAXPOS:/30, [-3:-1]:/10, [1:2]:/10};

                if((((opcode == OR) || (opcode == XOR)) && red_op_A)){
                    |A == 1;
                    B == 3'b000;
                }

                if((((opcode == OR) || (opcode == XOR)) && red_op_B)){
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

        constraint c_array{
            unique {array};
        }

        //Added constraint
        constraint c_red_ops {
            red_op_A dist {0:/70, 1:/30};
            red_op_B dist {0:/70, 1:/30};
        }

        covergroup CovCode @(posedge clk);

        A_CP: coverpoint A {
            bins A_data_0 = {0};
            bins A_data_max = {MAXPOS};
            bins A_data_min = {MAXNEG};
            bins A_data_default = default;
            bins A_data_walkingones[] = {3'b001, 3'b010, 3'b100} iff(red_op_A);
        }

        B_CP: coverpoint B {
            bins B_data_0 = {0};
            bins B_data_max = {MAXPOS};
            bins B_data_min = {MAXNEG};
            bins B_data_default = default;
            bins B_data_walkingones[] = {3'b001, 3'b010, 3'b100} iff(red_op_B && ~red_op_A);
        }


        ALU_cp: coverpoint opcode {
            bins Bins_shift[] = {SHIFT, ROTATE};
            bins Bins_arith[] = {ADD, MULT};
            bins Bins_bitwise[] = {OR, XOR};
            bins Bins_trans = (0 => 1 => 2 => 3 => 4 => 5);
            illegal_bins Bins_invalid = {INVALID_6, INVALID_7};

        }
        //Added coverpoint for C_in
        cin_CP: coverpoint cin
        { option.weight = 0;}

        //Added coverpoint for direction
        direction_CP: coverpoint direction{
            option.weight = 0;
        }

        //Added coverpoint for serial_in
        serial_in_CP: coverpoint serial_in{
            option.weight = 0;
        }

        //Added coverpoint for red_op_A
        red_op_A_cp: coverpoint red_op_A{
            option.weight = 0;
        }
        
        //Added coverpoint for red_op_B
        red_op_B_cp: coverpoint red_op_B{
            option.weight = 0;
        }



        //1.Cross coverage for ADD and MULT with A/B permutations
        A_B_ALU_cross: cross A_CP, B_CP, ALU_cp {

            bins add_mult_perms = binsof(ALU_cp.Bins_arith) && 
                                binsof(A_CP) intersect {MAXPOS, MAXNEG, 0} &&
                                binsof(B_CP) intersect {MAXPOS, MAXNEG, 0};
            option.cross_auto_bin_max = 0;
        }

        //2.ALU is addition, c_in should have taken 0 or 1
        CIN_ADD_cross: cross ALU_cp, cin_CP{

            bins cin_add = binsof(ALU_cp.Bins_arith) intersect {ADD} &&
                             binsof(cin_CP) intersect {0, 1};
            option.cross_auto_bin_max = 0;

        }

        //3.ALSU is shifting or rotating, then direction must take 0 or 1
        DIRECTION_ALU_cross: cross direction_CP, ALU_cp {

            bins direction_ALU = binsof(ALU_cp.Bins_shift) &&
                                 binsof(direction_CP) intersect {0, 1};
            option.cross_auto_bin_max = 0;
        }

        //4.ALSU is shifting, then shift_in must take 0 or 1
        SERIAL_IN_SHIFT_cross: cross serial_in_CP, ALU_cp {
            bins serial_in_ALU = binsof(ALU_cp.Bins_shift) intersect {SHIFT} &&
                                 binsof(serial_in_CP) intersect {0, 1};
            option.cross_auto_bin_max = 0;
        }

        //5.ALSU is OR or XOR and red_op_A is asserted, then A took all walking one patterns
        //(001, 010, and 100) while B is taking the value 0
        RED_OP_A_OR_XOR_cross: cross ALU_cp, A_CP, B_CP {
            bins red_op_A_or_xor = binsof(ALU_cp.Bins_bitwise) &&
                                    binsof(A_CP.A_data_walkingones) &&
                                    binsof(B_CP.B_data_0);
            option.cross_auto_bin_max = 0;
        }

        //6.ALSU is OR or XOR and red_op_B is asserted, then B took all walking one patterns
        // (001, 010, and 100) while A is taking the value 0
        RED_OP_B_OR_XOR_cross: cross ALU_cp, A_CP, B_CP {
            bins red_op_A_or_xor = binsof(ALU_cp.Bins_bitwise) &&
                                    binsof(B_CP.B_data_walkingones) &&
                                    binsof(A_CP.A_data_0);
            option.cross_auto_bin_max = 0;
        }

        //7.invalid case: reduction operation is activated while the opcode is not OR or XOR
        RED_INVLAID_cross: cross ALU_cp, red_op_A_cp, red_op_B_cp {
            ignore_bins OR_XOR = binsof(red_op_A_cp) &&
                                 binsof(red_op_B_cp) &&
                                 binsof(ALU_cp.Bins_bitwise);
                                 
            ignore_bins trans = binsof(ALU_cp.Bins_trans);
        }

        endgroup

        function new(cin = 0, rst = 0, red_op_A = 0, red_op_B = 0, bypass_A = 0,
                     bypass_B = 0, direction = 0, serial_in = 0,
                     A = 0, B = 0, OPCODE_e opcode = OR);
            this.cin = cin;
            this.rst = rst;
            this.red_op_A = red_op_A;
            this.red_op_B = red_op_B;
            this.bypass_A = bypass_A;
            this.bypass_B = bypass_B;
            this.direction = direction;
            this.serial_in = serial_in;
            this.opcode = opcode;
            this.A = A;
            this.B = B;

            CovCode = new;
            
        endfunction //new()

    endclass //ALSU_inputs

endpackage