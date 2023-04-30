`include "def.svh"
module Data_Memory (clk,rst,EXE_MemRead,EXE_MemWrite,EXE_MemtoReg,EXE_RegWrite,EXE_RDSrc,
EXE_rd_addr,EXE_fuct3,EXE_rs2_data,EXE_ALU_out,DO,EXE_pc_out,CS,MEM_MemtoReg,MEM_RegWrite,
MEM_DO_out,MEM_rd_data,MEM_rd_addr,WEB,DI,MEM_rd_data_next,MEM_WB_regwrite,wire_writeType);

input clk,rst,EXE_MemRead,EXE_MemWrite,EXE_MemtoReg,EXE_RegWrite,MEM_WB_regwrite;
input EXE_RDSrc;
input [4:0] EXE_rd_addr;
input logic [2:0] EXE_fuct3;
input [31:0] EXE_rs2_data,EXE_ALU_out,EXE_pc_out; //,DO
input unsigned [31:0] DO;
output logic CS;
output logic MEM_MemtoReg,MEM_RegWrite;
output logic [31:0] MEM_DO_out,MEM_rd_data;
output logic [4:0] MEM_rd_addr;
output logic [3:0] WEB;
output logic [31:0] DI;
output logic [31:0] MEM_rd_data_next;
output logic [`CACHE_TYPE_BITS-1:0] wire_writeType;
logic [31:0] DO_out;
assign CS = (EXE_MemRead) | (EXE_MemWrite);
assign MEM_rd_data_next = (EXE_RDSrc) ? EXE_pc_out : EXE_ALU_out;

 always_comb begin
        case(EXE_fuct3) // 
            3'b010: // LW
                wire_writeType = `CACHE_WORD;
            3'b000: // LB
                wire_writeType = `CACHE_BYTE;
            3'b001: // LH
                wire_writeType = `CACHE_HWORD;
            3'b100: // LBU
                wire_writeType = `CACHE_BYTE_U;
            3'b101: // LHU
                wire_writeType = `CACHE_HWORD_U;
            default:
                wire_writeType = `CACHE_WORD;
        endcase
    end

always_comb
begin
	if(EXE_MemWrite)
	begin
		case (EXE_fuct3) 
			3'b000:
			begin	//SB
				case (EXE_ALU_out[1:0])
					2'd0:
					begin
						WEB = 4'b1110;
						DI = {24'd0,EXE_rs2_data[7:0]};
					end
					2'd1:
					begin
						WEB = 4'b1101;
						DI = {16'd0,EXE_rs2_data[7:0],8'd0};
					end
					2'd2:
					begin
						WEB = 4'b1011;
						DI = {8'd0,EXE_rs2_data[7:0],16'd0};
					end
					default:
					begin
						WEB = 4'b0111;
						DI = {EXE_rs2_data[7:0],24'd0};
					end
				endcase
			end
			3'b001:
			begin	//SH
				case(EXE_ALU_out[1])
					1'b0:
					begin
						WEB = 4'b1100;
						DI = {16'd0,EXE_rs2_data[15:0]};
					end
					default:
					begin
						WEB = 4'b0011;
						DI = {EXE_rs2_data[15:0],16'd0};
					end
				endcase
			end
			default:
			begin	//SW
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

always_comb
begin
	if (EXE_MemRead)
	begin
		case (EXE_fuct3)
			3'b000:
			begin	//LB
				case(EXE_ALU_out[1:0])
					2'd0:
					begin
						DO_out = {{24{DO[7]}},DO[7:0]};
					end
					2'd1:
					begin
						DO_out = {{24{DO[15]}},DO[15:8]};
					end
					2'd2:
					begin
						DO_out = {{24{DO[23]}},DO[23:16]};
					end
					default:
					begin
						DO_out = {{24{DO[31]}},DO[31:24]};
					end
				endcase
			end
			3'b001:
			begin	//LH
				case(EXE_ALU_out[1])
					1'b0:
					begin
						DO_out = {{16{DO[15]}},DO[15:0]};
					end
					default:
					begin
						DO_out = {{16{DO[31]}},DO[31:16]};
					end
				endcase
			end
			3'b010:
			begin	//LW
				DO_out = DO;
			end
			3'b100:
			begin	//LBU
				case(EXE_ALU_out[1:0])
					2'd0:
					begin
						DO_out = {24'd0,DO[7:0]};
					end
					2'd1:
					begin
						DO_out = {24'd0,DO[15:8]};
					end
					2'd2:
					begin
						DO_out = {24'd0,DO[23:16]};
					end
					default:
					begin
						DO_out = {24'd0,DO[31:24]};
					end
				endcase
			end
			3'b101:
			begin	//LHU
				case(EXE_ALU_out[1])
					1'b0:
					begin
						DO_out = {16'd0,DO[15:0]};
					end
					default:
					begin
						DO_out = {16'd0,DO[31:16]};
					end
				endcase
			end
			default:
			begin
				DO_out = 32'd0;
			end
		endcase
	end
	else
	begin
		DO_out = 32'd0;
	end
end

always_ff @(posedge clk)
begin
	if(rst)
	begin
		MEM_MemtoReg	<=1'b0;
		MEM_RegWrite	<=1'b0;
		MEM_DO_out		<=32'd0;
		MEM_rd_data		<=32'd0;
		MEM_rd_addr		<=5'd0;
	end
	else
	begin
		if (MEM_WB_regwrite)
		begin
			MEM_MemtoReg	<=EXE_MemtoReg;
			MEM_RegWrite	<=EXE_RegWrite;
			MEM_DO_out		<=DO_out;
			MEM_rd_data		<=MEM_rd_data_next;
			MEM_rd_addr		<=EXE_rd_addr;
		end
	end
end

endmodule