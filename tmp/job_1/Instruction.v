// Generator : SpinalHDL v1.7.0    git head : eca519e78d4e6022e34911ec300a432ed9db8220
// Component : Instruction
// Git hash  : c291dcd37715455e40e542ccadbd87a15f27226d

`timescale 1ns/1ps

module Instruction (
  input               regSData_awvalid,
  output reg          regSData_awready,
  input      [19:0]   regSData_awaddr,
  input      [2:0]    regSData_awprot,
  input               regSData_wvalid,
  output reg          regSData_wready,
  input      [31:0]   regSData_wdata,
  input      [3:0]    regSData_wstrb,
  output              regSData_bvalid,
  input               regSData_bready,
  output     [1:0]    regSData_bresp,
  input               regSData_arvalid,
  output reg          regSData_arready,
  input      [19:0]   regSData_araddr,
  input      [2:0]    regSData_arprot,
  output              regSData_rvalid,
  input               regSData_rready,
  output     [31:0]   regSData_rdata,
  output     [1:0]    regSData_rresp,
  input      [3:0]    convState,
  output reg [3:0]    convControl,
  input      [3:0]    shapeState,
  output reg [3:0]    shapeControl,
  output reg [31:0]   instruction0,
  output reg [31:0]   instruction1,
  output reg [31:0]   instruction2,
  output reg [31:0]   instruction3,
  output reg [31:0]   instruction4,
  output reg [31:0]   instruction5,
  output reg [31:0]   convwriteAddr,
  output reg [31:0]   convwriteLen,
  output reg [31:0]   convreadAddr,
  output reg [31:0]   convreadLen,
  output reg [31:0]   shapewriteAddr,
  output reg [31:0]   shapewriteLen,
  output reg [31:0]   shapereadAddr,
  output reg [31:0]   shapereadLen,
  output reg [31:0]   shapereadAddr1,
  output reg [31:0]   shapereadLen1,
  input               clk,
  input               reset
);

  reg                 bus_readError;
  reg        [31:0]   bus_readData;
  wire                bus_axiAr_valid;
  wire                bus_axiAr_ready;
  wire       [19:0]   bus_axiAr_payload_addr;
  wire       [2:0]    bus_axiAr_payload_prot;
  reg                 regSData_ar_rValid;
  reg        [19:0]   regSData_ar_rData_addr;
  reg        [2:0]    regSData_ar_rData_prot;
  wire                when_Stream_l368;
  wire                bus_axiR_valid;
  wire                bus_axiR_ready;
  wire       [31:0]   bus_axiR_payload_data;
  wire       [1:0]    bus_axiR_payload_resp;
  reg                 bus_axiRValid;
  wire                bus_axiAw_valid;
  wire                bus_axiAw_ready;
  wire       [19:0]   bus_axiAw_payload_addr;
  wire       [2:0]    bus_axiAw_payload_prot;
  reg                 regSData_aw_rValid;
  reg        [19:0]   regSData_aw_rData_addr;
  reg        [2:0]    regSData_aw_rData_prot;
  wire                when_Stream_l368_1;
  wire                bus_axiW_valid;
  wire                bus_axiW_ready;
  wire       [31:0]   bus_axiW_payload_data;
  wire       [3:0]    bus_axiW_payload_strb;
  reg                 regSData_w_rValid;
  reg        [31:0]   regSData_w_rData_data;
  reg        [3:0]    regSData_w_rData_strb;
  wire                when_Stream_l368_2;
  wire                bus_axiB_valid;
  wire                bus_axiB_ready;
  wire       [1:0]    bus_axiB_payload_resp;
  reg                 bus_axiBValid;
  wire                bus_doWrite;
  wire                bus_doRead;
  wire                when_RegInst_l281;
  wire                when_RegInst_l281_1;
  wire                when_RegInst_l281_2;
  wire                when_RegInst_l281_3;
  wire                when_RegInst_l281_4;
  wire                when_RegInst_l281_5;
  wire                when_RegInst_l281_6;
  wire                when_RegInst_l281_7;
  wire                when_RegInst_l281_8;
  wire                when_RegInst_l281_9;
  wire                when_RegInst_l281_10;
  wire                when_RegInst_l281_11;
  wire                when_RegInst_l281_12;
  wire                when_RegInst_l281_13;
  wire                when_RegInst_l281_14;
  wire                when_RegInst_l281_15;
  wire                when_RegInst_l281_16;
  wire                when_RegInst_l281_17;

  always @(*) begin
    regSData_arready = bus_axiAr_ready;
    if(when_Stream_l368) begin
      regSData_arready = 1'b1;
    end
  end

  assign when_Stream_l368 = (! bus_axiAr_valid);
  assign bus_axiAr_valid = regSData_ar_rValid;
  assign bus_axiAr_payload_addr = regSData_ar_rData_addr;
  assign bus_axiAr_payload_prot = regSData_ar_rData_prot;
  always @(*) begin
    regSData_awready = bus_axiAw_ready;
    if(when_Stream_l368_1) begin
      regSData_awready = 1'b1;
    end
  end

  assign when_Stream_l368_1 = (! bus_axiAw_valid);
  assign bus_axiAw_valid = regSData_aw_rValid;
  assign bus_axiAw_payload_addr = regSData_aw_rData_addr;
  assign bus_axiAw_payload_prot = regSData_aw_rData_prot;
  always @(*) begin
    regSData_wready = bus_axiW_ready;
    if(when_Stream_l368_2) begin
      regSData_wready = 1'b1;
    end
  end

  assign when_Stream_l368_2 = (! bus_axiW_valid);
  assign bus_axiW_valid = regSData_w_rValid;
  assign bus_axiW_payload_data = regSData_w_rData_data;
  assign bus_axiW_payload_strb = regSData_w_rData_strb;
  assign bus_axiAr_ready = ((! bus_axiRValid) || bus_axiR_ready);
  assign bus_axiR_payload_resp = 2'b00;
  assign bus_axiR_valid = bus_axiRValid;
  assign bus_axiR_payload_data = bus_readData;
  assign bus_axiAw_ready = (bus_axiAw_valid && bus_axiW_valid);
  assign bus_axiW_ready = (bus_axiAw_valid && bus_axiW_valid);
  assign bus_axiB_payload_resp = 2'b00;
  assign bus_axiB_valid = bus_axiBValid;
  assign regSData_rvalid = bus_axiR_valid;
  assign bus_axiR_ready = regSData_rready;
  assign regSData_rdata = bus_axiR_payload_data;
  assign regSData_rresp = bus_axiR_payload_resp;
  assign regSData_bvalid = bus_axiB_valid;
  assign bus_axiB_ready = regSData_bready;
  assign regSData_bresp = bus_axiB_payload_resp;
  assign bus_doWrite = (bus_axiAw_valid && bus_axiW_valid);
  assign bus_doRead = (bus_axiAr_valid && bus_axiAr_ready);
  assign when_RegInst_l281 = ((bus_axiAw_payload_addr == 20'h00004) && bus_doWrite);
  assign when_RegInst_l281_1 = ((bus_axiAw_payload_addr == 20'h0000c) && bus_doWrite);
  assign when_RegInst_l281_2 = ((bus_axiAw_payload_addr == 20'h00010) && bus_doWrite);
  assign when_RegInst_l281_3 = ((bus_axiAw_payload_addr == 20'h00014) && bus_doWrite);
  assign when_RegInst_l281_4 = ((bus_axiAw_payload_addr == 20'h00018) && bus_doWrite);
  assign when_RegInst_l281_5 = ((bus_axiAw_payload_addr == 20'h0001c) && bus_doWrite);
  assign when_RegInst_l281_6 = ((bus_axiAw_payload_addr == 20'h00020) && bus_doWrite);
  assign when_RegInst_l281_7 = ((bus_axiAw_payload_addr == 20'h00024) && bus_doWrite);
  assign when_RegInst_l281_8 = ((bus_axiAw_payload_addr == 20'h00028) && bus_doWrite);
  assign when_RegInst_l281_9 = ((bus_axiAw_payload_addr == 20'h0002c) && bus_doWrite);
  assign when_RegInst_l281_10 = ((bus_axiAw_payload_addr == 20'h00030) && bus_doWrite);
  assign when_RegInst_l281_11 = ((bus_axiAw_payload_addr == 20'h00034) && bus_doWrite);
  assign when_RegInst_l281_12 = ((bus_axiAw_payload_addr == 20'h00038) && bus_doWrite);
  assign when_RegInst_l281_13 = ((bus_axiAw_payload_addr == 20'h0003c) && bus_doWrite);
  assign when_RegInst_l281_14 = ((bus_axiAw_payload_addr == 20'h00040) && bus_doWrite);
  assign when_RegInst_l281_15 = ((bus_axiAw_payload_addr == 20'h00044) && bus_doWrite);
  assign when_RegInst_l281_16 = ((bus_axiAw_payload_addr == 20'h00048) && bus_doWrite);
  assign when_RegInst_l281_17 = ((bus_axiAw_payload_addr == 20'h0004c) && bus_doWrite);
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      bus_readError <= 1'b0;
      bus_readData <= 32'h0;
      regSData_ar_rValid <= 1'b0;
      bus_axiRValid <= 1'b0;
      regSData_aw_rValid <= 1'b0;
      regSData_w_rValid <= 1'b0;
      bus_axiBValid <= 1'b0;
      convControl <= 4'b0000;
      shapeControl <= 4'b0000;
      instruction0 <= 32'h0;
      instruction1 <= 32'h0;
      instruction2 <= 32'h0;
      instruction3 <= 32'h0;
      instruction4 <= 32'h0;
      instruction5 <= 32'h0;
      convwriteAddr <= 32'h0;
      convwriteLen <= 32'h0;
      convreadAddr <= 32'h0;
      convreadLen <= 32'h0;
      shapewriteAddr <= 32'h0;
      shapewriteLen <= 32'h0;
      shapereadAddr <= 32'h0;
      shapereadLen <= 32'h0;
      shapereadAddr1 <= 32'h0;
      shapereadLen1 <= 32'h0;
    end else begin
      if(regSData_arready) begin
        regSData_ar_rValid <= regSData_arvalid;
      end
      if(regSData_awready) begin
        regSData_aw_rValid <= regSData_awvalid;
      end
      if(regSData_wready) begin
        regSData_w_rValid <= regSData_wvalid;
      end
      bus_axiRValid <= bus_doRead;
      bus_axiBValid <= bus_doWrite;
      if(when_RegInst_l281) begin
        convControl <= bus_axiW_payload_data[3 : 0];
      end
      if(when_RegInst_l281_1) begin
        shapeControl <= bus_axiW_payload_data[3 : 0];
      end
      if(when_RegInst_l281_2) begin
        instruction0 <= bus_axiW_payload_data[31 : 0];
      end
      if(when_RegInst_l281_3) begin
        instruction1 <= bus_axiW_payload_data[31 : 0];
      end
      if(when_RegInst_l281_4) begin
        instruction2 <= bus_axiW_payload_data[31 : 0];
      end
      if(when_RegInst_l281_5) begin
        instruction3 <= bus_axiW_payload_data[31 : 0];
      end
      if(when_RegInst_l281_6) begin
        instruction4 <= bus_axiW_payload_data[31 : 0];
      end
      if(when_RegInst_l281_7) begin
        instruction5 <= bus_axiW_payload_data[31 : 0];
      end
      if(when_RegInst_l281_8) begin
        convwriteAddr <= bus_axiW_payload_data[31 : 0];
      end
      if(when_RegInst_l281_9) begin
        convwriteLen <= bus_axiW_payload_data[31 : 0];
      end
      if(when_RegInst_l281_10) begin
        convreadAddr <= bus_axiW_payload_data[31 : 0];
      end
      if(when_RegInst_l281_11) begin
        convreadLen <= bus_axiW_payload_data[31 : 0];
      end
      if(when_RegInst_l281_12) begin
        shapewriteAddr <= bus_axiW_payload_data[31 : 0];
      end
      if(when_RegInst_l281_13) begin
        shapewriteLen <= bus_axiW_payload_data[31 : 0];
      end
      if(when_RegInst_l281_14) begin
        shapereadAddr <= bus_axiW_payload_data[31 : 0];
      end
      if(when_RegInst_l281_15) begin
        shapereadLen <= bus_axiW_payload_data[31 : 0];
      end
      if(when_RegInst_l281_16) begin
        shapereadAddr1 <= bus_axiW_payload_data[31 : 0];
      end
      if(when_RegInst_l281_17) begin
        shapereadLen1 <= bus_axiW_payload_data[31 : 0];
      end
      if(bus_axiAr_valid) begin
        case(bus_axiAr_payload_addr)
          20'h0 : begin
            bus_readData <= {28'h0,convState};
            bus_readError <= 1'b0;
          end
          20'h00004 : begin
            bus_readData <= {28'h0,convControl};
            bus_readError <= 1'b1;
          end
          20'h00008 : begin
            bus_readData <= {28'h0,shapeState};
            bus_readError <= 1'b0;
          end
          20'h0000c : begin
            bus_readData <= {28'h0,shapeControl};
            bus_readError <= 1'b1;
          end
          20'h00010 : begin
            bus_readData <= instruction0;
            bus_readError <= 1'b1;
          end
          20'h00014 : begin
            bus_readData <= instruction1;
            bus_readError <= 1'b1;
          end
          20'h00018 : begin
            bus_readData <= instruction2;
            bus_readError <= 1'b1;
          end
          20'h0001c : begin
            bus_readData <= instruction3;
            bus_readError <= 1'b1;
          end
          20'h00020 : begin
            bus_readData <= instruction4;
            bus_readError <= 1'b1;
          end
          20'h00024 : begin
            bus_readData <= instruction5;
            bus_readError <= 1'b1;
          end
          20'h00028 : begin
            bus_readData <= convwriteAddr;
            bus_readError <= 1'b1;
          end
          20'h0002c : begin
            bus_readData <= convwriteLen;
            bus_readError <= 1'b1;
          end
          20'h00030 : begin
            bus_readData <= convreadAddr;
            bus_readError <= 1'b1;
          end
          20'h00034 : begin
            bus_readData <= convreadLen;
            bus_readError <= 1'b1;
          end
          20'h00038 : begin
            bus_readData <= shapewriteAddr;
            bus_readError <= 1'b1;
          end
          20'h0003c : begin
            bus_readData <= shapewriteLen;
            bus_readError <= 1'b1;
          end
          20'h00040 : begin
            bus_readData <= shapereadAddr;
            bus_readError <= 1'b1;
          end
          20'h00044 : begin
            bus_readData <= shapereadLen;
            bus_readError <= 1'b1;
          end
          20'h00048 : begin
            bus_readData <= shapereadAddr1;
            bus_readError <= 1'b1;
          end
          20'h0004c : begin
            bus_readData <= shapereadLen1;
            bus_readError <= 1'b1;
          end
          default : begin
            bus_readData <= 32'h0;
            bus_readError <= 1'b1;
          end
        endcase
      end
    end
  end

  always @(posedge clk) begin
    if(regSData_arready) begin
      regSData_ar_rData_addr <= regSData_araddr;
      regSData_ar_rData_prot <= regSData_arprot;
    end
    if(regSData_awready) begin
      regSData_aw_rData_addr <= regSData_awaddr;
      regSData_aw_rData_prot <= regSData_awprot;
    end
    if(regSData_wready) begin
      regSData_w_rData_data <= regSData_wdata;
      regSData_w_rData_strb <= regSData_wstrb;
    end
  end


endmodule
