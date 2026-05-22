module SLAVE_sva (MOSI,MISO,SS_n,clk,rst_n,rx_data,rx_valid,tx_data,tx_valid);

input MOSI, clk, rst_n, SS_n, tx_valid;
input [7:0] tx_data;
input [9:0] rx_data;
input rx_valid, MISO;

//////////////// assertions /////////////////

  // 1. During reset, all outputs must be low
property p_reset_outputs_low;
    @(posedge clk) (!rst_n) |-> ##1 (!MISO && !rx_valid && ~rx_data);
endproperty
assert property (p_reset_outputs_low);
cover property(p_reset_outputs_low);

// write add 000
sequence write_add_seq;
    //##1 MOSI==0 ##1 MOSI==0 ##1 MOSI==0 && SS_n==0;
    ($fell(SS_n) ##1 !MOSI ##1 !MOSI ##1 !MOSI);
endsequence
assert property (@(posedge clk) disable iff(!rst_n) write_add_seq |-> ##10 (rx_valid && $rose(SS_n) [->1]));
cover property (@(posedge clk) disable iff(!rst_n) write_add_seq |-> ##10 (rx_valid && $rose(SS_n) [->1]));

// write data 001
sequence write_data_seq;
    // ##1 MOSI==0 ##1 MOSI==0 ##1 MOSI==1 && SS_n==0 ;
    ($fell(SS_n) ##1 !MOSI ##1 !MOSI ##1 MOSI);
endsequence
assert property (@(posedge clk) disable iff(!rst_n) write_data_seq |-> ##10 (rx_valid && $rose(SS_n)[->1]));
cover property (@(posedge clk) disable iff(!rst_n) write_data_seq |-> ##10 (rx_valid && $rose(SS_n)[->1]));

// read add 110
sequence read_add_seq;
    // ##1 MOSI==1 ##1 MOSI==1 ##1 MOSI==0 && SS_n==0 ;
    ($fell(SS_n) ##1 MOSI ##1 MOSI ##1 !MOSI);
endsequence
assert property (@(posedge clk) disable iff(!rst_n) read_add_seq |-> ##10 (rx_valid && $rose(SS_n)[->1]));
cover property (@(posedge clk) disable iff(!rst_n) read_add_seq |-> ##10 (rx_valid && $rose(SS_n)[->1]));

// read data 111
sequence read_data_seq;
    //##1 MOSI==1 ##1 MOSI==1 ##1 MOSI==1 && SS_n==0 ;
    ($fell(SS_n) ##1 MOSI ##1 MOSI ##1 MOSI);
endsequence
assert property (@(posedge clk) disable iff(!rst_n) read_add_seq |-> ##10 (rx_valid && $rose(SS_n)[->1]));
cover property (@(posedge clk) disable iff(!rst_n) read_add_seq |-> ##10 (rx_valid && $rose(SS_n)[->1]));



endmodule