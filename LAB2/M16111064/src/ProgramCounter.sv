module ProgramCounter(clk,rst,PC_write,pc_in,pc_out);
input clk,rst,PC_write;
input [31:0] pc_in;
output logic [31:0] pc_out;

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
	begin
		pc_out <= 32'd0;
	end
	else if (PC_write)
	begin
		pc_out <= pc_in;
	end
end
endmodule