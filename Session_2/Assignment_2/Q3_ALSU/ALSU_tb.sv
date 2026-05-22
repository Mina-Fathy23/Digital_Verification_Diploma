import ALSU_pkg::*;

module ALSU_tb ();

    logic clk, cin, rst, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
    OPCODE_e opcode;
    logic signed [2:0] A, B;
    logic [15:0] leds;
    logic signed [5:0] out;
    //Testbench Variables
    logic [15:0] leds_expected;
    logic signed [5:0] out_expected;

    ALSU_inputs inputs = new();
    int error_count, correct_count;

    ALSU DUT (.*);
    ALSU_golden_2 Golden (.clk(clk), .A(A), .B(B), .cin(cin), .rst(rst), .red_op_A(red_op_A),
                        .red_op_B(red_op_B), .bypass_A(bypass_A), .bypass_B(bypass_B),
                        .direction(direction), .serial_in(serial_in), .opcode(opcode),
                        .leds(leds_expected), .out_DFF(out_expected));

    initial begin
        clk = 0;
        forever
            #1 clk = ~clk;
    end

    initial begin
        //ALSU_1
        assert(inputs.randomize());
        rst         = 1;
        cin         = inputs.cin;
        red_op_A    = inputs.red_op_A;
        red_op_B    = inputs.red_op_B;
        bypass_A    = inputs.bypass_A;
        bypass_B    = inputs.bypass_B;
        direction   = inputs.direction;
        serial_in   = inputs.serial_in;
        opcode      = inputs.opcode;
        
        A = inputs.A;
        B = inputs.B;
        check_result();

        //ALSU_2, ALSU_3, ALSU_5
        for(int i = 0; i < 200; i++)begin
            assert(inputs.randomize());
            rst         = inputs.rst;
            cin         = inputs.cin;
            red_op_A    = inputs.red_op_A;
            red_op_B    = inputs.red_op_B;
            bypass_A    = inputs.bypass_A;
            bypass_B    = inputs.bypass_B;
            direction   = inputs.direction;
            serial_in   = inputs.serial_in;
            opcode      = inputs.opcode;
            
            A = inputs.A;
            B = inputs.B;
            check_result();
        end

        //ALSU_4
        A         = 2; B         = 3;
        cin       = 0; serial_in = 0;
        red_op_A  = 1; red_op_B  = 1;
        opcode    = OR; direction = 1;
        bypass_A  = 0; bypass_B  = 0;            
        check_result();

        A         = 2; B         = 3;
        cin       = 0; serial_in = 0;
        red_op_A  = 1; red_op_B  = 0;
        opcode    = OR; direction = 1;
        bypass_A  = 0; bypass_B  = 0;            
        check_result();

        A         = 2; B         = 3;
        cin       = 0; serial_in = 0;
        red_op_A  = 0; red_op_B  = 1;
        opcode    = OR; direction = 1;
        bypass_A  = 0; bypass_B  = 0;            
        check_result();

        A         = -1; B         = 1;
        cin       = 0; serial_in = 0;
        red_op_A  = 1; red_op_B  = 1;
        opcode    = XOR; direction = 1;
        bypass_A  = 0; bypass_B  = 0;
        check_result();


    
        $display("Total Tests:%0d | Correct Tests:%0d | Error Test:%0d", correct_count + error_count, correct_count, error_count);  
        $stop;
    end

    task check_result();
        repeat(2)@(negedge clk);
        if((leds !== leds_expected) || (out !== out_expected)) begin
            error_count++;
            $display("Expected Leds:%b, Out:%d| DUT Leds:%b, Out:%d <---- ERROR", leds_expected, out_expected, leds, out);
            //$stop;
        end
        else begin
            $display("Expected Leds:%b, Out:%d| DUT Leds:%b, Out:%d", leds_expected, out_expected, leds, out);
            correct_count++;
        end
    endtask
endmodule