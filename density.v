DENSITY
module density (
input wire [7:0] switches,
output reg [1:0] north,
output reg [1:0] east,
output reg [1:0] south,
output reg [1:0] west);
always @(*) begin
north = switches[1:0];
east  = switches[3:2];
south = switches[5:4];
west  = switches[7:6];
end
endmodule
