module WB (MEM_MemtoReg,MEM_RegWrite,MEM_rd_data,MEM_rd_addr,MEM_DO_out,
WB_RegWrite,WB_rd_addr,WB_rd_data);
input logic MEM_MemtoReg,MEM_RegWrite;
input [4:0] MEM_rd_addr;
input [31:0] MEM_rd_data,MEM_DO_out;
output WB_RegWrite;
output [4:0] WB_rd_addr;
output [31:0] WB_rd_data;
assign WB_rd_data = (MEM_MemtoReg == 1'b0)? MEM_rd_data:MEM_DO_out;
assign WB_rd_addr = MEM_rd_addr;
assign WB_RegWrite = MEM_RegWrite;
endmodule