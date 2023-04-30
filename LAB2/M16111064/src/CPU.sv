`include "CycleRegister.sv"
`include "IF.sv"
`include "RegisterFile.sv"
`include "Hazard_control.sv"
`include "ImmediateGenerator.sv"
`include "Control_unit.sv"
`include "ID_EXE_register.sv"
`include "ALU_Contol.sv"
`include "ALU.sv"
`include "Forwarding_Unit.sv"
`include "BranchControl.sv"
`include "InstructionRegister.sv"
`include "EXE_MEM_register.sv"
`include "Data_Memory.sv"
`include "WB.sv"

module CPU (clk,rst,instruction,pc_out,instruction_read,DO,WEB,DI,
EXE_ALU_out,EXE_MemRead,EXE_MemWrite,IM_stall,DM_stall);
input clk,rst; 

input [31:0] instruction; //instr_out
output logic [31:0] pc_out;	//instr_addr
output logic instruction_read;

input  [31:0] DO;               //data_out
output logic [3:0] WEB;         //write_type
output logic [31:0] DI;         //data_in
output logic [31:0] EXE_ALU_out;//data_addr
output logic EXE_MemRead;       //b_data_read
output logic EXE_MemWrite;      //b_data_write

input IM_stall,DM_stall;

logic clk,rst;
logic [1:0] BranchControl;
logic [31:0] pc_immrs1,pc_imm,instruction,IF_pc_out,IF_instruction_out,ID_pc_out,EXE_pc_out;
logic [31:0] rs1_data,rs2_data,ID_rs1,ID_rs2,imm,ID_imm;
logic instruction_flush,CtrlSignalFlush,IF_regwrite,PC_write;
logic [2:0] imm_type;
logic PCtoRegSrc,ALUSrc,RDSrc,MemtoReg,MemWrite,MemRead,RegWrite;
logic [1:0] Branch,ID_Branch;
logic [2:0] ALUOP,ID_ALUOP;
logic ID_PCtoRegSrc,ID_ALUSrc,ID_RDSrc,ID_MemtoReg,ID_MemWrite,ID_MemRead,ID_RegWrite;
logic [2:0] ID_funct3,EXE_fuct3;
logic [6:0] ID_funct7;
logic [4:0] ID_rd_addr,ID_rs1_addr,ID_rs2_addr,MEM_rd_addr,EXE_rd_addr,WB_rd_addr,rs1_addr,rs2_addr;
logic [4:0] ALU_Ctrl;
logic [1:0] Fowardingrs1,Fowardingrs2;
logic Zero_flag;
logic [31:0] ALU_out,ID_pctoreg,rs2_1;
logic EXE_RDSrc,EXE_MemtoReg,EXE_RegWrite;
logic [31:0] EXE_rs2_data;
logic [31:0] DO,MEM_DO_out,MEM_rd_data,WB_rd_data,MEM_rd_data_next;
logic MEM_MemtoReg,MEM_RegWrite,WB_RegWrite;
logic [63:0] cycle,IF_cycle,ID_cycle;
logic [63:0] instret;
logic CSRtoRegSrc,ID_CSRtoRegSrc,ID_IRWrite,IRWrite;
logic [1:0] ID_imm_2 ;
logic ID_EXE_regwrite,EXE_MEM_regwrite,MEM_WB_regwrite,Stall_CRWrite,Stall_IRWrite;
assign ID_imm_2 = {ID_imm[7],ID_imm[1]};
//assign pc_out_trim = pc_out[15:2];

CycleRegister CR1 (
.clk(clk),
.rst(rst),
.Stall_CRWrite(Stall_CRWrite),
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
.clk(clk),
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
.PC_write(PC_write),
.IM_stall(IM_stall),
.DM_stall(DM_stall),
.ID_EXE_regwrite(ID_EXE_regwrite),
.EXE_MEM_regwrite(EXE_MEM_regwrite),
.MEM_WB_regwrite(MEM_WB_regwrite),
.Stall_IRWrite(Stall_IRWrite),
.Stall_CRWrite(Stall_CRWrite)
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
.IRWrite(IRWrite),
.ID_EXE_regwrite(ID_EXE_regwrite)
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
.Stall_IRWrite(Stall_IRWrite),
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
.ID_cycle(ID_cycle),
.EXE_MEM_regwrite(EXE_MEM_regwrite)
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
.MEM_rd_data_next(MEM_rd_data_next),
.MEM_WB_regwrite(MEM_WB_regwrite)
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

assign instruction_read = 1'b1;

endmodule
