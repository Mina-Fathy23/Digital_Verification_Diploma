interface ram_interface (clk);
//INPUTS
input bit clk;
bit rst_n, rx_valid;
bit [9:0] din;
//OUTPUTS
bit tx_valid; //Should be high if we want to read
logic [7:0] dout;

bit tx_valid_ref; //Should be high if we want to read
logic [7:0] dout_ref;

endinterface