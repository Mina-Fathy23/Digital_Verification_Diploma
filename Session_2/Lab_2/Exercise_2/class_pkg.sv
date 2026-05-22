package class_pkg;

    class MemTrans;
        rand logic [3:0] address;
        rand logic [7:0] data_in;

        constraint c_data_in {
            data_in == 5;
        }

        constraint c_address {
            address dist{0:/10, [1:14]:/80, 15:/10};
        }

        function new(logic [7:0] data_in = 0, logic [3:0] address = 0);
            this.data_in = data_in;
            this.address = address;
    
        endfunction
        
        function void display();
            $display("Address:%0h, Data in:%0h", this.address, this.data_in);
            
        endfunction

        endclass
    
endpackage