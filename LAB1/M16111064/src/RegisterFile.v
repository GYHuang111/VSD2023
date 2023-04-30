module RegisterFile (clk,rst,WB_RegWrite,WB_rd_addr,IF_instruction_out,WB_rd_data,rs1_data,rs2_data);
input clk,rst,WB_RegWrite;
input [4:0]  WB_rd_addr;
input [9:0] IF_instruction_out;
input [31:0] WB_rd_data;
output [31:0] rs1_data,rs2_data;
wire [4:0] rs1_addr,rs2_addr,WB_rd_addr;
wire [31:0] rs1_data,rs2_data;
reg [31:0] Register [31:0];

assign rs1_data = Register[rs1_addr];
assign rs2_data = Register[rs2_addr];
assign rs1_addr = IF_instruction_out[4:0];
assign rs2_addr = IF_instruction_out[9:5];

always @ (posedge clk or posedge rst) begin
	if (rst) begin
		for (int i = 0;i<32;i++) begin
			Register[i] <= 32'd0;
		end
	end
	else begin
		if (WB_RegWrite && (WB_rd_addr != 5'd0)) begin //dont save to r0
		Register[WB_rd_addr] <= WB_rd_data;
		end
	end	
end

endmodule