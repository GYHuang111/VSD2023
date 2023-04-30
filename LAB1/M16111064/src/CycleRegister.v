module CycleRegister(clk,rst,cycle);
input clk,rst;
output reg [63:0] cycle;
wire [63:0] cycle_next;
assign cycle_next = cycle + 64'd1;
always @(posedge clk or posedge rst) begin
if (rst) begin
   cycle <= 64'd0;
end
else begin
   cycle <= cycle_next;
end
end
endmodule