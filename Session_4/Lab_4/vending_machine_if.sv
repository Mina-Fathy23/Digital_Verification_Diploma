////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: Vending machine example
// 
////////////////////////////////////////////////////////////////////////////////
interface vending_machine_if(clk);
// 1. Add the parameters (WAIT = 0, Q_25 = 1, Q_50 =2)
    parameter WAIT = 0;
    parameter Q_25 = 1;
    parameter Q_50 =2;
// 2. Add the clock as an input port
    input bit clk;
// 3. Add the internal signals of the interface
    logic rstn;
    logic Q_in;
    logic D_in;
    logic dispense;
    logic change;
// 4. Add the modports
    modport DUT (input clk, rstn, Q_in, D_in, 
                    output dispense, change);

    modport TEST (input clk, dispense, change, 
                    output rstn, Q_in, D_in);
    
    modport MONITOR (input clk, dispense, change, 
                        rstn, Q_in, D_in);

endinterface 