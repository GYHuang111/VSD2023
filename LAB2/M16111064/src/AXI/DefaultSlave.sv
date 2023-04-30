`include "../../include/AXI_define.svh"

module DefaultSlave (
    input clk,  // Clock
    input rst,  // Asynchronous reset active high

    // RA receive
    input [`AXI_IDS_BITS-1:0]   ARID_SDEFAULT,
    input [`AXI_ADDR_BITS-1:0]  ARADDR_SDEFAULT,
    input [`AXI_LEN_BITS-1:0]   ARLEN_SDEFAULT,
    input [`AXI_SIZE_BITS-1:0]  ARSIZE_SDEFAULT,
    input [1:0] ARBURST_SDEFAULT,
    input ARVALID_SDEFAULT,
    // RA send
    output logic ARREADY_SDEFAULT,

    // RD send
    output logic [`AXI_IDS_BITS-1:0]    RID_SDEFAULT,
    output logic [`AXI_DATA_BITS-1:0]   RDATA_SDEFAULT,
    output logic [1:0] RRESP_SDEFAULT,
    output logic RLAST_SDEFAULT,
    output logic RVALID_SDEFAULT,
    // RD receive
    input RREADY_SDEFAULT,

    // WA receive
    input [`AXI_IDS_BITS-1:0]   AWID_SDEFAULT,
    input [`AXI_ADDR_BITS-1:0]  AWADDR_SDFAULT,
    input [`AXI_LEN_BITS-1:0]   AWLEN_SDEFAULT,
    input [`AXI_SIZE_BITS-1:0]  AWSIZE_SDEFAULT,
    input [1:0] AWBURST_SDEFAULT,
    input AWVALID_SDEFAULT,
    // WA send
    output logic AWREADY_SDEFAULT,

    // WD receive
    input [`AXI_DATA_BITS-1:0] WDATA_SDEFAULT,
    input [`AXI_STRB_BITS-1:0] WSTRB_SDEFAULT,
    input WLAST_SDEFAULT,
    input WVALID_SDEFAULT,
    // WD send
    output logic WREADY_SDEFAULT,

    // WR send
    output logic [`AXI_IDS_BITS-1:0] BID_SDEFAULT,
    output logic [1:0] BRESP_SDEFAULT,
    output logic BVALID_SDEFAULT,
    // WR receive
    input BREADY_SDEFAULT
);

    logic [1:0] slave_status, next_status;

    parameter [1:0] S_address   = 2'b00,
                    S_data_read = 2'b01,
                    S_data_write= 2'b10,
                    S_response  = 2'b11;

    always_ff @(posedge clk or negedge rst)
    begin
        if(~rst)
        begin
            slave_status <= 2'b00;
        end
        else
        begin
            slave_status <= next_status;
        end
    end

    always_comb
    begin
        case(slave_status)
            S_address:
            begin
                if(ARREADY_SDEFAULT & ARVALID_SDEFAULT)
                    next_status = S_data_read;
                else if (AWREADY_SDEFAULT & AWVALID_SDEFAULT)
                    next_status = S_data_write;
                else
                    next_status = S_address;
            end

            S_data_read:
            begin
                if(RVALID_SDEFAULT & RREADY_SDEFAULT)
                    next_status = S_address;
                else
                    next_status = S_data_read;
            end

            S_data_write:
            begin
                if(WVALID_SDEFAULT & WREADY_SDEFAULT & WLAST_SDEFAULT)
                    next_status = S_response;
                else
                    next_status = S_data_write;
            end

            S_response:
            begin
                if(BVALID_SDEFAULT & BREADY_SDEFAULT)
                    next_status = S_address;
                else
                    next_status = S_response;
            end
        endcase
    end

    // RA, RD
    assign ARREADY_SDEFAULT = (slave_status == S_address) ? 1'b1 : 1'b0;
    
    logic tmp_ARLEN;

    always_ff @(posedge clk or negedge rst)
    begin
        if(~rst)
            tmp_ARLEN <= 1'b0;
        else
            tmp_ARLEN <= (ARVALID_SDEFAULT & ARREADY_SDEFAULT) ? ARLEN_SDEFAULT : tmp_ARLEN;
    end

    always_ff @(posedge clk or negedge rst)
    begin
        if(~rst)
        begin
            RID_SDEFAULT <= 8'b0;
        end
        else
        begin
            RID_SDEFAULT <= (ARVALID_SDEFAULT & ARREADY_SDEFAULT) ? ARID_SDEFAULT : RID_SDEFAULT;
        end
    end

    assign RDATA_SDEFAULT = `AXI_DATA_BITS'b0;
    assign RRESP_SDEFAULT = `AXI_RESP_DECERR;
    assign RVALID_SDEFAULT = (slave_status == S_data_read) ? 1'b1 : 1'b0;

    always_ff @(posedge clk or negedge rst)
    begin
        if(~rst)
            RLAST_SDEFAULT <= 1'b1;
        else
        begin
            if(ARVALID_SDEFAULT & ARREADY_SDEFAULT)
            begin
                if(ARLEN_SDEFAULT == 4'b0)
                    RLAST_SDEFAULT <= 1'b1;
                else
                    RLAST_SDEFAULT <= 1'b0; 
            end
            else if(RVALID_SDEFAULT & RREADY_SDEFAULT)
            begin
                if((tmp_ARLEN == 4'b1) & (RLAST_SDEFAULT == 1'b0))
                    RLAST_SDEFAULT <= 1'b1;
            end
        end
    end

    // WA, WD, WR
    assign AWREADY_SDEFAULT = (AWVALID_SDEFAULT & (slave_status == S_address)) ? 1'b1 : 1'b0;

    always_ff @(posedge clk or negedge rst)
    begin
        if(~rst)
        begin
            BID_SDEFAULT <= 8'b0;
        end
        else
        begin
            BID_SDEFAULT <= (AWREADY_SDEFAULT & AWVALID_SDEFAULT) ? AWID_SDEFAULT : BID_SDEFAULT;
        end
    end
    assign WREADY_SDEFAULT = (WVALID_SDEFAULT && (slave_status == S_data_write));
    assign BRESP_SDEFAULT  = `AXI_RESP_DECERR;
    assign BVALID_SDEFAULT = (slave_status == S_response) ? 1'b1 : 1'b0;

endmodule : DefaultSlave
