module EXE_MEM_register (clk,rst,ID_RDSrc,ID_MemtoReg,ID_MemWrite,ID_MemRead,ID_RegWrite,ID_funct3,
ID_pctoreg,ID_CSRtoRegSrc,ID_imm_2,ALU_out,rs2_1,ID_rd_addr,EXE_RDSrc,EXE_MemtoReg,EXE_MemWrite,EXE_MemRead,
EXE_RegWrite,EXE_fuct3,EXE_pc_out,EXE_ALU_out,EXE_rs2_data,EXE_rd_addr,instret,ID_cycle);
input clk,rst;
input ID_RDSrc,ID_MemtoReg,ID_MemWrite,ID_MemRead,ID_RegWrite,ID_CSRtoRegSrc;
input [2:0] ID_funct3;
input [31:0] ID_pctoreg,ALU_out,rs2_1;
input [1:0] ID_imm_2;
input [4:0] ID_rd_addr;
input [63:0] instret,ID_cycle;
output reg EXE_RDSrc,EXE_MemtoReg,EXE_MemWrite,EXE_MemRead,EXE_RegWrite;
output reg [2:0] EXE_fuct3;
output reg [31:0] EXE_pc_out,EXE_ALU_out,EXE_rs2_data;
output reg [4:0] EXE_rd_addr;
reg [31:0] CSRtoReg;
wire [31:0] CSRtoReg_out;
always @(*) begin
    case(ID_imm_2)
    2'b11:begin
	    CSRtoReg = instret[63:32];
    end  
    2'b01:begin
        CSRtoReg = instret[31:0];
    end	
	2'b10:begin
	    CSRtoReg = ID_cycle[63:32];
    end  
    default:begin //2'b00
        CSRtoReg = ID_cycle[31:0];
    end	
    endcase
end

assign CSRtoReg_out = (ID_CSRtoRegSrc)?CSRtoReg:ID_pctoreg;

always @ (posedge clk or posedge rst) begin
	if (rst) begin
		EXE_pc_out 		<=32'd0;
		EXE_ALU_out 	<=32'd0;
		EXE_rs2_data	<=32'd0;
		EXE_rd_addr		<=5'd0;
		EXE_fuct3		<=3'd0;
		
		EXE_RDSrc		<=1'd0;
		EXE_MemtoReg	<=1'd0;
		EXE_MemWrite	<=1'd0;
		EXE_MemRead		<=1'd0;
		EXE_RegWrite	<=1'd0;
	end
	else begin
		EXE_pc_out 		<=CSRtoReg_out;
		EXE_ALU_out 	<=ALU_out;
		EXE_rs2_data	<=rs2_1;
		EXE_rd_addr		<=ID_rd_addr;
		EXE_fuct3		<=ID_funct3;
		
		EXE_RDSrc		<=ID_RDSrc;
		EXE_MemtoReg	<=ID_MemtoReg;
		EXE_MemWrite	<=ID_MemWrite;
		EXE_MemRead		<=ID_MemRead;
		EXE_RegWrite	<=ID_RegWrite;
	end
end
endmodule