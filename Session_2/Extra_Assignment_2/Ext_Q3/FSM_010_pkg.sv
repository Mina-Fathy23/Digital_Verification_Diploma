package FSM_010_pkg;

    typedef enum logic [1:0] {IDLE, ZERO, ONE, STORE} state_e;

    class fsm_transaction;

        rand logic       x, rst, y_exp;
        rand logic [9:0] user_count_exp;
        bit clk;

        constraint c_x{
            x dist{0:/67, 1:/33};
        }
        
        constraint c_rst{
            rst dist{0:/95, 1:/5};
        }

        covergroup cg_x @(posedge clk);
            x_trans: coverpoint x{
                bins x_0_1_0 = (0 => 1 => 0);
            }
        endgroup
        
        function new(logic x = 0, rst = 0, y = 0, logic [9:0] user_count_exp = 0);

            this.x = x;
            this.rst = rst;
            this.y_exp = y;
            this.user_count_exp = user_count_exp;

            cg_x = new;
            
        endfunction
        
    endclass
    
endpackage