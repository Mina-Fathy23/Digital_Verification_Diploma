module arbiter_SVA();
    
    property p_request_grant;
        @(posedge clk) $rose(request) |-> ##[2:5] $rose(grant);
    endproperty

    property p_grant_ack;
        @(posedge clk) $rose(grant) |-> ($fell(frame) && $fell(irdy));
    endproperty

    property p_complete_transaction;
        @(posedge clk) ($rose(frame) && $rose(irdy)) |=> $fell(grant);
    endproperty

endmodule