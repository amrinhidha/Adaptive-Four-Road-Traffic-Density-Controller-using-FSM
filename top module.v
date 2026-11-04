
module traffic_top #(
    parameter integer CLK_FREQ = 100_000_000
)(
    input wire clk,
    input wire [15:0] sw,
    input wire [3:0] btn,
    output reg [15:0] led,
    output wire [3:0] D0_AN,
    output wire [7:0] D0_SEG);
    wire [1:0] north, east, south, west;
    wire [1:0] selected_road, max_density;
    wire [1:0] last_served, current_road;
    wire one_sec_tick;
    wire [11:0] lights;
    wire [4:0] countdown;
    wire emergency_active;
    wire ped_request;
    wire pedestrian_walk;
    wire ped_clear;
    wire ped_button_press;
    // Reset synchronizer
    reg reset_sync1, reset_sync2;
    wire reset;
    always @(posedge clk or posedge btn[0]) begin
        if (btn[0]) begin
            reset_sync1 <= 1'b1;
            reset_sync2 <= 1'b1;
        end
        else begin
            reset_sync1 <= 1'b0;
            reset_sync2 <= reset_sync1;
        end
    end
    assign reset = reset_sync2;

    // Density decoder
    density D1 (
        .switches(sw[7:0]),
        .north(north),
        .east(east),
        .south(south),
        .west(west)
    );

    // Priority scheduler
    priority P1 (
        .north(north),
        .east(east),
        .south(south),
        .west(west),
        .last_served(last_served),
        .selected_road(selected_road),
        .max_density(max_density)
    );

    // One-second timer
    timer #(
        .CLK_FREQ(CLK_FREQ)
    ) T1 (
        .clk(clk),
        .reset(reset),
        .one_sec_tick(one_sec_tick)
    );

    // Emergency controller
    emergency E1 (
        .clk(clk),
        .reset(reset),
        .emergency_button(btn[2]),
        .emergency_active(emergency_active)
    );

    // Pedestrian controller
    pedestrian #(
        .CLK_FREQ(CLK_FREQ)
    ) PD1 (
        .clk(clk),
        .reset(reset),
        .ped_button(btn[1]),
        .clear_request(ped_clear),
        .request_pending(ped_request),
        .ped_button_press(ped_button_press)
    );

    // Traffic FSM
    traffic_fsm F1 (
        .clk(clk),
        .reset(reset),
        .one_sec_tick(one_sec_tick),
        .selected_road(selected_road),
        .max_density(max_density),
        .ped_request(ped_request),
        .emergency(emergency_active),
        .lights(lights),
        .last_served(last_served),
        .current_road(current_road),
        .ped_clear(ped_clear),
        .pedestrian_walk(pedestrian_walk),
        .countdown(countdown)
    );

    // Seven-segment display
    seven_seg_countdown #(
        .CLK_FREQ(CLK_FREQ)
    ) SS1 (
        .clk(clk),
        .reset(reset),
        .countdown(countdown),
        .an(D0_AN),
        .seg(D0_SEG)
    );

    // LED mapping
    always @(*) begin
        led = 16'b0;
        led[11:0] = lights;
        led[12] = pedestrian_walk;
        led[13] = emergency_active;
        led[15:14] = 2'b00;
    end

endmodule
