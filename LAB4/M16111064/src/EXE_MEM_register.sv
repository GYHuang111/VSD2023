`include "CSR.sv"
module EXE_MEM_register (clk,rst,ID_RDSrc,ID_MemtoReg,ID_MemWrite,ID_MemRead,ID_RegWrite,ID_funct3,ID_funct7,ID_imm,
ID_pctoreg,ID_CSRtoRegSrc,ID_imm_2,ALU_out,rs2_1,ID_rd_addr,EXE_RDSrc,EXE_MemtoReg,EXE_MemWrite,EXE_MemRead,ID_rs1_addr,
EXE_RegWrite,EXE_fuct3,EXE_pc_out,EXE_ALU_out,EXE_rs2_data,EXE_rd_addr,EXE_MEM_regwrite,ID_CSR_addr,rs1,ID_pc_out,
CSR_return_pc,CSR_ISR_pc,CSR_stall,CSR_control,CSR_ret,interrupt); //,instret,ID_cycle

input clk,rst;
input ID_RDSrc,ID_MemtoReg,ID_MemWrite,ID_MemRead,ID_RegWrite,EXE_MEM_regwrite;
input [2:0] ID_funct3;
input [6:0] ID_funct7;
input [31:0] ID_pctoreg,ALU_out,rs2_1;
input [1:0] ID_imm_2;
input [4:0] ID_rd_addr;
input [31:0] rs1;
input [31:0] ID_pc_out;
input [31:0] ID_imm;
input [4:0] ID_rs1_addr;
//input [63:0] instret,ID_cycle;
// CSR
input ID_CSRtoRegSrc;
input [11:0] ID_CSR_addr;
output logic [31:0] CSR_return_pc;
output logic [31:0] CSR_ISR_pc;
output logic CSR_stall;
output logic CSR_control;
output logic CSR_ret;
	
output logic EXE_RDSrc,EXE_MemtoReg,EXE_MemWrite,EXE_MemRead,EXE_RegWrite;
output logic [2:0] EXE_fuct3;
output logic [31:0] EXE_pc_out,EXE_ALU_out,EXE_rs2_data;
output logic [4:0] EXE_rd_addr;

input interrupt;

logic [31:0] CSRtoReg;
logic [31:0] CSRtoReg_out;
logic [31:0] wire_CSR_rdata;
/*
always_comb
begin
    case(ID_imm_2)
		2'b11:
		begin
			CSRtoReg = instret[63:32];
		end  
		2'b01:
		begin
			CSRtoReg = instret[31:0];
		end	
		2'b10:
		begin
			CSRtoReg = ID_cycle[63:32];
		end  
		default:
		begin //2'b00
			CSRtoReg = ID_cycle[31:0];
		end	
    endcase
end
*/
//assign CSRtoReg_out = (ID_CSRtoRegSrc)?CSRtoReg:ID_pctoreg;

always_ff @(posedge clk)
begin
	if(rst)
	begin
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
	else
	begin
		if(EXE_MEM_regwrite)
		begin
			EXE_pc_out 		<=ID_pctoreg;//CSRtoReg_out
			//EXE_ALU_out 	<=ALU_out;
			if (ID_CSRtoRegSrc) begin
				EXE_ALU_out 	<=wire_CSR_rdata;
			end
			else begin
				EXE_ALU_out     <= ALU_out;
			end
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
end

// CSR
    CSR CSR (
        .clk(clk),    // Clock
        .rst(rst),  // Asynchronous reset active low

        // function
        .funct3(ID_funct3),
        .funct7(ID_funct7),

        // source
        // .rs1(ID_rs1),
        .rs1(rs1), // after forward
        .imm(ID_imm),
        .rs1_addr(ID_rs1_addr),

        // CSR addr, enable
        .CSR_addr(ID_CSR_addr),
        .CSR_write(ID_CSRtoRegSrc),

        // RegWrite
        .EXEMEM_RegWrite(EXE_MEM_regwrite),

        // interrupt
        .interrupt(interrupt), // need to fix

        // PC
        .EXE_pc(ID_pc_out),
        .CSR_return_pc(CSR_return_pc),
        .CSR_ISR_pc(CSR_ISR_pc),

        // output data
        .CSR_rdata(wire_CSR_rdata),

        // stall
        .CSR_stall(CSR_stall),
        .CSR_control(CSR_control),
        .CSR_ret(CSR_ret)
    );

endmodule