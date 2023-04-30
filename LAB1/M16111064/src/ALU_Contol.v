module ALU_Contol (ID_ALUOP,ID_funct3,ID_funct7,ALU_Ctrl);
input [2:0] ID_ALUOP,ID_funct3;
input [6:0] ID_funct7;
output reg [4:0] ALU_Ctrl;
parameter R_type=3'd0,I_type=3'd1,S_type=3'd2,B_type=3'd3,LUI_type=3'd4,J_type=3'd5,JALR_type=3'd6,ADD_type=3'd7;
parameter ADD=5'd0,SUB=5'd1,SLL=5'd2,SLT=5'd3,SLTU=5'd4,XOR=5'd5,SRL=5'd6,SRA=5'd7,OR=5'd8,AND=5'd9,JALR=5'd10,
BEQ=5'd11,BNE=5'd12,BLT=5'd13,BGE=5'd14,BLTU=5'd15,BGEU=5'd16,IMM=5'd17;
always @ (*) begin
	case (ID_ALUOP)
		R_type:begin
			case (ID_funct3)
				3'b000:begin
					if(ID_funct7==7'd0) begin
						ALU_Ctrl=ADD;
					end
					else begin
						ALU_Ctrl=SUB;
					end
				end
				3'b001:begin
					ALU_Ctrl=SLL;
				end
				3'b010:begin
					ALU_Ctrl=SLT;
				end
				3'b011:begin
					ALU_Ctrl=SLTU;
				end
				3'b100:begin
					ALU_Ctrl=XOR;
				end
				3'b101:begin
					if(ID_funct7==7'd0) begin
						ALU_Ctrl=SRL;
					end
					else begin
						ALU_Ctrl=SRA;
					end
				end
				3'b110:begin
					ALU_Ctrl=OR;
				end
				default:begin
					ALU_Ctrl=AND;
				end
			endcase	
		end
		I_type:begin
			case (ID_funct3)
				3'b000:begin
					ALU_Ctrl=ADD;
				end
				3'b001:begin
					ALU_Ctrl=SLL;
				end
				3'b010:begin
					ALU_Ctrl=SLT;
				end
				3'b011:begin
					ALU_Ctrl=SLTU;
				end
				3'b100:begin
					ALU_Ctrl=XOR;
				end
				3'b101:begin
					if(ID_funct7==7'd0) begin
						ALU_Ctrl=SRL;
					end
					else begin
						ALU_Ctrl=SRA;
					end
				end
				3'b110:begin
					ALU_Ctrl=OR;
				end
				default:begin
					ALU_Ctrl=AND;
				end
			endcase				
		end
		ADD_type:begin
			ALU_Ctrl=ADD;
		end
		JALR_type:begin
			ALU_Ctrl=JALR;
		end
		B_type:begin
			case(ID_funct3)
				3'b000:ALU_Ctrl=BEQ;
				3'b001:ALU_Ctrl=BNE;
				3'b100:ALU_Ctrl=BLT;
				3'b101:ALU_Ctrl=BGE;
				3'b110:ALU_Ctrl=BLTU;
				default:ALU_Ctrl=BGEU;
			endcase
		end
		default:begin
			ALU_Ctrl=IMM;//LUI
			end
	endcase	
end
endmodule 