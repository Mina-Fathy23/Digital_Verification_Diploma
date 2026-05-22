package wrapper_seq_item_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"
  class wrapper_seq_item extends uvm_sequence_item;
    `uvm_object_utils(wrapper_seq_item);

    rand bit rst_n;   
    rand bit SS_n;  
    
    rand bit MOSI;
    
    bit MISO_golden;         
    bit MISO; 

  typedef enum bit [2:0] {WRITE_ADDR = 3'b000, WRITE_DATA = 3'b001, READ_ADDR = 3'b110, READ_DATA = 3'b111} e_state;
 
    rand e_state ns;
		e_state cs;

	  int counter;   // Counter for Serialization
  	int SS_n_cnt;  // Counter for Comminication
	  int WIDTH;     // WIDTH = 13 (cs != READ_DATA) / 23 (cs = READ_DATA)

	  rand bit MOSI_BUS_RAND[];
	
	  bit  MOSI_BUS[]; // [0:1:2]



  constraint rst_n_c { rst_n dist { 0:/2 , 1:/98 }; }

	constraint read_write_c {
		if (!rst_n) {
			ns == e_state'(0);
		}
		else {
			ns inside {WRITE_ADDR,WRITE_DATA,READ_ADDR,READ_DATA};
			if (cs == WRITE_ADDR)
				ns inside {WRITE_ADDR, WRITE_DATA};
			else if (cs == WRITE_DATA)
				ns dist {WRITE_ADDR :/40, READ_ADDR :/60};
			else if (cs == READ_ADDR)
				ns == READ_DATA;
			else if (cs == READ_DATA)
				ns dist {WRITE_ADDR :/60, READ_ADDR :/40};
		}
	}

  constraint read_only_c{
    if (!rst_n){
      ns == e_state'(0); 
    }
    else{
      ns inside {READ_ADDR, READ_DATA};
      if(cs == READ_ADDR)
        ns == READ_DATA;
      else{
        ns == READ_ADDR;
      }
    }
  }

  constraint write_only_c{
    if(!rst_n){
      ns == e_state'(0);
    }
    else{
      ns inside {WRITE_ADDR, WRITE_DATA};
      if(cs == WRITE_ADDR)
        ns == WRITE_DATA;
      else{
        ns inside {WRITE_ADDR, WRITE_DATA};
      }
    }
  }

  
	constraint mosi_c {
		if (!rst_n) {
			MOSI == 0;
		}
		else {
			if (SS_n_cnt != WIDTH)         // MSB      LSB
				MOSI == MOSI_BUS[counter]; // [0:1:2...WIDTH]
		}
	}

	constraint ss_n_c {
		if (!rst_n) {
			SS_n == 1;
		}
		else {
			if (cs != READ_DATA) {
				if (SS_n_cnt < 13)
					SS_n == 0;
				else
					SS_n == 1;
			}
			else {
				if (SS_n_cnt < 23)
					SS_n == 0;
				else
					SS_n == 1;
			}
		}
	}

// Responible for Serialization Counter (counter) & cs reloading
	function void pre_randomize ();
		if (!rst_n) begin
			counter = 0;
		end
		else begin
			if (SS_n_cnt == 0) begin  // OFF COMM
				counter = 0;
				cs = ns;

				if (cs != READ_DATA) begin
					WIDTH = 13;
					MOSI_BUS = new[WIDTH];
					MOSI_BUS_RAND = new[WIDTH];
				end
				else begin
					WIDTH = 23;
					MOSI_BUS = new[WIDTH];
					MOSI_BUS_RAND = new[WIDTH];
				end
			end
			else begin
				// cs constant
				counter = counter + 1;
			end
		end
	endfunction

  	// Responsible for Communication Counter (ss_n_cnt)
	function void post_randomize ();
		if (!rst_n) begin
			SS_n_cnt = 0;
		end
		else begin
			MOSI_BUS = MOSI_BUS_RAND;
			for (int i = 0 ; i < 3 ; i++) begin
				MOSI_BUS [i] = cs[2-i];            // MOSI_BUS[0:2] = cs;
			end 

			if ((cs != READ_DATA) &&  (SS_n_cnt != 13))
				SS_n_cnt += 1;
			else if ((cs == READ_DATA) && (SS_n_cnt != 23))
				SS_n_cnt += 1;
			else
				SS_n_cnt = 0;
		end
	endfunction


function new (string name="wrapper_seq_item") ;
      super.new(name);
    endfunction


  endclass
endpackage

