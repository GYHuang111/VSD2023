module Data_Memory (clk,rst,EXE_MemRead,EXE_MemWrite,EXE_MemtoReg,EXE_RegWrite,EXE_RDSrc,
EXE_rd_addr,EXE_fuct3,EXE_rs2_data,EXE_ALU_out,DO,EXE_pc_out,CS,MEM_MemtoReg,MEM_RegWrite,
MEM_DO_out,MEM_rd_data,MEM_rd_addr,WEB,DI,MEM_rd_data_next);

input clk,rst,EXE_MemRead,EXE_MemWrite,EXE_MemtoReg,EXE_RegWrite;
input EXE_RDSrc;
input [4:0] EXE_rd_addr;
input wire [2:0] EXE_fuct3;
input [31:0] EXE_rs2_data,EXE_ALU_out,EXE_pc_out; //,DO
input unsigned [31:0] DO;
output wire CS;
output reg MEM_MemtoReg,MEM_RegWrite;
output reg [31:0] MEM_DO_out,MEM_rd_data;
output reg [4:0] MEM_rd_addr;
output reg [3:0] WEB;
output reg [31:0] DI;
output wire [31:0] MEM_rd_data_next;
reg [31:0] DO_out;
assign CS = (EXE_MemRead)|(EXE_MemWrite);
assign MEM_rd_data_next = (EXE_RDSrc)?EXE_pc_out:EXE_ALU_out;

always @ (*) begin
	if(EXE_MemWrite) begin
		case (EXE_fuct3) 
			3'b000:begin	//SB
				case (EXE_ALU_out[1:0])
					2'd0:begin
						WEB = 4'b1110;
						DI = {24'd0,EXE_rs2_data[7:0]};
					end
					2'd1:begin
						WEB = 4'b1101;
						DI = {16'd0,EXE_rs2_data[7:0],8'd0};
					end
					2'd2:begin
						WEB = 4'b1011;
						DI = {8'd0,EXE_rs2_data[7:0],16'd0};
					end
					default:begin
						WEB = 4'b0111;
						DI = {EXE_rs2_data[7:0],24'd0};
					end
				endcase
			end
			3'b001:begin	//SH
				case(EXE_ALU_out[1])
					1'b0:begin
						WEB = 4'b1100;
						DI = {16'd0,EXE_rs2_data[15:0]};
					end
					default:begin
						WEB = 4'b0011;
						DI = {EXE_rs2_data[15:0],16'd0};
					end
				endcase
			end
			default:begin	//SW
				WEB = 4'b0000;
				DI = EXE_rs2_data;
			end
		endcase
	end
	else begin
		WEB = 4'b1111;
		DI = 32'd0;
	end
end

/*
always @ (*) begin
	if(EXE_MemWrite) begin
		case (EXE_fuct3) 
			3'b000:begin	//SB
				case (EXE_ALU_out[1:0])
					2'd0:begin
						WEB = 4'b1110;
					end
					2'd1:begin
						WEB = 4'b1101;
					end
					2'd2:begin
						WEB = 4'b1011;
					end
					default:begin
						WEB = 4'b0111;
					end
				endcase
			end
			3'b001:begin	//SH
				case(EXE_ALU_out[1])
					1'b0:begin
						WEB = 4'b1100;
					end
					1'b1:begin
						WEB = 4'b0011;
					end
				endcase
			end
			default:begin	//SW
				WEB = 4'b0000;
			end
		endcase
	end
end
always @ (*) begin
		case (EXE_fuct3) 
			3'b000:begin	//SB
				case (EXE_ALU_out[1:0])
					2'd0:begin
						DI = {DI[31:8],EXE_rs2_data[7:0]};
					end
					2'd1:begin
						DI = {DI[31:16],EXE_rs2_data[7:0],DI[7:0]};
					end
					2'd2:begin
						DI = {DI[31:24],EXE_rs2_data[7:0],DI[15:0]};
					end
					default:begin
						DI = {EXE_rs2_data[7:0],DI[23:0]};
					end
				endcase
			end
			3'b001:begin	//SH
				case(EXE_ALU_out[1])
					1'b0:begin
						DI = {DI[31:16],EXE_rs2_data[15:0]};
					end
					1'b1:begin
						DI = {EXE_rs2_data[15:0],DI[15:0]};
					end
				endcase
			end
			default:begin	//SW
				DI = EXE_rs2_data;
			end
		endcase
end
*/
////////////////////////
always @(*) begin
	if (EXE_MemRead) begin
		case (EXE_fuct3)
			3'b000:begin	//LB
				DO_out = {{24{DO[7]}},DO[7:0]};
			end
			3'b001:begin	//LH
				DO_out = {{16{DO[15]}},DO[15:0]};
			end
			3'b010:begin	//LW
				DO_out = DO;
			end
			3'b100:begin	//LBU
				DO_out = {24'd0,DO[7:0]};
			end
			3'b101:begin	//LHU
				DO_out = {16'd0,DO[15:0]};
			end
			default:begin
				DO_out = 32'd0;
			end
		endcase
	end
	else begin
		DO_out = 32'd0;
	end
end

always @ (posedge clk or posedge rst) begin
	if (rst) begin
		MEM_MemtoReg	<=1'b0;
		MEM_RegWrite	<=1'b0;
		MEM_DO_out		<=32'd0;
		MEM_rd_data		<=32'd0;
		MEM_rd_addr		<=5'd0;
	end
	else begin
		MEM_MemtoReg	<=EXE_MemtoReg;
		MEM_RegWrite	<=EXE_RegWrite;
		MEM_DO_out		<=DO_out;
		MEM_rd_data		<=MEM_rd_data_next;
		MEM_rd_addr		<=EXE_rd_addr;
	end
end

endmodule