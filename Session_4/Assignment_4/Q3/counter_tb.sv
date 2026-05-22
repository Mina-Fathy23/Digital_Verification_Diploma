import counter_pkg::*;

module counter_tb(counter_if.TEST c_if);
    

    Counter_inputs inputs = new();
    
    initial begin
        assert(inputs.randomize());
        //COUNTER_1
        c_if.rst_n = 0;
        c_if.load_n = inputs.load_n;
        c_if.up_down = inputs.up_down;
        c_if.ce = inputs.ce;
        c_if.data_load = inputs.data_load;

        @(negedge c_if.clk);
        inputs.count_out = c_if.count_out;
        inputs.CovCode.sample();

        //COUNTER_2, 3, 4, 5
        for(int i = 0; i < 200; i++)begin
            assert(inputs.randomize());
            c_if.rst_n = inputs.rst_n;
            c_if.load_n = inputs.load_n;
            c_if.up_down = 1; inputs.up_down = 1;
            c_if.ce = inputs.ce;
            c_if.data_load = inputs.data_load;
            
            @(negedge c_if.clk);
            inputs.count_out = c_if.count_out;
            inputs.CovCode.sample();
        end

        for(int i = 0; i < 200; i++)begin
            assert(inputs.randomize());
            c_if.rst_n = inputs.rst_n;
            c_if.load_n = inputs.load_n;
            c_if.up_down = 0; inputs.up_down = 0;
            c_if.ce = inputs.ce;
            c_if.data_load = inputs.data_load;
            
            @(negedge c_if.clk);
            inputs.count_out = c_if.count_out;
            inputs.CovCode.sample();
        end

        //COUNTER_6
        c_if.rst_n = 1; c_if.load_n = 0; c_if.ce = 1; c_if.data_load = 4'b1111; 
        inputs.rst_n = 1;  inputs.load_n = 0; inputs.ce = 1; inputs.data_load = 4'b1111;
        @(negedge c_if.clk);
        inputs.count_out = c_if.count_out;
        inputs.CovCode.sample();
        

        //COUNTER_7
        c_if.rst_n = 1; c_if.load_n = 0; c_if.ce = 1; c_if.data_load = 0; 
        inputs.rst_n = 1; inputs.load_n = 0; inputs.ce = 1; inputs.data_load = 0;
        @(negedge c_if.clk);
        inputs.count_out = c_if.count_out;
        inputs.CovCode.sample();
        
        //Additioal Tests for 100% Coverage
        assert(inputs.randomize());
        c_if.rst_n = 0; inputs.rst_n = 0;
        c_if.load_n = inputs.load_n;
        c_if.up_down = inputs.up_down;
        c_if.ce = inputs.ce;
        c_if.data_load = inputs.data_load;
        @(negedge c_if.clk);
        inputs.count_out = c_if.count_out;
        inputs.CovCode.sample();


        assert(inputs.randomize());
        c_if.rst_n = inputs.rst_n;
        c_if.load_n = inputs.load_n;
        c_if.up_down = 1; inputs.up_down = 1;
        c_if.ce = inputs.ce;
        c_if.data_load = inputs.data_load;
         @(negedge c_if.clk);
        inputs.count_out = c_if.count_out;
        inputs.CovCode.sample();
        $stop;
        

    end

endmodule