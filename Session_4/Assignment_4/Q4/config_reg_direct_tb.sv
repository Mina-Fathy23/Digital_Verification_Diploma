import config_reg_pkg::*;

module Config_reg_directed_tb();

    //Inputs
    logic clk;
    logic reset;
    logic write;
    logic [15:0] data_in;
    reset_v address;
    //Outputs
    logic [15:0] data_out;

    config_reg dut(
        .clk(clk),
        .reset(reset),
        .write(write),
        .data_in(data_in),
        .address(address),
        .data_out(data_out)
    );

    initial begin
        clk = 0;
        forever
            #1 clk = ~clk;
    end

    initial begin

        //1.Incorrect Reset Value during 1st reset of Register : analog_test
        reset = 1; write = 0; data_in = 0; address = analog_test;
        @(negedge clk);

        $display("Address:%s\n| Data Out: Expceted:0xABCD | DUT:%h <-----Error", address.name, data_out);

        //2.Incorrect write assignment in Register: adc0_reg
        reset = 0; write = 1; data_in = 16'h3524 ; address = adc0_reg;
        @(negedge clk);
        reset = 0; write = 0; data_in = 16'h0 ; address = adc0_reg;
        @(negedge clk);
        $display("Address:%s\n| Data Out: Expceted:0x3524 | DUT:%h <-----Error", address.name, data_out);

        //3.Incorrect write assignment in Register: adc1_reg
        reset = 0; write = 1; data_in = 16'h5e81 ; address = adc1_reg;
        @(negedge clk);
        reset = 0; write = 0; data_in = 16'h0 ; address = adc1_reg;
        @(negedge clk);
        $display("Address:%s\n| Data Out: Expceted:0x5e81 | DUT:%h <-----Error", address.name, data_out);

        //4.Incorrect write assignment in Register: temp_sensor0_reg
        reset = 0; write = 1; data_in = 16'hd609 ; address = temp_sensor0_reg;
        @(negedge clk);
        reset = 0; write = 0; data_in = 16'h0 ; address = temp_sensor0_reg;
        @(negedge clk);
        $display("Address:%s\n| Data Out: Expceted:0xd609 | DUT:%h <-----Error", address.name, data_out);
        

        //5 & 6.Switched write assignment in Register: amp_gain & digital_test
        reset = 0; write = 1; data_in = 16'h8465 ; address = amp_gain;
        @(negedge clk);
        reset = 0; write = 1; data_in = 16'hd998d ; address = digital_test;
        @(negedge clk);
        
        reset = 0; write = 0; data_in = 16'h0 ; address = amp_gain;
        @(negedge clk);
        $display("Address:%s\n| Data Out: Expceted:0x8465 | DUT:%h <-----Error", address.name, data_out);
        
        reset = 0; write = 0; data_in = 16'h0 ; address = digital_test;
        @(negedge clk);
        $display("Address:%s\n| Data Out: Expceted:0xd998d | DUT:%h <-----Error", address.name, data_out);

        //7.Incorrect reset value in 2nd reset assignment in Register: temp_sensor1_reg
        reset = 1; write = 0; data_in = 16'h0 ; address = temp_sensor1_reg;
        @(negedge clk);
        reset = 0; write = 1; data_in = 16'h1111 ; address = temp_sensor1_reg;
        @(negedge clk);
        reset = 1; write = 0; data_in = 16'h0 ; address = temp_sensor1_reg;
        @(negedge clk);

        $display("Address:%s\n| Data Out: Expceted:0x0 | DUT:%h <-----Error", address.name, data_out);

        //8.Incorrect write assignment in Register: digital_config
        reset = 0; write = 1; data_in = 16'h870a ; address = digital_config;
        @(negedge clk);
        reset = 0; write = 0; data_in = 16'h0 ; address = digital_config;
        @(negedge clk);
        $display("Address:%s\n| Data Out: Expceted:0x870a | DUT:%h <-----Error", address.name, data_out);

        $$display("Total Of 8 Errors");
        $stop;
    end


endmodule