`include "CycleRegister.v"
`include "IF.v"
`include "RegisterFile.v"
`include "Hazard_control.v"
`include "ImmediateGenerator.v"
`include "Control_unit.v"
`include "ID_EXE_register.v"
`include "ALU_Contol.v"
`include "ALU.v"
`include "Forwarding_Unit.v"
`include "BranchControl.v"
`include "InstructionRegister.v"
`include "EXE_MEM_register.v"
`include "Data_Memory.v"
`include "WB.v"
module CPU (clk,rst,instruction,DO,CS,WEB,DI,pc_out,EXE_ALU_out,EXE_MemRead);
input clk,rst; 
input [31:0] instruction;
input  [31:0] DO;
output wire CS;
output wire [3:0] WEB;
output wire [31:0] DI;
output [31:0] pc_out;
output  [31:0] EXE_ALU_out;
output EXE_MemRead;
wire clk,rst;
wire [1:0] BranchControl;
wire [31:0] pc_immrs1,pc_imm,instruction,pc_out,IF_pc_out,IF_instruction_out,ID_pc_out,EXE_pc_out;
wire [31:0] rs1_data,rs2_data,ID_rs1,ID_rs2,imm,ID_imm;
wire instruction_flush,CtrlSignalFlush,IF_regwrite,PC_write;
wire [2:0] imm_type;
wire PCtoRegSrc,ALUSrc,RDSrc,MemtoReg,MemWrite,MemRead,RegWrite;
wire [1:0] Branch,ID_Branch;
wire [2:0] ALUOP,ID_ALUOP;
wire ID_PCtoRegSrc,ID_ALUSrc,ID_RDSrc,ID_MemtoReg,ID_MemWrite,ID_MemRead,ID_RegWrite;
wire [2:0] ID_funct3,EXE_fuct3;
wire [6:0] ID_funct7;
wire [4:0] ID_rd_addr,ID_rs1_addr,ID_rs2_addr,MEM_rd_addr,EXE_rd_addr,WB_rd_addr,rs1_addr,rs2_addr;
wire [4:0] ALU_Ctrl;
wire [1:0] Fowardingrs1,Fowardingrs2;
wire Zero_flag;
wire [31:0] ALU_out,ID_pctoreg,rs2_1,EXE_ALU_out;
wire EXE_RDSrc,EXE_MemtoReg,EXE_MemWrite,EXE_MemRead,EXE_RegWrite;
wire [31:0] EXE_rs2_data;
wire [31:0] DO,MEM_DO_out,MEM_rd_data,WB_rd_data,MEM_rd_data_next;
wire MEM_MemtoReg,MEM_RegWrite,WB_RegWrite;
wire [63:0] cycle,IF_cycle,ID_cycle;
wire [63:0] instret;
wire CSRtoRegSrc,ID_CSRtoRegSrc,ID_IRWrite,IRWrite;
wire [1:0] ID_imm_2 ;
assign ID_imm_2 = {ID_imm[7],ID_imm[1]};
//assign pc_out_trim = pc_out[15:2];

CycleRegister CR1 (
.clk(clk),
.rst(rst),
.cycle(cycle)
);

IF if1 (
.clk(clk),
.rst(rst),
.instruction_flush(instruction_flush),
.PC_write(PC_write),
.IF_regwrite(IF_regwrite),
.BranchControl(BranchControl),
.pc_immrs1(pc_immrs1),
.pc_imm(pc_imm),
.instruction(instruction),
.pc_out(pc_out),
.IF_pc_out(IF_pc_out),
.IF_instruction_out(IF_instruction_out),
.cycle(cycle),
.IF_cycle(IF_cycle)
);

RegisterFile registerfile1 (
.clk(~clk),
.rst(rst),
.WB_RegWrite(WB_RegWrite),
.WB_rd_addr(WB_rd_addr),
.IF_instruction_out(IF_instruction_out[24:15]),
.WB_rd_data(WB_rd_data),
.rs1_data(rs1_data),
.rs2_data(rs2_data)
);

Hazard_control hazard_control1 (
.ID_MemRead(ID_MemRead),
.BranchControl(BranchControl),
.ID_rd_addr(ID_rd_addr),
.rs1_addr(rs1_addr),
.rs2_addr(rs2_addr),
.instruction_flush(instruction_flush),
.CtrlSignalFlush(CtrlSignalFlush),
.IF_regwrite(IF_regwrite),
.PC_write(PC_write)
);

ImmediateGenerator immediategenerator1 (
.imm_type(imm_type),
.IF_instruction_out(IF_instruction_out[31:7]),
.imm(imm)
);

Control_unit control_unit1 (
.opcode(IF_instruction_out[6:0]),
.PCtoRegSrc(PCtoRegSrc),
.ALUSrc(ALUSrc),
.RDSrc(RDSrc),
.MemtoReg(MemtoReg),
.MemWrite(MemWrite),
.MemRead(MemRead),
.RegWrite(RegWrite),
.Branch(Branch),
.imm_type(imm_type),
.ALUOP(ALUOP),
.CSRtoRegSrc(CSRtoRegSrc),
.IRWrite(IRWrite)
);

ID_EXE_register id_exe_register1 (
.clk(clk),
.rst(rst),
.CtrlSignalFlush(CtrlSignalFlush),
.PCtoRegSrc(PCtoRegSrc),
.ALUSrc(ALUSrc),
.RDSrc(RDSrc),
.MemtoReg(MemtoReg),
.MemWrite(MemWrite),
.MemRead(MemRead),
.RegWrite(RegWrite),
.Branch(Branch),
.ALUOP(ALUOP),
.IF_pc_out(IF_pc_out),
.rs1_data(rs1_data),
.rs2_data(rs2_data),
.imm(imm),
.IF_instruction_out(IF_instruction_out[31:7]),
.ID_PCtoRegSrc(ID_PCtoRegSrc),
.ID_ALUSrc(ID_ALUSrc),
.ID_RDSrc(ID_RDSrc),
.ID_MemtoReg(ID_MemtoReg),
.ID_MemWrite(ID_MemWrite),
.ID_MemRead(ID_MemRead),
.ID_RegWrite(ID_RegWrite),
.ID_Branch(ID_Branch),
.ID_ALUOP(ID_ALUOP),
.ID_pc_out(ID_pc_out),
.ID_rs1(ID_rs1),
.ID_rs2(ID_rs2),
.ID_imm(ID_imm),
.ID_funct3(ID_funct3),
.ID_funct7(ID_funct7),
.ID_rd_addr(ID_rd_addr),
.ID_rs1_addr(ID_rs1_addr),
.ID_rs2_addr(ID_rs2_addr),
.rs1_addr(rs1_addr),
.rs2_addr(rs2_addr),
.IF_cycle(IF_cycle),
.ID_cycle(ID_cycle),
.CSRtoRegSrc(CSRtoRegSrc),
.ID_CSRtoRegSrc(ID_CSRtoRegSrc),
.ID_IRWrite(ID_IRWrite),
.IRWrite(IRWrite)
);

ALU_Contol alu_control1 (
.ID_ALUOP(ID_ALUOP),
.ID_funct3(ID_funct3),
.ID_funct7(ID_funct7),
.ALU_Ctrl(ALU_Ctrl)
);

ALU alu1 (
.ID_ALUSrc(ID_ALUSrc),
.ID_pc_out(ID_pc_out),
.ID_PCtoRegSrc(ID_PCtoRegSrc),
.Fowardingrs1(Fowardingrs1),
.Fowardingrs2(Fowardingrs2),
.ALU_Ctrl(ALU_Ctrl),
.ID_rs1(ID_rs1),
.ID_rs2(ID_rs2),
.MEM_rd_data_next(MEM_rd_data_next),
.WB_rd_data(WB_rd_data),
.ID_imm(ID_imm),
.Zero_flag(Zero_flag),
.ALU_out(ALU_out),
.ID_pctoreg(ID_pctoreg),
.pc_imm(pc_imm),
.pc_immrs1(pc_immrs1),
.rs2_1(rs2_1)
);

Forwarding_Unit fowarding_unit1 (
.EXE_RegWrite(EXE_RegWrite),
.MEM_RegWrite(MEM_RegWrite),
.EXE_rd_addr(EXE_rd_addr),
.MEM_rd_addr(MEM_rd_addr),
.ID_rs1_addr(ID_rs1_addr),
.ID_rs2_addr(ID_rs2_addr),
.Fowardingrs1(Fowardingrs1),
.Fowardingrs2(Fowardingrs2)
);

BranchControl branchcontrol1 (
.Zero_flag(Zero_flag),
.ID_Branch(ID_Branch),
.BranchControl(BranchControl)
);

InstructionRegister IR (
.clk(clk),
.rst(rst),
.ID_IRWrite(ID_IRWrite),
.instret(instret)
);

EXE_MEM_register exe_mem_register1 (
.clk(clk),
.rst(rst),
.ID_RDSrc(ID_RDSrc),
.ID_MemtoReg(ID_MemtoReg),
.ID_MemWrite(ID_MemWrite),
.ID_MemRead(ID_MemRead),
.ID_RegWrite(ID_RegWrite),
.ID_funct3(ID_funct3),
.ID_pctoreg(ID_pctoreg),
.ID_CSRtoRegSrc(ID_CSRtoRegSrc),
.ID_imm_2(ID_imm_2),
.ALU_out(ALU_out),
.rs2_1(rs2_1),
.ID_rd_addr(ID_rd_addr),
.EXE_RDSrc(EXE_RDSrc),
.EXE_MemtoReg(EXE_MemtoReg),
.EXE_MemWrite(EXE_MemWrite),
.EXE_MemRead(EXE_MemRead),
.EXE_RegWrite(EXE_RegWrite),
.EXE_fuct3(EXE_fuct3),
.EXE_pc_out(EXE_pc_out),
.EXE_ALU_out(EXE_ALU_out),
.EXE_rs2_data(EXE_rs2_data),
.EXE_rd_addr(EXE_rd_addr),
.instret(instret),
.ID_cycle(ID_cycle)
);

Data_Memory data_memory1 (
.clk(clk),
.rst(rst),
.EXE_MemRead(EXE_MemRead),
.EXE_MemWrite(EXE_MemWrite),
.EXE_MemtoReg(EXE_MemtoReg),
.EXE_RegWrite(EXE_RegWrite),
.EXE_RDSrc(EXE_RDSrc),
.EXE_rd_addr(EXE_rd_addr),
.EXE_fuct3(EXE_fuct3),
.EXE_rs2_data(EXE_rs2_data),
.EXE_ALU_out(EXE_ALU_out),
.DO(DO),
.EXE_pc_out(EXE_pc_out),
.CS(CS),
.MEM_MemtoReg(MEM_MemtoReg),
.MEM_RegWrite(MEM_RegWrite),
.MEM_DO_out(MEM_DO_out),
.MEM_rd_data(MEM_rd_data),
.MEM_rd_addr(MEM_rd_addr),
.WEB(WEB),
.DI(DI),
.MEM_rd_data_next(MEM_rd_data_next)
);

WB WB1 (
.MEM_MemtoReg(MEM_MemtoReg),
.MEM_RegWrite(MEM_RegWrite),
.MEM_rd_data(MEM_rd_data),
.MEM_rd_addr(MEM_rd_addr),
.MEM_DO_out(MEM_DO_out),
.WB_RegWrite(WB_RegWrite),
.WB_rd_addr(WB_rd_addr),
.WB_rd_data(WB_rd_data)
);

endmodule
