module FSM_SVA();

    property p_current_onehot;
        @(posedge clk) $onehot(cs);
    endproperty
    
    //Assuming that "IDLE", "GEN_BLK_ADDR" and "WAITO" are predefined parameters
    property p_idle_get_data;
        @(posedge clk) ((cs == IDLE) && $rose(get_data)) |-> ##1 (cs == GEN_BLK_ADDR) ##64 (cs == WAITO);
    endproperty

endmodule