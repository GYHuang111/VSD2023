module CycleRegister(clk,rst,Stall_CRWrite,cycle);

input clk,rst,Stall_CRWrite;
output logic [63:0] cycle;

logic [63:0] cycle_next;
assign cycle_next = cycle + 64'd1;

always_ff @(posedge clk or posedge rst)
begin
   if(rst)
   begin
      cycle <= 64'd0;
   end
   else if
   (Stall_CRWrite)
   begin
      cycle <= cycle_next;
   end
end
endmodule