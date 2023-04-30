module Hazard_control (ID_MemRead,BranchControl,ID_rd_addr,rs1_addr,rs2_addr,
instruction_flush,CtrlSignalFlush,IF_regwrite,PC_write);
input ID_MemRead;
input [1:0] BranchControl;
input [4:0] ID_rd_addr,rs1_addr,rs2_addr;
output reg instruction_flush,CtrlSignalFlush,IF_regwrite,PC_write;
parameter PCIMMRS1=2'd1,PCIMM=2'd2,PC4=2'd0;
always @(*) begin
	if (BranchControl!=2'd0) begin //if branch or jump occured
		instruction_flush=1'd1;		//let third instruction become 0000
		CtrlSignalFlush=1'd1;		//let second instruction become NOP
		IF_regwrite=1'd1;			//enable
		PC_write=1'd1;				//enable
	end
	else if ((ID_MemRead)&&((ID_rd_addr==rs1_addr)||(ID_rd_addr==rs2_addr))) begin //if load-use occured
		instruction_flush=1'd0;		
		CtrlSignalFlush=1'd1;		//let second instruction become NOP
		IF_regwrite=1'd0;			//disable to stop IF_reg
		PC_write=1'd0;				//disable to stop PC
	end
	else begin
		instruction_flush=1'd0;		
		CtrlSignalFlush=1'd0;		
		IF_regwrite=1'd1;			//enable
		PC_write=1'd1;				//enable
	end 
end
endmodule