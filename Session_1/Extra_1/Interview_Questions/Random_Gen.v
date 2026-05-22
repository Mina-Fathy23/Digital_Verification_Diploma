module tb_try ();

integer a;
integer temp;

initial begin
    repeat(30)begin

        temp = ($random & 3'b111) % 7;
        a = 8 + (temp * 2);
        
        $display("a = %0d", a);
    end
end
    
endmodule