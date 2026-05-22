class questa_constraint;
  rand bit [7:0] a, b;

  constraint twice {
    b == 2 * a;
    a + b < 50
  }
endclass

module tb;
  questa_constraint obj = new();

  initial begin
    repeat (5) begin
      void'(obj.randomize());
      $display("a=%0d, b=%0d, sum=%0d", obj.a, obj.b, obj.a + obj.b);
    end
  end
endmodule