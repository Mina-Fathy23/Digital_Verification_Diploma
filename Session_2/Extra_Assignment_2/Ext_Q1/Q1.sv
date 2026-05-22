module state_2_Array ();

    bit [11:0] my_array [4];

    initial begin
        my_array[0] = 12'h012;
        my_array[1] = 12'h345;
        my_array[2] = 12'h678;
        my_array[3] = 12'h9AB;

        $display("For Loop:");
        for(int i = 0; i < $size(my_array); i++)begin
            $display("bits [5:4] of Element %0d:%b | All Data:%b", i, my_array[i][5:4], my_array[i]);
        end
        $display("\n Foreach Loop:");
        foreach (my_array[i]) begin
            $display("bits [5:4] of Element %0d:%b | All Data:%b", i, my_array[i][5:4], my_array[i]);
        end
    end
    
endmodule