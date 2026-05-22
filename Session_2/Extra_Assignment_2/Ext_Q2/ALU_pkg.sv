package ALU_pkg;

    typedef enum logic [1:0] {ADD, SUB, NOT_A, ReductionOR_B} OPCODE_e;

    class ALU_Inputs;

        rand logic               reset;
        rand OPCODE_e            Opcode;	// The opcode
        rand logic  signed [3:0] A;	// Input data A in 2's complement
        rand logic  signed [3:0] B;	// Input data B in 2's complement

        function new(logic reset = 0, logic signed A = 0, B = 0, OPCODE_e Opcode = ADD);

            this.reset = reset;
            this.A = A;
            this.B = B;
            this.Opcode = Opcode;
            
        endfunction //new()

        constraint c_reset{
            reset dist{0:/95, 1:/5};
        }
    endclass //ALU_Inputs




endpackage