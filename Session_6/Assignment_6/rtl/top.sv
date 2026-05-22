`include "uvm/includes/all_imports.svh"

module top();

    bit clk;

    initial begin
        clk = 0;
        forever
            #1 clk = ~clk;
    end

    alsu_if alsuif (clk);

    ALSU DUT (.clk(clk), .A(alsuif.A), .B(alsuif.B),
                .cin(alsuif.cin), .serial_in(alsuif.serial_in),
                .red_op_A(alsuif.red_op_A), .red_op_B(alsuif.red_op_B),
                .opcode(alsuif.opcode), .bypass_A(alsuif.bypass_A),
                .bypass_B(alsuif.bypass_B), .rst(alsuif.rst), .direction(alsuif.direction),
                .leds(alsuif.leds), .out(alsuif.out));

    //bind the SVA module to the designs
    bind ALSU ALSU_SVA ALSU_SVA_inst(.clk(clk), .A(alsuif.A), .B(alsuif.B),
                .cin(alsuif.cin), .serial_in(alsuif.serial_in),
                .red_op_A(alsuif.red_op_A), .red_op_B(alsuif.red_op_B),
                .opcode(alsuif.opcode), .bypass_A(alsuif.bypass_A),
                .bypass_B(alsuif.bypass_B), .rst(alsuif.rst), .direction(alsuif.direction),
                .leds(alsuif.leds), .out(alsuif.out));


    initial begin
        uvm_config_db#(virtual alsu_if)::set(null, "uvm_test_top", "vif", alsuif);
        run_test("alsu_test");
    end

endmodule