module Control_unit (opcode,PCtoRegSrc,ALUSrc,RDSrc,MemtoReg,MemWrite,MemRead,RegWrite,Branch,imm_type,ALUOP,CSRtoRegSrc,IRWrite);
input [6:0] opcode;
output reg PCtoRegSrc,ALUSrc,RDSrc,MemtoReg,MemWrite,MemRead,RegWrite,CSRtoRegSrc,IRWrite;
output reg [1:0] Branch;
output reg [2:0] imm_type,ALUOP;
parameter I_immediate=3'd0,S_immediate=3'd1,B_immediate=3'd2,U_immediate=3'd3,J_immediate=3'd4,CSR_immediate=3'd5;
parameter R_type=3'd0,I_type=3'd1,S_type=3'd2,B_type=3'd3,LUI_type=3'd4,J_type=3'd5,JALR_type=3'd6,ADD_type=3'd7;
parameter NO_Branch=2'd0,JAL_Branch=2'd1,JALR_Branch=2'd2,B_Branch=2'd3;
always @ (*) begin
	case (opcode)
		7'b0110011:begin	//R_type
			imm_type	=I_immediate;
			ALUOP		=R_type;
			PCtoRegSrc	=1'b0; 
			CSRtoRegSrc =1'b0;
			ALUSrc		=1'b1; //choose rs2
			RDSrc		=1'b0; //ALU
			MemtoReg	=1'b0;
			MemWrite	=1'b0;
			MemRead		=1'b0;
			RegWrite	=1'b1;
			IRWrite     =1'b1;
			Branch		=NO_Branch;
		end
		7'b0010011:begin	//I_type
			imm_type	=I_immediate;
			ALUOP		=I_type;
			PCtoRegSrc	=1'b0;
			CSRtoRegSrc =1'b0;
			ALUSrc		=1'b0; //choose immediate
			RDSrc		=1'b0; //ALU
			MemtoReg	=1'b0;
			MemWrite	=1'b0;
			MemRead		=1'b0;
			RegWrite	=1'b1;
			IRWrite     =1'b1;
			Branch		=NO_Branch;
		end
		7'b0000011:begin	//LW
			imm_type	=I_immediate;
			ALUOP		=ADD_type;
			PCtoRegSrc	=1'b0;
			CSRtoRegSrc =1'b0;
			ALUSrc		=1'b0; //choose immediate
			RDSrc		=1'b0;
			MemtoReg	=1'b1; //choose mem
			MemWrite	=1'b0;
			MemRead		=1'b1;
			RegWrite	=1'b1;
			IRWrite     =1'b1;
			Branch		=NO_Branch;
		end
		7'b1100111:begin	//JALR
			imm_type	=I_immediate;
			ALUOP		=JALR_type;
			PCtoRegSrc	=1'b0; //choose PC+4
			CSRtoRegSrc =1'b0;
			ALUSrc		=1'b0; //choose immediate
			RDSrc		=1'b1; //choose PC+4
			MemtoReg	=1'b0;
			MemWrite	=1'b0;
			MemRead		=1'b0;
			RegWrite	=1'b1;
			IRWrite     =1'b1;
			Branch		=JALR_Branch;
		end
		7'b0100011:begin	//S_type
			imm_type	=S_immediate;
			ALUOP		=ADD_type;
			PCtoRegSrc	=1'b0; 
			CSRtoRegSrc =1'b0;
			ALUSrc		=1'b0; //choose immediate
			RDSrc		=1'b0; 
			MemtoReg	=1'b0;
			MemWrite	=1'b1;
			MemRead		=1'b0;
			RegWrite	=1'b0;
			IRWrite     =1'b1;
			Branch		=NO_Branch;
		end
		7'b1100011:begin	//B_type
			imm_type	=B_immediate;
			ALUOP		=B_type;
			PCtoRegSrc	=1'b0; 
			CSRtoRegSrc =1'b0;
			ALUSrc		=1'b1; //choose rs2
			RDSrc		=1'b0; 
			MemtoReg	=1'b0;
			MemWrite	=1'b0;
			MemRead		=1'b0;
			RegWrite	=1'b0;
			IRWrite     =1'b1;
			Branch		=B_Branch;
		end
		7'b0010111:begin	//AUIPC
			imm_type	=U_immediate;
			ALUOP		=ADD_type; 
			PCtoRegSrc	=1'b1; //choose PC+immediate
			CSRtoRegSrc =1'b0;
			ALUSrc		=1'b0; 
			RDSrc		=1'b1; //choose PC+immediate
			MemtoReg	=1'b0;
			MemWrite	=1'b0;
			MemRead		=1'b0;
			RegWrite	=1'b1;
			IRWrite     =1'b1;
			Branch		=NO_Branch;
		end
		7'b0110111:begin	//LUI
			imm_type	=U_immediate;
			ALUOP		=LUI_type;
			PCtoRegSrc	=1'b0; 
			CSRtoRegSrc =1'b0;
			ALUSrc		=1'b0; 
			RDSrc		=1'b0; 
			MemtoReg	=1'b0;
			MemWrite	=1'b0;
			MemRead		=1'b0;
			RegWrite	=1'b1;
			IRWrite     =1'b1;
			Branch		=NO_Branch;
		end
		7'b1101111:begin	//J_type
			imm_type	=J_immediate;
			ALUOP		=J_type;
			PCtoRegSrc	=1'b0; //choose PC+4
			CSRtoRegSrc =1'b0;
			ALUSrc		=1'b0; 
			RDSrc		=1'b1; //choose PC+4
			MemtoReg	=1'b0;
			MemWrite	=1'b0;
			MemRead		=1'b0;
			RegWrite	=1'b1;
			IRWrite     =1'b1;
			Branch		=JAL_Branch;
		end
		7'b1110011:begin  //CSR_type
			imm_type	=CSR_immediate;
			ALUOP		=J_type;
			PCtoRegSrc	=1'b0; //choose PC+4
			CSRtoRegSrc =1'b1;//choose CSR
			ALUSrc		=1'b0; 
			RDSrc		=1'b1; //choose PC+4
			MemtoReg	=1'b0;
			MemWrite	=1'b0;
			MemRead		=1'b0;
			RegWrite	=1'b1;
			IRWrite     =1'b1;
			Branch		=NO_Branch;
		end
		default:begin	//0000000
			imm_type	=J_immediate;
			ALUOP		=R_type;
			PCtoRegSrc	=1'b0; 
			CSRtoRegSrc =1'b0;
			ALUSrc		=1'b0; 
			RDSrc		=1'b0; 
			MemtoReg	=1'b0;
			MemWrite	=1'b0;
			MemRead		=1'b0;
			RegWrite	=1'b0;
			IRWrite     =1'b0;
			Branch		=NO_Branch;
		end
	endcase
	/*
	case (opcode)
		7'b0110011:begin	//R_type
			imm_type	=I_immediate;
			ALUOP		=R_type;
			PCtoRegSrc	=1'b0; 
			ALUSrc		=1'b1; 
			RDSrc		=1'b0; 
			MemtoReg	=1'b0;
			MemWrite	=1'b0;
			MemRead		=1'b0;
			RegWrite	=1'b1;
			IRWrite     =1'b1;
			Branch		=NO_Branch;
		end
		7'b0010011:begin	//I_type
			imm_type	=I_immediate;
			ALUOP		=I_type;
			PCtoRegSrc	=1'b0;
			ALUSrc		=1'b0; 
			RDSrc		=1'b0; 
			MemtoReg	=1'b0;
			MemWrite	=1'b0;
			MemRead		=1'b0;
			RegWrite	=1'b1;
			IRWrite     =1'b1;
			Branch		=NO_Branch;
		end
		7'b0000011:begin	//LW
			imm_type	=I_immediate;
			ALUOP		=ADD_type;
			PCtoRegSrc	=1'b0;
			ALUSrc		=1'b0;
			RDSrc		=1'b0;
			MemtoReg	=1'b1; 
			MemWrite	=1'b0;
			MemRead		=1'b1;
			RegWrite	=1'b1;
			IRWrite     =1'b1;
			Branch		=NO_Branch;
		end
		7'b1100111:begin	//JALR
			imm_type	=I_immediate;
			ALUOP		=JALR_type;
			PCtoRegSrc	=1'b0; 
			ALUSrc		=1'b0; 
			RDSrc		=1'b1; 
			MemtoReg	=1'b0;
			MemWrite	=1'b0;
			MemRead		=1'b0;
			RegWrite	=1'b1;
			IRWrite     =1'b1;
			Branch		=JALR_Branch;
		end
		7'b0100011:begin	//S_type
			imm_type	=S_immediate;
			ALUOP		=ADD_type;
			PCtoRegSrc	=1'b0; 
			ALUSrc		=1'b0; 
			RDSrc		=1'b0; 
			MemtoReg	=1'b0;
			MemWrite	=1'b1;
			MemRead		=1'b0;
			RegWrite	=1'b0;
			IRWrite     =1'b1;
			Branch		=NO_Branch;
		end
		7'b1100011:begin	//B_type
			imm_type	=B_immediate;
			ALUOP		=B_type;
			PCtoRegSrc	=1'b0; 
			ALUSrc		=1'b1; 
			RDSrc		=1'b0; 
			MemtoReg	=1'b0;
			MemWrite	=1'b0;
			MemRead		=1'b0;
			RegWrite	=1'b0;
			IRWrite     =1'b1;
			Branch		=B_Branch;
		end
		7'b0010111:begin	//AUIPC
			imm_type	=U_immediate;
			ALUOP		=ADD_type; 
			PCtoRegSrc	=1'b1; 
			ALUSrc		=1'b0; 
			RDSrc		=1'b1; 
			MemtoReg	=1'b0;
			MemWrite	=1'b0;
			MemRead		=1'b0;
			RegWrite	=1'b1;
			IRWrite     =1'b1;
			Branch		=NO_Branch;
		end
		7'b0110111:begin	//LUI
			imm_type	=U_immediate;
			ALUOP		=LUI_type;
			PCtoRegSrc	=1'b0; 
			ALUSrc		=1'b0; 
			RDSrc		=1'b0; 
			MemtoReg	=1'b0;
			MemWrite	=1'b0;
			MemRead		=1'b0;
			RegWrite	=1'b1;
			IRWrite     =1'b1;
			Branch		=NO_Branch;
		end
		7'b1101111:begin	//J_type
			imm_type	=J_immediate;
			ALUOP		=J_type;//don't care
			PCtoRegSrc	=1'b0; //choose PC+4
			ALUSrc		=1'b0; 
			RDSrc		=1'b1; //choose PC+4
			MemtoReg	=1'b0;
			MemWrite	=1'b0;
			MemRead		=1'b0;
			RegWrite	=1'b1;
			IRWrite     =1'b1;
			Branch		=JAL_Branch;
		end
		7'b1110011:begin  //CSR_type
			imm_type	=CSR_immediate;
			ALUOP		=J_type;//don't care
			PCtoRegSrc	=1'b0; //choose PC+4
			ALUSrc		=1'b0; 
			RDSrc		=1'b1; //choose PC+4
			MemtoReg	=1'b0;
			MemWrite	=1'b0;
			MemRead		=1'b0;
			RegWrite	=1'b1;
			IRWrite     =1'b1;
			Branch		=NO_Branch;
		end
		default:begin	//0000000
			imm_type	=J_immediate;
			ALUOP		=R_type;
			PCtoRegSrc	=1'b0; 
			ALUSrc		=1'b0; 
			RDSrc		=1'b0; 
			MemtoReg	=1'b0;
			MemWrite	=1'b0;
			MemRead		=1'b0;
			RegWrite	=1'b0;
			IRWrite     =1'b0;
			Branch		=NO_Branch;
		end
	endcase
	*/
end
endmodule