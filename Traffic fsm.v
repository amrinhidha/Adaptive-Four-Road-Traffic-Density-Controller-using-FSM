TRAFFIC FSM
module traffic_fsm ( clk, reset,one_sec_tick, selected_road, max_density, ped_request,emergency,lights, last_served, current_road,ped_clear, pedestrian_walk,countdown);
input wire clk, reset, one_sec_tick, emergency, ped_request;
output wire ped_clear,pedestrian_walk;
input wire [1:0] selected_road;
input wire [1:0] max_density;
output reg [11:0] lights;
output reg [1:0] last_served;
output reg [1:0] current_road;
output wire [4:0] countdown;
// FSM states
localparam ALL_RED = 2'b00;
localparam GREEN   = 2'b01;
localparam YELLOW  = 2'b10;
reg [1:0] state;
reg [4:0] timer_count;
reg ped_walk_active;
reg ped_clear_r;
assign countdown = timer_count;
assign ped_clear = ped_clear_r;
assign pedestrian_walk = ped_walk_active;
// Adaptive green duration
function [4:0] green_duration;
input [1:0] density;
begin
case (density)
2'b00: green_duration = 5'd5;
2'b01: green_duration = 5'd10;
default: green_duration = 5'd15;
endcase
end
endfunction
// FSM sequential logic
always @(posedge clk or posedge reset) begin
if (reset) begin
state <= ALL_RED;
timer_count <= 5'd1;
current_road <= 2'b00;
last_served <= 2'b11;
ped_walk_active <= 1'b0;
ped_clear_r <= 1'b0;
end
else begin
// One-clock-cycle pedestrian clear pulse
ped_clear_r <= 1'b0;
// Emergency override
if (emergency) begin
state <= ALL_RED;
timer_count <= 5'd1;
ped_walk_active <= 1'b0;
ped_clear_r <= 1'b0;
end
else if (one_sec_tick) begin
case (state)
// ALL RED
ALL_RED: begin
if (timer_count > 1) begin
timer_count <= timer_count - 1'b1;
end
else if (ped_request && !ped_walk_active) begin
ped_walk_active <= 1'b1;
ped_clear_r <= 1'b1;
timer_count <= 5'd10;
end
else if (ped_walk_active) begin
ped_walk_active <= 1'b0;
timer_count <= 5'd1;
state <= ALL_RED;
end
else begin
current_road <= selected_road;
timer_count <= green_duration(max_density);
state <= GREEN;
end
end
// GREEN
GREEN: begin
if (timer_count > 1) begin
timer_count <= timer_count - 1'b1;
end
else begin
timer_count <= 5'd3;
last_served <= current_road;
state <= YELLOW;
end
end
// YELLOW
YELLOW: begin
if (timer_count > 1) begin
timer_count <= timer_count - 1'b1;
end
else begin
timer_count <= 5'd1;
state <= ALL_RED;
end
end
default: begin
state <= ALL_RED;
timer_count <= 5'd1;
ped_walk_active <= 1'b0;
ped_clear_r <= 1'b0;
end
endcase
end
end
end
// Moore output logic
// Each road: {Red, Yellow, Green}
// Red = 100, Yellow = 010, Green = 001
always @(*) begin
// All roads RED
lights = 12'b100_100_100_100;
if (!emergency) begin
case (state)
GREEN: begin
case (current_road)
2'b00: lights[2:0] = 3'b001;
2'b01: lights[5:3] = 3'b001;
2'b10: lights[8:6] = 3'b001;
2'b11: lights[11:9] = 3'b001;
endcase
end
YELLOW: begin
 case (current_road)
 2'b00: lights[2:0] = 3'b010;
2'b01: lights[5:3] = 3'b010;
2'b10: lights[8:6] = 3'b010;
 2'b11: lights[11:9] = 3'b010;
endcase
end
default: begin
lights = 12'b100_100_100_100;
end
endcase
end
end
endmodule
