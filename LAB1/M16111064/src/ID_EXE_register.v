module ID_EXE_register (clk,rst,CtrlSignalFlush,PCtoRegSrc,ALUSrc,RDSrc,MemtoReg,MemWrite,MemRead,RegWrite,
Branch,ALUOP,IF_pc_out,rs1_data,rs2_data,imm,IF_instruction_out,ID_PCtoRegSrc,ID_ALUSrc,ID_RDSrc,ID_MemtoReg,
ID_MemWrite,ID_MemRead,ID_RegWrite,ID_Branch,ID_ALUOP,ID_pc_out,ID_rs1,ID_rs2,ID_imm,
ID_funct3,ID_funct7,ID_rd_addr,ID_rs1_addr,ID_rs2_addr,rs1_addr,rs2_addr,IF_cycle,ID_cycle,CSRtoRegSrc,
ID_CSRtoRegSrc,ID_IRWrite,IRWrite);
input clk,rst,CtrlSignalFlush,CSRtoRegSrc;
input PCtoRegSrc,ALUSrc,RDSrc,MemtoReg,MemWrite,MemRead,RegWrite,IRWrite;
input [63:0] IF_cycle;
input [1:0] Branch;
input [2:0] ALUOP;
input [31:0] IF_pc_out,rs1_data,rs2_data,imm;//,IF_instruction_out
input [24:0] IF_instruction_out;//no
output reg ID_PCtoRegSrc,ID_ALUSrc,ID_RDSrc,ID_MemtoReg,ID_MemWrite,ID_MemRead,
ID_RegWrite,ID_CSRtoRegSrc,ID_IRWrite;
output reg [1:0] ID_Branch;
output reg [2:0] ID_ALUOP;
output reg [2:0] ID_funct3;
output reg [6:0] ID_funct7;
output reg [4:0] ID_rd_addr,ID_rs1_addr,ID_rs2_addr;
output reg [31:0] ID_pc_out,ID_rs1,ID_rs2,ID_imm;
output reg [63:0] ID_cycle;
output wire [4:0] rs1_addr,rs2_addr;
assign rs1_addr = IF_instruction_out[12:8];//IF_instruction_out[19:15];
assign rs2_addr = IF_instruction_out[17:13];//IF_instruction_out[24:20];
always @ (posedge clk or posedge rst) begin
	if (rst) begin
		ID_pc_out 		<=32'd0;
		ID_rs1 			<=32'd0;
		ID_rs2			<=32'd0;
		ID_imm			<=32'd0;
		ID_funct3		<=3'd0;
		ID_funct7		<=7'd0;
		ID_rd_addr		<=5'd0;
		ID_rs1_addr		<=5'd0;
		ID_rs2_addr		<=5'd0;
		ID_cycle        <=64'd0;
		
		ID_ALUOP		<=3'd0;
		ID_PCtoRegSrc	<=1'd0;
		ID_ALUSrc		<=1'd0;
		ID_RDSrc		<=1'd0;
		ID_MemtoReg		<=1'd0;
		ID_MemWrite		<=1'd0;
		ID_MemRead		<=1'd0;
		ID_RegWrite		<=1'd0;
		ID_Branch		<=2'd0;		
		ID_IRWrite      <=1'd0;
		ID_CSRtoRegSrc  <=1'b0;
	end
	else begin
		ID_pc_out 		<=IF_pc_out;
		ID_rs1 			<=rs1_data;
		ID_rs2			<=rs2_data;
		ID_imm			<=imm;
		ID_funct3		<=IF_instruction_out[7:5];//IF_instruction_out[14:12];
		ID_funct7		<=IF_instruction_out[24:18];//IF_instruction_out[31:25];
		ID_rd_addr		<=IF_instruction_out[4:0];//IF_instruction_out[11:7];
		ID_rs1_addr		<=IF_instruction_out[12:8];//IF_instruction_out[19:15];
		ID_rs2_addr		<=IF_instruction_out[17:13];//IF_instruction_out[24:20];
		ID_cycle        <=IF_cycle;
		
		ID_ALUOP		<=ALUOP;
		ID_PCtoRegSrc	<=PCtoRegSrc;
		ID_ALUSrc		<=ALUSrc;
		ID_RDSrc		<=RDSrc;
		ID_MemtoReg		<=MemtoReg;
		ID_MemWrite		<=(CtrlSignalFlush)?1'b0:MemWrite;
		ID_MemRead		<=(CtrlSignalFlush)?1'b0:MemRead;
		ID_RegWrite		<=(CtrlSignalFlush)?1'b0:RegWrite;
		ID_Branch		<=(CtrlSignalFlush)?2'b0:Branch;	
		ID_IRWrite      <=(CtrlSignalFlush)?1'b0:IRWrite;
		ID_CSRtoRegSrc  <=CSRtoRegSrc;
	end
end
endmodule