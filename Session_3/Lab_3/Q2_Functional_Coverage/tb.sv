import testing_pkg::*;

module tb ();
    
    Transaction obj = new;

    byte operand1, operand2;
    logic clk, rst;
    opcode_e opcode;
    byte out;

    alu_seq DUT (.*);

    initial begin
        clk = 0;
        forever begin
            #1 clk = ~clk;
            obj.clk = clk;
        end
    end

    initial begin
        rst = 1;
        @(negedge clk);
        rst = 0;

        repeat(32)begin
            assert(obj.randomize());
            operand1 = obj.operand1;
            operand2 = obj.operand2;
            opcode = obj.opcode;
            @(negedge clk);

        end
        $stop;
    end




endmodule