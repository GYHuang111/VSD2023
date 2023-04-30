module Hazard_control (ID_MemRead,BranchControl,ID_rd_addr,rs1_addr,rs2_addr,
instruction_flush,CtrlSignalFlush,IF_regwrite,PC_write,IM_stall,DM_stall,ID_EXE_regwrite,
EXE_MEM_regwrite,MEM_WB_regwrite,CSR_stall,CSR_control,CSR_ret);//Stall_IRWrite,Stall_CRWrite
input ID_MemRead,IM_stall,DM_stall;
input [1:0] BranchControl;
input [4:0] ID_rd_addr,rs1_addr,rs2_addr;
output logic instruction_flush,CtrlSignalFlush,IF_regwrite,PC_write,ID_EXE_regwrite,
EXE_MEM_regwrite,MEM_WB_regwrite;//Stall_IRWrite,Stall_CRWrite;

// CSR
    input CSR_stall;
    input CSR_control;
    input CSR_ret;

parameter	PCIMMRS1= 2'd1,
			PCIMM	= 2'd2,
			C4		= 2'd0;
/*
always_comb
begin
	if (IM_stall | DM_stall)
	begin
		instruction_flush=1'd0;		//let third instruction become 0000
		CtrlSignalFlush=1'd0;		//let second instruction become NOP
		IF_regwrite=1'd0;			//enable
		PC_write=1'd0;				//enable
		ID_EXE_regwrite=1'd0;
		EXE_MEM_regwrite=1'd0;
		MEM_WB_regwrite=1'd0;
		Stall_IRWrite = 1'd0;
		Stall_CRWrite = 1'd0;
	end
	else if (BranchControl!=2'd0)
	begin //if branch or jump occured
		instruction_flush=1'd1;		//let third instruction become 0000
		CtrlSignalFlush=1'd1;		//let second instruction become NOP
		IF_regwrite=1'd1;			//enable
		PC_write=1'd1;				//enable
		ID_EXE_regwrite=1'd1;
		EXE_MEM_regwrite=1'd1;
		MEM_WB_regwrite=1'd1;
		Stall_IRWrite = 1'd1;
		Stall_CRWrite = 1'd1;
	end
	else if ((ID_MemRead)&&((ID_rd_addr==rs1_addr)||(ID_rd_addr==rs2_addr)))
	begin //if load-use occured
		instruction_flush=1'd0;		
		CtrlSignalFlush=1'd1;		//let second instruction become NOP
		IF_regwrite=1'd0;			//disable to stop IF_reg
		PC_write=1'd0;				//disable to stop PC
		ID_EXE_regwrite=1'd1;
		EXE_MEM_regwrite=1'd1;
		MEM_WB_regwrite=1'd1;
		Stall_IRWrite = 1'd1;
		Stall_CRWrite = 1'd1;
	end
	else begin
		instruction_flush=1'd0;		
		CtrlSignalFlush=1'd0;		
		IF_regwrite=1'd1;			//enable
		PC_write=1'd1;				//enable
		ID_EXE_regwrite=1'd1;
		EXE_MEM_regwrite=1'd1;
		MEM_WB_regwrite=1'd1;
		Stall_IRWrite = 1'd1;
		Stall_CRWrite = 1'd1;
	end 
end
*/
 logic load_use, control_hazard;

    assign load_use = (ID_MemRead && ((ID_rd_addr == rs1_addr) || (ID_rd_addr == rs2_addr)))? 1'b1:1'b0;
    assign control_hazard = (BranchControl != 2'd0)? 1'b1:1'b0; //!PC4

    assign instruction_flush      = ~(IM_stall | DM_stall | CSR_stall) & (control_hazard | CSR_control | CSR_ret);
    assign CtrlSignalFlush = ~(IM_stall | DM_stall | CSR_stall) & (load_use | control_hazard | CSR_control | CSR_ret);
    assign IF_regwrite   = ~(IM_stall | DM_stall | load_use | CSR_stall);
    assign PC_write         = ~(IM_stall | DM_stall | load_use | CSR_stall);
    assign ID_EXE_regwrite  = ~(IM_stall | DM_stall | CSR_stall);
    assign EXE_MEM_regwrite = ~(IM_stall | DM_stall | CSR_stall);
    assign MEM_WB_regwrite  = ~(IM_stall | DM_stall | CSR_stall);
endmodule