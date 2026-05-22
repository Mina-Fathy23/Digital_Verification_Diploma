import config_reg_pkg::*;

module Config_reg_tb();


    //Inputs
    logic clk;
    logic reset;
    logic write;
    logic [15:0] data_in;
    reset_v address;
    //Outputs
    logic [15:0] data_out;

    //Debug Variables
    logic [WIDTH-1:0] data_to_write_array[reset_v];
    logic [WIDTH-1:0] config_reg_expected[reset_v];
    logic [WIDTH-1:0] read_data_queue[$];
    logic [WIDTH-1:0] data;


    config_reg dut(
        .clk(clk),
        .reset(reset),
        .write(write),
        .data_in(data_in),
        .address(address),
        .data_out(data_out)
    );

    reg_inputs obj = new();
    int error_count, correct_count;

    initial begin
        clk = 0;
        forever
            #1 clk = ~clk;
    end

    initial begin
        error_count = 0; correct_count = 0;
            
        repeat(4)begin
            //check reset values    
            checkReset();

            //Stimulate random input data
            stimulus_gen();
            golden_model();

            for(int i = 0; i < address.num; i++)begin

                write = 1;
                data_in = data_to_write_array[address];
                @(negedge clk)
                address = address.next;
            end

            address = address.first;

            for(int i = 0; i < address.num; i++)begin
                write = 0;
                @(negedge clk);
                checkReg(address);
                read_data_queue.push_front(data_out);
                address = address.next;

            end

            for(int i = 0; read_data_queue.size(); i++)begin
                data = read_data_queue.pop_back();
                $display("%2d.Data Read:%h", i, data);
            end
        end

        $display("Total Tests:%d | Correct Tests:%d | Error Test:%d", correct_count + error_count, correct_count, error_count);  
        $stop;

    end

    task checkReset();
        
        write = 0; reset = 1;
        address = address.first;
        data_in = 0;

        $display("==============Reset Check=============\n");
        for(int i = 0; i < address.num; i++)begin
            @(negedge clk);
            if(data_out != obj.reset_assoc[address])begin
                error_count++;
                $display("Address:%s\n| Data Out: Expceted:%h | DUT:%h <-----Error", address.name, obj.reset_assoc[address], data_out);
                // $stop;
            end
            else begin
                $display("Address:%s\n| Data Out: Expceted:%h | DUT:%h", address.name, obj.reset_assoc[address], data_out);
                correct_count++;
            end

            address = address.next;
        end
         $display("==============End Reset Check=============\n");
        reset = 0;
    endtask

    task stimulus_gen();

        address = address.first;

        for(int i = 0; i < address.num; i++)begin
            data_to_write_array[address] = $random;
            address = address.next;
        end
    endtask

    task golden_model();
        address = address.first;

        for(int i = 0; i < address.num; i++)begin
            config_reg_expected[address] = data_to_write_array[address];
            address = address.next;
        end
    endtask

    task checkReg(input reset_v address);

         if(data_out != config_reg_expected[address])begin
            error_count++;
            $display("Address:%s\n| Data Out: Expceted:%h | DUT:%h <-----Error", address.name, config_reg_expected[address], data_out);
            // $stop;
        end
        else begin
            $display("Address:%s\n| Data Out: Expceted:%h | DUT:%h", address.name, config_reg_expected[address], data_out);
            correct_count++;
        end

    endtask

    
endmodule