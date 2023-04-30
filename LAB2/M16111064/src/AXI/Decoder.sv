`include "../../include/AXI_define.svh"

module Decoder (
    // VALID
    input VALID, // Master valid
    input [`AXI_ADDR_BITS-1:0] ADDR,
    output logic VALID_S0,
    output logic VALID_S1,
    output logic VALID_SDEFAULT,

    // READY
    input READY_S0,
    input READY_S1,
    input READY_SDEFAULT,
    output logic READY_S
);
    always_comb
    begin
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
    end
endmodule : Decoder
