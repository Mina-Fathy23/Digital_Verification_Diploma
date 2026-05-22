import counter_pkg::*;

module counter_tb();
    
    logic clk;
    logic rst_n;                        //(active low sync rst)
    logic load_n;                       //(active low load)
    logic up_down;                      //high then increment counter, else decrement
    logic ce;                           //(clock enable signal
    logic [WIDTH-1:0] data_load;        //(load data to count_out output when the load_n signal is asserted)    
    logic [WIDTH-1:0] count_out;  
    logic [WIDTH-1:0] count_out_expected;  
    logic max_count;                   //counter reaches the maximum value, this signal is high, else low)
    logic zero;                        //counter reaches the minimum value, this signal is high, else low)

    counter #(WIDTH) DUT (.*);
    N_bit_up_down_Counter #(WIDTH) Golden(.clk(clk), 
                                          .reset(rst_n), 
                                          .en_load(load_n),
                                          .clk_en(ce), 
                                          .load(data_load), 
                                          .up_ndown(up_down), 
                                          .cnt(count_out_expected));

    Counter_inputs inputs = new();
    
    int error_count, correct_count;

    initial begin
        clk = 0;
        forever begin
            #1 clk = ~clk;
            inputs.clk = clk;
            inputs.count_out = count_out;
        end
            
    end
    
    task check_result();
        @(negedge clk);
        $display("Expected:%d | DUT:%d |  UP_DOWN:%d | CLK_EN:%d | Load_n:%d | Load Data:%d", count_out_expected, count_out
                                                                                            , up_down, ce, load_n, data_load);
        if(count_out !== count_out_expected) begin
            error_count++;
            // $stop;
        end
        else begin
            correct_count++;
        end
    endtask


    initial begin
        assert(inputs.randomize());
        //COUNTER_1
        rst_n = 0;
        load_n = inputs.load_n;
        up_down = inputs.up_down;
        ce = inputs.ce;
        data_load = inputs.data_load;

        check_result();

        //COUNTER_2, 3, 4, 5
        for(int i = 0; i < 100; i++)begin
            assert(inputs.randomize());
            rst_n = inputs.rst_n;
            load_n = inputs.load_n;
            up_down = 1; inputs.up_down = 1;
            ce = inputs.ce;
            data_load = inputs.data_load;
            
            check_result();
        end

        for(int i = 0; i < 100; i++)begin
            assert(inputs.randomize());
            rst_n = inputs.rst_n;
            load_n = inputs.load_n;
            up_down = 0; inputs.up_down = 0;
            ce = inputs.ce;
            data_load = inputs.data_load;
            
            check_result();
        end

        //COUNTER_6
        rst_n = 1; load_n = 0; ce = 1; data_load = 4'b1111; 
        @(negedge clk)
        if(max_count != 1)begin
            $display("Error In Max_Count: Expected:1 | DUT:%0d", max_count);
            error_count++;
            // $stop;
        end
        else begin
            correct_count++;
        end

        //COUNTER_7
        rst_n = 1; load_n = 0; ce = 1; data_load = 0; 
        @(negedge clk)
        if(zero != 1)begin
            $display("Error In zero: Expected:1 | DUT:%0d", zero);
            error_count++;
            // $stop;
        end
        else begin
            correct_count++;
        end

        //Additioal Tests for 100% Coverage
        assert(inputs.randomize());
        rst_n = 0;
        load_n = inputs.load_n;
        up_down = inputs.up_down;
        ce = inputs.ce;
        data_load = inputs.data_load;

        check_result();

        assert(inputs.randomize());
        rst_n = inputs.rst_n;
        load_n = inputs.load_n;
        up_down = 1; inputs.up_down = 1;
        ce = inputs.ce;
        data_load = inputs.data_load;
        
        check_result();


        $display("Total Tests:%d | Correct Tests:%d | Error Test:%d", correct_count + error_count, correct_count, error_count);  
        $stop;

    end

endmodule