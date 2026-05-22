module queue();

    int j;
    int q[$];
    int temp;

    initial begin
        j = 1;
        q = {0, 2, 5};
        q.insert(1, j);
        $write("Q Queue:{");
        foreach(q[i])begin
            $write("%0d, ", q[i]);
        end
        $display("}\n");

        q.delete(1);
        $write("Q Queue after deleting index 1:{");
        foreach(q[i])begin
            $write("%0d, ", q[i]);
        end
        $display("}\n");

        q.push_front(7);
        $write("Q Queue pushing 7 in front:{");
        foreach(q[i])begin
            $write("%0d, ", q[i]);
        end
        $display("}\n");

        q.push_back(9);
        $write("Q Queue after pushing 9 in back:{");
        foreach(q[i])begin
            $write("%0d, ", q[i]);
        end
        $display("}\n");

        j = q.pop_back();
        $display("J = %0d", j);
        $write("Q Queue:{");
        foreach(q[i])begin
            $write("%0d, ", q[i]);
        end
        $display("}\n");

        j = q.pop_front();
        $display("J = %0d", j);
        $write("Q Queue:{");
        foreach(q[i])begin
            $write("%0d, ", q[i]);
        end
        $display("}\n");

        q.reverse();
        $write("Q Queue Reversed:{");
        foreach(q[i])begin
            $write("%0d, ", q[i]);
        end
        $display("}\n");

        q.sort();
        $write("Q Queue Sorted:{");
        foreach(q[i])begin
            $write("%0d, ", q[i]);
        end
        $display("}\n");

        q.rsort();
        $write("Q Queue Reversed Sorted:{");
        foreach(q[i])begin
            $write("%0d, ", q[i]);
        end
        $display("}\n");

        q.shuffle();
        $write("Q Queue shuffled:{");
        foreach(q[i])begin
            $write("%0d, ", q[i]);
        end
        $display("}\n");
        
    end

endmodule