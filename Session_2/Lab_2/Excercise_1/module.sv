import pkg::*;

module test();

    MemTrans obj_1, obj_2;

    initial begin
        obj_1 = new(.address(2));
        obj_2 = new(.address(3), .data_in(4));

        obj_1.print();
        obj_2.print();

        $stop;
    end

    
endmodule