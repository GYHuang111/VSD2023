module Forwarding_Unit (EXE_RegWrite,MEM_RegWrite,EXE_rd_addr,MEM_rd_addr,ID_rs1_addr,ID_rs2_addr,Fowardingrs1,Fowardingrs2);
input EXE_RegWrite,MEM_RegWrite;
input [4:0] EXE_rd_addr,MEM_rd_addr,ID_rs1_addr,ID_rs2_addr;
output logic [1:0] Fowardingrs1,Fowardingrs2;

always_comb
begin
	if ((EXE_RegWrite)&&(EXE_rd_addr==ID_rs1_addr))
	begin //data_harzrd occured
		Fowardingrs1=2'd1;
	end
	else if ((MEM_RegWrite)&&(MEM_rd_addr==ID_rs1_addr))
	begin //load-use occured
		Fowardingrs1=2'd2;
	end
	else
	begin
		Fowardingrs1=2'd0;
	end
end

always_comb
begin
	if ((EXE_RegWrite)&&(EXE_rd_addr==ID_rs2_addr))
	begin //data_harzrd occured
		Fowardingrs2=2'd1;
	end
	else if ((MEM_RegWrite)&&(MEM_rd_addr==ID_rs2_addr))
	begin //load-use occured
		Fowardingrs2=2'd2;
	end
	else
	begin
		Fowardingrs2=2'd0;
	end
end

endmodule