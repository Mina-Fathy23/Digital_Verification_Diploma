module ALSU_golden_2 #(
    parameter INPUT_PRIORITY = "A",
    parameter FULL_ADDER     = "ON"
)(
    input clk, rst, cin, serial_in, red_op_A, red_op_B, bypass_A, bypass_B, direction,
    input signed [2:0] A, B,
    input [2:0] opcode,
    output reg signed [5:0] out_DFF,
    output reg [15:0] leds
);

    wire cin_DFF, serial_in_DFF, red_op_A_DFF, red_op_B_DFF;
    wire bypass_A_DFF, bypass_B_DFF, direction_DFF;
    wire signed [2:0] A_DFF, B_DFF;
    wire [2:0] opcode_DFF;
    reg signed [5:0] out;

    D_FF #(.WIDTH(1))   dff_cin       (.D(cin),        .rst(rst), .CLK(clk), .Q(cin_DFF));
    D_FF #(.WIDTH(1))   dff_serial    (.D(serial_in),  .rst(rst), .CLK(clk), .Q(serial_in_DFF));
    D_FF #(.WIDTH(1))   dff_redA      (.D(red_op_A),   .rst(rst), .CLK(clk), .Q(red_op_A_DFF));
    D_FF #(.WIDTH(1))   dff_redB      (.D(red_op_B),   .rst(rst), .CLK(clk), .Q(red_op_B_DFF));
    D_FF #(.WIDTH(1))   dff_bypassA   (.D(bypass_A),   .rst(rst), .CLK(clk), .Q(bypass_A_DFF));
    D_FF #(.WIDTH(1))   dff_bypassB   (.D(bypass_B),   .rst(rst), .CLK(clk), .Q(bypass_B_DFF));
    D_FF #(.WIDTH(1))   dff_dir       (.D(direction),  .rst(rst), .CLK(clk), .Q(direction_DFF));
    D_FF #(.WIDTH(3))   dff_A         (.D(A),          .rst(rst), .CLK(clk), .Q(A_DFF));
    D_FF #(.WIDTH(3))   dff_B         (.D(B),          .rst(rst), .CLK(clk), .Q(B_DFF));
    D_FF #(.WIDTH(3))   dff_op        (.D(opcode),     .rst(rst), .CLK(clk), .Q(opcode_DFF));

    always @(*) begin
        out = 0;

        if (rst)
            out = 0;
        else if (bypass_A_DFF && bypass_B_DFF) begin
            if (INPUT_PRIORITY == "A")
                out = A_DFF;
            else
                out = B_DFF;
        end else if (bypass_A_DFF)
            out = A_DFF;
        else if (bypass_B_DFF)
            out = B_DFF;
        else begin
            case (opcode_DFF)
                3'b000: begin
                    if (red_op_A_DFF && red_op_B_DFF)
                        out = (INPUT_PRIORITY == "A") ? |A_DFF : |B_DFF;
                    else if (red_op_A_DFF)
                        out = |A_DFF;
                    else if (red_op_B_DFF)
                        out = |B_DFF;
                    else
                        out = A_DFF | B_DFF;
                end

                3'b001: begin
                    if (red_op_A_DFF && red_op_B_DFF)
                        out = (INPUT_PRIORITY == "A") ? ^A_DFF : ^B_DFF;
                    else if (red_op_A_DFF)
                        out = ^A_DFF;
                    else if (red_op_B_DFF)
                        out = ^B_DFF;
                    else
                        out = A_DFF ^ B_DFF;
                end

                3'b010: begin
                    if (FULL_ADDER == "ON")
                        out = A_DFF + B_DFF + cin_DFF;
                    else
                        out = A_DFF + B_DFF;
                end

                3'b011:
                    out = A_DFF * B_DFF;

                3'b100: begin  // Logical shift
                    if (direction_DFF)
                        out = {out_DFF[4:0], serial_in_DFF};  // Left
                    else
                        out = {serial_in_DFF, out_DFF[5:1]};  // Right
                end

                3'b101: begin  // Rotate
                    if (direction_DFF)
                        out = {out_DFF[4:0], out_DFF[5]};  // Left
                    else
                        out = {out_DFF[0], out_DFF[5:1]};  // Right
                end

                default:
                    out = 0;
            endcase
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            out_DFF <= 0;
            leds <= 0;
        end else if (opcode_DFF == 3'b110 || opcode_DFF == 3'b111) begin
                if (bypass_A_DFF && bypass_B_DFF)
                    out_DFF <= (INPUT_PRIORITY == "A")? A_DFF: B_DFF;
                else if (bypass_A_DFF)
                    out_DFF <= A_DFF;
                else if (bypass_B_DFF)
                    out_DFF <= B_DFF;
                else
                    out_DFF <= 0;
            leds <= 16'hFFFF;
        end else if ((red_op_A_DFF || red_op_B_DFF) && !(opcode_DFF == 3'b000 || opcode_DFF == 3'b001)) begin
                if (bypass_A_DFF && bypass_B_DFF)
                    out_DFF <= (INPUT_PRIORITY == "A")? A_DFF: B_DFF;
                else if (bypass_A_DFF)
                    out_DFF <= A_DFF;
                else if (bypass_B_DFF)
                    out_DFF <= B_DFF;
                else
                    out_DFF <= 0;
            leds <= 16'hFFFF;
        end else begin
            out_DFF <= out;
            leds <= 0;
        end
    end

endmodule
