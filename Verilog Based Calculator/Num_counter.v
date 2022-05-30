`timescale 1ns / 1ps

module Num_counter(
input btn,
input rst,
input clk,
output reg[3:0] digit
    );
   
reg push_f;
reg push_sync;
reg push_sync_f;
wire push_edge;

always@(posedge clk) begin
    push_f <= btn;
    push_sync <= push_f;    
end

always @(posedge clk) begin
if (rst) begin
    push_sync_f <= 1'b0;
end else begin
    push_sync_f <= push_sync;
    end
end

assign push_edge = push_sync & ~push_sync_f;

always@(posedge clk) begin
if (rst)
    digit <= 0;
if (push_edge) begin
    if (digit != 9) begin
        digit <= digit + 1; end
    else begin
        digit <= 0; end
    end
end

endmodule