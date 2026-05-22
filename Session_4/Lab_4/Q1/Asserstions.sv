
assert property (@(posedge clk) $rose(signal_a) |=> $fell(signal_b) [->1]);

assert property (@(posedge clk) valid |=> (wr_ack throughout done[->1]));

assert property (@(posedge clk) $rose(req) |=> (ack[->1] ##1 !ack));