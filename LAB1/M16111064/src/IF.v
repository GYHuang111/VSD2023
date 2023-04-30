`include "ProgramCounter.v"
module IF(clk,rst,instruction_flush,PC_write,IF_regwrite,BranchControl,
pc_immrs1,pc_imm,instruction,pc_out,IF_pc_out,IF_instruction_out,cycle,IF_cycle);
input clk,rst,instruction_flush,PC_write,IF_regwrite;
input [63:0] cycle;
input [1:0] BranchControl;
input [31:0] pc_immrs1,pc_imm,instruction;
output reg [31:0] IF_pc_out,IF_instruction_out;
output [31:0] pc_out;
output reg [63:0] IF_cycle;
wire [31:0] instruction_out,pc_out;
reg [31:0] pc_in;
parameter PCIMMRS1=2'd1,PCIMM=2'd2;
ProgramCounter PC (
.clk(clk),
.rst(rst),
.PC_write(PC_write),
.pc_in(pc_in),
.pc_out(pc_out)
);

always @ (*) begin
	case (BranchControl)
		PCIMMRS1:pc_in=pc_immrs1;
		PCIMM:pc_in=pc_imm;
		default:pc_in=pc_out+32'd4;
	endcase	
end

assign instruction_out = (instruction_flush)?32'd0:instruction;
 
always @ (posedge clk or posedge rst) begin
	if (rst) begin
		IF_pc_out <= 32'd0;
		IF_instruction_out <= 32'd0;
		IF_cycle <= 64'd0;
	end
	else if (IF_regwrite) begin
		IF_pc_out <= pc_out;
		IF_instruction_out <= instruction_out;
		IF_cycle <= cycle;
	end
end

endmodule
////////////////////////////////////////////////////////////////
module RegisterFile (clk,rst,WB_RegWrite,WB_rd_addr,IF_instruction_out,WB_rd_data,rs1_data,rs2_data);
input clk,rst,WB_RegWrite;
input [4:0]  WB_rd_addr;
input [9:0] IF_instruction_out;
input [31:0] WB_rd_data;
output [31:0] rs1_data,rs2_data;
wire [4:0] rs1_addr,rs2_addr,WB_rd_addr;
wire [31:0] rs1_data,rs2_data;
reg [31:0] Register [31:0];

assign rs1_addr = IF_instruction_out[4:0];
assign rs2_addr = IF_instruction_out[9:5];
assign rs1_data = Register[rs1_addr];
assign rs2_data = Register[rs2_addr];

always @ (posedge clk or posedge rst) begin
	if (rst) begin
		for (int i = 0;i<32;i++) begin
			Register[i] <= 32'd0;
		end
	end
	else begin
		if (WB_RegWrite && (WB_rd_addr != 5'd0)) begin //dont save to r0
		Register[WB_rd_addr] <= WB_rd_data;
		end
	end	
end

endmodule