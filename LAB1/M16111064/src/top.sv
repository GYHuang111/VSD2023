`include "SRAM_wrapper.sv"
`include "CPU.sv"
module top (clk,rst);
input clk,rst;
wire clk,rst,EXE_MemRead,CS;
wire [3:0] WEB;
wire [31:0] instruction,DO,DI,pc_out,EXE_ALU_out;
CPU cpu1 (
.clk(clk),
.rst(rst),
.instruction(instruction),
.DO(DO),
.CS(CS),
.WEB(WEB),
.DI(DI),
.pc_out(pc_out),
.EXE_ALU_out(EXE_ALU_out),
.EXE_MemRead(EXE_MemRead)
);

SRAM_wrapper IM1(
        .CK(~clk),
        .CS(1'b1),
        .OE(1'b1),
        .WEB(4'b1111), // low active
        .A(pc_out[15:2]),
        .DI(32'b0),
        .DO(instruction)
    );
        
SRAM_wrapper DM1(
        .CK(~clk),
        .CS(CS),
        .OE(EXE_MemRead),
        //.WEB({4{~EXE_MemWrite}}),
        .WEB(WEB),
        .A(EXE_ALU_out[15:2]), 
        //.DI(EXE_rs2_data),
        .DI(DI),
        .DO(DO)
    );  
endmodule
