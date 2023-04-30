`include "ProgramCounter.sv"

module IF(clk,rst,instruction_flush,PC_write,IF_regwrite,BranchControl,
pc_immrs1,pc_imm,instruction,pc_out,IF_pc_out,IF_instruction_out,cycle,IF_cycle);
input clk,rst,instruction_flush,PC_write,IF_regwrite;
input [63:0] cycle;
input [1:0] BranchControl;
input [31:0] pc_immrs1,pc_imm,instruction;
output logic [31:0] IF_pc_out,IF_instruction_out;
output [31:0] pc_out;
output logic [63:0] IF_cycle;
logic [31:0] instruction_out,pc_out;
logic [31:0] pc_in;

parameter 	PCIMMRS1	= 2'd1,
			PCIMM		= 2'd2;

ProgramCounter PC (
.clk(clk),
.rst(rst),
.PC_write(PC_write),
.pc_in(pc_in),
.pc_out(pc_out)
);

always_comb
begin
	case (BranchControl)
		PCIMMRS1:
			pc_in=pc_immrs1;
		PCIMM:
			pc_in=pc_imm;
		default:
			pc_in=pc_out+32'd4;
	endcase	
end

assign instruction_out = (instruction_flush)?32'd0:instruction;
 
always_ff @(posedge clk or posedge rst)
begin
	if (rst)
	begin
		IF_pc_out <= 32'd0;
		IF_instruction_out <= 32'd0;
		IF_cycle <= 64'd0;
	end
	else if (IF_regwrite)
	begin
		IF_pc_out <= pc_out;
		IF_instruction_out <= instruction_out;
		IF_cycle <= cycle;
	end
end

endmodule