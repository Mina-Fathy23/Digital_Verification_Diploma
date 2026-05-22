import counter_pkg::*;
module counter_sva(counter_if.DUT c_if);

    //1.When the load control signal is active, then the dout has the value of the din
    property p_load_active_count_out;
        @(posedge c_if.clk) disable iff(~c_if.rst_n) (~c_if.load_n) |=> (c_if.count_out == $past(c_if.data_load));
    endproperty    

    //2.When the load control signal is not active, and the enable is off then the dout does not change
    property p_load_inactive_enable_off;
        @(posedge c_if.clk) disable iff(~c_if.rst_n) ((c_if.load_n) && (~c_if.ce)) |=> $stable(c_if.count_out);
    endproperty

    //3.When the load control signal is not active and the enable is active, and the up_down is high then the dout is incremented.
    property p_load_inactive_enable_on_updown_1;
        @(posedge c_if.clk) disable iff(~c_if.rst_n || $isunknown(c_if.count_out))
            (c_if.load_n && c_if.ce && c_if.up_down) |=> (c_if.count_out == $past(c_if.count_out) + 1'b1);
    endproperty

    //4.When the load control signal is not active and the enable is active, and the up_down is low
    //  then the dout is decremented.
    property p_load_inactive_enable_on_updown_0;
        @(posedge c_if.clk) disable iff(~c_if.rst_n) (c_if.load_n && c_if.ce && ~(c_if.up_down)) |=> (c_if.count_out == $past(c_if.count_out) - 1'b1);
    endproperty

    always_comb begin
         //5.When the asynchronous reset is asserted then the counter output is tied to low at the same instant.
        if(~c_if.rst_n) begin
            assert final (c_if.count_out == 0);
            cover final (c_if.count_out == 0);
        end

        //6.max_count output is high when the counter output is maximum.
        if(c_if.count_out == {WIDTH{1'b1}})begin
            assert final (c_if.max_count);
            cover final (c_if.max_count);
        end

        //7.zero output is high when the counter output is zero.
        if(c_if.count_out == 4'b0000)begin
            assert final (c_if.zero);
            cover final (c_if.zero);
        end
    end 

    load_active_count_out_assertion : assert property (p_load_active_count_out);
    load_inactive_enable_off_assertion  : assert property (p_load_inactive_enable_off);
    load_inactive_enable_on_updown_1_assertion  : assert property (p_load_inactive_enable_on_updown_1);
    load_inactive_enable_on_updown_0_assertion  : assert property (p_load_inactive_enable_on_updown_0);

    load_active_count_out_coverage : cover property (p_load_active_count_out);
    load_inactive_enable_off_coverage : cover property (p_load_inactive_enable_off);
    load_inactive_enable_on_updown_1_coverage : cover property (p_load_inactive_enable_on_updown_1);
    load_inactive_enable_on_updown_0_coverage : cover property (p_load_inactive_enable_on_updown_0);



endmodule