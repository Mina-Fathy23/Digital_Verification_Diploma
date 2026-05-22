import class_pkg::*;

module test_2();

    MemTrans obj = new;

    initial begin
        for(int i = 0; i < 20; i++) begin
            assert(obj.randomize());   
            obj.display();
        end
        $stop;
    end


    
endmodule