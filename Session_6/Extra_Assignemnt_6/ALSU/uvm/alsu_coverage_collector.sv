package alsu_CovCollector_pkg;
    
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import alsu_seq_item_pkg::*;

    class alsu_covcollector extends uvm_component;
        `uvm_component_utils(alsu_covcollector)

        uvm_analysis_export #(alsu_seq_item) cov_export;
        uvm_tlm_analysis_fifo #(alsu_seq_item) cov_fifo; 
        alsu_seq_item seq_item;

        
        covergroup CovCode;

            A_CP: coverpoint seq_item.A {
                bins A_data_0 = {0};
                bins A_data_max = {MAXPOS};
                bins A_data_min = {MAXNEG};
                bins A_data_default = default;
                bins A_data_walkingones[] = {3'b001, 3'b010, 3'b100} iff(seq_item.red_op_A);
            }

            B_CP: coverpoint seq_item.B {
                bins B_data_0 = {0};
                bins B_data_max = {MAXPOS};
                bins B_data_min = {MAXNEG};
                bins B_data_default = default;
                bins B_data_walkingones[] = {3'b001, 3'b010, 3'b100} iff(seq_item.red_op_B && ~seq_item.red_op_A);
            }


            ALU_cp: coverpoint seq_item.opcode {
                bins Bins_shift[] = {SHIFT, ROTATE};
                bins Bins_arith[] = {ADD, MULT};
                bins Bins_bitwise[] = {OR, XOR};
                bins Bins_trans = (0 => 1 => 2 => 3 => 4 => 5);
                illegal_bins Bins_invalid = {INVALID_6, INVALID_7};

            }
            //Added coverpoint for C_in
            cin_CP: coverpoint seq_item.cin
            { option.weight = 0;}

            //Added coverpoint for direction
            direction_CP: coverpoint seq_item.direction{
                option.weight = 0;
            }

            //Added coverpoint for serial_in
            serial_in_CP: coverpoint seq_item.serial_in{
                option.weight = 0;
            }

            //Added coverpoint for red_op_A
            red_op_A_cp: coverpoint seq_item.red_op_A{
                option.weight = 0;
            }
            
            //Added coverpoint for red_op_B
            red_op_B_cp: coverpoint seq_item.red_op_B{
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
                bins red_op_B_or_xor = binsof(ALU_cp.Bins_bitwise) &&
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

        function new(string name = "alsu_covcollector", uvm_component parent = null);
            super.new(name, parent);
            CovCode = new;
        endfunction //new()

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            cov_export = new("cov_export", this);
            cov_fifo = new("cov_fifo", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            cov_export.connect(cov_fifo.analysis_export);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                cov_fifo.get(seq_item);
                CovCode.sample();
            end
        endtask

    endclass //alsu_CovCollector extends uvm_component

endpackage