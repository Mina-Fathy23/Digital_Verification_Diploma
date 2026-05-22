package counter_pkg;

    parameter WIDTH = 4;

    class Counter_inputs;

        rand logic rst_n;                        //(active low sync rst)
        rand logic load_n;                       //(active low load)
        rand logic up_down;                      //high then increment counter, else decrement
        rand logic ce;                           //(clock enable signal
        rand logic [WIDTH-1:0] data_load;        //(load data to count_out output when the load_n signal is asserted)

        constraint c_rst_n{
            rst_n dist{0:/10, 1:/90};
        }

        constraint c_load_n{
            load_n dist{0:/30, 1:/70};
        }

        constraint c_ce{
            ce dist{0:/30, 1:/70};
        }
        
        function new(logic rst_n = 1, logic load_n = 1, logic up_down = 1, logic ce = 0, logic [WIDTH-1:0] data_load = 0);

            this.rst_n = rst_n;
            this.load_n = load_n;
            this.up_down = up_down;
            this.ce = ce;
            this.data_load = data_load;

        endfunction
        

    endclass

endpackage