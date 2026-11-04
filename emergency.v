EMERGENCY
module emergency (clk, reset, emergency_button,emergency_active);
input wire clk;
input wire reset;
input wire emergency_button;
output reg emergency_active;
reg emergency_sync1;
reg emergency_sync2;
always @(posedge clk or posedge reset) begin
 if (reset) begin
emergency_sync1 <= 1'b0;
emergency_sync2 <= 1'b0;
emergency_active <= 1'b0;
end
else begin
emergency_sync1 <= emergency_button;
emergency_sync2 <= emergency_sync1;
emergency_active <= emergency_sync2;
end
end
endmodule
