import my_pkg::*;

module image ();
    
    screen obj = new;

    initial begin
        assert(obj.randomize());
        obj.print_screen();

        $stop;
    end

endmodule