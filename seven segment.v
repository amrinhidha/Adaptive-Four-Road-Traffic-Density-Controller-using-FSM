SEVEN SEGMENT 
module seven_seg_countdown #(
    parameter integer CLK_FREQ = 100_000_000)
(input wire clk,
 input wire reset,
 input wire [4:0] countdown,
 output reg [3:0] an,
 output reg [7:0] seg);
reg [3:0] tens;
reg [3:0] ones;
always @(*) begin
case (countdown)
5'd0:  begin tens = 0; ones = 0; end
5'd1:  begin tens = 0; ones = 1; end
5'd2:  begin tens = 0; ones = 2; end
5'd3:  begin tens = 0; ones = 3; end
5'd4:  begin tens = 0; ones = 4; end
5'd5:  begin tens = 0; ones = 5; end
5'd6:  begin tens = 0; ones = 6; end
5'd7:  begin tens = 0; ones = 7; end
5'd8:  begin tens = 0; ones = 8; end
5'd9:  begin tens = 0; ones = 9; end
5'd10: begin tens = 1; ones = 0; end
5'd11: begin tens = 1; ones = 1; end
5'd12: begin tens = 1; ones = 2; end
5'd13: begin tens = 1; ones = 3; end
5'd14: begin tens = 1; ones = 4; end
default: begin
tens = 1;
ones = 5;
end
endcase
end
localparam integer REFRESH_DIV = CLK_FREQ / 2000;
localparam integer REFRESH_W =
(REFRESH_DIV <= 1) ? 1 : $clog2(REFRESH_DIV);
reg [REFRESH_W-1:0] refresh_cnt;
reg digit_sel;
always @(posedge clk or posedge reset) begin
if (reset) begin
refresh_cnt <= 0;
digit_sel <= 1'b0;
end
else if (refresh_cnt == REFRESH_DIV - 1) begin
refresh_cnt <= 0;
digit_sel <= ~digit_sel;
end
else begin
refresh_cnt <= refresh_cnt + 1'b1;
end
end
always @(*) begin
an = 4'b1111;
if (digit_sel == 1'b0)
an[0] = 1'b0;
else
an[1] = 1'b0;
end
reg [6:0] pattern;
always @(*) begin
if (digit_sel == 1'b0) begin
case (ones)
4'd0: pattern = 7'b1000000;
4'd1: pattern = 7'b1111001;
4'd2: pattern = 7'b0100100;
4'd3: pattern = 7'b0110000;
4'd4: pattern = 7'b0011001;
4'd5: pattern = 7'b0010010;
4'd6: pattern = 7'b0000010;
4'd7: pattern = 7'b1111000;
4'd8: pattern = 7'b0000000;
4'd9: pattern = 7'b0010000;
default: pattern = 7'b1111111;
endcase
end
else begin
case (tens)
4'd0: pattern = 7'b1000000;
4'd1: pattern = 7'b1111001;
default: pattern = 7'b1111111;
endcase
end
end
always @(*) begin
seg = 8'b11111111;
seg[6:0] = pattern;
end
endmodule

