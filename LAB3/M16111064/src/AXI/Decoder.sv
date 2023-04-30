`include "../../include/AXI_define.svh"

module Decoder (
    // VALID
    input VALID, // Master valid
    input [`AXI_ADDR_BITS-1:0] ADDR,
    output logic VALID_S0,
    output logic VALID_S1,
	output logic VALID_S2,
	output logic VALID_S3,
    output logic VALID_SDEFAULT,

    // READY
    input READY_S0,
    input READY_S1,
	input READY_S2,
	input READY_S3,
    input READY_SDEFAULT,
    output logic READY_S
);
    always_comb
    begin
		case(ADDR[31:16])
            16'h0000: //S0
            begin
                {VALID_SDEFAULT, VALID_S3, VALID_S2, VALID_S1, VALID_S0} = {4'b0, VALID};
                READY_S = (VALID) ? READY_S0 : 1'b0;        //modified
            end
            16'h0001: //S1
            begin
                {VALID_SDEFAULT, VALID_S3, VALID_S2, VALID_S1, VALID_S0} = {3'b0, VALID, 1'b0};
                READY_S = (VALID) ? READY_S1 : 1'b0;        //modified
            end
			16'h0002: //S2
            begin
                {VALID_SDEFAULT, VALID_S3, VALID_S2, VALID_S1, VALID_S0} = {2'b0, VALID, 2'b0};
                READY_S = (VALID) ? READY_S2 : 1'b0;        //modified
            end
			16'h2000,16'h2001,16'h2002,16'h2003,16'h2004,16'h2005,16'h2006,16'h2007,16'h2008,16'h2009,
			16'h200a,16'h200b,16'h200c,16'h200d,16'h200e,16'h200f,16'h2010,16'h2011,16'h2012,16'h2013,
			16'h2014,16'h2015,16'h2016,16'h2017,16'h2018,16'h2019,16'h201a,16'h201b,16'h201c,16'h201d,
			16'h201e,16'h201f: //S3
            begin
                {VALID_SDEFAULT, VALID_S3, VALID_S2, VALID_S1, VALID_S0} = {1'b0, VALID, 3'b0};
                READY_S = (VALID) ? READY_S3 : 1'b0;        //modified
            end
            default: //Default Slave
            begin
                {VALID_SDEFAULT, VALID_S3, VALID_S2, VALID_S1, VALID_S0} = {VALID, 4'b0};
                READY_S = (VALID) ? READY_SDEFAULT : 1'b0;  //modified
            end
        endcase
		/*
        case(ADDR[31:16])
            16'h0000: //S0
            begin
                {VALID_SDEFAULT, VALID_S1, VALID_S0} = {2'b0, VALID};
                READY_S = (VALID) ? READY_S0 : 1'b0;        //modified
            end
            16'h0001: //S1
            begin
                {VALID_SDEFAULT, VALID_S1, VALID_S0} = {1'b0, VALID, 1'b0};
                READY_S = (VALID) ? READY_S1 : 1'b0;        //modified
            end
            default: //Default Slave
            begin
                {VALID_SDEFAULT, VALID_S1, VALID_S0} = {VALID, 2'b0};
                READY_S = (VALID) ? READY_SDEFAULT : 1'b0;  //modified
            end
        endcase
		*/
    end
endmodule : Decoder
