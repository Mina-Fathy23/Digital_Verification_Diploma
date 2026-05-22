package pkg;
    class MemTrans;
        logic [7:0] data_in;
        logic [3:0] address;
        
        function new(logic [7:0] data_in = 0, logic [3:0] address = 0);
            this.data_in = data_in;
            this.address = address;
        
        endfunction

        function void print();
            $display("Address = %0h, data in = %0h", this.address, this.data_in);
            
        endfunction
    endclass

endpackage

