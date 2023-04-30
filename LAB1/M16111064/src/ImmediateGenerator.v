module ImmediateGenerator (imm_type,IF_instruction_out,imm);
input [2:0] imm_type;
input wire [24:0] IF_instruction_out;//[31:0] IF_instruction_out;
output[31:0] imm;
reg [31:0] imm;
parameter I_immediate=3'd0,S_immediate=3'd1,B_immediate=3'd2,U_immediate=3'd3,J_immediate=3'd4,CSR_immediate=3'd5;
always @(*) begin
case (imm_type)
	//3'd0:imm=32'd0;																																	//R
	I_immediate:imm={{20{IF_instruction_out[24]}},IF_instruction_out[24:13]};																				//I
	S_immediate:imm={{20{IF_instruction_out[24]}},IF_instruction_out[24:18],IF_instruction_out[4:0]};														//S
	B_immediate:imm={{19{IF_instruction_out[24]}},IF_instruction_out[24],IF_instruction_out[0],IF_instruction_out[23:18],IF_instruction_out[4:1],1'b0};		//B
	U_immediate:imm={IF_instruction_out[24:5],12'd0};																										//U
	J_immediate:imm={{11{IF_instruction_out[24]}},IF_instruction_out[24],IF_instruction_out[12:5],IF_instruction_out[13],IF_instruction_out[23:14],1'b0};	//J
	CSR_immediate:imm={20'd0,IF_instruction_out[24:13]};
	/*
	I_immediate:imm={{20{IF_instruction_out[31]}},IF_instruction_out[31:20]};																				//I
	S_immediate:imm={{20{IF_instruction_out[31]}},IF_instruction_out[31:25],IF_instruction_out[11:7]};														//S
	B_immediate:imm={{19{IF_instruction_out[31]}},IF_instruction_out[31],IF_instruction_out[7],IF_instruction_out[30:25],IF_instruction_out[11:8],1'b0};		//B
	U_immediate:imm={IF_instruction_out[31:12],12'd0};																										//U
	J_immediate:imm={{11{IF_instruction_out[31]}},IF_instruction_out[31],IF_instruction_out[19:12],IF_instruction_out[20],IF_instruction_out[30:21],1'b0};	//J
	CSR_immediate:imm={20'd0,IF_instruction_out[31:20]};
	*/
	default:imm=32'd0;	
endcase	
end
endmodule