module BranchControl (Zero_flag,ID_Branch,BranchControl);
input Zero_flag;
input [1:0] ID_Branch;
output logic [1:0] BranchControl;

parameter 	NO_Branch	= 2'd0,
			JAL_Branch	= 2'd1,
			JALR_Branch	= 2'd2,
			B_Branch	= 2'd3;

parameter	PCPLUSIMMRS1= 2'd1,
			PCPLUSIMM	= 2'd2,
			PCPLUS4		= 2'd0;
			
always_comb
begin
	case (ID_Branch)
		JALR_Branch:
		begin
			BranchControl = PCPLUSIMMRS1;
		end
		JAL_Branch:
		begin
			BranchControl = PCPLUSIMM;
		end
		B_Branch:
		begin
			if (Zero_flag)
			begin
				BranchControl = PCPLUSIMM;
			end
			else
			begin
				BranchControl = PCPLUS4;
			end
		end
		default:
		begin
			BranchControl = PCPLUS4;
		end
	endcase	
end
endmodule 