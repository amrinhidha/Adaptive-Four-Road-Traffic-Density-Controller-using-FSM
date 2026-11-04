PEDESTRIAN
module pedestrian #(
parameter integer CLK_FREQ = 100_000_000,
parameter integer DEBOUNCE_MS = 20)
( input wire clk,
  input wire reset,
  input wire ped_button,
  input wire clear_request,
  output reg request_pending,
  output wire ped_button_press);
localparam integer DEBOUNCE_LIMIT = (CLK_FREQ / 1000) * DEBOUNCE_MS;
localparam integer CNT_WIDTH = (DEBOUNCE_LIMIT <= 1) ? 1 : $clog2(DEBOUNCE_LIMIT);
localparam [CNT_WIDTH-1:0] DEBOUNCE_LAST = DEBOUNCE_LIMIT - 1;
reg button_sync1;
reg button_sync2;
always @(posedge clk or posedge reset) begin
if (reset) begin
button_sync1 <= 1'b0;
button_sync2 <= 1'b0;
end
else begin
button_sync1 <= ped_button;
button_sync2 <= button_sync1;
end
end
reg [CNT_WIDTH-1:0] debounce_cnt;
reg button_stable;
always @(posedge clk or posedge reset) begin
if (reset) begin
debounce_cnt <= 0;
button_stable <= 1'b0;
end
else if (button_sync2 == button_stable) begin
debounce_cnt <= 0;
end
else if (debounce_cnt == DEBOUNCE_LAST) begin
button_stable <= button_sync2;
debounce_cnt <= 0;
end
else begin
debounce_cnt <= debounce_cnt + 1'b1;
end
end
reg button_previous;
reg button_press_r;
always @(posedge clk or posedge reset) begin
if (reset) begin
button_previous <= 1'b0;
button_press_r <= 1'b0;
end
else begin
button_previous <= button_stable;
button_press_r <= button_stable & ~button_previous;
end
end
always @(posedge clk or posedge reset) begin
if (reset)
request_pending <= 1'b0;
else if (clear_request)
request_pending <= 1'b0;
else if (button_press_r)
request_pending <= 1'b1;
end
endmodule
