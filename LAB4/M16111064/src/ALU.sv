module ALU ( ID_ALUSrc,ID_pc_out,ID_PCtoRegSrc,Fowardingrs1,Fowardingrs2,ALU_Ctrl,ID_rs1,
ID_rs2,MEM_rd_data_next,WB_rd_data,ID_imm,Zero_flag,ALU_out,
ID_pctoreg,pc_imm,pc_immrs1,rs2_1,rs1);

input ID_PCtoRegSrc,ID_ALUSrc;
input [1:0] Fowardingrs1,Fowardingrs2;
input [4:0] ALU_Ctrl;
input [31:0] ID_rs1,ID_rs2,MEM_rd_data_next,WB_rd_data,ID_imm,ID_pc_out;
output logic Zero_flag;
output logic [31:0] ALU_out;
output logic [31:0] ID_pctoreg,pc_imm,pc_immrs1;
output logic [31:0] rs2_1;
output logic [31:0] rs1;
logic [31:0] rs2;
logic signed [31:0] rs1_signed,rs2_signed;
logic [31:0] sum,wire_pc_imm,wire_pc_4;

parameter 	ADD		= 5'd0,
			SUB		= 5'd1,
			SLL		= 5'd2,
			SLT		= 5'd3,
			SLTU	= 5'd4,
			XOR		= 5'd5,
			SRL		= 5'd6,
			SRA		= 5'd7,
			OR		= 5'd8,
			AND		= 5'd9,
			JALR	= 5'd10,
			BEQ		= 5'd11,
			BNE		= 5'd12,
			BLT		= 5'd13,
			BGE		= 5'd14,
			BLTU	= 5'd15,
			BGEU	= 5'd16,
			IMM		= 5'd17;

assign wire_pc_imm = ID_pc_out + ID_imm; // for ALU
assign wire_pc_4 = ID_pc_out + 4;
assign ID_pctoreg = (ID_PCtoRegSrc) ? wire_pc_imm : wire_pc_4;
assign pc_imm = ID_pc_out + ID_imm; // for IF
assign pc_immrs1 = ALU_out;

always_comb
begin
	case(Fowardingrs1)
		2'b00:
			rs1 = ID_rs1;
		2'b01:
			rs1 = MEM_rd_data_next;
		default:// 2'b10
			rs1 = WB_rd_data;
	endcase 
end

always_comb
begin
	case(Fowardingrs2)
		2'b00:
			rs2_1 = ID_rs2;
		2'b01:
			rs2_1 = MEM_rd_data_next;
		default:// 2'b10
			rs2_1 = WB_rd_data;
	endcase 
end

always_comb
begin
	if(ID_ALUSrc)
		rs2 = rs2_1;
	else
		rs2 = ID_imm;
end

assign rs1_signed = rs1;
assign rs2_signed = rs2;
assign sum = rs1 + rs2;

always_comb
begin
	case (ALU_Ctrl)
		ADD:	ALU_out = sum;
		SUB:	ALU_out = rs1 - rs2;
		SLL:	ALU_out = rs1 << (rs2[4:0]);
		SLT:	ALU_out = (rs1_signed<rs2_signed)?32'd1:32'd0;
		SLTU:	ALU_out = (rs1<rs2)?32'd1:32'd0;
		XOR:	ALU_out = rs1 ^ rs2;
		SRL:	ALU_out = rs1 >> (rs2[4:0]);
		SRA:	ALU_out = rs1_signed >>> (rs2[4:0]);
		OR:		ALU_out = rs1 | rs2;
		AND:	ALU_out = rs1 & rs2;
		JALR:	ALU_out = {sum[31:1],1'b0};
		IMM:	ALU_out = rs2;
		default:ALU_out = 32'd0;
	endcase	
end

always_comb
begin
	case (ALU_Ctrl)
		BEQ:Zero_flag=(rs1==rs2)?1'b1:1'b0;
		BNE:Zero_flag=(rs1!=rs2)?1'b1:1'b0;
		BLT:Zero_flag=(rs1_signed<rs2_signed)?1'b1:1'b0;
		BGE:Zero_flag=(rs1_signed>=rs2_signed)?1'b1:1'b0;
		BLTU:Zero_flag=(rs1<rs2)?1'b1:1'b0;
		default:Zero_flag=(rs1>=rs2)?1'b1:1'b0;
	endcase
end

endmodule