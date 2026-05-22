
module my_mem_tb();

    parameter TESTS = 100;
    logic [15:0] address_array[];
    logic [7:0]  data_to_write_array[];

    logic [7:0]  data_read_expect_assoc[int];
    logic [7:0]  data_read_queue[$];
    logic [7:0]  data;

    //MEM INPUT and OUTPUT ports
    logic clk;
    logic write;
    logic read;
    logic [7:0] data_in;
    logic [15:0] address;
    logic [7:0] data_out;

    int error_count, correct_count;

    my_mem dut (
        .clk     (clk),
        .write   (write),
        .read    (read),
        .data_in (data_in),
        .address (address),
        .data_out(data_out)
    );

    initial begin
        clk = 0;
        forever
            #1 clk = ~clk;
    end

    initial begin
        error_count = 0; correct_count = 0;
        write = 0; read = 0; address = 0; data_in = 0;
        stimulus_gen();
        golden_model();

        for(int i = 0; i < TESTS; i++)begin

            write = 1; read = 0;
            address = address_array[i];
            data_in = data_to_write_array[i];
            @(negedge clk);
            

        end

        for(int i = 0; i < TESTS; i++)begin
            read = 1; write = 0;  address = address_array[i];
            @(negedge clk);
            check9Bits(address_array[i]);
            data_read_queue.push_front(data_out);

        end

        for(int i = 0; data_read_queue.size(); i++)begin
            data = data_read_queue.pop_front();
            $display("%2d.Data Read:%h", i, data);
        end

        $display("Total Tests:%d | Correct Tests:%d | Error Test:%d", correct_count + error_count, correct_count, error_count);  
        $stop;
    end

    task stimulus_gen();

        address_array = new[TESTS];
        data_to_write_array = new[TESTS];

        for(int i = 0; i < TESTS; i++)begin
            address_array[i] = $random;
            data_to_write_array[i] = $random;
        end
    endtask

    task golden_model();

        for(int i = 0; i < TESTS; i++)begin
            data_read_expect_assoc[address_array[i]] = data_to_write_array[i];
        end
    endtask

    task check9Bits(input logic [15:0] address);

        if(data_out != data_read_expect_assoc[address])begin
            error_count++;
            $display("Error in Data Out: Expceted:%h | DUT:%h ", data_read_expect_assoc[address], data_out);
            $stop;
        end
        else
            correct_count++;

    endtask

endmodule