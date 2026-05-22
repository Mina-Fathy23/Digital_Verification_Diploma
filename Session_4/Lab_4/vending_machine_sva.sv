////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: Vending machine example
// 
////////////////////////////////////////////////////////////////////////////////
module vending_machine_sva(vending_machine_if.MONITOR v_if);
// 1. Add the modport above
// 2. Add the following 3 properties, then use assert property and cover property on each property
//// First Assertion: At each positive edge of the clock, if the D_in is high then at the same clock cycle, the dispense and the change outputs are high
    property p_dollar;
        @(posedge v_if.clk) v_if.D_in |-> (v_if.dispense && v_if.change);
    endproperty
//// Second Assertion: At each positive edge of the clock, If there is a rising edge for the input Q_in then after 2 clock cycles the dispense output is high
    property p_quarter_dispense;
        @(posedge v_if.clk) $rose(v_if.Q_in) |-> ##2 v_if.dispense;
    endproperty
//// Third Assertion: At each positive edge of the clock, if the Q_in is high then at the same clock cycle, the change must be low
    property p_quarter_change;
        @(posedge v_if.clk) v_if.Q_in |-> !(v_if.change);
    endproperty

    Dollar_Assert: assert property(p_dollar);
    Quarter_dispense_Assert: assert property(p_quarter_dispense);
    Quarter_change_Assert: assert property(p_quarter_change);

    Dollar_coverage: cover property(p_dollar);
    Quarter_dispense_coverage: cover property(p_quarter_dispense);
    Quarter_change_coverage: cover property(p_quarter_change);
endmodule