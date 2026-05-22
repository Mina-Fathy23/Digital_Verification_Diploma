package config_reg_pkg;

    typedef enum logic[2:0] { adc0_reg, adc1_reg, temp_sensor0_reg, temp_sensor1_reg, 
                                analog_test, digital_test, amp_gain, digital_config } reset_v;

    parameter WIDTH = 16;

    class reg_inputs;

         logic[WIDTH-1:0] reset_assoc[reset_v];

        rand logic reset;
        rand logic write;
        rand logic [15:0] data_in;
        rand reset_v address;

        constraint reset_c{
            reset dist {0:/90, 1:/10};
        }


    function new(logic reset = 0, write = 0, data_in = 0);
        this.reset = reset;
        this.write = write;
        this.data_in = data_in;
        
        this.reset_assoc[adc0_reg] = 16'hFFFF;
        this.reset_assoc[adc1_reg] = 16'h0;
        this.reset_assoc[temp_sensor0_reg] = 16'h0;
        this.reset_assoc[temp_sensor1_reg] = 16'h0;
        this.reset_assoc[analog_test] = 16'hABCD;
        this.reset_assoc[digital_test] = 16'h0;
        this.reset_assoc[amp_gain] = 16'h0;
        this.reset_assoc[digital_config] = 16'h1;

    endfunction


    endclass

endpackage