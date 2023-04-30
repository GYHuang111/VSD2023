module InstructionRegister(clk,rst,ID_IRWrite,Stall_IRWrite,instret);
input clk,rst,ID_IRWrite,Stall_IRWrite;
output logic [63:0] instret;
logic [63:0] instret_next;
assign instret_next = instret+64'd1;

always_ff @(posedge clk or posedge rst)
begin
   if (rst)
   begin
      instret <= 64'd0;
   end
   else if(ID_IRWrite & Stall_IRWrite)
   begin
      instret <= instret_next;
   end
end

endmodule