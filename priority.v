PRIORITY
module priority (north, east,south,west,last_served,selected_road,max_density);
  input wire [1:0] north;
  input wire [1:0] east;
  input wire [1:0] south;
  input wire [1:0] west;
  input wire [1:0] last_served;
  output reg [1:0] selected_road;
  output reg [1:0] max_density;
reg [1:0] road_density [0:3];
integer start_index;
integer k;
integer idx;
function [1:0] normalize;
input [1:0] d;
begin
case (d)
2'b00: normalize = 2'b00;
2'b01: normalize = 2'b01;
default: normalize = 2'b10;
endcase
end
endfunction
always @(*) begin
road_density[0] = normalize(north);
road_density[1] = normalize(east);
road_density[2] = normalize(south);
road_density[3] = normalize(west);
if (start_index >= 4)
start_index = 0;
selected_road = start_index[1:0];
max_density = road_density[start_index];
for (k = 1; k < 4; k = k + 1) 
begin
idx = start_index + k;
if (idx >= 4)
idx = idx - 4;
if (road_density[idx] > max_density) begin
max_density = road_density[idx];
selected_road = idx[1:0];
end
end
end
endmodule
module timer #(parameter integer CLK_FREQ = 100_000_000)
(input wire clk,
input wire reset,
output reg one_sec_tick);
reg [31:0] counter;
always @(posedge clk or posedge reset) begin
if (reset) begin
counter <= 32'd0;
one_sec_tick <= 1'b0;
end
else begin
if (counter == CLK_FREQ - 1) begin
counter <= 32'd0;
one_sec_tick <= 1'b1;
end
else begin
counter <= counter + 1'b1;
one_sec_tick <= 1'b0;
end
end
end
endmodule
