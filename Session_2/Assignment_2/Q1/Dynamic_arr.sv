module Dynamic_Arr();

    int dyn_arr1[], dyn_arr2[] = '{9, 1, 8, 3, 4, 4};


    initial begin
        dyn_arr1 = new[6];
        foreach (dyn_arr1[i]) begin
            dyn_arr1[i] = i;
        end

        $display("dyn_arr1: %p", dyn_arr1);
        dyn_arr1.delete();

        dyn_arr2.reverse();
        $display("dyn_arr2 Reversed: %p", dyn_arr2);

        dyn_arr2.sort();
        $display("dyn_arr2 Sorted: %p", dyn_arr2);

        dyn_arr2.rsort();
        $display("dyn_arr2 Reverse Sorted: %p", dyn_arr2);

        dyn_arr2.shuffle();
        $display("dyn_arr2 Shuffled: %p", dyn_arr2);
    end
    

endmodule