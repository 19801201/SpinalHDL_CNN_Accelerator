// Generator : SpinalHDL v1.7.0    git head : eca519e78d4e6022e34911ec300a432ed9db8220
// Component : Npu
// Git hash  : c291dcd37715455e40e542ccadbd87a15f27226d

`timescale 1ns/1ps

module Npu (
  output              convSData_arvalid,
  input               convSData_arready,
  output     [31:0]   convSData_araddr,
  output     [7:0]    convSData_arlen,
  output     [2:0]    convSData_arsize,
  output     [1:0]    convSData_arburst,
  output     [3:0]    convSData_arcache,
  output     [2:0]    convSData_arprot,
  input               convSData_rvalid,
  output              convSData_rready,
  input      [63:0]   convSData_rdata,
  input      [1:0]    convSData_rresp,
  input               convSData_rlast,
  output              convMData_awvalid,
  input               convMData_awready,
  output     [31:0]   convMData_awaddr,
  output     [7:0]    convMData_awlen,
  output     [2:0]    convMData_awsize,
  output     [1:0]    convMData_awburst,
  output     [3:0]    convMData_awcache,
  output     [2:0]    convMData_awprot,
  output              convMData_wvalid,
  input               convMData_wready,
  output     [63:0]   convMData_wdata,
  output     [7:0]    convMData_wstrb,
  output              convMData_wlast,
  input               convMData_bvalid,
  output              convMData_bready,
  input      [1:0]    convMData_bresp,
  output              shapeSData_arvalid,
  input               shapeSData_arready,
  output     [31:0]   shapeSData_araddr,
  output     [7:0]    shapeSData_arlen,
  output     [2:0]    shapeSData_arsize,
  output     [1:0]    shapeSData_arburst,
  output     [3:0]    shapeSData_arcache,
  output     [2:0]    shapeSData_arprot,
  input               shapeSData_rvalid,
  output              shapeSData_rready,
  input      [63:0]   shapeSData_rdata,
  input      [1:0]    shapeSData_rresp,
  input               shapeSData_rlast,
  output              shapeSData1_arvalid,
  input               shapeSData1_arready,
  output     [31:0]   shapeSData1_araddr,
  output     [7:0]    shapeSData1_arlen,
  output     [2:0]    shapeSData1_arsize,
  output     [1:0]    shapeSData1_arburst,
  output     [3:0]    shapeSData1_arcache,
  output     [2:0]    shapeSData1_arprot,
  input               shapeSData1_rvalid,
  output              shapeSData1_rready,
  input      [63:0]   shapeSData1_rdata,
  input      [1:0]    shapeSData1_rresp,
  input               shapeSData1_rlast,
  output              shapeMData_awvalid,
  input               shapeMData_awready,
  output     [31:0]   shapeMData_awaddr,
  output     [7:0]    shapeMData_awlen,
  output     [2:0]    shapeMData_awsize,
  output     [1:0]    shapeMData_awburst,
  output     [3:0]    shapeMData_awcache,
  output     [2:0]    shapeMData_awprot,
  output              shapeMData_wvalid,
  input               shapeMData_wready,
  output     [63:0]   shapeMData_wdata,
  output     [7:0]    shapeMData_wstrb,
  output              shapeMData_wlast,
  input               shapeMData_bvalid,
  output              shapeMData_bready,
  input      [1:0]    shapeMData_bresp,
  input               regSData_awvalid,
  output              regSData_awready,
  input      [19:0]   regSData_awaddr,
  input      [2:0]    regSData_awprot,
  input               regSData_wvalid,
  output              regSData_wready,
  input      [31:0]   regSData_wdata,
  input      [3:0]    regSData_wstrb,
  output              regSData_bvalid,
  input               regSData_bready,
  output     [1:0]    regSData_bresp,
  input               regSData_arvalid,
  output              regSData_arready,
  input      [19:0]   regSData_araddr,
  input      [2:0]    regSData_arprot,
  output              regSData_rvalid,
  input               regSData_rready,
  output     [31:0]   regSData_rdata,
  output     [1:0]    regSData_rresp,
  input               reset,
  input               clk,
  input               RST_2X,
  input               CLK_2X
);

  wire       [31:0]   convDmaWrite_cmd_addr;
  wire       [31:0]   convDmaWrite_cmd_len;
  wire       [31:0]   convDmaRead_cmd_addr;
  wire       [31:0]   convDmaRead_cmd_len;
  wire       [31:0]   shapeDmaWrite_cmd_addr;
  wire       [31:0]   shapeDmaWrite_cmd_len;
  wire       [31:0]   shapeDmaRead_cmd_addr;
  wire       [31:0]   shapeDmaRead_cmd_len;
  wire       [31:0]   shapeDmaRead1_cmd_addr;
  wire       [31:0]   shapeDmaRead1_cmd_len;
  wire                convDmaWrite_M_AXI_S2MM_awvalid;
  wire       [31:0]   convDmaWrite_M_AXI_S2MM_awaddr;
  wire       [7:0]    convDmaWrite_M_AXI_S2MM_awlen;
  wire       [2:0]    convDmaWrite_M_AXI_S2MM_awsize;
  wire       [1:0]    convDmaWrite_M_AXI_S2MM_awburst;
  wire       [3:0]    convDmaWrite_M_AXI_S2MM_awcache;
  wire       [2:0]    convDmaWrite_M_AXI_S2MM_awprot;
  wire                convDmaWrite_M_AXI_S2MM_wvalid;
  wire       [63:0]   convDmaWrite_M_AXI_S2MM_wdata;
  wire       [7:0]    convDmaWrite_M_AXI_S2MM_wstrb;
  wire                convDmaWrite_M_AXI_S2MM_wlast;
  wire                convDmaWrite_M_AXI_S2MM_bready;
  wire                convDmaWrite_M_AXIS_S2MM_ready;
  wire                convDmaWrite_cmd_introut;
  wire                convDmaRead_M_AXI_MM2S_arvalid;
  wire       [31:0]   convDmaRead_M_AXI_MM2S_araddr;
  wire       [7:0]    convDmaRead_M_AXI_MM2S_arlen;
  wire       [2:0]    convDmaRead_M_AXI_MM2S_arsize;
  wire       [1:0]    convDmaRead_M_AXI_MM2S_arburst;
  wire       [3:0]    convDmaRead_M_AXI_MM2S_arcache;
  wire       [2:0]    convDmaRead_M_AXI_MM2S_arprot;
  wire                convDmaRead_M_AXI_MM2S_rready;
  wire                convDmaRead_M_AXIS_MM2S_valid;
  wire       [63:0]   convDmaRead_M_AXIS_MM2S_payload;
  wire                convDmaRead_cmd_introut;
  wire                shapeDmaWrite_M_AXI_S2MM_awvalid;
  wire       [31:0]   shapeDmaWrite_M_AXI_S2MM_awaddr;
  wire       [7:0]    shapeDmaWrite_M_AXI_S2MM_awlen;
  wire       [2:0]    shapeDmaWrite_M_AXI_S2MM_awsize;
  wire       [1:0]    shapeDmaWrite_M_AXI_S2MM_awburst;
  wire       [3:0]    shapeDmaWrite_M_AXI_S2MM_awcache;
  wire       [2:0]    shapeDmaWrite_M_AXI_S2MM_awprot;
  wire                shapeDmaWrite_M_AXI_S2MM_wvalid;
  wire       [63:0]   shapeDmaWrite_M_AXI_S2MM_wdata;
  wire       [7:0]    shapeDmaWrite_M_AXI_S2MM_wstrb;
  wire                shapeDmaWrite_M_AXI_S2MM_wlast;
  wire                shapeDmaWrite_M_AXI_S2MM_bready;
  wire                shapeDmaWrite_M_AXIS_S2MM_ready;
  wire                shapeDmaWrite_cmd_introut;
  wire                shapeDmaRead_M_AXI_MM2S_arvalid;
  wire       [31:0]   shapeDmaRead_M_AXI_MM2S_araddr;
  wire       [7:0]    shapeDmaRead_M_AXI_MM2S_arlen;
  wire       [2:0]    shapeDmaRead_M_AXI_MM2S_arsize;
  wire       [1:0]    shapeDmaRead_M_AXI_MM2S_arburst;
  wire       [3:0]    shapeDmaRead_M_AXI_MM2S_arcache;
  wire       [2:0]    shapeDmaRead_M_AXI_MM2S_arprot;
  wire                shapeDmaRead_M_AXI_MM2S_rready;
  wire                shapeDmaRead_M_AXIS_MM2S_valid;
  wire       [63:0]   shapeDmaRead_M_AXIS_MM2S_payload;
  wire                shapeDmaRead_cmd_introut;
  wire                shapeDmaRead1_M_AXI_MM2S_arvalid;
  wire       [31:0]   shapeDmaRead1_M_AXI_MM2S_araddr;
  wire       [7:0]    shapeDmaRead1_M_AXI_MM2S_arlen;
  wire       [2:0]    shapeDmaRead1_M_AXI_MM2S_arsize;
  wire       [1:0]    shapeDmaRead1_M_AXI_MM2S_arburst;
  wire       [3:0]    shapeDmaRead1_M_AXI_MM2S_arcache;
  wire       [2:0]    shapeDmaRead1_M_AXI_MM2S_arprot;
  wire                shapeDmaRead1_M_AXI_MM2S_rready;
  wire                shapeDmaRead1_M_AXIS_MM2S_valid;
  wire       [63:0]   shapeDmaRead1_M_AXIS_MM2S_payload;
  wire                shapeDmaRead1_cmd_introut;
  wire                conv_1_sData_ready;
  wire                conv_1_mData_valid;
  wire       [63:0]   conv_1_mData_payload;
  wire       [3:0]    conv_1_state;
  wire                conv_1_dmaReadValid;
  wire                conv_1_dmaWriteValid;
  wire                shape_1_sData_0_ready;
  wire                shape_1_sData_1_ready;
  wire                shape_1_mData_valid;
  wire       [63:0]   shape_1_mData_payload;
  wire                shape_1_dmaReadValid_0;
  wire                shape_1_dmaReadValid_1;
  wire                shape_1_dmaWriteValid;
  wire       [3:0]    shape_1_state;
  wire                register_1_regSData_awready;
  wire                register_1_regSData_wready;
  wire                register_1_regSData_bvalid;
  wire       [1:0]    register_1_regSData_bresp;
  wire                register_1_regSData_arready;
  wire                register_1_regSData_rvalid;
  wire       [31:0]   register_1_regSData_rdata;
  wire       [1:0]    register_1_regSData_rresp;
  wire       [3:0]    register_1_convControl;
  wire       [3:0]    register_1_shapeControl;
  wire       [31:0]   register_1_instruction0;
  wire       [31:0]   register_1_instruction1;
  wire       [31:0]   register_1_instruction2;
  wire       [31:0]   register_1_instruction3;
  wire       [31:0]   register_1_instruction4;
  wire       [31:0]   register_1_instruction5;
  wire       [31:0]   register_1_convwriteAddr;
  wire       [31:0]   register_1_convwriteLen;
  wire       [31:0]   register_1_convreadAddr;
  wire       [31:0]   register_1_convreadLen;
  wire       [31:0]   register_1_shapewriteAddr;
  wire       [31:0]   register_1_shapewriteLen;
  wire       [31:0]   register_1_shapereadAddr;
  wire       [31:0]   register_1_shapereadLen;
  wire       [31:0]   register_1_shapereadAddr1;
  wire       [31:0]   register_1_shapereadLen1;

  DmaWrite convDmaWrite (
    .M_AXI_S2MM_awvalid  (convDmaWrite_M_AXI_S2MM_awvalid     ), //o
    .M_AXI_S2MM_awready  (convMData_awready                   ), //i
    .M_AXI_S2MM_awaddr   (convDmaWrite_M_AXI_S2MM_awaddr[31:0]), //o
    .M_AXI_S2MM_awlen    (convDmaWrite_M_AXI_S2MM_awlen[7:0]  ), //o
    .M_AXI_S2MM_awsize   (convDmaWrite_M_AXI_S2MM_awsize[2:0] ), //o
    .M_AXI_S2MM_awburst  (convDmaWrite_M_AXI_S2MM_awburst[1:0]), //o
    .M_AXI_S2MM_awcache  (convDmaWrite_M_AXI_S2MM_awcache[3:0]), //o
    .M_AXI_S2MM_awprot   (convDmaWrite_M_AXI_S2MM_awprot[2:0] ), //o
    .M_AXI_S2MM_wvalid   (convDmaWrite_M_AXI_S2MM_wvalid      ), //o
    .M_AXI_S2MM_wready   (convMData_wready                    ), //i
    .M_AXI_S2MM_wdata    (convDmaWrite_M_AXI_S2MM_wdata[63:0] ), //o
    .M_AXI_S2MM_wstrb    (convDmaWrite_M_AXI_S2MM_wstrb[7:0]  ), //o
    .M_AXI_S2MM_wlast    (convDmaWrite_M_AXI_S2MM_wlast       ), //o
    .M_AXI_S2MM_bvalid   (convMData_bvalid                    ), //i
    .M_AXI_S2MM_bready   (convDmaWrite_M_AXI_S2MM_bready      ), //o
    .M_AXI_S2MM_bresp    (convMData_bresp[1:0]                ), //i
    .M_AXIS_S2MM_valid   (conv_1_mData_valid                  ), //i
    .M_AXIS_S2MM_ready   (convDmaWrite_M_AXIS_S2MM_ready      ), //o
    .M_AXIS_S2MM_payload (conv_1_mData_payload[63:0]          ), //i
    .cmd_valid           (conv_1_dmaWriteValid                ), //i
    .cmd_addr            (convDmaWrite_cmd_addr[31:0]         ), //i
    .cmd_len             (convDmaWrite_cmd_len[31:0]          ), //i
    .cmd_introut         (convDmaWrite_cmd_introut            ), //o
    .clk                 (clk                                 ), //i
    .reset               (reset                               )  //i
  );
  DmaRead convDmaRead (
    .M_AXI_MM2S_arvalid  (convDmaRead_M_AXI_MM2S_arvalid       ), //o
    .M_AXI_MM2S_arready  (convSData_arready                    ), //i
    .M_AXI_MM2S_araddr   (convDmaRead_M_AXI_MM2S_araddr[31:0]  ), //o
    .M_AXI_MM2S_arlen    (convDmaRead_M_AXI_MM2S_arlen[7:0]    ), //o
    .M_AXI_MM2S_arsize   (convDmaRead_M_AXI_MM2S_arsize[2:0]   ), //o
    .M_AXI_MM2S_arburst  (convDmaRead_M_AXI_MM2S_arburst[1:0]  ), //o
    .M_AXI_MM2S_arcache  (convDmaRead_M_AXI_MM2S_arcache[3:0]  ), //o
    .M_AXI_MM2S_arprot   (convDmaRead_M_AXI_MM2S_arprot[2:0]   ), //o
    .M_AXI_MM2S_rvalid   (convSData_rvalid                     ), //i
    .M_AXI_MM2S_rready   (convDmaRead_M_AXI_MM2S_rready        ), //o
    .M_AXI_MM2S_rdata    (convSData_rdata[63:0]                ), //i
    .M_AXI_MM2S_rresp    (convSData_rresp[1:0]                 ), //i
    .M_AXI_MM2S_rlast    (convSData_rlast                      ), //i
    .M_AXIS_MM2S_valid   (convDmaRead_M_AXIS_MM2S_valid        ), //o
    .M_AXIS_MM2S_ready   (conv_1_sData_ready                   ), //i
    .M_AXIS_MM2S_payload (convDmaRead_M_AXIS_MM2S_payload[63:0]), //o
    .cmd_valid           (conv_1_dmaReadValid                  ), //i
    .cmd_addr            (convDmaRead_cmd_addr[31:0]           ), //i
    .cmd_len             (convDmaRead_cmd_len[31:0]            ), //i
    .cmd_introut         (convDmaRead_cmd_introut              ), //o
    .clk                 (clk                                  ), //i
    .reset               (reset                                )  //i
  );
  DmaWrite shapeDmaWrite (
    .M_AXI_S2MM_awvalid  (shapeDmaWrite_M_AXI_S2MM_awvalid     ), //o
    .M_AXI_S2MM_awready  (shapeMData_awready                   ), //i
    .M_AXI_S2MM_awaddr   (shapeDmaWrite_M_AXI_S2MM_awaddr[31:0]), //o
    .M_AXI_S2MM_awlen    (shapeDmaWrite_M_AXI_S2MM_awlen[7:0]  ), //o
    .M_AXI_S2MM_awsize   (shapeDmaWrite_M_AXI_S2MM_awsize[2:0] ), //o
    .M_AXI_S2MM_awburst  (shapeDmaWrite_M_AXI_S2MM_awburst[1:0]), //o
    .M_AXI_S2MM_awcache  (shapeDmaWrite_M_AXI_S2MM_awcache[3:0]), //o
    .M_AXI_S2MM_awprot   (shapeDmaWrite_M_AXI_S2MM_awprot[2:0] ), //o
    .M_AXI_S2MM_wvalid   (shapeDmaWrite_M_AXI_S2MM_wvalid      ), //o
    .M_AXI_S2MM_wready   (shapeMData_wready                    ), //i
    .M_AXI_S2MM_wdata    (shapeDmaWrite_M_AXI_S2MM_wdata[63:0] ), //o
    .M_AXI_S2MM_wstrb    (shapeDmaWrite_M_AXI_S2MM_wstrb[7:0]  ), //o
    .M_AXI_S2MM_wlast    (shapeDmaWrite_M_AXI_S2MM_wlast       ), //o
    .M_AXI_S2MM_bvalid   (shapeMData_bvalid                    ), //i
    .M_AXI_S2MM_bready   (shapeDmaWrite_M_AXI_S2MM_bready      ), //o
    .M_AXI_S2MM_bresp    (shapeMData_bresp[1:0]                ), //i
    .M_AXIS_S2MM_valid   (shape_1_mData_valid                  ), //i
    .M_AXIS_S2MM_ready   (shapeDmaWrite_M_AXIS_S2MM_ready      ), //o
    .M_AXIS_S2MM_payload (shape_1_mData_payload[63:0]          ), //i
    .cmd_valid           (shape_1_dmaWriteValid                ), //i
    .cmd_addr            (shapeDmaWrite_cmd_addr[31:0]         ), //i
    .cmd_len             (shapeDmaWrite_cmd_len[31:0]          ), //i
    .cmd_introut         (shapeDmaWrite_cmd_introut            ), //o
    .clk                 (clk                                  ), //i
    .reset               (reset                                )  //i
  );
  DmaRead shapeDmaRead (
    .M_AXI_MM2S_arvalid  (shapeDmaRead_M_AXI_MM2S_arvalid       ), //o
    .M_AXI_MM2S_arready  (shapeSData_arready                    ), //i
    .M_AXI_MM2S_araddr   (shapeDmaRead_M_AXI_MM2S_araddr[31:0]  ), //o
    .M_AXI_MM2S_arlen    (shapeDmaRead_M_AXI_MM2S_arlen[7:0]    ), //o
    .M_AXI_MM2S_arsize   (shapeDmaRead_M_AXI_MM2S_arsize[2:0]   ), //o
    .M_AXI_MM2S_arburst  (shapeDmaRead_M_AXI_MM2S_arburst[1:0]  ), //o
    .M_AXI_MM2S_arcache  (shapeDmaRead_M_AXI_MM2S_arcache[3:0]  ), //o
    .M_AXI_MM2S_arprot   (shapeDmaRead_M_AXI_MM2S_arprot[2:0]   ), //o
    .M_AXI_MM2S_rvalid   (shapeSData_rvalid                     ), //i
    .M_AXI_MM2S_rready   (shapeDmaRead_M_AXI_MM2S_rready        ), //o
    .M_AXI_MM2S_rdata    (shapeSData_rdata[63:0]                ), //i
    .M_AXI_MM2S_rresp    (shapeSData_rresp[1:0]                 ), //i
    .M_AXI_MM2S_rlast    (shapeSData_rlast                      ), //i
    .M_AXIS_MM2S_valid   (shapeDmaRead_M_AXIS_MM2S_valid        ), //o
    .M_AXIS_MM2S_ready   (shape_1_sData_0_ready                 ), //i
    .M_AXIS_MM2S_payload (shapeDmaRead_M_AXIS_MM2S_payload[63:0]), //o
    .cmd_valid           (shape_1_dmaReadValid_0                ), //i
    .cmd_addr            (shapeDmaRead_cmd_addr[31:0]           ), //i
    .cmd_len             (shapeDmaRead_cmd_len[31:0]            ), //i
    .cmd_introut         (shapeDmaRead_cmd_introut              ), //o
    .clk                 (clk                                   ), //i
    .reset               (reset                                 )  //i
  );
  DmaRead shapeDmaRead1 (
    .M_AXI_MM2S_arvalid  (shapeDmaRead1_M_AXI_MM2S_arvalid       ), //o
    .M_AXI_MM2S_arready  (shapeSData1_arready                    ), //i
    .M_AXI_MM2S_araddr   (shapeDmaRead1_M_AXI_MM2S_araddr[31:0]  ), //o
    .M_AXI_MM2S_arlen    (shapeDmaRead1_M_AXI_MM2S_arlen[7:0]    ), //o
    .M_AXI_MM2S_arsize   (shapeDmaRead1_M_AXI_MM2S_arsize[2:0]   ), //o
    .M_AXI_MM2S_arburst  (shapeDmaRead1_M_AXI_MM2S_arburst[1:0]  ), //o
    .M_AXI_MM2S_arcache  (shapeDmaRead1_M_AXI_MM2S_arcache[3:0]  ), //o
    .M_AXI_MM2S_arprot   (shapeDmaRead1_M_AXI_MM2S_arprot[2:0]   ), //o
    .M_AXI_MM2S_rvalid   (shapeSData1_rvalid                     ), //i
    .M_AXI_MM2S_rready   (shapeDmaRead1_M_AXI_MM2S_rready        ), //o
    .M_AXI_MM2S_rdata    (shapeSData1_rdata[63:0]                ), //i
    .M_AXI_MM2S_rresp    (shapeSData1_rresp[1:0]                 ), //i
    .M_AXI_MM2S_rlast    (shapeSData1_rlast                      ), //i
    .M_AXIS_MM2S_valid   (shapeDmaRead1_M_AXIS_MM2S_valid        ), //o
    .M_AXIS_MM2S_ready   (shape_1_sData_1_ready                  ), //i
    .M_AXIS_MM2S_payload (shapeDmaRead1_M_AXIS_MM2S_payload[63:0]), //o
    .cmd_valid           (shape_1_dmaReadValid_1                 ), //i
    .cmd_addr            (shapeDmaRead1_cmd_addr[31:0]           ), //i
    .cmd_len             (shapeDmaRead1_cmd_len[31:0]            ), //i
    .cmd_introut         (shapeDmaRead1_cmd_introut              ), //o
    .clk                 (clk                                    ), //i
    .reset               (reset                                  )  //i
  );
  Conv conv_1 (
    .sData_valid   (convDmaRead_M_AXIS_MM2S_valid        ), //i
    .sData_ready   (conv_1_sData_ready                   ), //o
    .sData_payload (convDmaRead_M_AXIS_MM2S_payload[63:0]), //i
    .mData_valid   (conv_1_mData_valid                   ), //o
    .mData_ready   (convDmaWrite_M_AXIS_S2MM_ready       ), //i
    .mData_payload (conv_1_mData_payload[63:0]           ), //o
    .instruction_0 (register_1_instruction0[31:0]        ), //i
    .instruction_1 (register_1_instruction1[31:0]        ), //i
    .instruction_2 (register_1_instruction2[31:0]        ), //i
    .control       (register_1_convControl[3:0]          ), //i
    .state         (conv_1_state[3:0]                    ), //o
    .dmaReadValid  (conv_1_dmaReadValid                  ), //o
    .dmaWriteValid (conv_1_dmaWriteValid                 ), //o
    .introut       (convDmaWrite_cmd_introut             ), //i
    .reset         (reset                                ), //i
    .clk           (clk                                  ), //i
    .RST_2X        (RST_2X                               ), //i
    .CLK_2X        (CLK_2X                               )  //i
  );
  Shape shape_1 (
    .sData_0_valid   (shapeDmaRead_M_AXIS_MM2S_valid         ), //i
    .sData_0_ready   (shape_1_sData_0_ready                  ), //o
    .sData_0_payload (shapeDmaRead_M_AXIS_MM2S_payload[63:0] ), //i
    .sData_1_valid   (shapeDmaRead1_M_AXIS_MM2S_valid        ), //i
    .sData_1_ready   (shape_1_sData_1_ready                  ), //o
    .sData_1_payload (shapeDmaRead1_M_AXIS_MM2S_payload[63:0]), //i
    .mData_valid     (shape_1_mData_valid                    ), //o
    .mData_ready     (shapeDmaWrite_M_AXIS_S2MM_ready        ), //i
    .mData_payload   (shape_1_mData_payload[63:0]            ), //o
    .dmaReadValid_0  (shape_1_dmaReadValid_0                 ), //o
    .dmaReadValid_1  (shape_1_dmaReadValid_1                 ), //o
    .dmaWriteValid   (shape_1_dmaWriteValid                  ), //o
    .control         (register_1_shapeControl[3:0]           ), //i
    .state           (shape_1_state[3:0]                     ), //o
    .introut         (shapeDmaWrite_cmd_introut              ), //i
    .instruction_0   (register_1_instruction0[31:0]          ), //i
    .instruction_1   (register_1_instruction1[31:0]          ), //i
    .instruction_2   (register_1_instruction2[31:0]          ), //i
    .instruction_3   (register_1_instruction3[31:0]          ), //i
    .instruction_4   (register_1_instruction4[31:0]          ), //i
    .instruction_5   (register_1_instruction5[31:0]          ), //i
    .clk             (clk                                    ), //i
    .reset           (reset                                  )  //i
  );
  Instruction register_1 (
    .regSData_awvalid (regSData_awvalid               ), //i
    .regSData_awready (register_1_regSData_awready    ), //o
    .regSData_awaddr  (regSData_awaddr[19:0]          ), //i
    .regSData_awprot  (regSData_awprot[2:0]           ), //i
    .regSData_wvalid  (regSData_wvalid                ), //i
    .regSData_wready  (register_1_regSData_wready     ), //o
    .regSData_wdata   (regSData_wdata[31:0]           ), //i
    .regSData_wstrb   (regSData_wstrb[3:0]            ), //i
    .regSData_bvalid  (register_1_regSData_bvalid     ), //o
    .regSData_bready  (regSData_bready                ), //i
    .regSData_bresp   (register_1_regSData_bresp[1:0] ), //o
    .regSData_arvalid (regSData_arvalid               ), //i
    .regSData_arready (register_1_regSData_arready    ), //o
    .regSData_araddr  (regSData_araddr[19:0]          ), //i
    .regSData_arprot  (regSData_arprot[2:0]           ), //i
    .regSData_rvalid  (register_1_regSData_rvalid     ), //o
    .regSData_rready  (regSData_rready                ), //i
    .regSData_rdata   (register_1_regSData_rdata[31:0]), //o
    .regSData_rresp   (register_1_regSData_rresp[1:0] ), //o
    .convState_1      (conv_1_state[3:0]              ), //i
    .convControl      (register_1_convControl[3:0]    ), //o
    .shapeState_1     (shape_1_state[3:0]             ), //i
    .shapeControl     (register_1_shapeControl[3:0]   ), //o
    .instruction0     (register_1_instruction0[31:0]  ), //o
    .instruction1     (register_1_instruction1[31:0]  ), //o
    .instruction2     (register_1_instruction2[31:0]  ), //o
    .instruction3     (register_1_instruction3[31:0]  ), //o
    .instruction4     (register_1_instruction4[31:0]  ), //o
    .instruction5     (register_1_instruction5[31:0]  ), //o
    .convwriteAddr    (register_1_convwriteAddr[31:0] ), //o
    .convwriteLen     (register_1_convwriteLen[31:0]  ), //o
    .convreadAddr     (register_1_convreadAddr[31:0]  ), //o
    .convreadLen      (register_1_convreadLen[31:0]   ), //o
    .shapewriteAddr   (register_1_shapewriteAddr[31:0]), //o
    .shapewriteLen    (register_1_shapewriteLen[31:0] ), //o
    .shapereadAddr    (register_1_shapereadAddr[31:0] ), //o
    .shapereadLen     (register_1_shapereadLen[31:0]  ), //o
    .shapereadAddr1   (register_1_shapereadAddr1[31:0]), //o
    .shapereadLen1    (register_1_shapereadLen1[31:0] ), //o
    .clk              (clk                            ), //i
    .reset            (reset                          )  //i
  );
  assign convMData_awvalid = convDmaWrite_M_AXI_S2MM_awvalid;
  assign convMData_awaddr = convDmaWrite_M_AXI_S2MM_awaddr;
  assign convMData_awlen = convDmaWrite_M_AXI_S2MM_awlen;
  assign convMData_awsize = convDmaWrite_M_AXI_S2MM_awsize;
  assign convMData_awburst = convDmaWrite_M_AXI_S2MM_awburst;
  assign convMData_awcache = convDmaWrite_M_AXI_S2MM_awcache;
  assign convMData_awprot = convDmaWrite_M_AXI_S2MM_awprot;
  assign convMData_wvalid = convDmaWrite_M_AXI_S2MM_wvalid;
  assign convMData_wdata = convDmaWrite_M_AXI_S2MM_wdata;
  assign convMData_wstrb = convDmaWrite_M_AXI_S2MM_wstrb;
  assign convMData_wlast = convDmaWrite_M_AXI_S2MM_wlast;
  assign convMData_bready = convDmaWrite_M_AXI_S2MM_bready;
  assign convSData_arvalid = convDmaRead_M_AXI_MM2S_arvalid;
  assign convSData_araddr = convDmaRead_M_AXI_MM2S_araddr;
  assign convSData_arlen = convDmaRead_M_AXI_MM2S_arlen;
  assign convSData_arsize = convDmaRead_M_AXI_MM2S_arsize;
  assign convSData_arburst = convDmaRead_M_AXI_MM2S_arburst;
  assign convSData_arcache = convDmaRead_M_AXI_MM2S_arcache;
  assign convSData_arprot = convDmaRead_M_AXI_MM2S_arprot;
  assign convSData_rready = convDmaRead_M_AXI_MM2S_rready;
  assign shapeMData_awvalid = shapeDmaWrite_M_AXI_S2MM_awvalid;
  assign shapeMData_awaddr = shapeDmaWrite_M_AXI_S2MM_awaddr;
  assign shapeMData_awlen = shapeDmaWrite_M_AXI_S2MM_awlen;
  assign shapeMData_awsize = shapeDmaWrite_M_AXI_S2MM_awsize;
  assign shapeMData_awburst = shapeDmaWrite_M_AXI_S2MM_awburst;
  assign shapeMData_awcache = shapeDmaWrite_M_AXI_S2MM_awcache;
  assign shapeMData_awprot = shapeDmaWrite_M_AXI_S2MM_awprot;
  assign shapeMData_wvalid = shapeDmaWrite_M_AXI_S2MM_wvalid;
  assign shapeMData_wdata = shapeDmaWrite_M_AXI_S2MM_wdata;
  assign shapeMData_wstrb = shapeDmaWrite_M_AXI_S2MM_wstrb;
  assign shapeMData_wlast = shapeDmaWrite_M_AXI_S2MM_wlast;
  assign shapeMData_bready = shapeDmaWrite_M_AXI_S2MM_bready;
  assign shapeSData_arvalid = shapeDmaRead_M_AXI_MM2S_arvalid;
  assign shapeSData_araddr = shapeDmaRead_M_AXI_MM2S_araddr;
  assign shapeSData_arlen = shapeDmaRead_M_AXI_MM2S_arlen;
  assign shapeSData_arsize = shapeDmaRead_M_AXI_MM2S_arsize;
  assign shapeSData_arburst = shapeDmaRead_M_AXI_MM2S_arburst;
  assign shapeSData_arcache = shapeDmaRead_M_AXI_MM2S_arcache;
  assign shapeSData_arprot = shapeDmaRead_M_AXI_MM2S_arprot;
  assign shapeSData_rready = shapeDmaRead_M_AXI_MM2S_rready;
  assign shapeSData1_arvalid = shapeDmaRead1_M_AXI_MM2S_arvalid;
  assign shapeSData1_araddr = shapeDmaRead1_M_AXI_MM2S_araddr;
  assign shapeSData1_arlen = shapeDmaRead1_M_AXI_MM2S_arlen;
  assign shapeSData1_arsize = shapeDmaRead1_M_AXI_MM2S_arsize;
  assign shapeSData1_arburst = shapeDmaRead1_M_AXI_MM2S_arburst;
  assign shapeSData1_arcache = shapeDmaRead1_M_AXI_MM2S_arcache;
  assign shapeSData1_arprot = shapeDmaRead1_M_AXI_MM2S_arprot;
  assign shapeSData1_rready = shapeDmaRead1_M_AXI_MM2S_rready;
  assign regSData_awready = register_1_regSData_awready;
  assign regSData_wready = register_1_regSData_wready;
  assign regSData_bvalid = register_1_regSData_bvalid;
  assign regSData_bresp = register_1_regSData_bresp;
  assign regSData_arready = register_1_regSData_arready;
  assign regSData_rvalid = register_1_regSData_rvalid;
  assign regSData_rdata = register_1_regSData_rdata;
  assign regSData_rresp = register_1_regSData_rresp;
  assign convDmaWrite_cmd_addr = register_1_convwriteAddr;
  assign convDmaWrite_cmd_len = register_1_convwriteLen;
  assign convDmaRead_cmd_addr = register_1_convreadAddr;
  assign convDmaRead_cmd_len = register_1_convreadLen;
  assign shapeDmaWrite_cmd_addr = register_1_shapewriteAddr;
  assign shapeDmaWrite_cmd_len = register_1_shapewriteLen;
  assign shapeDmaRead_cmd_addr = register_1_shapereadAddr;
  assign shapeDmaRead_cmd_len = register_1_shapereadLen;
  assign shapeDmaRead1_cmd_addr = register_1_shapereadAddr1;
  assign shapeDmaRead1_cmd_len = register_1_shapereadLen1;

endmodule

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
  input      [3:0]    convState_1,
  output reg [3:0]    convControl,
  input      [3:0]    shapeState_1,
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
            bus_readData <= {28'h0,convState_1};
            bus_readError <= 1'b0;
          end
          20'h00004 : begin
            bus_readData <= {28'h0,convControl};
            bus_readError <= 1'b1;
          end
          20'h00008 : begin
            bus_readData <= {28'h0,shapeState_1};
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

module Shape (
  input               sData_0_valid,
  output reg          sData_0_ready,
  input      [63:0]   sData_0_payload,
  input               sData_1_valid,
  output reg          sData_1_ready,
  input      [63:0]   sData_1_payload,
  output              mData_valid,
  input               mData_ready,
  output     [63:0]   mData_payload,
  output              dmaReadValid_0,
  output              dmaReadValid_1,
  output              dmaWriteValid,
  input      [3:0]    control,
  output     [3:0]    state,
  input               introut,
  input      [31:0]   instruction_0,
  input      [31:0]   instruction_1,
  input      [31:0]   instruction_2,
  input      [31:0]   instruction_3,
  input      [31:0]   instruction_4,
  input      [31:0]   instruction_5,
  input               clk,
  input               reset
);

  reg                 concat_1_dataPort_sData_valid;
  reg        [63:0]   concat_1_dataPort_sData_payload;
  reg                 concat_1_dataPort_mData_ready;
  wire       [9:0]    concat_1_dataPort_rowNumIn;
  wire       [9:0]    concat_1_dataPort_colNumIn;
  wire       [9:0]    concat_1_dataPort_channelIn;
  wire       [31:0]   concat_1_zero_1;
  wire       [31:0]   concat_1_zero1;
  wire       [31:0]   concat_1_scale_1;
  wire       [31:0]   concat_1_scale1;
  reg                 concat_1_sData1_valid;
  reg        [63:0]   concat_1_sData1_payload;
  wire       [9:0]    concat_1_channelIn1;
  reg                 maxPooling_1_sData_valid;
  reg        [63:0]   maxPooling_1_sData_payload;
  reg                 maxPooling_1_mData_ready;
  wire       [9:0]    maxPooling_1_rowNumIn;
  wire       [9:0]    maxPooling_1_colNumIn;
  wire       [9:0]    maxPooling_1_channelIn;
  reg                 split_1_sData_valid;
  reg        [63:0]   split_1_sData_payload;
  reg                 split_1_mData_ready;
  wire       [9:0]    split_1_rowNumIn;
  wire       [9:0]    split_1_colNumIn;
  wire       [9:0]    split_1_channelIn;
  reg                 upSampling_1_sData_valid;
  reg        [63:0]   upSampling_1_sData_payload;
  reg                 upSampling_1_mData_ready;
  wire       [9:0]    upSampling_1_rowNumIn;
  wire       [9:0]    upSampling_1_colNumIn;
  wire       [9:0]    upSampling_1_channelIn;
  reg                 fifo_io_push_valid;
  reg        [63:0]   fifo_io_push_payload;
  wire       [3:0]    shapeState_1_state;
  wire                shapeState_1_start_0;
  wire                shapeState_1_start_1;
  wire                shapeState_1_start_2;
  wire                shapeState_1_start_3;
  wire                shapeState_1_dmaReadValid_0;
  wire                shapeState_1_dmaReadValid_1;
  wire                shapeState_1_dmaWriteValid;
  wire                concat_1_dataPort_sData_ready;
  wire                concat_1_dataPort_mData_valid;
  wire       [63:0]   concat_1_dataPort_mData_payload;
  wire                concat_1_sData1_ready;
  wire                maxPooling_1_sData_ready;
  wire                maxPooling_1_mData_valid;
  wire       [63:0]   maxPooling_1_mData_payload;
  wire                split_1_sData_ready;
  wire                split_1_mData_valid;
  wire       [63:0]   split_1_mData_payload;
  wire                upSampling_1_sData_ready;
  wire                upSampling_1_mData_valid;
  wire       [63:0]   upSampling_1_mData_payload;
  wire                fifo_io_push_ready;
  wire                fifo_io_pop_valid;
  wire       [63:0]   fifo_io_pop_payload;
  wire       [11:0]   fifo_io_occupancy;
  wire       [11:0]   fifo_io_availability;
  wire       [10:0]   _zz_dataPort_colNumIn;
  wire       [10:0]   _zz_dataPort_rowNumIn;
  wire       [10:0]   _zz_colNumIn;
  wire       [10:0]   _zz_rowNumIn;
  wire       [10:0]   _zz_colNumIn_1;
  wire       [10:0]   _zz_rowNumIn_1;
  wire       [10:0]   _zz_colNumIn_2;
  wire       [10:0]   _zz_rowNumIn_2;
  wire       [6:0]    _zz_dataCount1;
  wire       [17:0]   _zz_when_Shape_l89;
  reg                 shapeState_1_start_0_regNext;
  reg                 shapeState_1_start_1_regNext;
  reg                 shapeState_1_start_2_regNext;
  reg                 shapeState_1_start_3_regNext;
  wire                start;
  wire       [191:0]  instruction_6;
  reg        [191:0]  instructionReg;
  reg                 fifoReady;
  reg        [17:0]   dataCount1;
  reg        [17:0]   dataCount2;
  reg        [17:0]   dataCount;
  wire                when_Shape_l89;

  assign _zz_dataPort_colNumIn = instructionReg[21 : 11];
  assign _zz_dataPort_rowNumIn = instructionReg[10 : 0];
  assign _zz_colNumIn = instructionReg[21 : 11];
  assign _zz_rowNumIn = instructionReg[10 : 0];
  assign _zz_colNumIn_1 = instructionReg[21 : 11];
  assign _zz_rowNumIn_1 = instructionReg[10 : 0];
  assign _zz_colNumIn_2 = instructionReg[21 : 11];
  assign _zz_rowNumIn_2 = instructionReg[10 : 0];
  assign _zz_dataCount1 = (instructionReg[31 : 22] >>> 3);
  assign _zz_when_Shape_l89 = {6'd0, fifo_io_availability};
  ShapeState shapeState_1 (
    .control        (control[3:0]               ), //i
    .complete       (introut                    ), //i
    .state          (shapeState_1_state[3:0]    ), //o
    .start_0        (shapeState_1_start_0       ), //o
    .start_1        (shapeState_1_start_1       ), //o
    .start_2        (shapeState_1_start_2       ), //o
    .start_3        (shapeState_1_start_3       ), //o
    .dmaReadValid_0 (shapeState_1_dmaReadValid_0), //o
    .dmaReadValid_1 (shapeState_1_dmaReadValid_1), //o
    .dmaWriteValid  (shapeState_1_dmaWriteValid ), //o
    .clk            (clk                        ), //i
    .reset          (reset                      )  //i
  );
  Concat concat_1 (
    .dataPort_start         (shapeState_1_start_3                 ), //i
    .dataPort_fifoReady     (fifoReady                            ), //i
    .dataPort_sData_valid   (concat_1_dataPort_sData_valid        ), //i
    .dataPort_sData_ready   (concat_1_dataPort_sData_ready        ), //o
    .dataPort_sData_payload (concat_1_dataPort_sData_payload[63:0]), //i
    .dataPort_mData_valid   (concat_1_dataPort_mData_valid        ), //o
    .dataPort_mData_ready   (concat_1_dataPort_mData_ready        ), //i
    .dataPort_mData_payload (concat_1_dataPort_mData_payload[63:0]), //o
    .dataPort_rowNumIn      (concat_1_dataPort_rowNumIn[9:0]      ), //i
    .dataPort_colNumIn      (concat_1_dataPort_colNumIn[9:0]      ), //i
    .dataPort_channelIn     (concat_1_dataPort_channelIn[9:0]     ), //i
    .zero_1                 (concat_1_zero_1[31:0]                ), //i
    .zero1                  (concat_1_zero1[31:0]                 ), //i
    .scale_1                (concat_1_scale_1[31:0]               ), //i
    .scale1                 (concat_1_scale1[31:0]                ), //i
    .sData1_valid           (concat_1_sData1_valid                ), //i
    .sData1_ready           (concat_1_sData1_ready                ), //o
    .sData1_payload         (concat_1_sData1_payload[63:0]        ), //i
    .channelIn1             (concat_1_channelIn1[9:0]             ), //i
    .clk                    (clk                                  ), //i
    .reset                  (reset                                )  //i
  );
  MaxPooling maxPooling_1 (
    .start         (shapeState_1_start_0            ), //i
    .fifoReady     (fifoReady                       ), //i
    .sData_valid   (maxPooling_1_sData_valid        ), //i
    .sData_ready   (maxPooling_1_sData_ready        ), //o
    .sData_payload (maxPooling_1_sData_payload[63:0]), //i
    .mData_valid   (maxPooling_1_mData_valid        ), //o
    .mData_ready   (maxPooling_1_mData_ready        ), //i
    .mData_payload (maxPooling_1_mData_payload[63:0]), //o
    .rowNumIn      (maxPooling_1_rowNumIn[9:0]      ), //i
    .colNumIn      (maxPooling_1_colNumIn[9:0]      ), //i
    .channelIn     (maxPooling_1_channelIn[9:0]     ), //i
    .clk           (clk                             ), //i
    .reset         (reset                           )  //i
  );
  Split split_1 (
    .start         (shapeState_1_start_1       ), //i
    .fifoReady     (fifoReady                  ), //i
    .sData_valid   (split_1_sData_valid        ), //i
    .sData_ready   (split_1_sData_ready        ), //o
    .sData_payload (split_1_sData_payload[63:0]), //i
    .mData_valid   (split_1_mData_valid        ), //o
    .mData_ready   (split_1_mData_ready        ), //i
    .mData_payload (split_1_mData_payload[63:0]), //o
    .rowNumIn      (split_1_rowNumIn[9:0]      ), //i
    .colNumIn      (split_1_colNumIn[9:0]      ), //i
    .channelIn     (split_1_channelIn[9:0]     ), //i
    .clk           (clk                        ), //i
    .reset         (reset                      )  //i
  );
  UpSampling upSampling_1 (
    .start         (shapeState_1_start_2            ), //i
    .fifoReady     (fifoReady                       ), //i
    .sData_valid   (upSampling_1_sData_valid        ), //i
    .sData_ready   (upSampling_1_sData_ready        ), //o
    .sData_payload (upSampling_1_sData_payload[63:0]), //i
    .mData_valid   (upSampling_1_mData_valid        ), //o
    .mData_ready   (upSampling_1_mData_ready        ), //i
    .mData_payload (upSampling_1_mData_payload[63:0]), //o
    .rowNumIn      (upSampling_1_rowNumIn[9:0]      ), //i
    .colNumIn      (upSampling_1_colNumIn[9:0]      ), //i
    .channelIn     (upSampling_1_channelIn[9:0]     ), //i
    .clk           (clk                             ), //i
    .reset         (reset                           )  //i
  );
  StreamFifo_3 fifo (
    .io_push_valid   (fifo_io_push_valid        ), //i
    .io_push_ready   (fifo_io_push_ready        ), //o
    .io_push_payload (fifo_io_push_payload[63:0]), //i
    .io_pop_valid    (fifo_io_pop_valid         ), //o
    .io_pop_ready    (mData_ready               ), //i
    .io_pop_payload  (fifo_io_pop_payload[63:0] ), //o
    .io_flush        (1'b0                      ), //i
    .io_occupancy    (fifo_io_occupancy[11:0]   ), //o
    .io_availability (fifo_io_availability[11:0]), //o
    .clk             (clk                       ), //i
    .reset           (reset                     )  //i
  );
  assign dmaReadValid_0 = shapeState_1_dmaReadValid_0;
  assign dmaReadValid_1 = shapeState_1_dmaReadValid_1;
  assign dmaWriteValid = shapeState_1_dmaWriteValid;
  assign state = shapeState_1_state;
  assign start = ((((shapeState_1_start_0 && (! shapeState_1_start_0_regNext)) || (shapeState_1_start_1 && (! shapeState_1_start_1_regNext))) || (shapeState_1_start_2 && (! shapeState_1_start_2_regNext))) || (shapeState_1_start_3 && (! shapeState_1_start_3_regNext)));
  assign instruction_6 = {instruction_5,{instruction_4,{instruction_3,{instruction_2,{instruction_1,instruction_0}}}}};
  assign concat_1_dataPort_colNumIn = _zz_dataPort_colNumIn[9:0];
  assign concat_1_dataPort_rowNumIn = _zz_dataPort_rowNumIn[9:0];
  assign concat_1_dataPort_channelIn = instructionReg[31 : 22];
  assign concat_1_channelIn1 = instructionReg[41 : 32];
  assign concat_1_zero_1 = instructionReg[159 : 128];
  assign concat_1_scale_1 = instructionReg[95 : 64];
  assign concat_1_zero1 = instructionReg[191 : 160];
  assign concat_1_scale1 = instructionReg[127 : 96];
  assign maxPooling_1_colNumIn = _zz_colNumIn[9:0];
  assign maxPooling_1_rowNumIn = _zz_rowNumIn[9:0];
  assign maxPooling_1_channelIn = instructionReg[31 : 22];
  assign split_1_colNumIn = _zz_colNumIn_1[9:0];
  assign split_1_rowNumIn = _zz_rowNumIn_1[9:0];
  assign split_1_channelIn = instructionReg[31 : 22];
  assign upSampling_1_colNumIn = _zz_colNumIn_2[9:0];
  assign upSampling_1_rowNumIn = _zz_rowNumIn_2[9:0];
  assign upSampling_1_channelIn = instructionReg[31 : 22];
  assign mData_valid = fifo_io_pop_valid;
  assign mData_payload = fifo_io_pop_payload;
  assign when_Shape_l89 = (dataCount < _zz_when_Shape_l89);
  always @(*) begin
    if(when_Shape_l89) begin
      fifoReady = 1'b1;
    end else begin
      fifoReady = 1'b0;
    end
  end

  always @(*) begin
    case(shapeState_1_state)
      4'b0100 : begin
        concat_1_dataPort_sData_valid = sData_0_valid;
      end
      4'b0001 : begin
        concat_1_dataPort_sData_valid = 1'b0;
      end
      4'b0011 : begin
        concat_1_dataPort_sData_valid = 1'b0;
      end
      4'b0010 : begin
        concat_1_dataPort_sData_valid = 1'b0;
      end
      default : begin
        concat_1_dataPort_sData_valid = 1'b0;
      end
    endcase
  end

  always @(*) begin
    case(shapeState_1_state)
      4'b0100 : begin
        sData_0_ready = concat_1_dataPort_sData_ready;
      end
      4'b0001 : begin
        sData_0_ready = maxPooling_1_sData_ready;
      end
      4'b0011 : begin
        sData_0_ready = upSampling_1_sData_ready;
      end
      4'b0010 : begin
        sData_0_ready = split_1_sData_ready;
      end
      default : begin
        sData_0_ready = 1'b0;
      end
    endcase
  end

  always @(*) begin
    case(shapeState_1_state)
      4'b0100 : begin
        concat_1_dataPort_sData_payload = sData_0_payload;
      end
      4'b0001 : begin
        concat_1_dataPort_sData_payload = 64'h0;
      end
      4'b0011 : begin
        concat_1_dataPort_sData_payload = 64'h0;
      end
      4'b0010 : begin
        concat_1_dataPort_sData_payload = 64'h0;
      end
      default : begin
        concat_1_dataPort_sData_payload = 64'h0;
      end
    endcase
  end

  always @(*) begin
    case(shapeState_1_state)
      4'b0100 : begin
        concat_1_sData1_valid = sData_1_valid;
      end
      4'b0001 : begin
        concat_1_sData1_valid = 1'b0;
      end
      4'b0011 : begin
        concat_1_sData1_valid = 1'b0;
      end
      4'b0010 : begin
        concat_1_sData1_valid = 1'b0;
      end
      default : begin
        concat_1_sData1_valid = 1'b0;
      end
    endcase
  end

  always @(*) begin
    case(shapeState_1_state)
      4'b0100 : begin
        sData_1_ready = concat_1_sData1_ready;
      end
      4'b0001 : begin
        sData_1_ready = 1'b0;
      end
      4'b0011 : begin
        sData_1_ready = 1'b0;
      end
      4'b0010 : begin
        sData_1_ready = 1'b0;
      end
      default : begin
        sData_1_ready = 1'b0;
      end
    endcase
  end

  always @(*) begin
    case(shapeState_1_state)
      4'b0100 : begin
        concat_1_sData1_payload = sData_1_payload;
      end
      4'b0001 : begin
        concat_1_sData1_payload = 64'h0;
      end
      4'b0011 : begin
        concat_1_sData1_payload = 64'h0;
      end
      4'b0010 : begin
        concat_1_sData1_payload = 64'h0;
      end
      default : begin
        concat_1_sData1_payload = 64'h0;
      end
    endcase
  end

  always @(*) begin
    case(shapeState_1_state)
      4'b0100 : begin
        fifo_io_push_valid = concat_1_dataPort_mData_valid;
      end
      4'b0001 : begin
        fifo_io_push_valid = maxPooling_1_mData_valid;
      end
      4'b0011 : begin
        fifo_io_push_valid = upSampling_1_mData_valid;
      end
      4'b0010 : begin
        fifo_io_push_valid = split_1_mData_valid;
      end
      default : begin
        fifo_io_push_valid = 1'b0;
      end
    endcase
  end

  always @(*) begin
    case(shapeState_1_state)
      4'b0100 : begin
        concat_1_dataPort_mData_ready = fifo_io_push_ready;
      end
      4'b0001 : begin
        concat_1_dataPort_mData_ready = 1'b0;
      end
      4'b0011 : begin
        concat_1_dataPort_mData_ready = 1'b0;
      end
      4'b0010 : begin
        concat_1_dataPort_mData_ready = 1'b0;
      end
      default : begin
        concat_1_dataPort_mData_ready = 1'b0;
      end
    endcase
  end

  always @(*) begin
    case(shapeState_1_state)
      4'b0100 : begin
        fifo_io_push_payload = concat_1_dataPort_mData_payload;
      end
      4'b0001 : begin
        fifo_io_push_payload = maxPooling_1_mData_payload;
      end
      4'b0011 : begin
        fifo_io_push_payload = upSampling_1_mData_payload;
      end
      4'b0010 : begin
        fifo_io_push_payload = split_1_mData_payload;
      end
      default : begin
        fifo_io_push_payload = 64'h0;
      end
    endcase
  end

  always @(*) begin
    case(shapeState_1_state)
      4'b0100 : begin
        dataCount = dataCount2;
      end
      4'b0001 : begin
        dataCount = dataCount1;
      end
      4'b0011 : begin
        dataCount = dataCount2;
      end
      4'b0010 : begin
        dataCount = dataCount1;
      end
      default : begin
        dataCount = 18'h0;
      end
    endcase
  end

  always @(*) begin
    case(shapeState_1_state)
      4'b0100 : begin
        maxPooling_1_sData_payload = 64'h0;
      end
      4'b0001 : begin
        maxPooling_1_sData_payload = sData_0_payload;
      end
      4'b0011 : begin
        maxPooling_1_sData_payload = 64'h0;
      end
      4'b0010 : begin
        maxPooling_1_sData_payload = 64'h0;
      end
      default : begin
        maxPooling_1_sData_payload = 64'h0;
      end
    endcase
  end

  always @(*) begin
    case(shapeState_1_state)
      4'b0100 : begin
        maxPooling_1_sData_valid = 1'b0;
      end
      4'b0001 : begin
        maxPooling_1_sData_valid = sData_0_valid;
      end
      4'b0011 : begin
        maxPooling_1_sData_valid = 1'b0;
      end
      4'b0010 : begin
        maxPooling_1_sData_valid = 1'b0;
      end
      default : begin
        maxPooling_1_sData_valid = 1'b0;
      end
    endcase
  end

  always @(*) begin
    case(shapeState_1_state)
      4'b0100 : begin
        split_1_sData_payload = 64'h0;
      end
      4'b0001 : begin
        split_1_sData_payload = 64'h0;
      end
      4'b0011 : begin
        split_1_sData_payload = 64'h0;
      end
      4'b0010 : begin
        split_1_sData_payload = sData_0_payload;
      end
      default : begin
        split_1_sData_payload = 64'h0;
      end
    endcase
  end

  always @(*) begin
    case(shapeState_1_state)
      4'b0100 : begin
        split_1_sData_valid = 1'b0;
      end
      4'b0001 : begin
        split_1_sData_valid = 1'b0;
      end
      4'b0011 : begin
        split_1_sData_valid = 1'b0;
      end
      4'b0010 : begin
        split_1_sData_valid = sData_0_valid;
      end
      default : begin
        split_1_sData_valid = 1'b0;
      end
    endcase
  end

  always @(*) begin
    case(shapeState_1_state)
      4'b0100 : begin
        upSampling_1_sData_payload = 64'h0;
      end
      4'b0001 : begin
        upSampling_1_sData_payload = 64'h0;
      end
      4'b0011 : begin
        upSampling_1_sData_payload = sData_0_payload;
      end
      4'b0010 : begin
        upSampling_1_sData_payload = 64'h0;
      end
      default : begin
        upSampling_1_sData_payload = 64'h0;
      end
    endcase
  end

  always @(*) begin
    case(shapeState_1_state)
      4'b0100 : begin
        upSampling_1_sData_valid = 1'b0;
      end
      4'b0001 : begin
        upSampling_1_sData_valid = 1'b0;
      end
      4'b0011 : begin
        upSampling_1_sData_valid = sData_0_valid;
      end
      4'b0010 : begin
        upSampling_1_sData_valid = 1'b0;
      end
      default : begin
        upSampling_1_sData_valid = 1'b0;
      end
    endcase
  end

  always @(*) begin
    case(shapeState_1_state)
      4'b0100 : begin
        maxPooling_1_mData_ready = 1'b0;
      end
      4'b0001 : begin
        maxPooling_1_mData_ready = fifo_io_push_ready;
      end
      4'b0011 : begin
        maxPooling_1_mData_ready = 1'b0;
      end
      4'b0010 : begin
        maxPooling_1_mData_ready = 1'b0;
      end
      default : begin
        maxPooling_1_mData_ready = 1'b0;
      end
    endcase
  end

  always @(*) begin
    case(shapeState_1_state)
      4'b0100 : begin
        upSampling_1_mData_ready = 1'b0;
      end
      4'b0001 : begin
        upSampling_1_mData_ready = 1'b0;
      end
      4'b0011 : begin
        upSampling_1_mData_ready = fifo_io_push_ready;
      end
      4'b0010 : begin
        upSampling_1_mData_ready = 1'b0;
      end
      default : begin
        upSampling_1_mData_ready = 1'b0;
      end
    endcase
  end

  always @(*) begin
    case(shapeState_1_state)
      4'b0100 : begin
        split_1_mData_ready = 1'b0;
      end
      4'b0001 : begin
        split_1_mData_ready = 1'b0;
      end
      4'b0011 : begin
        split_1_mData_ready = 1'b0;
      end
      4'b0010 : begin
        split_1_mData_ready = fifo_io_push_ready;
      end
      default : begin
        split_1_mData_ready = 1'b0;
      end
    endcase
  end

  always @(posedge clk) begin
    shapeState_1_start_0_regNext <= shapeState_1_start_0;
    shapeState_1_start_1_regNext <= shapeState_1_start_1;
    shapeState_1_start_2_regNext <= shapeState_1_start_2;
    shapeState_1_start_3_regNext <= shapeState_1_start_3;
    dataCount1 <= (_zz_dataCount1 * instructionReg[21 : 11]);
    dataCount2 <= (dataCount1 <<< 1);
  end

  always @(posedge clk or posedge reset) begin
    if(reset) begin
      instructionReg <= 192'h0;
    end else begin
      if(start) begin
        instructionReg <= instruction_6;
      end
    end
  end


endmodule

module Conv (
  input               sData_valid,
  output reg          sData_ready,
  input      [63:0]   sData_payload,
  output              mData_valid,
  input               mData_ready,
  output     [63:0]   mData_payload,
  input      [31:0]   instruction_0,
  input      [31:0]   instruction_1,
  input      [31:0]   instruction_2,
  input      [3:0]    control,
  output     [3:0]    state,
  output              dmaReadValid,
  output              dmaWriteValid,
  input               introut,
  input               reset,
  input               clk,
  input               RST_2X,
  input               CLK_2X
);

  reg        [3:0]    convState_1_complete;
  reg                 convCompute_1_sParaData_valid;
  reg        [63:0]   convCompute_1_sParaData_payload;
  reg                 convCompute_1_sFeatureData_valid;
  reg        [63:0]   convCompute_1_sFeatureData_payload;
  wire                convCompute_1_mNormData_ready;
  wire       [8:0]    convCompute_1_rowNumIn;
  wire       [8:0]    convCompute_1_colNumIn;
  wire       [11:0]   convCompute_1_channelIn;
  wire       [11:0]   convCompute_1_channelOut;
  wire                convCompute_1_enPadding;
  wire                convCompute_1_enActivation;
  wire       [7:0]    convCompute_1_zeroDara;
  wire       [0:0]    convCompute_1_zeroNum;
  wire       [12:0]   convCompute_1_weightNum;
  wire       [8:0]    convCompute_1_quanNum;
  wire       [7:0]    convCompute_1_quanZeroData;
  wire                convCompute_1_enStride;
  wire       [1:0]    convCompute_1_convType;
  wire       [3:0]    convState_1_state;
  wire       [3:0]    convState_1_sign;
  wire                convState_1_dmaReadValid;
  wire                convState_1_dmaWriteValid;
  wire                convCompute_1_sParaData_ready;
  wire                convCompute_1_sFeatureData_ready;
  wire                convCompute_1_mFeatureData_valid;
  wire       [63:0]   convCompute_1_mFeatureData_payload;
  wire                convCompute_1_mNormData_valid;
  wire       [31:0]   convCompute_1_mNormData_payload_0;
  wire       [31:0]   convCompute_1_mNormData_payload_1;
  wire       [31:0]   convCompute_1_mNormData_payload_2;
  wire       [31:0]   convCompute_1_mNormData_payload_3;
  wire       [31:0]   convCompute_1_mNormData_payload_4;
  wire       [31:0]   convCompute_1_mNormData_payload_5;
  wire       [31:0]   convCompute_1_mNormData_payload_6;
  wire       [31:0]   convCompute_1_mNormData_payload_7;
  wire                convCompute_1_copyWeightDone;
  wire                convCompute_1_computeComplete;
  wire       [9:0]    _zz_channelIn;
  wire       [9:0]    _zz_channelOut;
  wire       [10:0]   _zz_rowNumIn;
  wire       [10:0]   _zz_colNumIn;
  wire       [2:0]    _zz_zeroNum;
  wire       [15:0]   _zz_weightNum;
  wire       [15:0]   _zz_quanNum;
  reg                 para;
  wire                when_Conv_l31;
  wire                when_Conv_l31_1;
  reg                 compute;
  wire                when_Conv_l32;
  wire                when_Conv_l32_1;
  wire       [95:0]   computeInstruction;
  reg        [31:0]   paraInstructionReg;
  reg        [95:0]   computeInstructionReg;
  wire                when_Conv_l40;
  wire                when_Conv_l43;
  reg                 para_delay_1;
  reg                 para_delay_2;
  reg                 para_delay_3;
  reg                 compute_delay_1;
  reg                 compute_delay_2;
  reg                 compute_delay_3;
  reg                 writeComplete;
  wire                when_Conv_l72;
  reg                 computeComplete;
  wire                when_Conv_l76;
  wire                when_Conv_l80;
  reg        [1:0]    dest;
  wire                when_Conv_l87;
  wire                when_Conv_l89;
  wire                when_Conv_l95;
  wire                when_Conv_l99;

  assign _zz_channelIn = computeInstructionReg[31 : 22];
  assign _zz_channelOut = computeInstructionReg[41 : 32];
  assign _zz_rowNumIn = computeInstructionReg[10 : 0];
  assign _zz_colNumIn = computeInstructionReg[21 : 11];
  assign _zz_zeroNum = computeInstructionReg[54 : 52];
  assign _zz_weightNum = paraInstructionReg[15 : 0];
  assign _zz_quanNum = paraInstructionReg[31 : 16];
  ConvState convState_1 (
    .control       (control[3:0]             ), //i
    .complete      (convState_1_complete[3:0]), //i
    .state         (convState_1_state[3:0]   ), //o
    .sign          (convState_1_sign[3:0]    ), //o
    .dmaReadValid  (convState_1_dmaReadValid ), //o
    .dmaWriteValid (convState_1_dmaWriteValid), //o
    .clk           (clk                      ), //i
    .reset         (reset                    )  //i
  );
  ConvCompute convCompute_1 (
    .startPa              (para_delay_3                            ), //i
    .startCu              (compute_delay_3                         ), //i
    .sParaData_valid      (convCompute_1_sParaData_valid           ), //i
    .sParaData_ready      (convCompute_1_sParaData_ready           ), //o
    .sParaData_payload    (convCompute_1_sParaData_payload[63:0]   ), //i
    .sFeatureData_valid   (convCompute_1_sFeatureData_valid        ), //i
    .sFeatureData_ready   (convCompute_1_sFeatureData_ready        ), //o
    .sFeatureData_payload (convCompute_1_sFeatureData_payload[63:0]), //i
    .mFeatureData_valid   (convCompute_1_mFeatureData_valid        ), //o
    .mFeatureData_ready   (mData_ready                             ), //i
    .mFeatureData_payload (convCompute_1_mFeatureData_payload[63:0]), //o
    .mNormData_valid      (convCompute_1_mNormData_valid           ), //o
    .mNormData_ready      (convCompute_1_mNormData_ready           ), //i
    .mNormData_payload_0  (convCompute_1_mNormData_payload_0[31:0] ), //o
    .mNormData_payload_1  (convCompute_1_mNormData_payload_1[31:0] ), //o
    .mNormData_payload_2  (convCompute_1_mNormData_payload_2[31:0] ), //o
    .mNormData_payload_3  (convCompute_1_mNormData_payload_3[31:0] ), //o
    .mNormData_payload_4  (convCompute_1_mNormData_payload_4[31:0] ), //o
    .mNormData_payload_5  (convCompute_1_mNormData_payload_5[31:0] ), //o
    .mNormData_payload_6  (convCompute_1_mNormData_payload_6[31:0] ), //o
    .mNormData_payload_7  (convCompute_1_mNormData_payload_7[31:0] ), //o
    .copyWeightDone       (convCompute_1_copyWeightDone            ), //o
    .computeComplete      (convCompute_1_computeComplete           ), //o
    .rowNumIn             (convCompute_1_rowNumIn[8:0]             ), //i
    .colNumIn             (convCompute_1_colNumIn[8:0]             ), //i
    .channelIn            (convCompute_1_channelIn[11:0]           ), //i
    .channelOut           (convCompute_1_channelOut[11:0]          ), //i
    .enPadding            (convCompute_1_enPadding                 ), //i
    .enActivation         (convCompute_1_enActivation              ), //i
    .zeroDara             (convCompute_1_zeroDara[7:0]             ), //i
    .zeroNum              (convCompute_1_zeroNum                   ), //i
    .weightNum            (convCompute_1_weightNum[12:0]           ), //i
    .quanNum              (convCompute_1_quanNum[8:0]              ), //i
    .quanZeroData         (convCompute_1_quanZeroData[7:0]         ), //i
    .enStride             (convCompute_1_enStride                  ), //i
    .convType             (convCompute_1_convType[1:0]             ), //i
    .reset                (reset                                   ), //i
    .clk                  (clk                                     ), //i
    .RST_2X               (RST_2X                                  ), //i
    .CLK_2X               (CLK_2X                                  )  //i
  );
  assign state = convState_1_state;
  assign dmaReadValid = convState_1_dmaReadValid;
  assign dmaWriteValid = convState_1_dmaWriteValid;
  assign when_Conv_l31 = (convState_1_sign == 4'b0001);
  assign when_Conv_l31_1 = (convState_1_sign != 4'b0001);
  assign when_Conv_l32 = (convState_1_sign == 4'b0010);
  assign when_Conv_l32_1 = (convState_1_sign != 4'b0010);
  assign computeInstruction = {instruction_2,{instruction_1,instruction_0}};
  assign when_Conv_l40 = (convState_1_sign == 4'b0001);
  assign when_Conv_l43 = (convState_1_sign == 4'b0010);
  assign convCompute_1_channelIn = {2'd0, _zz_channelIn};
  assign convCompute_1_channelOut = {2'd0, _zz_channelOut};
  assign convCompute_1_rowNumIn = _zz_rowNumIn[8:0];
  assign convCompute_1_colNumIn = _zz_colNumIn[8:0];
  assign convCompute_1_enPadding = computeInstructionReg[42];
  assign convCompute_1_enActivation = computeInstructionReg[43];
  assign convCompute_1_zeroDara = computeInstructionReg[51 : 44];
  assign convCompute_1_zeroNum = _zz_zeroNum[0:0];
  assign convCompute_1_quanZeroData = computeInstructionReg[62 : 55];
  assign convCompute_1_convType = computeInstructionReg[65 : 64];
  assign convCompute_1_enStride = computeInstructionReg[63];
  assign convCompute_1_weightNum = _zz_weightNum[12:0];
  assign convCompute_1_quanNum = _zz_quanNum[8:0];
  assign when_Conv_l72 = (control == 4'b0001);
  assign when_Conv_l76 = (control == 4'b0001);
  always @(*) begin
    if(convCompute_1_copyWeightDone) begin
      convState_1_complete = 4'b0001;
    end else begin
      if(when_Conv_l80) begin
        convState_1_complete = 4'b0010;
      end else begin
        convState_1_complete = 4'b0000;
      end
    end
  end

  assign when_Conv_l80 = (writeComplete && computeComplete);
  assign when_Conv_l87 = (control == 4'b0001);
  assign when_Conv_l89 = (control == 4'b0010);
  assign when_Conv_l95 = (dest == 2'b00);
  always @(*) begin
    if(when_Conv_l95) begin
      convCompute_1_sParaData_valid = sData_valid;
    end else begin
      if(when_Conv_l99) begin
        convCompute_1_sParaData_valid = 1'b0;
      end else begin
        convCompute_1_sParaData_valid = 1'b0;
      end
    end
  end

  always @(*) begin
    if(when_Conv_l95) begin
      sData_ready = convCompute_1_sParaData_ready;
    end else begin
      if(when_Conv_l99) begin
        sData_ready = convCompute_1_sFeatureData_ready;
      end else begin
        sData_ready = 1'b0;
      end
    end
  end

  always @(*) begin
    if(when_Conv_l95) begin
      convCompute_1_sParaData_payload = sData_payload;
    end else begin
      if(when_Conv_l99) begin
        convCompute_1_sParaData_payload = 64'h0;
      end else begin
        convCompute_1_sParaData_payload = 64'h0;
      end
    end
  end

  always @(*) begin
    if(when_Conv_l95) begin
      convCompute_1_sFeatureData_valid = 1'b0;
    end else begin
      if(when_Conv_l99) begin
        convCompute_1_sFeatureData_valid = sData_valid;
      end else begin
        convCompute_1_sFeatureData_valid = 1'b0;
      end
    end
  end

  always @(*) begin
    if(when_Conv_l95) begin
      convCompute_1_sFeatureData_payload = 64'h0;
    end else begin
      if(when_Conv_l99) begin
        convCompute_1_sFeatureData_payload = sData_payload;
      end else begin
        convCompute_1_sFeatureData_payload = 64'h0;
      end
    end
  end

  assign when_Conv_l99 = (dest == 2'b01);
  assign mData_valid = convCompute_1_mFeatureData_valid;
  assign mData_payload = convCompute_1_mFeatureData_payload;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      para <= 1'b0;
      compute <= 1'b0;
      paraInstructionReg <= 32'h0;
      computeInstructionReg <= 96'h0;
      writeComplete <= 1'b0;
      computeComplete <= 1'b0;
      dest <= 2'b00;
    end else begin
      if(when_Conv_l31) begin
        para <= 1'b1;
      end
      if(when_Conv_l31_1) begin
        para <= 1'b0;
      end
      if(when_Conv_l32) begin
        compute <= 1'b1;
      end
      if(when_Conv_l32_1) begin
        compute <= 1'b0;
      end
      if(when_Conv_l40) begin
        paraInstructionReg <= instruction_0;
        computeInstructionReg <= computeInstructionReg;
      end else begin
        if(when_Conv_l43) begin
          paraInstructionReg <= paraInstructionReg;
          computeInstructionReg <= computeInstruction;
        end else begin
          paraInstructionReg <= paraInstructionReg;
          computeInstructionReg <= computeInstructionReg;
        end
      end
      if(introut) begin
        writeComplete <= 1'b1;
      end
      if(when_Conv_l72) begin
        writeComplete <= 1'b0;
      end
      if(convCompute_1_computeComplete) begin
        computeComplete <= 1'b1;
      end
      if(when_Conv_l76) begin
        computeComplete <= 1'b0;
      end
      if(when_Conv_l87) begin
        dest <= 2'b00;
      end else begin
        if(when_Conv_l89) begin
          dest <= 2'b01;
        end else begin
          dest <= dest;
        end
      end
    end
  end

  always @(posedge clk) begin
    para_delay_1 <= para;
    para_delay_2 <= para_delay_1;
    para_delay_3 <= para_delay_2;
    compute_delay_1 <= compute;
    compute_delay_2 <= compute_delay_1;
    compute_delay_3 <= compute_delay_2;
  end


endmodule

//DmaRead replaced by DmaRead

//DmaRead replaced by DmaRead

//DmaWrite replaced by DmaWrite

module DmaRead (
  output              M_AXI_MM2S_arvalid,
  input               M_AXI_MM2S_arready,
  output reg [31:0]   M_AXI_MM2S_araddr,
  output reg [7:0]    M_AXI_MM2S_arlen,
  output reg [2:0]    M_AXI_MM2S_arsize,
  output reg [1:0]    M_AXI_MM2S_arburst,
  output     [3:0]    M_AXI_MM2S_arcache,
  output     [2:0]    M_AXI_MM2S_arprot,
  input               M_AXI_MM2S_rvalid,
  output              M_AXI_MM2S_rready,
  input      [63:0]   M_AXI_MM2S_rdata,
  input      [1:0]    M_AXI_MM2S_rresp,
  input               M_AXI_MM2S_rlast,
  output              M_AXIS_MM2S_valid,
  input               M_AXIS_MM2S_ready,
  output     [63:0]   M_AXIS_MM2S_payload,
  input               cmd_valid,
  input      [31:0]   cmd_addr,
  input      [31:0]   cmd_len,
  output reg          cmd_introut,
  input               clk,
  input               reset
);

  wire       [31:0]   _zz_when_DmaRead_l63;
  wire       [31:0]   _zz_when_DmaRead_l74;
  wire       [31:0]   _zz_M_AXI_MM2S_arlen;
  wire       [31:0]   _zz_M_AXI_MM2S_arlen_1;
  wire                M_AXI_MM2S_ar_fire;
  reg        [31:0]   addr;
  wire                M_AXI_MM2S_ar_fire_1;
  reg        [31:0]   cnt;
  reg        [31:0]   cntLast;
  wire                M_AXI_MM2S_r_fire;
  wire                M_AXI_MM2S_ar_fire_2;
  reg        [31:0]   len;
  wire                when_DmaRead_l63;
  wire                M_AXI_MM2S_ar_fire_3;
  wire                M_AXI_MM2S_ar_fire_4;
  wire                when_DmaRead_l74;
  reg                 aValid;
  reg        [31:0]   cntAv;
  wire                when_DmaRead_l86;
  reg                 trans;
  reg                 cmd_valid_regNext;
  wire                when_DmaRead_l96;

  assign _zz_when_DmaRead_l63 = (len - 32'h00000001);
  assign _zz_when_DmaRead_l74 = (len - cnt);
  assign _zz_M_AXI_MM2S_arlen = (_zz_M_AXI_MM2S_arlen_1 - cnt);
  assign _zz_M_AXI_MM2S_arlen_1 = (len - 32'h00000001);
  assign M_AXI_MM2S_ar_fire = (M_AXI_MM2S_arvalid && M_AXI_MM2S_arready);
  always @(*) begin
    if(M_AXI_MM2S_ar_fire) begin
      M_AXI_MM2S_arburst = 2'b01;
    end else begin
      M_AXI_MM2S_arburst = 2'b00;
    end
  end

  always @(*) begin
    if(M_AXI_MM2S_ar_fire) begin
      M_AXI_MM2S_arsize = 3'b011;
    end else begin
      M_AXI_MM2S_arsize = 3'b000;
    end
  end

  assign M_AXI_MM2S_arcache = 4'b0011;
  assign M_AXI_MM2S_arprot = 3'b000;
  assign M_AXIS_MM2S_valid = M_AXI_MM2S_rvalid;
  assign M_AXI_MM2S_rready = M_AXIS_MM2S_ready;
  assign M_AXIS_MM2S_payload = M_AXI_MM2S_rdata;
  assign M_AXI_MM2S_ar_fire_1 = (M_AXI_MM2S_arvalid && M_AXI_MM2S_arready);
  assign M_AXI_MM2S_r_fire = (M_AXI_MM2S_rvalid && M_AXI_MM2S_rready);
  assign M_AXI_MM2S_ar_fire_2 = (M_AXI_MM2S_arvalid && M_AXI_MM2S_arready);
  assign when_DmaRead_l63 = (cntLast == _zz_when_DmaRead_l63);
  always @(*) begin
    if(when_DmaRead_l63) begin
      cmd_introut = 1'b1;
    end else begin
      cmd_introut = 1'b0;
    end
  end

  assign M_AXI_MM2S_ar_fire_3 = (M_AXI_MM2S_arvalid && M_AXI_MM2S_arready);
  always @(*) begin
    if(M_AXI_MM2S_ar_fire_3) begin
      M_AXI_MM2S_araddr = addr;
    end else begin
      M_AXI_MM2S_araddr = 32'h0;
    end
  end

  assign M_AXI_MM2S_ar_fire_4 = (M_AXI_MM2S_arvalid && M_AXI_MM2S_arready);
  assign when_DmaRead_l74 = (32'h00000020 < _zz_when_DmaRead_l74);
  always @(*) begin
    if(M_AXI_MM2S_ar_fire_4) begin
      if(when_DmaRead_l74) begin
        M_AXI_MM2S_arlen = 8'h1f;
      end else begin
        M_AXI_MM2S_arlen = _zz_M_AXI_MM2S_arlen[7:0];
      end
    end else begin
      M_AXI_MM2S_arlen = 8'h0;
    end
  end

  assign when_DmaRead_l86 = (aValid && M_AXI_MM2S_arready);
  always @(*) begin
    if(cmd_valid_regNext) begin
      aValid = 1'b1;
    end else begin
      if(when_DmaRead_l96) begin
        aValid = 1'b1;
      end else begin
        aValid = 1'b0;
      end
    end
  end

  assign when_DmaRead_l96 = (((cntAv == 32'h0000001f) && (cnt < len)) && trans);
  assign M_AXI_MM2S_arvalid = aValid;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      addr <= 32'h0;
      cnt <= 32'h0;
      cntLast <= 32'h0;
      trans <= 1'b0;
    end else begin
      if(cmd_valid) begin
        addr <= cmd_addr;
      end else begin
        if(M_AXI_MM2S_ar_fire_1) begin
          addr <= (addr + 32'h00000100);
        end
      end
      if(M_AXI_MM2S_r_fire) begin
        if(cmd_introut) begin
          cntLast <= 32'h0;
        end else begin
          cntLast <= (cntLast + 32'h00000001);
        end
      end
      if(M_AXI_MM2S_ar_fire_2) begin
        cnt <= (cnt + 32'h00000020);
      end else begin
        if(cmd_introut) begin
          cnt <= 32'h0;
        end else begin
          cnt <= cnt;
        end
      end
      if(cmd_valid) begin
        trans <= 1'b1;
      end
      if(cmd_introut) begin
        trans <= 1'b0;
      end
    end
  end

  always @(posedge clk) begin
    if(cmd_valid) begin
      len <= cmd_len;
    end
    if(when_DmaRead_l86) begin
      cntAv <= 32'h0;
    end else begin
      if(aValid) begin
        cntAv <= cntAv;
      end else begin
        cntAv <= (cntAv + 32'h00000001);
      end
    end
    cmd_valid_regNext <= cmd_valid;
  end


endmodule

module DmaWrite (
  output              M_AXI_S2MM_awvalid,
  input               M_AXI_S2MM_awready,
  output reg [31:0]   M_AXI_S2MM_awaddr,
  output reg [7:0]    M_AXI_S2MM_awlen,
  output reg [2:0]    M_AXI_S2MM_awsize,
  output reg [1:0]    M_AXI_S2MM_awburst,
  output     [3:0]    M_AXI_S2MM_awcache,
  output     [2:0]    M_AXI_S2MM_awprot,
  output              M_AXI_S2MM_wvalid,
  input               M_AXI_S2MM_wready,
  output     [63:0]   M_AXI_S2MM_wdata,
  output     [7:0]    M_AXI_S2MM_wstrb,
  output reg          M_AXI_S2MM_wlast,
  input               M_AXI_S2MM_bvalid,
  output              M_AXI_S2MM_bready,
  input      [1:0]    M_AXI_S2MM_bresp,
  input               M_AXIS_S2MM_valid,
  output              M_AXIS_S2MM_ready,
  input      [63:0]   M_AXIS_S2MM_payload,
  input               cmd_valid,
  input      [31:0]   cmd_addr,
  input      [31:0]   cmd_len,
  output reg          cmd_introut,
  input               clk,
  input               reset
);

  wire       [31:0]   _zz_when_DmaWrite_l75;
  wire       [31:0]   _zz_when_DmaWrite_l80;
  wire       [31:0]   _zz_when_DmaWrite_l91;
  wire       [31:0]   _zz_M_AXI_S2MM_awlen;
  wire       [31:0]   _zz_M_AXI_S2MM_awlen_1;
  wire                M_AXI_S2MM_aw_fire;
  reg        [31:0]   addr;
  wire                M_AXI_S2MM_aw_fire_1;
  reg        [31:0]   cnt;
  reg        [31:0]   cntBrust;
  wire                M_AXI_S2MM_w_fire;
  wire                when_DmaWrite_l48;
  reg        [31:0]   cntLast;
  wire                M_AXI_S2MM_w_fire_1;
  wire                M_AXI_S2MM_aw_fire_2;
  reg        [31:0]   len;
  wire                when_DmaWrite_l75;
  wire                when_DmaWrite_l80;
  wire                M_AXI_S2MM_aw_fire_3;
  wire                M_AXI_S2MM_aw_fire_4;
  wire                when_DmaWrite_l91;
  reg                 aValid;
  reg        [31:0]   cntAv;
  wire                when_DmaWrite_l103;
  reg                 trans;
  reg                 cmd_valid_regNext;
  wire                when_DmaWrite_l113;

  assign _zz_when_DmaWrite_l75 = (len - 32'h00000001);
  assign _zz_when_DmaWrite_l80 = (len - 32'h00000001);
  assign _zz_when_DmaWrite_l91 = (len - cnt);
  assign _zz_M_AXI_S2MM_awlen = (_zz_M_AXI_S2MM_awlen_1 - cnt);
  assign _zz_M_AXI_S2MM_awlen_1 = (len - 32'h00000001);
  assign M_AXI_S2MM_aw_fire = (M_AXI_S2MM_awvalid && M_AXI_S2MM_awready);
  always @(*) begin
    if(M_AXI_S2MM_aw_fire) begin
      M_AXI_S2MM_awburst = 2'b01;
    end else begin
      M_AXI_S2MM_awburst = 2'b00;
    end
  end

  always @(*) begin
    if(M_AXI_S2MM_aw_fire) begin
      M_AXI_S2MM_awsize = 3'b011;
    end else begin
      M_AXI_S2MM_awsize = 3'b000;
    end
  end

  assign M_AXI_S2MM_awcache = 4'b0011;
  assign M_AXI_S2MM_awprot = 3'b000;
  assign M_AXI_S2MM_bready = 1'b1;
  assign M_AXI_S2MM_wvalid = M_AXIS_S2MM_valid;
  assign M_AXIS_S2MM_ready = M_AXI_S2MM_wready;
  assign M_AXI_S2MM_wdata = M_AXIS_S2MM_payload;
  assign M_AXI_S2MM_wstrb = 8'hff;
  assign M_AXI_S2MM_aw_fire_1 = (M_AXI_S2MM_awvalid && M_AXI_S2MM_awready);
  assign M_AXI_S2MM_w_fire = (M_AXI_S2MM_wvalid && M_AXI_S2MM_wready);
  assign when_DmaWrite_l48 = ((cntBrust == 32'h0000001f) || cmd_introut);
  assign M_AXI_S2MM_w_fire_1 = (M_AXI_S2MM_wvalid && M_AXI_S2MM_wready);
  assign M_AXI_S2MM_aw_fire_2 = (M_AXI_S2MM_awvalid && M_AXI_S2MM_awready);
  assign when_DmaWrite_l75 = ((cntBrust == 32'h0000001f) || (cntLast == _zz_when_DmaWrite_l75));
  always @(*) begin
    if(when_DmaWrite_l75) begin
      M_AXI_S2MM_wlast = 1'b1;
    end else begin
      M_AXI_S2MM_wlast = 1'b0;
    end
  end

  assign when_DmaWrite_l80 = (cntLast == _zz_when_DmaWrite_l80);
  always @(*) begin
    if(when_DmaWrite_l80) begin
      cmd_introut = 1'b1;
    end else begin
      cmd_introut = 1'b0;
    end
  end

  assign M_AXI_S2MM_aw_fire_3 = (M_AXI_S2MM_awvalid && M_AXI_S2MM_awready);
  always @(*) begin
    if(M_AXI_S2MM_aw_fire_3) begin
      M_AXI_S2MM_awaddr = addr;
    end else begin
      M_AXI_S2MM_awaddr = 32'h0;
    end
  end

  assign M_AXI_S2MM_aw_fire_4 = (M_AXI_S2MM_awvalid && M_AXI_S2MM_awready);
  assign when_DmaWrite_l91 = (32'h00000020 < _zz_when_DmaWrite_l91);
  always @(*) begin
    if(M_AXI_S2MM_aw_fire_4) begin
      if(when_DmaWrite_l91) begin
        M_AXI_S2MM_awlen = 8'h1f;
      end else begin
        M_AXI_S2MM_awlen = _zz_M_AXI_S2MM_awlen[7:0];
      end
    end else begin
      M_AXI_S2MM_awlen = 8'h0;
    end
  end

  assign when_DmaWrite_l103 = (aValid && M_AXI_S2MM_awready);
  always @(*) begin
    if(cmd_valid_regNext) begin
      aValid = 1'b1;
    end else begin
      if(when_DmaWrite_l113) begin
        aValid = 1'b1;
      end else begin
        aValid = 1'b0;
      end
    end
  end

  assign when_DmaWrite_l113 = (((cntAv == 32'h0000001f) && (cnt < len)) && trans);
  assign M_AXI_S2MM_awvalid = aValid;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      addr <= 32'h0;
      cnt <= 32'h0;
      cntBrust <= 32'h0;
      cntLast <= 32'h0;
      trans <= 1'b0;
    end else begin
      if(cmd_valid) begin
        addr <= cmd_addr;
      end else begin
        if(M_AXI_S2MM_aw_fire_1) begin
          addr <= (addr + 32'h00000100);
        end
      end
      if(M_AXI_S2MM_w_fire) begin
        if(when_DmaWrite_l48) begin
          cntBrust <= 32'h0;
        end else begin
          cntBrust <= (cntBrust + 32'h00000001);
        end
      end
      if(M_AXI_S2MM_w_fire_1) begin
        if(cmd_introut) begin
          cntLast <= 32'h0;
        end else begin
          cntLast <= (cntLast + 32'h00000001);
        end
      end
      if(M_AXI_S2MM_aw_fire_2) begin
        cnt <= (cnt + 32'h00000020);
      end else begin
        if(cmd_introut) begin
          cnt <= 32'h0;
        end else begin
          cnt <= cnt;
        end
      end
      if(cmd_valid) begin
        trans <= 1'b1;
      end
      if(cmd_introut) begin
        trans <= 1'b0;
      end
    end
  end

  always @(posedge clk) begin
    if(cmd_valid) begin
      len <= cmd_len;
    end
    if(when_DmaWrite_l103) begin
      cntAv <= 32'h0;
    end else begin
      if(aValid) begin
        cntAv <= cntAv;
      end else begin
        cntAv <= (cntAv + 32'h00000001);
      end
    end
    cmd_valid_regNext <= cmd_valid;
  end


endmodule

module StreamFifo_3 (
  input               io_push_valid,
  output              io_push_ready,
  input      [63:0]   io_push_payload,
  output              io_pop_valid,
  input               io_pop_ready,
  output     [63:0]   io_pop_payload,
  input               io_flush,
  output     [11:0]   io_occupancy,
  output     [11:0]   io_availability,
  input               clk,
  input               reset
);

  reg        [63:0]   _zz_logic_ram_port0;
  wire       [10:0]   _zz_logic_pushPtr_valueNext;
  wire       [0:0]    _zz_logic_pushPtr_valueNext_1;
  wire       [10:0]   _zz_logic_popPtr_valueNext;
  wire       [0:0]    _zz_logic_popPtr_valueNext_1;
  wire                _zz_logic_ram_port;
  wire                _zz_io_pop_payload;
  wire       [63:0]   _zz_logic_ram_port_1;
  wire       [10:0]   _zz_io_availability;
  reg                 _zz_1;
  reg                 logic_pushPtr_willIncrement;
  reg                 logic_pushPtr_willClear;
  reg        [10:0]   logic_pushPtr_valueNext;
  reg        [10:0]   logic_pushPtr_value;
  wire                logic_pushPtr_willOverflowIfInc;
  wire                logic_pushPtr_willOverflow;
  reg                 logic_popPtr_willIncrement;
  reg                 logic_popPtr_willClear;
  reg        [10:0]   logic_popPtr_valueNext;
  reg        [10:0]   logic_popPtr_value;
  wire                logic_popPtr_willOverflowIfInc;
  wire                logic_popPtr_willOverflow;
  wire                logic_ptrMatch;
  reg                 logic_risingOccupancy;
  wire                logic_pushing;
  wire                logic_popping;
  wire                logic_empty;
  wire                logic_full;
  reg                 _zz_io_pop_valid;
  wire                when_Stream_l1021;
  wire       [10:0]   logic_ptrDif;
  reg [63:0] logic_ram [0:2047];

  assign _zz_logic_pushPtr_valueNext_1 = logic_pushPtr_willIncrement;
  assign _zz_logic_pushPtr_valueNext = {10'd0, _zz_logic_pushPtr_valueNext_1};
  assign _zz_logic_popPtr_valueNext_1 = logic_popPtr_willIncrement;
  assign _zz_logic_popPtr_valueNext = {10'd0, _zz_logic_popPtr_valueNext_1};
  assign _zz_io_availability = (logic_popPtr_value - logic_pushPtr_value);
  assign _zz_io_pop_payload = 1'b1;
  assign _zz_logic_ram_port_1 = io_push_payload;
  always @(posedge clk) begin
    if(_zz_io_pop_payload) begin
      _zz_logic_ram_port0 <= logic_ram[logic_popPtr_valueNext];
    end
  end

  always @(posedge clk) begin
    if(_zz_1) begin
      logic_ram[logic_pushPtr_value] <= _zz_logic_ram_port_1;
    end
  end

  always @(*) begin
    _zz_1 = 1'b0;
    if(logic_pushing) begin
      _zz_1 = 1'b1;
    end
  end

  always @(*) begin
    logic_pushPtr_willIncrement = 1'b0;
    if(logic_pushing) begin
      logic_pushPtr_willIncrement = 1'b1;
    end
  end

  always @(*) begin
    logic_pushPtr_willClear = 1'b0;
    if(io_flush) begin
      logic_pushPtr_willClear = 1'b1;
    end
  end

  assign logic_pushPtr_willOverflowIfInc = (logic_pushPtr_value == 11'h7ff);
  assign logic_pushPtr_willOverflow = (logic_pushPtr_willOverflowIfInc && logic_pushPtr_willIncrement);
  always @(*) begin
    logic_pushPtr_valueNext = (logic_pushPtr_value + _zz_logic_pushPtr_valueNext);
    if(logic_pushPtr_willClear) begin
      logic_pushPtr_valueNext = 11'h0;
    end
  end

  always @(*) begin
    logic_popPtr_willIncrement = 1'b0;
    if(logic_popping) begin
      logic_popPtr_willIncrement = 1'b1;
    end
  end

  always @(*) begin
    logic_popPtr_willClear = 1'b0;
    if(io_flush) begin
      logic_popPtr_willClear = 1'b1;
    end
  end

  assign logic_popPtr_willOverflowIfInc = (logic_popPtr_value == 11'h7ff);
  assign logic_popPtr_willOverflow = (logic_popPtr_willOverflowIfInc && logic_popPtr_willIncrement);
  always @(*) begin
    logic_popPtr_valueNext = (logic_popPtr_value + _zz_logic_popPtr_valueNext);
    if(logic_popPtr_willClear) begin
      logic_popPtr_valueNext = 11'h0;
    end
  end

  assign logic_ptrMatch = (logic_pushPtr_value == logic_popPtr_value);
  assign logic_pushing = (io_push_valid && io_push_ready);
  assign logic_popping = (io_pop_valid && io_pop_ready);
  assign logic_empty = (logic_ptrMatch && (! logic_risingOccupancy));
  assign logic_full = (logic_ptrMatch && logic_risingOccupancy);
  assign io_push_ready = (! logic_full);
  assign io_pop_valid = ((! logic_empty) && (! (_zz_io_pop_valid && (! logic_full))));
  assign io_pop_payload = _zz_logic_ram_port0;
  assign when_Stream_l1021 = (logic_pushing != logic_popping);
  assign logic_ptrDif = (logic_pushPtr_value - logic_popPtr_value);
  assign io_occupancy = {(logic_risingOccupancy && logic_ptrMatch),logic_ptrDif};
  assign io_availability = {((! logic_risingOccupancy) && logic_ptrMatch),_zz_io_availability};
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      logic_pushPtr_value <= 11'h0;
      logic_popPtr_value <= 11'h0;
      logic_risingOccupancy <= 1'b0;
      _zz_io_pop_valid <= 1'b0;
    end else begin
      logic_pushPtr_value <= logic_pushPtr_valueNext;
      logic_popPtr_value <= logic_popPtr_valueNext;
      _zz_io_pop_valid <= (logic_popPtr_valueNext == logic_pushPtr_value);
      if(when_Stream_l1021) begin
        logic_risingOccupancy <= logic_pushing;
      end
      if(io_flush) begin
        logic_risingOccupancy <= 1'b0;
      end
    end
  end


endmodule

module UpSampling (
  input               start,
  input               fifoReady,
  input               sData_valid,
  output reg          sData_ready,
  input      [63:0]   sData_payload,
  output reg          mData_valid,
  input               mData_ready,
  output reg [63:0]   mData_payload,
  input      [9:0]    rowNumIn,
  input      [9:0]    colNumIn,
  input      [9:0]    channelIn,
  input               clk,
  input               reset
);
  localparam ShapeStateMachineEnum_IDLE = 5'd1;
  localparam ShapeStateMachineEnum_INIT = 5'd2;
  localparam ShapeStateMachineEnum_FIFO_READY = 5'd4;
  localparam ShapeStateMachineEnum_COMPUTE = 5'd8;
  localparam ShapeStateMachineEnum_LAST = 5'd16;

  reg                 dataTemp_io_push_valid;
  reg        [63:0]   dataTemp_io_push_payload;
  reg                 dataTemp_io_pop_ready;
  reg                 channelMem_io_push_valid;
  reg        [63:0]   channelMem_io_push_payload;
  reg                 channelMem_io_pop_ready;
  wire                dataTemp_io_push_ready;
  wire                dataTemp_io_pop_valid;
  wire       [63:0]   dataTemp_io_pop_payload;
  wire       [10:0]   dataTemp_io_occupancy;
  wire       [10:0]   dataTemp_io_availability;
  wire                channelMem_io_push_ready;
  wire                channelMem_io_pop_valid;
  wire       [63:0]   channelMem_io_pop_payload;
  wire       [6:0]    channelMem_io_occupancy;
  wire       [6:0]    channelMem_io_availability;
  wire       [9:0]    _zz_when_WaCounter_l12;
  wire       [6:0]    _zz_when_WaCounter_l12_1;
  wire       [10:0]   _zz_when_WaCounter_l12_1_1;
  wire       [10:0]   _zz_when_WaCounter_l12_2;
  wire       [6:0]    computeChannelTimes;
  wire       [10:0]   computeColumn;
  wire       [10:0]   computeRow;
  wire                fsm_initEnd;
  wire                fsm_fifoReady;
  reg                 fsm_computeEnd;
  wire                fsm_last;
  reg        [4:0]    fsm_currentState;
  reg        [4:0]    fsm_nextState;
  wire                mData_fire;
  reg        [9:0]    channelCnt_count;
  reg                 channelCnt_valid;
  wire                when_WaCounter_l12;
  wire                mData_fire_1;
  wire                when_WaCounter_l17;
  reg        [10:0]   columnCnt_count;
  reg                 columnCnt_valid;
  wire                when_WaCounter_l12_1;
  reg        [10:0]   rowCnt_count;
  reg                 rowCnt_valid;
  wire                when_WaCounter_l12_2;
  wire                when_WaCounter_l17_1;
  reg        [2:0]    initCount_count;
  reg                 initCount_valid;
  wire                when_WaCounter_l12_3;
  wire                when_UpSampling_l38;
  reg                 columnCnt_valid_regNext;
  reg                 rowCnt_valid_regNext;
  wire                when_UpSampling_l51;
  wire                when_UpSampling_l52;
  wire                sData_fire;
  wire                sData_fire_1;
  wire                sData_fire_2;
  wire                when_UpSampling_l73;
  wire                when_UpSampling_l91;
  `ifndef SYNTHESIS
  reg [79:0] fsm_currentState_string;
  reg [79:0] fsm_nextState_string;
  `endif


  assign _zz_when_WaCounter_l12_1 = (computeChannelTimes - 7'h01);
  assign _zz_when_WaCounter_l12 = {3'd0, _zz_when_WaCounter_l12_1};
  assign _zz_when_WaCounter_l12_1_1 = (computeColumn - 11'h001);
  assign _zz_when_WaCounter_l12_2 = (computeRow - 11'h001);
  StreamFifo_1 dataTemp (
    .io_push_valid   (dataTemp_io_push_valid        ), //i
    .io_push_ready   (dataTemp_io_push_ready        ), //o
    .io_push_payload (dataTemp_io_push_payload[63:0]), //i
    .io_pop_valid    (dataTemp_io_pop_valid         ), //o
    .io_pop_ready    (dataTemp_io_pop_ready         ), //i
    .io_pop_payload  (dataTemp_io_pop_payload[63:0] ), //o
    .io_flush        (1'b0                          ), //i
    .io_occupancy    (dataTemp_io_occupancy[10:0]   ), //o
    .io_availability (dataTemp_io_availability[10:0]), //o
    .clk             (clk                           ), //i
    .reset           (reset                         )  //i
  );
  StreamFifo_2 channelMem (
    .io_push_valid   (channelMem_io_push_valid        ), //i
    .io_push_ready   (channelMem_io_push_ready        ), //o
    .io_push_payload (channelMem_io_push_payload[63:0]), //i
    .io_pop_valid    (channelMem_io_pop_valid         ), //o
    .io_pop_ready    (channelMem_io_pop_ready         ), //i
    .io_pop_payload  (channelMem_io_pop_payload[63:0] ), //o
    .io_flush        (1'b0                            ), //i
    .io_occupancy    (channelMem_io_occupancy[6:0]    ), //o
    .io_availability (channelMem_io_availability[6:0] ), //o
    .clk             (clk                             ), //i
    .reset           (reset                           )  //i
  );
  `ifndef SYNTHESIS
  always @(*) begin
    case(fsm_currentState)
      ShapeStateMachineEnum_IDLE : fsm_currentState_string = "IDLE      ";
      ShapeStateMachineEnum_INIT : fsm_currentState_string = "INIT      ";
      ShapeStateMachineEnum_FIFO_READY : fsm_currentState_string = "FIFO_READY";
      ShapeStateMachineEnum_COMPUTE : fsm_currentState_string = "COMPUTE   ";
      ShapeStateMachineEnum_LAST : fsm_currentState_string = "LAST      ";
      default : fsm_currentState_string = "??????????";
    endcase
  end
  always @(*) begin
    case(fsm_nextState)
      ShapeStateMachineEnum_IDLE : fsm_nextState_string = "IDLE      ";
      ShapeStateMachineEnum_INIT : fsm_nextState_string = "INIT      ";
      ShapeStateMachineEnum_FIFO_READY : fsm_nextState_string = "FIFO_READY";
      ShapeStateMachineEnum_COMPUTE : fsm_nextState_string = "COMPUTE   ";
      ShapeStateMachineEnum_LAST : fsm_nextState_string = "LAST      ";
      default : fsm_nextState_string = "??????????";
    endcase
  end
  `endif

  assign computeChannelTimes = (channelIn >>> 3);
  assign computeColumn = ({1'd0,colNumIn} <<< 1);
  assign computeRow = ({1'd0,rowNumIn} <<< 1);
  always @(*) begin
    (* parallel_case *)
    case(1) // synthesis parallel_case
      (((fsm_currentState) & ShapeStateMachineEnum_IDLE) == ShapeStateMachineEnum_IDLE) : begin
        if(start) begin
          fsm_nextState = ShapeStateMachineEnum_INIT;
        end else begin
          fsm_nextState = ShapeStateMachineEnum_IDLE;
        end
      end
      (((fsm_currentState) & ShapeStateMachineEnum_INIT) == ShapeStateMachineEnum_INIT) : begin
        if(fsm_initEnd) begin
          fsm_nextState = ShapeStateMachineEnum_FIFO_READY;
        end else begin
          fsm_nextState = ShapeStateMachineEnum_INIT;
        end
      end
      (((fsm_currentState) & ShapeStateMachineEnum_FIFO_READY) == ShapeStateMachineEnum_FIFO_READY) : begin
        if(fsm_fifoReady) begin
          fsm_nextState = ShapeStateMachineEnum_COMPUTE;
        end else begin
          fsm_nextState = ShapeStateMachineEnum_FIFO_READY;
        end
      end
      (((fsm_currentState) & ShapeStateMachineEnum_COMPUTE) == ShapeStateMachineEnum_COMPUTE) : begin
        if(fsm_computeEnd) begin
          fsm_nextState = ShapeStateMachineEnum_LAST;
        end else begin
          fsm_nextState = ShapeStateMachineEnum_COMPUTE;
        end
      end
      default : begin
        if(fsm_last) begin
          fsm_nextState = ShapeStateMachineEnum_IDLE;
        end else begin
          fsm_nextState = ShapeStateMachineEnum_FIFO_READY;
        end
      end
    endcase
  end

  assign mData_fire = (mData_valid && mData_ready);
  assign when_WaCounter_l12 = (channelCnt_count == _zz_when_WaCounter_l12);
  always @(*) begin
    if(when_WaCounter_l12) begin
      channelCnt_valid = 1'b1;
    end else begin
      channelCnt_valid = 1'b0;
    end
  end

  assign mData_fire_1 = (mData_valid && mData_ready);
  assign when_WaCounter_l17 = (channelCnt_valid && mData_fire_1);
  assign when_WaCounter_l12_1 = (columnCnt_count == _zz_when_WaCounter_l12_1_1);
  always @(*) begin
    if(when_WaCounter_l12_1) begin
      columnCnt_valid = 1'b1;
    end else begin
      columnCnt_valid = 1'b0;
    end
  end

  assign when_WaCounter_l12_2 = (rowCnt_count == _zz_when_WaCounter_l12_2);
  always @(*) begin
    if(when_WaCounter_l12_2) begin
      rowCnt_valid = 1'b1;
    end else begin
      rowCnt_valid = 1'b0;
    end
  end

  assign when_WaCounter_l17_1 = ((fsm_currentState & ShapeStateMachineEnum_INIT) != 5'b00000);
  assign when_WaCounter_l12_3 = (initCount_count == 3'b101);
  always @(*) begin
    if(when_WaCounter_l12_3) begin
      initCount_valid = 1'b1;
    end else begin
      initCount_valid = 1'b0;
    end
  end

  assign fsm_initEnd = initCount_valid;
  assign fsm_fifoReady = fifoReady;
  assign when_UpSampling_l38 = (computeChannelTimes == 7'h01);
  always @(*) begin
    if(when_UpSampling_l38) begin
      fsm_computeEnd = (channelCnt_valid && (columnCnt_valid && (! columnCnt_valid_regNext)));
    end else begin
      fsm_computeEnd = (channelCnt_valid && columnCnt_valid);
    end
  end

  assign fsm_last = rowCnt_valid_regNext;
  assign when_UpSampling_l51 = (! rowCnt_count[0]);
  assign when_UpSampling_l52 = (! columnCnt_count[0]);
  always @(*) begin
    if(when_UpSampling_l51) begin
      if(when_UpSampling_l52) begin
        sData_ready = ((mData_ready && dataTemp_io_push_ready) && channelMem_io_push_ready);
      end else begin
        sData_ready = 1'b0;
      end
    end else begin
      sData_ready = 1'b0;
    end
    if(when_UpSampling_l91) begin
      sData_ready = 1'b0;
    end
  end

  assign sData_fire = (sData_valid && sData_ready);
  always @(*) begin
    if(when_UpSampling_l51) begin
      if(when_UpSampling_l52) begin
        mData_valid = sData_fire;
      end else begin
        mData_valid = channelMem_io_pop_valid;
      end
    end else begin
      if(when_UpSampling_l73) begin
        mData_valid = dataTemp_io_pop_valid;
      end else begin
        mData_valid = channelMem_io_pop_valid;
      end
    end
  end

  always @(*) begin
    if(when_UpSampling_l51) begin
      if(when_UpSampling_l52) begin
        mData_payload = sData_payload;
      end else begin
        mData_payload = channelMem_io_pop_payload;
      end
    end else begin
      if(when_UpSampling_l73) begin
        mData_payload = dataTemp_io_pop_payload;
      end else begin
        mData_payload = channelMem_io_pop_payload;
      end
    end
  end

  always @(*) begin
    if(when_UpSampling_l51) begin
      if(when_UpSampling_l52) begin
        dataTemp_io_push_payload = sData_payload;
      end else begin
        dataTemp_io_push_payload = 64'h0;
      end
    end else begin
      if(when_UpSampling_l73) begin
        dataTemp_io_push_payload = 64'h0;
      end else begin
        dataTemp_io_push_payload = 64'h0;
      end
    end
  end

  assign sData_fire_1 = (sData_valid && sData_ready);
  always @(*) begin
    if(when_UpSampling_l51) begin
      if(when_UpSampling_l52) begin
        dataTemp_io_push_valid = sData_fire_1;
      end else begin
        dataTemp_io_push_valid = 1'b0;
      end
    end else begin
      if(when_UpSampling_l73) begin
        dataTemp_io_push_valid = 1'b0;
      end else begin
        dataTemp_io_push_valid = 1'b0;
      end
    end
  end

  always @(*) begin
    if(when_UpSampling_l51) begin
      if(when_UpSampling_l52) begin
        dataTemp_io_pop_ready = 1'b0;
      end else begin
        dataTemp_io_pop_ready = 1'b0;
      end
    end else begin
      if(when_UpSampling_l73) begin
        dataTemp_io_pop_ready = (mData_ready && channelMem_io_push_ready);
      end else begin
        dataTemp_io_pop_ready = 1'b0;
      end
    end
  end

  always @(*) begin
    if(when_UpSampling_l51) begin
      if(when_UpSampling_l52) begin
        channelMem_io_push_payload = sData_payload;
      end else begin
        channelMem_io_push_payload = 64'h0;
      end
    end else begin
      if(when_UpSampling_l73) begin
        channelMem_io_push_payload = dataTemp_io_pop_payload;
      end else begin
        channelMem_io_push_payload = 64'h0;
      end
    end
  end

  assign sData_fire_2 = (sData_valid && sData_ready);
  always @(*) begin
    if(when_UpSampling_l51) begin
      if(when_UpSampling_l52) begin
        channelMem_io_push_valid = sData_fire_2;
      end else begin
        channelMem_io_push_valid = 1'b0;
      end
    end else begin
      if(when_UpSampling_l73) begin
        channelMem_io_push_valid = dataTemp_io_pop_valid;
      end else begin
        channelMem_io_push_valid = 1'b0;
      end
    end
  end

  always @(*) begin
    if(when_UpSampling_l51) begin
      if(when_UpSampling_l52) begin
        channelMem_io_pop_ready = 1'b0;
      end else begin
        channelMem_io_pop_ready = mData_ready;
      end
    end else begin
      if(when_UpSampling_l73) begin
        channelMem_io_pop_ready = 1'b0;
      end else begin
        channelMem_io_pop_ready = mData_ready;
      end
    end
  end

  assign when_UpSampling_l73 = (! columnCnt_count[0]);
  assign when_UpSampling_l91 = (((fsm_currentState & ShapeStateMachineEnum_IDLE) != 5'b00000) || ((fsm_currentState & ShapeStateMachineEnum_INIT) != 5'b00000));
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      fsm_currentState <= ShapeStateMachineEnum_IDLE;
      channelCnt_count <= 10'h0;
      columnCnt_count <= 11'h0;
      rowCnt_count <= 11'h0;
      initCount_count <= 3'b000;
    end else begin
      fsm_currentState <= fsm_nextState;
      if(mData_fire) begin
        channelCnt_count <= (channelCnt_count + 10'h001);
        if(channelCnt_valid) begin
          channelCnt_count <= 10'h0;
        end
      end
      if(when_WaCounter_l17) begin
        columnCnt_count <= (columnCnt_count + 11'h001);
        if(columnCnt_valid) begin
          columnCnt_count <= 11'h0;
        end
      end
      if(fsm_computeEnd) begin
        rowCnt_count <= (rowCnt_count + 11'h001);
        if(rowCnt_valid) begin
          rowCnt_count <= 11'h0;
        end
      end
      if(when_WaCounter_l17_1) begin
        initCount_count <= (initCount_count + 3'b001);
        if(initCount_valid) begin
          initCount_count <= 3'b000;
        end
      end
    end
  end

  always @(posedge clk) begin
    columnCnt_valid_regNext <= columnCnt_valid;
  end

  always @(posedge clk) begin
    rowCnt_valid_regNext <= rowCnt_valid;
  end


endmodule

module Split (
  input               start,
  input               fifoReady,
  input               sData_valid,
  output              sData_ready,
  input      [63:0]   sData_payload,
  output              mData_valid,
  input               mData_ready,
  output     [63:0]   mData_payload,
  input      [9:0]    rowNumIn,
  input      [9:0]    colNumIn,
  input      [9:0]    channelIn,
  input               clk,
  input               reset
);
  localparam ShapeStateMachineEnum_IDLE = 5'd1;
  localparam ShapeStateMachineEnum_INIT = 5'd2;
  localparam ShapeStateMachineEnum_FIFO_READY = 5'd4;
  localparam ShapeStateMachineEnum_COMPUTE = 5'd8;
  localparam ShapeStateMachineEnum_LAST = 5'd16;

  wire       [9:0]    _zz_when_WaCounter_l12;
  wire       [6:0]    _zz_when_WaCounter_l12_1;
  wire       [9:0]    _zz_when_WaCounter_l12_1_1;
  wire       [9:0]    _zz_when_WaCounter_l12_2;
  wire       [9:0]    _zz_when_Stream_l434;
  wire       [6:0]    computeChannelTimes;
  wire       [5:0]    channelOut;
  wire                fsm_initEnd;
  wire                fsm_fifoReady;
  wire                fsm_computeEnd;
  wire                fsm_last;
  reg        [4:0]    fsm_currentState;
  reg        [4:0]    fsm_nextState;
  wire                sData_fire;
  reg        [9:0]    channelCnt_count;
  reg                 channelCnt_valid;
  wire                when_WaCounter_l12;
  wire                sData_fire_1;
  wire                when_WaCounter_l17;
  reg        [9:0]    columnCnt_count;
  reg                 columnCnt_valid;
  wire                when_WaCounter_l12_1;
  wire                when_WaCounter_l17_1;
  reg        [9:0]    rowCnt_count;
  reg                 rowCnt_valid;
  wire                when_WaCounter_l12_2;
  wire                when_WaCounter_l17_2;
  reg        [2:0]    initCount_count;
  reg                 initCount_valid;
  wire                when_WaCounter_l12_3;
  wire                _zz_sData_ready;
  reg                 _zz_sData_ready_1;
  wire                when_Stream_l434;
  reg                 _zz_mData_valid;
  `ifndef SYNTHESIS
  reg [79:0] fsm_currentState_string;
  reg [79:0] fsm_nextState_string;
  `endif


  assign _zz_when_WaCounter_l12_1 = (computeChannelTimes - 7'h01);
  assign _zz_when_WaCounter_l12 = {3'd0, _zz_when_WaCounter_l12_1};
  assign _zz_when_WaCounter_l12_1_1 = (colNumIn - 10'h001);
  assign _zz_when_WaCounter_l12_2 = (rowNumIn - 10'h001);
  assign _zz_when_Stream_l434 = {4'd0, channelOut};
  `ifndef SYNTHESIS
  always @(*) begin
    case(fsm_currentState)
      ShapeStateMachineEnum_IDLE : fsm_currentState_string = "IDLE      ";
      ShapeStateMachineEnum_INIT : fsm_currentState_string = "INIT      ";
      ShapeStateMachineEnum_FIFO_READY : fsm_currentState_string = "FIFO_READY";
      ShapeStateMachineEnum_COMPUTE : fsm_currentState_string = "COMPUTE   ";
      ShapeStateMachineEnum_LAST : fsm_currentState_string = "LAST      ";
      default : fsm_currentState_string = "??????????";
    endcase
  end
  always @(*) begin
    case(fsm_nextState)
      ShapeStateMachineEnum_IDLE : fsm_nextState_string = "IDLE      ";
      ShapeStateMachineEnum_INIT : fsm_nextState_string = "INIT      ";
      ShapeStateMachineEnum_FIFO_READY : fsm_nextState_string = "FIFO_READY";
      ShapeStateMachineEnum_COMPUTE : fsm_nextState_string = "COMPUTE   ";
      ShapeStateMachineEnum_LAST : fsm_nextState_string = "LAST      ";
      default : fsm_nextState_string = "??????????";
    endcase
  end
  `endif

  assign computeChannelTimes = (channelIn >>> 3);
  assign channelOut = (computeChannelTimes >>> 1);
  always @(*) begin
    (* parallel_case *)
    case(1) // synthesis parallel_case
      (((fsm_currentState) & ShapeStateMachineEnum_IDLE) == ShapeStateMachineEnum_IDLE) : begin
        if(start) begin
          fsm_nextState = ShapeStateMachineEnum_INIT;
        end else begin
          fsm_nextState = ShapeStateMachineEnum_IDLE;
        end
      end
      (((fsm_currentState) & ShapeStateMachineEnum_INIT) == ShapeStateMachineEnum_INIT) : begin
        if(fsm_initEnd) begin
          fsm_nextState = ShapeStateMachineEnum_FIFO_READY;
        end else begin
          fsm_nextState = ShapeStateMachineEnum_INIT;
        end
      end
      (((fsm_currentState) & ShapeStateMachineEnum_FIFO_READY) == ShapeStateMachineEnum_FIFO_READY) : begin
        if(fsm_fifoReady) begin
          fsm_nextState = ShapeStateMachineEnum_COMPUTE;
        end else begin
          fsm_nextState = ShapeStateMachineEnum_FIFO_READY;
        end
      end
      (((fsm_currentState) & ShapeStateMachineEnum_COMPUTE) == ShapeStateMachineEnum_COMPUTE) : begin
        if(fsm_computeEnd) begin
          fsm_nextState = ShapeStateMachineEnum_LAST;
        end else begin
          fsm_nextState = ShapeStateMachineEnum_COMPUTE;
        end
      end
      default : begin
        if(fsm_last) begin
          fsm_nextState = ShapeStateMachineEnum_IDLE;
        end else begin
          fsm_nextState = ShapeStateMachineEnum_FIFO_READY;
        end
      end
    endcase
  end

  assign sData_fire = (sData_valid && sData_ready);
  assign when_WaCounter_l12 = (channelCnt_count == _zz_when_WaCounter_l12);
  always @(*) begin
    if(when_WaCounter_l12) begin
      channelCnt_valid = 1'b1;
    end else begin
      channelCnt_valid = 1'b0;
    end
  end

  assign sData_fire_1 = (sData_valid && sData_ready);
  assign when_WaCounter_l17 = (channelCnt_valid && sData_fire_1);
  assign when_WaCounter_l12_1 = (columnCnt_count == _zz_when_WaCounter_l12_1_1);
  always @(*) begin
    if(when_WaCounter_l12_1) begin
      columnCnt_valid = 1'b1;
    end else begin
      columnCnt_valid = 1'b0;
    end
  end

  assign when_WaCounter_l17_1 = ((fsm_currentState & ShapeStateMachineEnum_LAST) != 5'b00000);
  assign when_WaCounter_l12_2 = (rowCnt_count == _zz_when_WaCounter_l12_2);
  always @(*) begin
    if(when_WaCounter_l12_2) begin
      rowCnt_valid = 1'b1;
    end else begin
      rowCnt_valid = 1'b0;
    end
  end

  assign when_WaCounter_l17_2 = ((fsm_currentState & ShapeStateMachineEnum_INIT) != 5'b00000);
  assign when_WaCounter_l12_3 = (initCount_count == 3'b101);
  always @(*) begin
    if(when_WaCounter_l12_3) begin
      initCount_valid = 1'b1;
    end else begin
      initCount_valid = 1'b0;
    end
  end

  assign fsm_initEnd = initCount_valid;
  assign fsm_fifoReady = fifoReady;
  assign fsm_computeEnd = (channelCnt_valid && columnCnt_valid);
  assign fsm_last = rowCnt_valid;
  assign _zz_sData_ready = (! ((fsm_currentState & ShapeStateMachineEnum_COMPUTE) == 5'b00000));
  assign sData_ready = (_zz_sData_ready_1 && _zz_sData_ready);
  assign when_Stream_l434 = (channelCnt_count < _zz_when_Stream_l434);
  always @(*) begin
    _zz_mData_valid = (sData_valid && _zz_sData_ready);
    if(when_Stream_l434) begin
      _zz_mData_valid = 1'b0;
    end
  end

  always @(*) begin
    _zz_sData_ready_1 = mData_ready;
    if(when_Stream_l434) begin
      _zz_sData_ready_1 = 1'b1;
    end
  end

  assign mData_valid = _zz_mData_valid;
  assign mData_payload = sData_payload;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      fsm_currentState <= ShapeStateMachineEnum_IDLE;
      channelCnt_count <= 10'h0;
      columnCnt_count <= 10'h0;
      rowCnt_count <= 10'h0;
      initCount_count <= 3'b000;
    end else begin
      fsm_currentState <= fsm_nextState;
      if(sData_fire) begin
        channelCnt_count <= (channelCnt_count + 10'h001);
        if(channelCnt_valid) begin
          channelCnt_count <= 10'h0;
        end
      end
      if(when_WaCounter_l17) begin
        columnCnt_count <= (columnCnt_count + 10'h001);
        if(columnCnt_valid) begin
          columnCnt_count <= 10'h0;
        end
      end
      if(when_WaCounter_l17_1) begin
        rowCnt_count <= (rowCnt_count + 10'h001);
        if(rowCnt_valid) begin
          rowCnt_count <= 10'h0;
        end
      end
      if(when_WaCounter_l17_2) begin
        initCount_count <= (initCount_count + 3'b001);
        if(initCount_valid) begin
          initCount_count <= 3'b000;
        end
      end
    end
  end


endmodule

module MaxPooling (
  input               start,
  input               fifoReady,
  input               sData_valid,
  output reg          sData_ready,
  input      [63:0]   sData_payload,
  output              mData_valid,
  input               mData_ready,
  output reg [63:0]   mData_payload,
  input      [9:0]    rowNumIn,
  input      [9:0]    colNumIn,
  input      [9:0]    channelIn,
  input               clk,
  input               reset
);
  localparam ShapeStateMachineEnum_IDLE = 5'd1;
  localparam ShapeStateMachineEnum_INIT = 5'd2;
  localparam ShapeStateMachineEnum_FIFO_READY = 5'd4;
  localparam ShapeStateMachineEnum_COMPUTE = 5'd8;
  localparam ShapeStateMachineEnum_LAST = 5'd16;

  wire       [63:0]   _zz_channelMem_port1;
  wire       [63:0]   _zz_rowMem_port1;
  wire       [9:0]    _zz_when_WaCounter_l12_1;
  wire       [6:0]    _zz_when_WaCounter_l12_1_1;
  wire       [9:0]    _zz_when_WaCounter_l12_2;
  wire       [9:0]    _zz_when_WaCounter_l12_3;
  wire       [6:0]    _zz_when_WaCounter_l12_4;
  wire       [6:0]    _zz_when_WaCounter_l12_4_1;
  wire       [63:0]   _zz_channelMem_port;
  wire                _zz_channelMem_port_1;
  wire       [6:0]    _zz_when_WaCounter_l12_5;
  wire       [6:0]    _zz_when_WaCounter_l12_5_1;
  wire       [16:0]   _zz_when_WaCounter_l12_6;
  wire       [16:0]   _zz_when_WaCounter_l12_6_1;
  wire       [63:0]   _zz_rowMem_port;
  wire       [16:0]   _zz_when_WaCounter_l12_7;
  wire       [16:0]   _zz_when_WaCounter_l12_7_1;
  wire       [6:0]    computeChannelTimes;
  wire                fsm_initEnd;
  wire                fsm_fifoReady;
  wire                fsm_computeEnd;
  wire                fsm_last;
  reg        [4:0]    fsm_currentState;
  reg        [4:0]    fsm_nextState;
  wire                when_WaCounter_l17;
  reg        [2:0]    initCount_count;
  reg                 initCount_valid;
  wire                when_WaCounter_l12;
  wire                sData_fire;
  reg        [9:0]    channelCnt_count;
  reg                 channelCnt_valid;
  wire                when_WaCounter_l12_1;
  wire                sData_fire_1;
  wire                when_WaCounter_l17_1;
  reg        [9:0]    columnCnt_count;
  reg                 columnCnt_valid;
  wire                when_WaCounter_l12_2;
  wire                when_WaCounter_l17_2;
  reg        [9:0]    rowCnt_count;
  reg                 rowCnt_valid;
  wire                when_WaCounter_l12_3;
  wire                sData_fire_2;
  wire                when_WaCounter_l17_3;
  reg        [5:0]    channelMemWriteAddr_count;
  reg                 channelMemWriteAddr_valid;
  wire                when_WaCounter_l12_4;
  wire                sData_fire_3;
  wire                sData_fire_4;
  wire                when_WaCounter_l17_4;
  reg        [5:0]    channelMemReadAddr_count;
  reg                 channelMemReadAddr_valid;
  wire                when_WaCounter_l12_5;
  wire                when_MaxPooling_l44;
  wire       [7:0]    dataTemp_0;
  wire       [7:0]    dataTemp_1;
  wire       [7:0]    dataTemp_2;
  wire       [7:0]    dataTemp_3;
  wire       [7:0]    dataTemp_4;
  wire       [7:0]    dataTemp_5;
  wire       [7:0]    dataTemp_6;
  wire       [7:0]    dataTemp_7;
  reg        [16:0]   depth;
  wire                sData_fire_5;
  reg                 _zz_1;
  reg        [9:0]    rowMemWriteAddr_count;
  reg                 rowMemWriteAddr_valid;
  wire                when_WaCounter_l12_6;
  reg                 _zz_2;
  wire                sData_fire_6;
  reg                 _zz_3;
  reg        [9:0]    rowMemReadAddr_count;
  reg                 rowMemReadAddr_valid;
  wire                when_WaCounter_l12_7;
  wire       [7:0]    dataOut_0;
  wire       [7:0]    dataOut_1;
  wire       [7:0]    dataOut_2;
  wire       [7:0]    dataOut_3;
  wire       [7:0]    dataOut_4;
  wire       [7:0]    dataOut_5;
  wire       [7:0]    dataOut_6;
  wire       [7:0]    dataOut_7;
  wire       [7:0]    pix12_0;
  wire       [7:0]    pix12_1;
  wire       [7:0]    pix12_2;
  wire       [7:0]    pix12_3;
  wire       [7:0]    pix12_4;
  wire       [7:0]    pix12_5;
  wire       [7:0]    pix12_6;
  wire       [7:0]    pix12_7;
  wire       [7:0]    pix11_0;
  wire       [7:0]    pix11_1;
  wire       [7:0]    pix11_2;
  wire       [7:0]    pix11_3;
  wire       [7:0]    pix11_4;
  wire       [7:0]    pix11_5;
  wire       [7:0]    pix11_6;
  wire       [7:0]    pix11_7;
  wire       [7:0]    maxPix2_0;
  wire       [7:0]    maxPix2_1;
  wire       [7:0]    maxPix2_2;
  wire       [7:0]    maxPix2_3;
  wire       [7:0]    maxPix2_4;
  wire       [7:0]    maxPix2_5;
  wire       [7:0]    maxPix2_6;
  wire       [7:0]    maxPix2_7;
  wire       [7:0]    maxPix1_0;
  wire       [7:0]    maxPix1_1;
  wire       [7:0]    maxPix1_2;
  wire       [7:0]    maxPix1_3;
  wire       [7:0]    maxPix1_4;
  wire       [7:0]    maxPix1_5;
  wire       [7:0]    maxPix1_6;
  wire       [7:0]    maxPix1_7;
  wire       [63:0]   _zz_pix11_0;
  wire       [63:0]   _zz_maxPix1_0;
  reg        [7:0]    _zz_dataTemp_0;
  wire                when_MaxPooling_l55;
  reg        [7:0]    _zz_dataOut_0;
  wire                when_MaxPooling_l55_1;
  reg        [7:0]    _zz_dataTemp_1;
  wire                when_MaxPooling_l55_2;
  reg        [7:0]    _zz_dataOut_1;
  wire                when_MaxPooling_l55_3;
  reg        [7:0]    _zz_dataTemp_2;
  wire                when_MaxPooling_l55_4;
  reg        [7:0]    _zz_dataOut_2;
  wire                when_MaxPooling_l55_5;
  reg        [7:0]    _zz_dataTemp_3;
  wire                when_MaxPooling_l55_6;
  reg        [7:0]    _zz_dataOut_3;
  wire                when_MaxPooling_l55_7;
  reg        [7:0]    _zz_dataTemp_4;
  wire                when_MaxPooling_l55_8;
  reg        [7:0]    _zz_dataOut_4;
  wire                when_MaxPooling_l55_9;
  reg        [7:0]    _zz_dataTemp_5;
  wire                when_MaxPooling_l55_10;
  reg        [7:0]    _zz_dataOut_5;
  wire                when_MaxPooling_l55_11;
  reg        [7:0]    _zz_dataTemp_6;
  wire                when_MaxPooling_l55_12;
  reg        [7:0]    _zz_dataOut_6;
  wire                when_MaxPooling_l55_13;
  reg        [7:0]    _zz_dataTemp_7;
  wire                when_MaxPooling_l55_14;
  reg        [7:0]    _zz_dataOut_7;
  wire                when_MaxPooling_l55_15;
  reg                 _zz_mData_valid;
  reg                 _zz_mData_valid_1;
  `ifndef SYNTHESIS
  reg [79:0] fsm_currentState_string;
  reg [79:0] fsm_nextState_string;
  `endif

  (* ram_style = "distributed" *) reg [63:0] channelMem [0:63];
  (* ram_style = "distributed" *) reg [63:0] rowMem [0:1023];

  assign _zz_when_WaCounter_l12_1_1 = (computeChannelTimes - 7'h01);
  assign _zz_when_WaCounter_l12_1 = {3'd0, _zz_when_WaCounter_l12_1_1};
  assign _zz_when_WaCounter_l12_2 = (colNumIn - 10'h001);
  assign _zz_when_WaCounter_l12_3 = (rowNumIn - 10'h001);
  assign _zz_when_WaCounter_l12_4 = {1'd0, channelMemWriteAddr_count};
  assign _zz_when_WaCounter_l12_4_1 = (computeChannelTimes - 7'h01);
  assign _zz_when_WaCounter_l12_5 = {1'd0, channelMemReadAddr_count};
  assign _zz_when_WaCounter_l12_5_1 = (computeChannelTimes - 7'h01);
  assign _zz_when_WaCounter_l12_6 = {7'd0, rowMemWriteAddr_count};
  assign _zz_when_WaCounter_l12_6_1 = (depth - 17'h00001);
  assign _zz_when_WaCounter_l12_7 = {7'd0, rowMemReadAddr_count};
  assign _zz_when_WaCounter_l12_7_1 = (depth - 17'h00001);
  assign _zz_channelMem_port = sData_payload;
  assign _zz_channelMem_port_1 = ((! columnCnt_count[0]) && sData_fire_3);
  assign _zz_rowMem_port = {{{{{{{dataTemp_7,dataTemp_6},dataTemp_5},dataTemp_4},dataTemp_3},dataTemp_2},dataTemp_1},dataTemp_0};
  always @(posedge clk) begin
    if(_zz_channelMem_port_1) begin
      channelMem[channelMemWriteAddr_count] <= _zz_channelMem_port;
    end
  end

  assign _zz_channelMem_port1 = channelMem[channelMemReadAddr_count];
  always @(posedge clk) begin
    if(_zz_2) begin
      rowMem[rowMemWriteAddr_count] <= _zz_rowMem_port;
    end
  end

  assign _zz_rowMem_port1 = rowMem[rowMemReadAddr_count];
  `ifndef SYNTHESIS
  always @(*) begin
    case(fsm_currentState)
      ShapeStateMachineEnum_IDLE : fsm_currentState_string = "IDLE      ";
      ShapeStateMachineEnum_INIT : fsm_currentState_string = "INIT      ";
      ShapeStateMachineEnum_FIFO_READY : fsm_currentState_string = "FIFO_READY";
      ShapeStateMachineEnum_COMPUTE : fsm_currentState_string = "COMPUTE   ";
      ShapeStateMachineEnum_LAST : fsm_currentState_string = "LAST      ";
      default : fsm_currentState_string = "??????????";
    endcase
  end
  always @(*) begin
    case(fsm_nextState)
      ShapeStateMachineEnum_IDLE : fsm_nextState_string = "IDLE      ";
      ShapeStateMachineEnum_INIT : fsm_nextState_string = "INIT      ";
      ShapeStateMachineEnum_FIFO_READY : fsm_nextState_string = "FIFO_READY";
      ShapeStateMachineEnum_COMPUTE : fsm_nextState_string = "COMPUTE   ";
      ShapeStateMachineEnum_LAST : fsm_nextState_string = "LAST      ";
      default : fsm_nextState_string = "??????????";
    endcase
  end
  `endif

  assign computeChannelTimes = (channelIn >>> 3);
  always @(*) begin
    (* parallel_case *)
    case(1) // synthesis parallel_case
      (((fsm_currentState) & ShapeStateMachineEnum_IDLE) == ShapeStateMachineEnum_IDLE) : begin
        if(start) begin
          fsm_nextState = ShapeStateMachineEnum_INIT;
        end else begin
          fsm_nextState = ShapeStateMachineEnum_IDLE;
        end
      end
      (((fsm_currentState) & ShapeStateMachineEnum_INIT) == ShapeStateMachineEnum_INIT) : begin
        if(fsm_initEnd) begin
          fsm_nextState = ShapeStateMachineEnum_FIFO_READY;
        end else begin
          fsm_nextState = ShapeStateMachineEnum_INIT;
        end
      end
      (((fsm_currentState) & ShapeStateMachineEnum_FIFO_READY) == ShapeStateMachineEnum_FIFO_READY) : begin
        if(fsm_fifoReady) begin
          fsm_nextState = ShapeStateMachineEnum_COMPUTE;
        end else begin
          fsm_nextState = ShapeStateMachineEnum_FIFO_READY;
        end
      end
      (((fsm_currentState) & ShapeStateMachineEnum_COMPUTE) == ShapeStateMachineEnum_COMPUTE) : begin
        if(fsm_computeEnd) begin
          fsm_nextState = ShapeStateMachineEnum_LAST;
        end else begin
          fsm_nextState = ShapeStateMachineEnum_COMPUTE;
        end
      end
      default : begin
        if(fsm_last) begin
          fsm_nextState = ShapeStateMachineEnum_IDLE;
        end else begin
          fsm_nextState = ShapeStateMachineEnum_FIFO_READY;
        end
      end
    endcase
  end

  assign fsm_fifoReady = fifoReady;
  assign when_WaCounter_l17 = ((fsm_currentState & ShapeStateMachineEnum_INIT) != 5'b00000);
  assign when_WaCounter_l12 = (initCount_count == 3'b101);
  always @(*) begin
    if(when_WaCounter_l12) begin
      initCount_valid = 1'b1;
    end else begin
      initCount_valid = 1'b0;
    end
  end

  assign fsm_initEnd = initCount_valid;
  assign sData_fire = (sData_valid && sData_ready);
  assign when_WaCounter_l12_1 = (channelCnt_count == _zz_when_WaCounter_l12_1);
  always @(*) begin
    if(when_WaCounter_l12_1) begin
      channelCnt_valid = 1'b1;
    end else begin
      channelCnt_valid = 1'b0;
    end
  end

  assign sData_fire_1 = (sData_valid && sData_ready);
  assign when_WaCounter_l17_1 = (channelCnt_valid && sData_fire_1);
  assign when_WaCounter_l12_2 = (columnCnt_count == _zz_when_WaCounter_l12_2);
  always @(*) begin
    if(when_WaCounter_l12_2) begin
      columnCnt_valid = 1'b1;
    end else begin
      columnCnt_valid = 1'b0;
    end
  end

  assign when_WaCounter_l17_2 = ((fsm_currentState & ShapeStateMachineEnum_LAST) != 5'b00000);
  assign when_WaCounter_l12_3 = (rowCnt_count == _zz_when_WaCounter_l12_3);
  always @(*) begin
    if(when_WaCounter_l12_3) begin
      rowCnt_valid = 1'b1;
    end else begin
      rowCnt_valid = 1'b0;
    end
  end

  assign sData_fire_2 = (sData_valid && sData_ready);
  assign when_WaCounter_l17_3 = ((! columnCnt_count[0]) && sData_fire_2);
  assign when_WaCounter_l12_4 = (_zz_when_WaCounter_l12_4 == _zz_when_WaCounter_l12_4_1);
  always @(*) begin
    if(when_WaCounter_l12_4) begin
      channelMemWriteAddr_valid = 1'b1;
    end else begin
      channelMemWriteAddr_valid = 1'b0;
    end
  end

  assign sData_fire_3 = (sData_valid && sData_ready);
  assign sData_fire_4 = (sData_valid && sData_ready);
  assign when_WaCounter_l17_4 = (columnCnt_count[0] && sData_fire_4);
  assign when_WaCounter_l12_5 = (_zz_when_WaCounter_l12_5 == _zz_when_WaCounter_l12_5_1);
  always @(*) begin
    if(when_WaCounter_l12_5) begin
      channelMemReadAddr_valid = 1'b1;
    end else begin
      channelMemReadAddr_valid = 1'b0;
    end
  end

  assign when_MaxPooling_l44 = ((fsm_currentState & ShapeStateMachineEnum_COMPUTE) != 5'b00000);
  always @(*) begin
    if(when_MaxPooling_l44) begin
      sData_ready = 1'b1;
    end else begin
      sData_ready = 1'b0;
    end
  end

  assign fsm_computeEnd = (columnCnt_valid && channelCnt_valid);
  assign fsm_last = rowCnt_valid;
  assign sData_fire_5 = (sData_valid && sData_ready);
  assign when_WaCounter_l12_6 = (_zz_when_WaCounter_l12_6 == _zz_when_WaCounter_l12_6_1);
  always @(*) begin
    if(when_WaCounter_l12_6) begin
      rowMemWriteAddr_valid = 1'b1;
    end else begin
      rowMemWriteAddr_valid = 1'b0;
    end
  end

  assign sData_fire_6 = (sData_valid && sData_ready);
  assign when_WaCounter_l12_7 = (_zz_when_WaCounter_l12_7 == _zz_when_WaCounter_l12_7_1);
  always @(*) begin
    if(when_WaCounter_l12_7) begin
      rowMemReadAddr_valid = 1'b1;
    end else begin
      rowMemReadAddr_valid = 1'b0;
    end
  end

  assign pix12_0 = sData_payload[7 : 0];
  assign pix12_1 = sData_payload[15 : 8];
  assign pix12_2 = sData_payload[23 : 16];
  assign pix12_3 = sData_payload[31 : 24];
  assign pix12_4 = sData_payload[39 : 32];
  assign pix12_5 = sData_payload[47 : 40];
  assign pix12_6 = sData_payload[55 : 48];
  assign pix12_7 = sData_payload[63 : 56];
  assign _zz_pix11_0 = _zz_channelMem_port1;
  assign pix11_0 = _zz_pix11_0[7 : 0];
  assign pix11_1 = _zz_pix11_0[15 : 8];
  assign pix11_2 = _zz_pix11_0[23 : 16];
  assign pix11_3 = _zz_pix11_0[31 : 24];
  assign pix11_4 = _zz_pix11_0[39 : 32];
  assign pix11_5 = _zz_pix11_0[47 : 40];
  assign pix11_6 = _zz_pix11_0[55 : 48];
  assign pix11_7 = _zz_pix11_0[63 : 56];
  assign maxPix2_0 = dataTemp_0;
  assign maxPix2_1 = dataTemp_1;
  assign maxPix2_2 = dataTemp_2;
  assign maxPix2_3 = dataTemp_3;
  assign maxPix2_4 = dataTemp_4;
  assign maxPix2_5 = dataTemp_5;
  assign maxPix2_6 = dataTemp_6;
  assign maxPix2_7 = dataTemp_7;
  assign _zz_maxPix1_0 = _zz_rowMem_port1;
  assign maxPix1_0 = _zz_maxPix1_0[7 : 0];
  assign maxPix1_1 = _zz_maxPix1_0[15 : 8];
  assign maxPix1_2 = _zz_maxPix1_0[23 : 16];
  assign maxPix1_3 = _zz_maxPix1_0[31 : 24];
  assign maxPix1_4 = _zz_maxPix1_0[39 : 32];
  assign maxPix1_5 = _zz_maxPix1_0[47 : 40];
  assign maxPix1_6 = _zz_maxPix1_0[55 : 48];
  assign maxPix1_7 = _zz_maxPix1_0[63 : 56];
  assign when_MaxPooling_l55 = (pix11_0 < pix12_0);
  assign dataTemp_0 = _zz_dataTemp_0;
  assign when_MaxPooling_l55_1 = (maxPix1_0 < maxPix2_0);
  assign dataOut_0 = _zz_dataOut_0;
  assign when_MaxPooling_l55_2 = (pix11_1 < pix12_1);
  assign dataTemp_1 = _zz_dataTemp_1;
  assign when_MaxPooling_l55_3 = (maxPix1_1 < maxPix2_1);
  assign dataOut_1 = _zz_dataOut_1;
  assign when_MaxPooling_l55_4 = (pix11_2 < pix12_2);
  assign dataTemp_2 = _zz_dataTemp_2;
  assign when_MaxPooling_l55_5 = (maxPix1_2 < maxPix2_2);
  assign dataOut_2 = _zz_dataOut_2;
  assign when_MaxPooling_l55_6 = (pix11_3 < pix12_3);
  assign dataTemp_3 = _zz_dataTemp_3;
  assign when_MaxPooling_l55_7 = (maxPix1_3 < maxPix2_3);
  assign dataOut_3 = _zz_dataOut_3;
  assign when_MaxPooling_l55_8 = (pix11_4 < pix12_4);
  assign dataTemp_4 = _zz_dataTemp_4;
  assign when_MaxPooling_l55_9 = (maxPix1_4 < maxPix2_4);
  assign dataOut_4 = _zz_dataOut_4;
  assign when_MaxPooling_l55_10 = (pix11_5 < pix12_5);
  assign dataTemp_5 = _zz_dataTemp_5;
  assign when_MaxPooling_l55_11 = (maxPix1_5 < maxPix2_5);
  assign dataOut_5 = _zz_dataOut_5;
  assign when_MaxPooling_l55_12 = (pix11_6 < pix12_6);
  assign dataTemp_6 = _zz_dataTemp_6;
  assign when_MaxPooling_l55_13 = (maxPix1_6 < maxPix2_6);
  assign dataOut_6 = _zz_dataOut_6;
  assign when_MaxPooling_l55_14 = (pix11_7 < pix12_7);
  assign dataTemp_7 = _zz_dataTemp_7;
  assign when_MaxPooling_l55_15 = (maxPix1_7 < maxPix2_7);
  assign dataOut_7 = _zz_dataOut_7;
  always @(*) begin
    mData_payload[7 : 0] = dataOut_0;
    mData_payload[15 : 8] = dataOut_1;
    mData_payload[23 : 16] = dataOut_2;
    mData_payload[31 : 24] = dataOut_3;
    mData_payload[39 : 32] = dataOut_4;
    mData_payload[47 : 40] = dataOut_5;
    mData_payload[55 : 48] = dataOut_6;
    mData_payload[63 : 56] = dataOut_7;
  end

  assign mData_valid = _zz_mData_valid_1;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      fsm_currentState <= ShapeStateMachineEnum_IDLE;
      initCount_count <= 3'b000;
      channelCnt_count <= 10'h0;
      columnCnt_count <= 10'h0;
      rowCnt_count <= 10'h0;
      channelMemWriteAddr_count <= 6'h0;
      channelMemReadAddr_count <= 6'h0;
      rowMemWriteAddr_count <= 10'h0;
      rowMemReadAddr_count <= 10'h0;
    end else begin
      fsm_currentState <= fsm_nextState;
      if(when_WaCounter_l17) begin
        initCount_count <= (initCount_count + 3'b001);
        if(initCount_valid) begin
          initCount_count <= 3'b000;
        end
      end
      if(sData_fire) begin
        channelCnt_count <= (channelCnt_count + 10'h001);
        if(channelCnt_valid) begin
          channelCnt_count <= 10'h0;
        end
      end
      if(when_WaCounter_l17_1) begin
        columnCnt_count <= (columnCnt_count + 10'h001);
        if(columnCnt_valid) begin
          columnCnt_count <= 10'h0;
        end
      end
      if(when_WaCounter_l17_2) begin
        rowCnt_count <= (rowCnt_count + 10'h001);
        if(rowCnt_valid) begin
          rowCnt_count <= 10'h0;
        end
      end
      if(when_WaCounter_l17_3) begin
        channelMemWriteAddr_count <= (channelMemWriteAddr_count + 6'h01);
        if(channelMemWriteAddr_valid) begin
          channelMemWriteAddr_count <= 6'h0;
        end
      end
      if(when_WaCounter_l17_4) begin
        channelMemReadAddr_count <= (channelMemReadAddr_count + 6'h01);
        if(channelMemReadAddr_valid) begin
          channelMemReadAddr_count <= 6'h0;
        end
      end
      if(_zz_1) begin
        rowMemWriteAddr_count <= (rowMemWriteAddr_count + 10'h001);
        if(rowMemWriteAddr_valid) begin
          rowMemWriteAddr_count <= 10'h0;
        end
      end
      if(_zz_3) begin
        rowMemReadAddr_count <= (rowMemReadAddr_count + 10'h001);
        if(rowMemReadAddr_valid) begin
          rowMemReadAddr_count <= 10'h0;
        end
      end
    end
  end

  always @(posedge clk) begin
    depth <= (colNumIn * computeChannelTimes);
    _zz_1 <= ((columnCnt_count[0] && (! rowCnt_count[0])) && sData_fire_5);
    _zz_2 <= (columnCnt_count[0] && (! rowCnt_count[0]));
    _zz_3 <= ((columnCnt_count[0] && rowCnt_count[0]) && sData_fire_6);
    if(when_MaxPooling_l55) begin
      _zz_dataTemp_0 <= pix12_0;
    end else begin
      _zz_dataTemp_0 <= pix11_0;
    end
    if(when_MaxPooling_l55_1) begin
      _zz_dataOut_0 <= maxPix2_0;
    end else begin
      _zz_dataOut_0 <= maxPix1_0;
    end
    if(when_MaxPooling_l55_2) begin
      _zz_dataTemp_1 <= pix12_1;
    end else begin
      _zz_dataTemp_1 <= pix11_1;
    end
    if(when_MaxPooling_l55_3) begin
      _zz_dataOut_1 <= maxPix2_1;
    end else begin
      _zz_dataOut_1 <= maxPix1_1;
    end
    if(when_MaxPooling_l55_4) begin
      _zz_dataTemp_2 <= pix12_2;
    end else begin
      _zz_dataTemp_2 <= pix11_2;
    end
    if(when_MaxPooling_l55_5) begin
      _zz_dataOut_2 <= maxPix2_2;
    end else begin
      _zz_dataOut_2 <= maxPix1_2;
    end
    if(when_MaxPooling_l55_6) begin
      _zz_dataTemp_3 <= pix12_3;
    end else begin
      _zz_dataTemp_3 <= pix11_3;
    end
    if(when_MaxPooling_l55_7) begin
      _zz_dataOut_3 <= maxPix2_3;
    end else begin
      _zz_dataOut_3 <= maxPix1_3;
    end
    if(when_MaxPooling_l55_8) begin
      _zz_dataTemp_4 <= pix12_4;
    end else begin
      _zz_dataTemp_4 <= pix11_4;
    end
    if(when_MaxPooling_l55_9) begin
      _zz_dataOut_4 <= maxPix2_4;
    end else begin
      _zz_dataOut_4 <= maxPix1_4;
    end
    if(when_MaxPooling_l55_10) begin
      _zz_dataTemp_5 <= pix12_5;
    end else begin
      _zz_dataTemp_5 <= pix11_5;
    end
    if(when_MaxPooling_l55_11) begin
      _zz_dataOut_5 <= maxPix2_5;
    end else begin
      _zz_dataOut_5 <= maxPix1_5;
    end
    if(when_MaxPooling_l55_12) begin
      _zz_dataTemp_6 <= pix12_6;
    end else begin
      _zz_dataTemp_6 <= pix11_6;
    end
    if(when_MaxPooling_l55_13) begin
      _zz_dataOut_6 <= maxPix2_6;
    end else begin
      _zz_dataOut_6 <= maxPix1_6;
    end
    if(when_MaxPooling_l55_14) begin
      _zz_dataTemp_7 <= pix12_7;
    end else begin
      _zz_dataTemp_7 <= pix11_7;
    end
    if(when_MaxPooling_l55_15) begin
      _zz_dataOut_7 <= maxPix2_7;
    end else begin
      _zz_dataOut_7 <= maxPix1_7;
    end
    _zz_mData_valid <= (rowCnt_count[0] && columnCnt_count[0]);
    _zz_mData_valid_1 <= _zz_mData_valid;
  end


endmodule

module Concat (
  input               dataPort_start,
  input               dataPort_fifoReady,
  input               dataPort_sData_valid,
  output reg          dataPort_sData_ready,
  input      [63:0]   dataPort_sData_payload,
  output              dataPort_mData_valid,
  input               dataPort_mData_ready,
  output reg [63:0]   dataPort_mData_payload,
  input      [9:0]    dataPort_rowNumIn,
  input      [9:0]    dataPort_colNumIn,
  input      [9:0]    dataPort_channelIn,
  input      [31:0]   zero_1,
  input      [31:0]   zero1,
  input      [31:0]   scale_1,
  input      [31:0]   scale1,
  input               sData1_valid,
  output reg          sData1_ready,
  input      [63:0]   sData1_payload,
  input      [9:0]    channelIn1,
  input               clk,
  input               reset
);
  localparam ShapeStateMachineEnum_IDLE = 5'd1;
  localparam ShapeStateMachineEnum_INIT = 5'd2;
  localparam ShapeStateMachineEnum_FIFO_READY = 5'd4;
  localparam ShapeStateMachineEnum_COMPUTE = 5'd8;
  localparam ShapeStateMachineEnum_LAST = 5'd16;

  reg        [63:0]   concatZero_1_dataIn;
  reg        [31:0]   concatZero_1_zero_1;
  wire       [31:0]   concatZero_1_dataOut_0;
  wire       [31:0]   concatZero_1_dataOut_1;
  wire       [31:0]   concatZero_1_dataOut_2;
  wire       [31:0]   concatZero_1_dataOut_3;
  wire       [31:0]   concatZero_1_dataOut_4;
  wire       [31:0]   concatZero_1_dataOut_5;
  wire       [31:0]   concatZero_1_dataOut_6;
  wire       [31:0]   concatZero_1_dataOut_7;
  wire       [7:0]    concatScale_1_dataOut_0;
  wire       [7:0]    concatScale_1_dataOut_1;
  wire       [7:0]    concatScale_1_dataOut_2;
  wire       [7:0]    concatScale_1_dataOut_3;
  wire       [7:0]    concatScale_1_dataOut_4;
  wire       [7:0]    concatScale_1_dataOut_5;
  wire       [7:0]    concatScale_1_dataOut_6;
  wire       [7:0]    concatScale_1_dataOut_7;
  wire       [6:0]    _zz_when_WaCounter_l12;
  wire       [9:0]    _zz_when_WaCounter_l12_1;
  wire       [9:0]    _zz_when_WaCounter_l12_2;
  wire                fsm_initEnd;
  wire                fsm_fifoReady;
  wire                fsm_computeEnd;
  wire                fsm_last;
  reg        [4:0]    fsm_currentState;
  reg        [4:0]    fsm_nextState;
  wire       [6:0]    channelTimes0;
  wire       [6:0]    channelTimes1;
  reg        [6:0]    channelTimes;
  wire                dataPort_sData_fire;
  wire                when_WaCounter_l17;
  reg        [6:0]    channelCnt_count;
  reg                 channelCnt_valid;
  wire                when_WaCounter_l12;
  reg        [9:0]    columnCnt_count;
  reg                 columnCnt_valid;
  wire                when_WaCounter_l12_1;
  wire                when_WaCounter_l17_1;
  reg        [9:0]    rowCnt_count;
  reg                 rowCnt_valid;
  wire                when_WaCounter_l12_2;
  wire                when_WaCounter_l17_2;
  reg        [2:0]    initCount_count;
  reg                 initCount_valid;
  wire                when_WaCounter_l12_3;
  wire                when_Concat_l43;
  wire                when_Concat_l44;
  reg        [31:0]   scaleTemp;
  wire                dataPort_sData_fire_1;
  wire                sData1_fire;
  reg        [31:0]   scaleTemp_delay_1;
  reg        [31:0]   scaleTemp_delay_2;
  wire                dataPort_sData_fire_2;
  wire                sData1_fire_1;
  reg                 _zz_dataPort_mData_valid;
  reg                 _zz_dataPort_mData_valid_1;
  reg                 _zz_dataPort_mData_valid_2;
  reg                 _zz_dataPort_mData_valid_3;
  reg                 _zz_dataPort_mData_valid_4;
  reg                 _zz_dataPort_mData_valid_5;
  reg                 _zz_dataPort_mData_valid_6;
  `ifndef SYNTHESIS
  reg [79:0] fsm_currentState_string;
  reg [79:0] fsm_nextState_string;
  `endif


  assign _zz_when_WaCounter_l12 = (channelTimes - 7'h01);
  assign _zz_when_WaCounter_l12_1 = (dataPort_colNumIn - 10'h001);
  assign _zz_when_WaCounter_l12_2 = (dataPort_rowNumIn - 10'h001);
  ConcatZero concatZero_1 (
    .dataIn    (concatZero_1_dataIn[63:0]   ), //i
    .zero_1    (concatZero_1_zero_1[31:0]   ), //i
    .dataOut_0 (concatZero_1_dataOut_0[31:0]), //o
    .dataOut_1 (concatZero_1_dataOut_1[31:0]), //o
    .dataOut_2 (concatZero_1_dataOut_2[31:0]), //o
    .dataOut_3 (concatZero_1_dataOut_3[31:0]), //o
    .dataOut_4 (concatZero_1_dataOut_4[31:0]), //o
    .dataOut_5 (concatZero_1_dataOut_5[31:0]), //o
    .dataOut_6 (concatZero_1_dataOut_6[31:0]), //o
    .dataOut_7 (concatZero_1_dataOut_7[31:0]), //o
    .clk       (clk                         )  //i
  );
  ConcatScale concatScale_1 (
    .dataIn_0  (concatZero_1_dataOut_0[31:0]), //i
    .dataIn_1  (concatZero_1_dataOut_1[31:0]), //i
    .dataIn_2  (concatZero_1_dataOut_2[31:0]), //i
    .dataIn_3  (concatZero_1_dataOut_3[31:0]), //i
    .dataIn_4  (concatZero_1_dataOut_4[31:0]), //i
    .dataIn_5  (concatZero_1_dataOut_5[31:0]), //i
    .dataIn_6  (concatZero_1_dataOut_6[31:0]), //i
    .dataIn_7  (concatZero_1_dataOut_7[31:0]), //i
    .scale_1   (scaleTemp_delay_2[31:0]     ), //i
    .dataOut_0 (concatScale_1_dataOut_0[7:0]), //o
    .dataOut_1 (concatScale_1_dataOut_1[7:0]), //o
    .dataOut_2 (concatScale_1_dataOut_2[7:0]), //o
    .dataOut_3 (concatScale_1_dataOut_3[7:0]), //o
    .dataOut_4 (concatScale_1_dataOut_4[7:0]), //o
    .dataOut_5 (concatScale_1_dataOut_5[7:0]), //o
    .dataOut_6 (concatScale_1_dataOut_6[7:0]), //o
    .dataOut_7 (concatScale_1_dataOut_7[7:0]), //o
    .clk       (clk                         ), //i
    .reset     (reset                       )  //i
  );
  `ifndef SYNTHESIS
  always @(*) begin
    case(fsm_currentState)
      ShapeStateMachineEnum_IDLE : fsm_currentState_string = "IDLE      ";
      ShapeStateMachineEnum_INIT : fsm_currentState_string = "INIT      ";
      ShapeStateMachineEnum_FIFO_READY : fsm_currentState_string = "FIFO_READY";
      ShapeStateMachineEnum_COMPUTE : fsm_currentState_string = "COMPUTE   ";
      ShapeStateMachineEnum_LAST : fsm_currentState_string = "LAST      ";
      default : fsm_currentState_string = "??????????";
    endcase
  end
  always @(*) begin
    case(fsm_nextState)
      ShapeStateMachineEnum_IDLE : fsm_nextState_string = "IDLE      ";
      ShapeStateMachineEnum_INIT : fsm_nextState_string = "INIT      ";
      ShapeStateMachineEnum_FIFO_READY : fsm_nextState_string = "FIFO_READY";
      ShapeStateMachineEnum_COMPUTE : fsm_nextState_string = "COMPUTE   ";
      ShapeStateMachineEnum_LAST : fsm_nextState_string = "LAST      ";
      default : fsm_nextState_string = "??????????";
    endcase
  end
  `endif

  always @(*) begin
    (* parallel_case *)
    case(1) // synthesis parallel_case
      (((fsm_currentState) & ShapeStateMachineEnum_IDLE) == ShapeStateMachineEnum_IDLE) : begin
        if(dataPort_start) begin
          fsm_nextState = ShapeStateMachineEnum_INIT;
        end else begin
          fsm_nextState = ShapeStateMachineEnum_IDLE;
        end
      end
      (((fsm_currentState) & ShapeStateMachineEnum_INIT) == ShapeStateMachineEnum_INIT) : begin
        if(fsm_initEnd) begin
          fsm_nextState = ShapeStateMachineEnum_FIFO_READY;
        end else begin
          fsm_nextState = ShapeStateMachineEnum_INIT;
        end
      end
      (((fsm_currentState) & ShapeStateMachineEnum_FIFO_READY) == ShapeStateMachineEnum_FIFO_READY) : begin
        if(fsm_fifoReady) begin
          fsm_nextState = ShapeStateMachineEnum_COMPUTE;
        end else begin
          fsm_nextState = ShapeStateMachineEnum_FIFO_READY;
        end
      end
      (((fsm_currentState) & ShapeStateMachineEnum_COMPUTE) == ShapeStateMachineEnum_COMPUTE) : begin
        if(fsm_computeEnd) begin
          fsm_nextState = ShapeStateMachineEnum_LAST;
        end else begin
          fsm_nextState = ShapeStateMachineEnum_COMPUTE;
        end
      end
      default : begin
        if(fsm_last) begin
          fsm_nextState = ShapeStateMachineEnum_IDLE;
        end else begin
          fsm_nextState = ShapeStateMachineEnum_FIFO_READY;
        end
      end
    endcase
  end

  assign channelTimes0 = (dataPort_channelIn >>> 3);
  assign channelTimes1 = (channelIn1 >>> 3);
  assign dataPort_sData_fire = (dataPort_sData_valid && dataPort_sData_ready);
  assign when_WaCounter_l17 = (dataPort_sData_fire && ((fsm_currentState & ShapeStateMachineEnum_COMPUTE) != 5'b00000));
  assign when_WaCounter_l12 = (channelCnt_count == _zz_when_WaCounter_l12);
  always @(*) begin
    if(when_WaCounter_l12) begin
      channelCnt_valid = 1'b1;
    end else begin
      channelCnt_valid = 1'b0;
    end
  end

  assign when_WaCounter_l12_1 = (columnCnt_count == _zz_when_WaCounter_l12_1);
  always @(*) begin
    if(when_WaCounter_l12_1) begin
      columnCnt_valid = 1'b1;
    end else begin
      columnCnt_valid = 1'b0;
    end
  end

  assign when_WaCounter_l17_1 = ((fsm_currentState & ShapeStateMachineEnum_LAST) != 5'b00000);
  assign when_WaCounter_l12_2 = (rowCnt_count == _zz_when_WaCounter_l12_2);
  always @(*) begin
    if(when_WaCounter_l12_2) begin
      rowCnt_valid = 1'b1;
    end else begin
      rowCnt_valid = 1'b0;
    end
  end

  assign when_WaCounter_l17_2 = ((fsm_currentState & ShapeStateMachineEnum_INIT) != 5'b00000);
  assign when_WaCounter_l12_3 = (initCount_count == 3'b101);
  always @(*) begin
    if(when_WaCounter_l12_3) begin
      initCount_valid = 1'b1;
    end else begin
      initCount_valid = 1'b0;
    end
  end

  assign fsm_initEnd = initCount_valid;
  assign fsm_fifoReady = dataPort_fifoReady;
  assign fsm_computeEnd = (channelCnt_valid && columnCnt_valid);
  assign fsm_last = rowCnt_valid;
  assign when_Concat_l43 = (((fsm_currentState & ShapeStateMachineEnum_COMPUTE) != 5'b00000) && dataPort_mData_ready);
  assign when_Concat_l44 = (channelCnt_count < channelTimes0);
  always @(*) begin
    if(when_Concat_l43) begin
      if(when_Concat_l44) begin
        dataPort_sData_ready = 1'b1;
      end else begin
        dataPort_sData_ready = 1'b0;
      end
    end else begin
      dataPort_sData_ready = 1'b0;
    end
  end

  always @(*) begin
    if(when_Concat_l43) begin
      if(when_Concat_l44) begin
        sData1_ready = 1'b0;
      end else begin
        sData1_ready = 1'b1;
      end
    end else begin
      sData1_ready = 1'b0;
    end
  end

  assign dataPort_sData_fire_1 = (dataPort_sData_valid && dataPort_sData_ready);
  always @(*) begin
    if(dataPort_sData_fire_1) begin
      concatZero_1_dataIn = dataPort_sData_payload;
    end else begin
      if(sData1_fire) begin
        concatZero_1_dataIn = sData1_payload;
      end else begin
        concatZero_1_dataIn = 64'h0;
      end
    end
  end

  always @(*) begin
    if(dataPort_sData_fire_1) begin
      concatZero_1_zero_1 = zero_1;
    end else begin
      if(sData1_fire) begin
        concatZero_1_zero_1 = zero1;
      end else begin
        concatZero_1_zero_1 = 32'h0;
      end
    end
  end

  always @(*) begin
    if(dataPort_sData_fire_1) begin
      scaleTemp = scale_1;
    end else begin
      if(sData1_fire) begin
        scaleTemp = scale1;
      end else begin
        scaleTemp = 32'h0;
      end
    end
  end

  assign sData1_fire = (sData1_valid && sData1_ready);
  always @(*) begin
    dataPort_mData_payload[7 : 0] = concatScale_1_dataOut_0;
    dataPort_mData_payload[15 : 8] = concatScale_1_dataOut_1;
    dataPort_mData_payload[23 : 16] = concatScale_1_dataOut_2;
    dataPort_mData_payload[31 : 24] = concatScale_1_dataOut_3;
    dataPort_mData_payload[39 : 32] = concatScale_1_dataOut_4;
    dataPort_mData_payload[47 : 40] = concatScale_1_dataOut_5;
    dataPort_mData_payload[55 : 48] = concatScale_1_dataOut_6;
    dataPort_mData_payload[63 : 56] = concatScale_1_dataOut_7;
  end

  assign dataPort_sData_fire_2 = (dataPort_sData_valid && dataPort_sData_ready);
  assign sData1_fire_1 = (sData1_valid && sData1_ready);
  assign dataPort_mData_valid = _zz_dataPort_mData_valid_6;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      fsm_currentState <= ShapeStateMachineEnum_IDLE;
      channelCnt_count <= 7'h0;
      columnCnt_count <= 10'h0;
      rowCnt_count <= 10'h0;
      initCount_count <= 3'b000;
    end else begin
      fsm_currentState <= fsm_nextState;
      if(when_WaCounter_l17) begin
        channelCnt_count <= (channelCnt_count + 7'h01);
        if(channelCnt_valid) begin
          channelCnt_count <= 7'h0;
        end
      end
      if(channelCnt_valid) begin
        columnCnt_count <= (columnCnt_count + 10'h001);
        if(columnCnt_valid) begin
          columnCnt_count <= 10'h0;
        end
      end
      if(when_WaCounter_l17_1) begin
        rowCnt_count <= (rowCnt_count + 10'h001);
        if(rowCnt_valid) begin
          rowCnt_count <= 10'h0;
        end
      end
      if(when_WaCounter_l17_2) begin
        initCount_count <= (initCount_count + 3'b001);
        if(initCount_valid) begin
          initCount_count <= 3'b000;
        end
      end
    end
  end

  always @(posedge clk) begin
    channelTimes <= (channelTimes0 + channelTimes1);
    scaleTemp_delay_1 <= scaleTemp;
    scaleTemp_delay_2 <= scaleTemp_delay_1;
    _zz_dataPort_mData_valid <= (dataPort_sData_fire_2 || sData1_fire_1);
    _zz_dataPort_mData_valid_1 <= _zz_dataPort_mData_valid;
    _zz_dataPort_mData_valid_2 <= _zz_dataPort_mData_valid_1;
    _zz_dataPort_mData_valid_3 <= _zz_dataPort_mData_valid_2;
    _zz_dataPort_mData_valid_4 <= _zz_dataPort_mData_valid_3;
    _zz_dataPort_mData_valid_5 <= _zz_dataPort_mData_valid_4;
    _zz_dataPort_mData_valid_6 <= _zz_dataPort_mData_valid_5;
  end


endmodule

module ShapeState (
  input      [3:0]    control,
  input               complete,
  output reg [3:0]    state,
  output reg          start_0,
  output reg          start_1,
  output reg          start_2,
  output reg          start_3,
  output reg          dmaReadValid_0,
  output reg          dmaReadValid_1,
  output reg          dmaWriteValid,
  input               clk,
  input               reset
);
  localparam ShapeStateEnum_IDLE = 6'd1;
  localparam ShapeStateEnum_MAX_POOLING = 6'd2;
  localparam ShapeStateEnum_SPLIT = 6'd4;
  localparam ShapeStateEnum_UP_SAMPLING = 6'd8;
  localparam ShapeStateEnum_CONCAT = 6'd16;
  localparam ShapeStateEnum_IRQ = 6'd32;

  reg        [5:0]    fsm_currentState;
  reg        [5:0]    fsm_nextState;
  wire                when_ShapeState_l89;
  wire                when_ShapeState_l137;
  wire                when_ShapeState_l137_1;
  wire                when_ShapeState_l137_2;
  wire                when_ShapeState_l137_3;
  `ifndef SYNTHESIS
  reg [87:0] fsm_currentState_string;
  reg [87:0] fsm_nextState_string;
  `endif


  `ifndef SYNTHESIS
  always @(*) begin
    case(fsm_currentState)
      ShapeStateEnum_IDLE : fsm_currentState_string = "IDLE       ";
      ShapeStateEnum_MAX_POOLING : fsm_currentState_string = "MAX_POOLING";
      ShapeStateEnum_SPLIT : fsm_currentState_string = "SPLIT      ";
      ShapeStateEnum_UP_SAMPLING : fsm_currentState_string = "UP_SAMPLING";
      ShapeStateEnum_CONCAT : fsm_currentState_string = "CONCAT     ";
      ShapeStateEnum_IRQ : fsm_currentState_string = "IRQ        ";
      default : fsm_currentState_string = "???????????";
    endcase
  end
  always @(*) begin
    case(fsm_nextState)
      ShapeStateEnum_IDLE : fsm_nextState_string = "IDLE       ";
      ShapeStateEnum_MAX_POOLING : fsm_nextState_string = "MAX_POOLING";
      ShapeStateEnum_SPLIT : fsm_nextState_string = "SPLIT      ";
      ShapeStateEnum_UP_SAMPLING : fsm_nextState_string = "UP_SAMPLING";
      ShapeStateEnum_CONCAT : fsm_nextState_string = "CONCAT     ";
      ShapeStateEnum_IRQ : fsm_nextState_string = "IRQ        ";
      default : fsm_nextState_string = "???????????";
    endcase
  end
  `endif

  always @(*) begin
    (* parallel_case *)
    case(1) // synthesis parallel_case
      (((fsm_currentState) & ShapeStateEnum_IDLE) == ShapeStateEnum_IDLE) : begin
        case(control)
          4'b0001 : begin
            fsm_nextState = ShapeStateEnum_MAX_POOLING;
          end
          4'b0010 : begin
            fsm_nextState = ShapeStateEnum_SPLIT;
          end
          4'b0011 : begin
            fsm_nextState = ShapeStateEnum_UP_SAMPLING;
          end
          4'b0100 : begin
            fsm_nextState = ShapeStateEnum_CONCAT;
          end
          default : begin
            fsm_nextState = ShapeStateEnum_IDLE;
          end
        endcase
      end
      (((fsm_currentState) & ShapeStateEnum_MAX_POOLING) == ShapeStateEnum_MAX_POOLING) : begin
        if(complete) begin
          fsm_nextState = ShapeStateEnum_IRQ;
        end else begin
          fsm_nextState = ShapeStateEnum_MAX_POOLING;
        end
      end
      (((fsm_currentState) & ShapeStateEnum_SPLIT) == ShapeStateEnum_SPLIT) : begin
        if(complete) begin
          fsm_nextState = ShapeStateEnum_IRQ;
        end else begin
          fsm_nextState = ShapeStateEnum_SPLIT;
        end
      end
      (((fsm_currentState) & ShapeStateEnum_UP_SAMPLING) == ShapeStateEnum_UP_SAMPLING) : begin
        if(complete) begin
          fsm_nextState = ShapeStateEnum_IRQ;
        end else begin
          fsm_nextState = ShapeStateEnum_UP_SAMPLING;
        end
      end
      (((fsm_currentState) & ShapeStateEnum_CONCAT) == ShapeStateEnum_CONCAT) : begin
        if(complete) begin
          fsm_nextState = ShapeStateEnum_IRQ;
        end else begin
          fsm_nextState = ShapeStateEnum_CONCAT;
        end
      end
      default : begin
        if(when_ShapeState_l89) begin
          fsm_nextState = ShapeStateEnum_IDLE;
        end else begin
          fsm_nextState = ShapeStateEnum_IRQ;
        end
      end
    endcase
  end

  assign when_ShapeState_l89 = (control == 4'b1111);
  assign when_ShapeState_l137 = (((fsm_currentState & ShapeStateEnum_IDLE) != 6'b000000) && ((fsm_nextState & ShapeStateEnum_MAX_POOLING) != 6'b000000));
  always @(*) begin
    if(when_ShapeState_l137) begin
      dmaReadValid_0 = 1'b1;
    end else begin
      dmaReadValid_0 = 1'b0;
    end
    if(when_ShapeState_l137_1) begin
      dmaReadValid_0 = 1'b1;
    end else begin
      dmaReadValid_0 = 1'b0;
    end
    if(when_ShapeState_l137_2) begin
      dmaReadValid_0 = 1'b1;
    end else begin
      dmaReadValid_0 = 1'b0;
    end
    if(when_ShapeState_l137_3) begin
      dmaReadValid_0 = 1'b1;
    end else begin
      dmaReadValid_0 = 1'b0;
    end
  end

  always @(*) begin
    if(when_ShapeState_l137) begin
      dmaReadValid_1 = 1'b0;
    end else begin
      dmaReadValid_1 = 1'b0;
    end
    if(when_ShapeState_l137_1) begin
      dmaReadValid_1 = 1'b0;
    end else begin
      dmaReadValid_1 = 1'b0;
    end
    if(when_ShapeState_l137_2) begin
      dmaReadValid_1 = 1'b0;
    end else begin
      dmaReadValid_1 = 1'b0;
    end
    if(when_ShapeState_l137_3) begin
      dmaReadValid_1 = 1'b1;
    end else begin
      dmaReadValid_1 = 1'b0;
    end
  end

  always @(*) begin
    if(when_ShapeState_l137) begin
      dmaWriteValid = 1'b1;
    end else begin
      dmaWriteValid = 1'b0;
    end
    if(when_ShapeState_l137_1) begin
      dmaWriteValid = 1'b1;
    end else begin
      dmaWriteValid = 1'b0;
    end
    if(when_ShapeState_l137_2) begin
      dmaWriteValid = 1'b1;
    end else begin
      dmaWriteValid = 1'b0;
    end
    if(when_ShapeState_l137_3) begin
      dmaWriteValid = 1'b1;
    end else begin
      dmaWriteValid = 1'b0;
    end
  end

  assign when_ShapeState_l137_1 = (((fsm_currentState & ShapeStateEnum_IDLE) != 6'b000000) && ((fsm_nextState & ShapeStateEnum_UP_SAMPLING) != 6'b000000));
  assign when_ShapeState_l137_2 = (((fsm_currentState & ShapeStateEnum_IDLE) != 6'b000000) && ((fsm_nextState & ShapeStateEnum_SPLIT) != 6'b000000));
  assign when_ShapeState_l137_3 = (((fsm_currentState & ShapeStateEnum_IDLE) != 6'b000000) && ((fsm_nextState & ShapeStateEnum_CONCAT) != 6'b000000));
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      start_0 <= 1'b0;
      start_1 <= 1'b0;
      start_2 <= 1'b0;
      start_3 <= 1'b0;
      fsm_currentState <= ShapeStateEnum_IDLE;
    end else begin
      fsm_currentState <= fsm_nextState;
      if(when_ShapeState_l137) begin
        start_0 <= 1'b1;
      end else begin
        start_0 <= 1'b0;
      end
      if(when_ShapeState_l137_1) begin
        start_2 <= 1'b1;
      end else begin
        start_2 <= 1'b0;
      end
      if(when_ShapeState_l137_2) begin
        start_1 <= 1'b1;
      end else begin
        start_1 <= 1'b0;
      end
      if(when_ShapeState_l137_3) begin
        start_3 <= 1'b1;
      end else begin
        start_3 <= 1'b0;
      end
    end
  end

  always @(posedge clk) begin
    (* parallel_case *)
    case(1) // synthesis parallel_case
      (((fsm_currentState) & ShapeStateEnum_CONCAT) == ShapeStateEnum_CONCAT) : begin
        state <= 4'b0100;
      end
      (((fsm_currentState) & ShapeStateEnum_MAX_POOLING) == ShapeStateEnum_MAX_POOLING) : begin
        state <= 4'b0001;
      end
      (((fsm_currentState) & ShapeStateEnum_UP_SAMPLING) == ShapeStateEnum_UP_SAMPLING) : begin
        state <= 4'b0011;
      end
      (((fsm_currentState) & ShapeStateEnum_SPLIT) == ShapeStateEnum_SPLIT) : begin
        state <= 4'b0010;
      end
      (((fsm_currentState) & ShapeStateEnum_IRQ) == ShapeStateEnum_IRQ) : begin
        state <= 4'b1111;
      end
      default : begin
        state <= 4'b0000;
      end
    endcase
  end


endmodule

module ConvCompute (
  input               startPa,
  input               startCu,
  input               sParaData_valid,
  output              sParaData_ready,
  input      [63:0]   sParaData_payload,
  input               sFeatureData_valid,
  output              sFeatureData_ready,
  input      [63:0]   sFeatureData_payload,
  output              mFeatureData_valid,
  input               mFeatureData_ready,
  output     [63:0]   mFeatureData_payload,
  output              mNormData_valid,
  input               mNormData_ready,
  output     [31:0]   mNormData_payload_0,
  output     [31:0]   mNormData_payload_1,
  output     [31:0]   mNormData_payload_2,
  output     [31:0]   mNormData_payload_3,
  output     [31:0]   mNormData_payload_4,
  output     [31:0]   mNormData_payload_5,
  output     [31:0]   mNormData_payload_6,
  output     [31:0]   mNormData_payload_7,
  output              copyWeightDone,
  output              computeComplete,
  input      [8:0]    rowNumIn,
  input      [8:0]    colNumIn,
  input      [11:0]   channelIn,
  input      [11:0]   channelOut,
  input               enPadding,
  input               enActivation,
  input      [7:0]    zeroDara,
  input      [0:0]    zeroNum,
  input      [12:0]   weightNum,
  input      [8:0]    quanNum,
  input      [7:0]    quanZeroData,
  input               enStride,
  input      [1:0]    convType,
  input               reset,
  input               clk,
  input               RST_2X,
  input               CLK_2X
);

  wire       [11:0]   featureFifo_0_sCount;
  wire       [11:0]   featureFifo_0_mCount;
  wire       [11:0]   featureFifo_1_sCount;
  wire       [11:0]   featureFifo_1_mCount;
  wire       [11:0]   featureFifo_2_sCount;
  wire       [11:0]   featureFifo_2_mCount;
  wire       [11:0]   featureFifo_3_sCount;
  wire       [11:0]   featureFifo_3_mCount;
  wire       [11:0]   featureFifo_4_sCount;
  wire       [11:0]   featureFifo_4_mCount;
  wire       [11:0]   featureFifo_5_sCount;
  wire       [11:0]   featureFifo_5_mCount;
  wire       [11:0]   featureFifo_6_sCount;
  wire       [11:0]   featureFifo_6_mCount;
  wire       [11:0]   featureFifo_7_sCount;
  wire       [11:0]   featureFifo_7_mCount;
  wire       [11:0]   featureFifo_8_sCount;
  wire       [11:0]   featureFifo_8_mCount;
  wire       [7:0]    dSP_1_a;
  wire       [7:0]    dSP_1_d;
  wire       [7:0]    dSP_1_b;
  wire       [7:0]    dSP_1_a1;
  wire       [7:0]    dSP_1_d1;
  wire       [7:0]    dSP_2_a;
  wire       [7:0]    dSP_2_d;
  wire       [7:0]    dSP_2_b;
  wire       [7:0]    dSP_2_a1;
  wire       [7:0]    dSP_2_d1;
  wire       [7:0]    dSP_3_a;
  wire       [7:0]    dSP_3_d;
  wire       [7:0]    dSP_3_b;
  wire       [7:0]    dSP_3_a1;
  wire       [7:0]    dSP_3_d1;
  wire       [7:0]    dSP_4_a;
  wire       [7:0]    dSP_4_d;
  wire       [7:0]    dSP_4_b;
  wire       [7:0]    dSP_4_a1;
  wire       [7:0]    dSP_4_d1;
  wire       [7:0]    dSP_5_a;
  wire       [7:0]    dSP_5_d;
  wire       [7:0]    dSP_5_b;
  wire       [7:0]    dSP_5_a1;
  wire       [7:0]    dSP_5_d1;
  wire       [7:0]    dSP_6_a;
  wire       [7:0]    dSP_6_d;
  wire       [7:0]    dSP_6_b;
  wire       [7:0]    dSP_6_a1;
  wire       [7:0]    dSP_6_d1;
  wire       [7:0]    dSP_7_a;
  wire       [7:0]    dSP_7_d;
  wire       [7:0]    dSP_7_b;
  wire       [7:0]    dSP_7_a1;
  wire       [7:0]    dSP_7_d1;
  wire       [7:0]    dSP_8_a;
  wire       [7:0]    dSP_8_d;
  wire       [7:0]    dSP_8_b;
  wire       [7:0]    dSP_8_a1;
  wire       [7:0]    dSP_8_d1;
  wire       [7:0]    dSP_9_a;
  wire       [7:0]    dSP_9_d;
  wire       [7:0]    dSP_9_b;
  wire       [7:0]    dSP_9_a1;
  wire       [7:0]    dSP_9_d1;
  wire       [7:0]    dSP_10_a;
  wire       [7:0]    dSP_10_d;
  wire       [7:0]    dSP_10_b;
  wire       [7:0]    dSP_10_a1;
  wire       [7:0]    dSP_10_d1;
  wire       [7:0]    dSP_11_a;
  wire       [7:0]    dSP_11_d;
  wire       [7:0]    dSP_11_b;
  wire       [7:0]    dSP_11_a1;
  wire       [7:0]    dSP_11_d1;
  wire       [7:0]    dSP_12_a;
  wire       [7:0]    dSP_12_d;
  wire       [7:0]    dSP_12_b;
  wire       [7:0]    dSP_12_a1;
  wire       [7:0]    dSP_12_d1;
  wire       [7:0]    dSP_13_a;
  wire       [7:0]    dSP_13_d;
  wire       [7:0]    dSP_13_b;
  wire       [7:0]    dSP_13_a1;
  wire       [7:0]    dSP_13_d1;
  wire       [7:0]    dSP_14_a;
  wire       [7:0]    dSP_14_d;
  wire       [7:0]    dSP_14_b;
  wire       [7:0]    dSP_14_a1;
  wire       [7:0]    dSP_14_d1;
  wire       [7:0]    dSP_15_a;
  wire       [7:0]    dSP_15_d;
  wire       [7:0]    dSP_15_b;
  wire       [7:0]    dSP_15_a1;
  wire       [7:0]    dSP_15_d1;
  wire       [7:0]    dSP_16_a;
  wire       [7:0]    dSP_16_d;
  wire       [7:0]    dSP_16_b;
  wire       [7:0]    dSP_16_a1;
  wire       [7:0]    dSP_16_d1;
  wire       [7:0]    dSP_17_a;
  wire       [7:0]    dSP_17_d;
  wire       [7:0]    dSP_17_b;
  wire       [7:0]    dSP_17_a1;
  wire       [7:0]    dSP_17_d1;
  wire       [7:0]    dSP_18_a;
  wire       [7:0]    dSP_18_d;
  wire       [7:0]    dSP_18_b;
  wire       [7:0]    dSP_18_a1;
  wire       [7:0]    dSP_18_d1;
  wire       [7:0]    dSP_19_a;
  wire       [7:0]    dSP_19_d;
  wire       [7:0]    dSP_19_b;
  wire       [7:0]    dSP_19_a1;
  wire       [7:0]    dSP_19_d1;
  wire       [7:0]    dSP_20_a;
  wire       [7:0]    dSP_20_d;
  wire       [7:0]    dSP_20_b;
  wire       [7:0]    dSP_20_a1;
  wire       [7:0]    dSP_20_d1;
  wire       [7:0]    dSP_21_a;
  wire       [7:0]    dSP_21_d;
  wire       [7:0]    dSP_21_b;
  wire       [7:0]    dSP_21_a1;
  wire       [7:0]    dSP_21_d1;
  wire       [7:0]    dSP_22_a;
  wire       [7:0]    dSP_22_d;
  wire       [7:0]    dSP_22_b;
  wire       [7:0]    dSP_22_a1;
  wire       [7:0]    dSP_22_d1;
  wire       [7:0]    dSP_23_a;
  wire       [7:0]    dSP_23_d;
  wire       [7:0]    dSP_23_b;
  wire       [7:0]    dSP_23_a1;
  wire       [7:0]    dSP_23_d1;
  wire       [7:0]    dSP_24_a;
  wire       [7:0]    dSP_24_d;
  wire       [7:0]    dSP_24_b;
  wire       [7:0]    dSP_24_a1;
  wire       [7:0]    dSP_24_d1;
  wire       [7:0]    dSP_25_a;
  wire       [7:0]    dSP_25_d;
  wire       [7:0]    dSP_25_b;
  wire       [7:0]    dSP_25_a1;
  wire       [7:0]    dSP_25_d1;
  wire       [7:0]    dSP_26_a;
  wire       [7:0]    dSP_26_d;
  wire       [7:0]    dSP_26_b;
  wire       [7:0]    dSP_26_a1;
  wire       [7:0]    dSP_26_d1;
  wire       [7:0]    dSP_27_a;
  wire       [7:0]    dSP_27_d;
  wire       [7:0]    dSP_27_b;
  wire       [7:0]    dSP_27_a1;
  wire       [7:0]    dSP_27_d1;
  wire       [7:0]    dSP_28_a;
  wire       [7:0]    dSP_28_d;
  wire       [7:0]    dSP_28_b;
  wire       [7:0]    dSP_28_a1;
  wire       [7:0]    dSP_28_d1;
  wire       [7:0]    dSP_29_a;
  wire       [7:0]    dSP_29_d;
  wire       [7:0]    dSP_29_b;
  wire       [7:0]    dSP_29_a1;
  wire       [7:0]    dSP_29_d1;
  wire       [7:0]    dSP_30_a;
  wire       [7:0]    dSP_30_d;
  wire       [7:0]    dSP_30_b;
  wire       [7:0]    dSP_30_a1;
  wire       [7:0]    dSP_30_d1;
  wire       [7:0]    dSP_31_a;
  wire       [7:0]    dSP_31_d;
  wire       [7:0]    dSP_31_b;
  wire       [7:0]    dSP_31_a1;
  wire       [7:0]    dSP_31_d1;
  wire       [7:0]    dSP_32_a;
  wire       [7:0]    dSP_32_d;
  wire       [7:0]    dSP_32_b;
  wire       [7:0]    dSP_32_a1;
  wire       [7:0]    dSP_32_d1;
  wire       [7:0]    dSP_33_a;
  wire       [7:0]    dSP_33_d;
  wire       [7:0]    dSP_33_b;
  wire       [7:0]    dSP_33_a1;
  wire       [7:0]    dSP_33_d1;
  wire       [7:0]    dSP_34_a;
  wire       [7:0]    dSP_34_d;
  wire       [7:0]    dSP_34_b;
  wire       [7:0]    dSP_34_a1;
  wire       [7:0]    dSP_34_d1;
  wire       [7:0]    dSP_35_a;
  wire       [7:0]    dSP_35_d;
  wire       [7:0]    dSP_35_b;
  wire       [7:0]    dSP_35_a1;
  wire       [7:0]    dSP_35_d1;
  wire       [7:0]    dSP_36_a;
  wire       [7:0]    dSP_36_d;
  wire       [7:0]    dSP_36_b;
  wire       [7:0]    dSP_36_a1;
  wire       [7:0]    dSP_36_d1;
  wire       [7:0]    dSP_37_a;
  wire       [7:0]    dSP_37_d;
  wire       [7:0]    dSP_37_b;
  wire       [7:0]    dSP_37_a1;
  wire       [7:0]    dSP_37_d1;
  wire       [7:0]    dSP_38_a;
  wire       [7:0]    dSP_38_d;
  wire       [7:0]    dSP_38_b;
  wire       [7:0]    dSP_38_a1;
  wire       [7:0]    dSP_38_d1;
  wire       [7:0]    dSP_39_a;
  wire       [7:0]    dSP_39_d;
  wire       [7:0]    dSP_39_b;
  wire       [7:0]    dSP_39_a1;
  wire       [7:0]    dSP_39_d1;
  wire       [7:0]    dSP_40_a;
  wire       [7:0]    dSP_40_d;
  wire       [7:0]    dSP_40_b;
  wire       [7:0]    dSP_40_a1;
  wire       [7:0]    dSP_40_d1;
  wire       [7:0]    dSP_41_a;
  wire       [7:0]    dSP_41_d;
  wire       [7:0]    dSP_41_b;
  wire       [7:0]    dSP_41_a1;
  wire       [7:0]    dSP_41_d1;
  wire       [7:0]    dSP_42_a;
  wire       [7:0]    dSP_42_d;
  wire       [7:0]    dSP_42_b;
  wire       [7:0]    dSP_42_a1;
  wire       [7:0]    dSP_42_d1;
  wire       [7:0]    dSP_43_a;
  wire       [7:0]    dSP_43_d;
  wire       [7:0]    dSP_43_b;
  wire       [7:0]    dSP_43_a1;
  wire       [7:0]    dSP_43_d1;
  wire       [7:0]    dSP_44_a;
  wire       [7:0]    dSP_44_d;
  wire       [7:0]    dSP_44_b;
  wire       [7:0]    dSP_44_a1;
  wire       [7:0]    dSP_44_d1;
  wire       [7:0]    dSP_45_a;
  wire       [7:0]    dSP_45_d;
  wire       [7:0]    dSP_45_b;
  wire       [7:0]    dSP_45_a1;
  wire       [7:0]    dSP_45_d1;
  wire       [7:0]    dSP_46_a;
  wire       [7:0]    dSP_46_d;
  wire       [7:0]    dSP_46_b;
  wire       [7:0]    dSP_46_a1;
  wire       [7:0]    dSP_46_d1;
  wire       [7:0]    dSP_47_a;
  wire       [7:0]    dSP_47_d;
  wire       [7:0]    dSP_47_b;
  wire       [7:0]    dSP_47_a1;
  wire       [7:0]    dSP_47_d1;
  wire       [7:0]    dSP_48_a;
  wire       [7:0]    dSP_48_d;
  wire       [7:0]    dSP_48_b;
  wire       [7:0]    dSP_48_a1;
  wire       [7:0]    dSP_48_d1;
  wire       [7:0]    dSP_49_a;
  wire       [7:0]    dSP_49_d;
  wire       [7:0]    dSP_49_b;
  wire       [7:0]    dSP_49_a1;
  wire       [7:0]    dSP_49_d1;
  wire       [7:0]    dSP_50_a;
  wire       [7:0]    dSP_50_d;
  wire       [7:0]    dSP_50_b;
  wire       [7:0]    dSP_50_a1;
  wire       [7:0]    dSP_50_d1;
  wire       [7:0]    dSP_51_a;
  wire       [7:0]    dSP_51_d;
  wire       [7:0]    dSP_51_b;
  wire       [7:0]    dSP_51_a1;
  wire       [7:0]    dSP_51_d1;
  wire       [7:0]    dSP_52_a;
  wire       [7:0]    dSP_52_d;
  wire       [7:0]    dSP_52_b;
  wire       [7:0]    dSP_52_a1;
  wire       [7:0]    dSP_52_d1;
  wire       [7:0]    dSP_53_a;
  wire       [7:0]    dSP_53_d;
  wire       [7:0]    dSP_53_b;
  wire       [7:0]    dSP_53_a1;
  wire       [7:0]    dSP_53_d1;
  wire       [7:0]    dSP_54_a;
  wire       [7:0]    dSP_54_d;
  wire       [7:0]    dSP_54_b;
  wire       [7:0]    dSP_54_a1;
  wire       [7:0]    dSP_54_d1;
  wire       [7:0]    dSP_55_a;
  wire       [7:0]    dSP_55_d;
  wire       [7:0]    dSP_55_b;
  wire       [7:0]    dSP_55_a1;
  wire       [7:0]    dSP_55_d1;
  wire       [7:0]    dSP_56_a;
  wire       [7:0]    dSP_56_d;
  wire       [7:0]    dSP_56_b;
  wire       [7:0]    dSP_56_a1;
  wire       [7:0]    dSP_56_d1;
  wire       [7:0]    dSP_57_a;
  wire       [7:0]    dSP_57_d;
  wire       [7:0]    dSP_57_b;
  wire       [7:0]    dSP_57_a1;
  wire       [7:0]    dSP_57_d1;
  wire       [7:0]    dSP_58_a;
  wire       [7:0]    dSP_58_d;
  wire       [7:0]    dSP_58_b;
  wire       [7:0]    dSP_58_a1;
  wire       [7:0]    dSP_58_d1;
  wire       [7:0]    dSP_59_a;
  wire       [7:0]    dSP_59_d;
  wire       [7:0]    dSP_59_b;
  wire       [7:0]    dSP_59_a1;
  wire       [7:0]    dSP_59_d1;
  wire       [7:0]    dSP_60_a;
  wire       [7:0]    dSP_60_d;
  wire       [7:0]    dSP_60_b;
  wire       [7:0]    dSP_60_a1;
  wire       [7:0]    dSP_60_d1;
  wire       [7:0]    dSP_61_a;
  wire       [7:0]    dSP_61_d;
  wire       [7:0]    dSP_61_b;
  wire       [7:0]    dSP_61_a1;
  wire       [7:0]    dSP_61_d1;
  wire       [7:0]    dSP_62_a;
  wire       [7:0]    dSP_62_d;
  wire       [7:0]    dSP_62_b;
  wire       [7:0]    dSP_62_a1;
  wire       [7:0]    dSP_62_d1;
  wire       [7:0]    dSP_63_a;
  wire       [7:0]    dSP_63_d;
  wire       [7:0]    dSP_63_b;
  wire       [7:0]    dSP_63_a1;
  wire       [7:0]    dSP_63_d1;
  wire       [7:0]    dSP_64_a;
  wire       [7:0]    dSP_64_d;
  wire       [7:0]    dSP_64_b;
  wire       [7:0]    dSP_64_a1;
  wire       [7:0]    dSP_64_d1;
  wire       [7:0]    dSP_65_a;
  wire       [7:0]    dSP_65_d;
  wire       [7:0]    dSP_65_b;
  wire       [7:0]    dSP_65_a1;
  wire       [7:0]    dSP_65_d1;
  wire       [7:0]    dSP_66_a;
  wire       [7:0]    dSP_66_d;
  wire       [7:0]    dSP_66_b;
  wire       [7:0]    dSP_66_a1;
  wire       [7:0]    dSP_66_d1;
  wire       [7:0]    dSP_67_a;
  wire       [7:0]    dSP_67_d;
  wire       [7:0]    dSP_67_b;
  wire       [7:0]    dSP_67_a1;
  wire       [7:0]    dSP_67_d1;
  wire       [7:0]    dSP_68_a;
  wire       [7:0]    dSP_68_d;
  wire       [7:0]    dSP_68_b;
  wire       [7:0]    dSP_68_a1;
  wire       [7:0]    dSP_68_d1;
  wire       [7:0]    dSP_69_a;
  wire       [7:0]    dSP_69_d;
  wire       [7:0]    dSP_69_b;
  wire       [7:0]    dSP_69_a1;
  wire       [7:0]    dSP_69_d1;
  wire       [7:0]    dSP_70_a;
  wire       [7:0]    dSP_70_d;
  wire       [7:0]    dSP_70_b;
  wire       [7:0]    dSP_70_a1;
  wire       [7:0]    dSP_70_d1;
  wire       [7:0]    dSP_71_a;
  wire       [7:0]    dSP_71_d;
  wire       [7:0]    dSP_71_b;
  wire       [7:0]    dSP_71_a1;
  wire       [7:0]    dSP_71_d1;
  wire       [7:0]    dSP_72_a;
  wire       [7:0]    dSP_72_d;
  wire       [7:0]    dSP_72_b;
  wire       [7:0]    dSP_72_a1;
  wire       [7:0]    dSP_72_d1;
  wire       [7:0]    dSP_73_a;
  wire       [7:0]    dSP_73_d;
  wire       [7:0]    dSP_73_b;
  wire       [7:0]    dSP_73_a1;
  wire       [7:0]    dSP_73_d1;
  wire       [7:0]    dSP_74_a;
  wire       [7:0]    dSP_74_d;
  wire       [7:0]    dSP_74_b;
  wire       [7:0]    dSP_74_a1;
  wire       [7:0]    dSP_74_d1;
  wire       [7:0]    dSP_75_a;
  wire       [7:0]    dSP_75_d;
  wire       [7:0]    dSP_75_b;
  wire       [7:0]    dSP_75_a1;
  wire       [7:0]    dSP_75_d1;
  wire       [7:0]    dSP_76_a;
  wire       [7:0]    dSP_76_d;
  wire       [7:0]    dSP_76_b;
  wire       [7:0]    dSP_76_a1;
  wire       [7:0]    dSP_76_d1;
  wire       [7:0]    dSP_77_a;
  wire       [7:0]    dSP_77_d;
  wire       [7:0]    dSP_77_b;
  wire       [7:0]    dSP_77_a1;
  wire       [7:0]    dSP_77_d1;
  wire       [7:0]    dSP_78_a;
  wire       [7:0]    dSP_78_d;
  wire       [7:0]    dSP_78_b;
  wire       [7:0]    dSP_78_a1;
  wire       [7:0]    dSP_78_d1;
  wire       [7:0]    dSP_79_a;
  wire       [7:0]    dSP_79_d;
  wire       [7:0]    dSP_79_b;
  wire       [7:0]    dSP_79_a1;
  wire       [7:0]    dSP_79_d1;
  wire       [7:0]    dSP_80_a;
  wire       [7:0]    dSP_80_d;
  wire       [7:0]    dSP_80_b;
  wire       [7:0]    dSP_80_a1;
  wire       [7:0]    dSP_80_d1;
  wire       [7:0]    dSP_81_a;
  wire       [7:0]    dSP_81_d;
  wire       [7:0]    dSP_81_b;
  wire       [7:0]    dSP_81_a1;
  wire       [7:0]    dSP_81_d1;
  wire       [7:0]    dSP_82_a;
  wire       [7:0]    dSP_82_d;
  wire       [7:0]    dSP_82_b;
  wire       [7:0]    dSP_82_a1;
  wire       [7:0]    dSP_82_d1;
  wire       [7:0]    dSP_83_a;
  wire       [7:0]    dSP_83_d;
  wire       [7:0]    dSP_83_b;
  wire       [7:0]    dSP_83_a1;
  wire       [7:0]    dSP_83_d1;
  wire       [7:0]    dSP_84_a;
  wire       [7:0]    dSP_84_d;
  wire       [7:0]    dSP_84_b;
  wire       [7:0]    dSP_84_a1;
  wire       [7:0]    dSP_84_d1;
  wire       [7:0]    dSP_85_a;
  wire       [7:0]    dSP_85_d;
  wire       [7:0]    dSP_85_b;
  wire       [7:0]    dSP_85_a1;
  wire       [7:0]    dSP_85_d1;
  wire       [7:0]    dSP_86_a;
  wire       [7:0]    dSP_86_d;
  wire       [7:0]    dSP_86_b;
  wire       [7:0]    dSP_86_a1;
  wire       [7:0]    dSP_86_d1;
  wire       [7:0]    dSP_87_a;
  wire       [7:0]    dSP_87_d;
  wire       [7:0]    dSP_87_b;
  wire       [7:0]    dSP_87_a1;
  wire       [7:0]    dSP_87_d1;
  wire       [7:0]    dSP_88_a;
  wire       [7:0]    dSP_88_d;
  wire       [7:0]    dSP_88_b;
  wire       [7:0]    dSP_88_a1;
  wire       [7:0]    dSP_88_d1;
  wire       [7:0]    dSP_89_a;
  wire       [7:0]    dSP_89_d;
  wire       [7:0]    dSP_89_b;
  wire       [7:0]    dSP_89_a1;
  wire       [7:0]    dSP_89_d1;
  wire       [7:0]    dSP_90_a;
  wire       [7:0]    dSP_90_d;
  wire       [7:0]    dSP_90_b;
  wire       [7:0]    dSP_90_a1;
  wire       [7:0]    dSP_90_d1;
  wire       [7:0]    dSP_91_a;
  wire       [7:0]    dSP_91_d;
  wire       [7:0]    dSP_91_b;
  wire       [7:0]    dSP_91_a1;
  wire       [7:0]    dSP_91_d1;
  wire       [7:0]    dSP_92_a;
  wire       [7:0]    dSP_92_d;
  wire       [7:0]    dSP_92_b;
  wire       [7:0]    dSP_92_a1;
  wire       [7:0]    dSP_92_d1;
  wire       [7:0]    dSP_93_a;
  wire       [7:0]    dSP_93_d;
  wire       [7:0]    dSP_93_b;
  wire       [7:0]    dSP_93_a1;
  wire       [7:0]    dSP_93_d1;
  wire       [7:0]    dSP_94_a;
  wire       [7:0]    dSP_94_d;
  wire       [7:0]    dSP_94_b;
  wire       [7:0]    dSP_94_a1;
  wire       [7:0]    dSP_94_d1;
  wire       [7:0]    dSP_95_a;
  wire       [7:0]    dSP_95_d;
  wire       [7:0]    dSP_95_b;
  wire       [7:0]    dSP_95_a1;
  wire       [7:0]    dSP_95_d1;
  wire       [7:0]    dSP_96_a;
  wire       [7:0]    dSP_96_d;
  wire       [7:0]    dSP_96_b;
  wire       [7:0]    dSP_96_a1;
  wire       [7:0]    dSP_96_d1;
  wire       [7:0]    dSP_97_a;
  wire       [7:0]    dSP_97_d;
  wire       [7:0]    dSP_97_b;
  wire       [7:0]    dSP_97_a1;
  wire       [7:0]    dSP_97_d1;
  wire       [7:0]    dSP_98_a;
  wire       [7:0]    dSP_98_d;
  wire       [7:0]    dSP_98_b;
  wire       [7:0]    dSP_98_a1;
  wire       [7:0]    dSP_98_d1;
  wire       [7:0]    dSP_99_a;
  wire       [7:0]    dSP_99_d;
  wire       [7:0]    dSP_99_b;
  wire       [7:0]    dSP_99_a1;
  wire       [7:0]    dSP_99_d1;
  wire       [7:0]    dSP_100_a;
  wire       [7:0]    dSP_100_d;
  wire       [7:0]    dSP_100_b;
  wire       [7:0]    dSP_100_a1;
  wire       [7:0]    dSP_100_d1;
  wire       [7:0]    dSP_101_a;
  wire       [7:0]    dSP_101_d;
  wire       [7:0]    dSP_101_b;
  wire       [7:0]    dSP_101_a1;
  wire       [7:0]    dSP_101_d1;
  wire       [7:0]    dSP_102_a;
  wire       [7:0]    dSP_102_d;
  wire       [7:0]    dSP_102_b;
  wire       [7:0]    dSP_102_a1;
  wire       [7:0]    dSP_102_d1;
  wire       [7:0]    dSP_103_a;
  wire       [7:0]    dSP_103_d;
  wire       [7:0]    dSP_103_b;
  wire       [7:0]    dSP_103_a1;
  wire       [7:0]    dSP_103_d1;
  wire       [7:0]    dSP_104_a;
  wire       [7:0]    dSP_104_d;
  wire       [7:0]    dSP_104_b;
  wire       [7:0]    dSP_104_a1;
  wire       [7:0]    dSP_104_d1;
  wire       [7:0]    dSP_105_a;
  wire       [7:0]    dSP_105_d;
  wire       [7:0]    dSP_105_b;
  wire       [7:0]    dSP_105_a1;
  wire       [7:0]    dSP_105_d1;
  wire       [7:0]    dSP_106_a;
  wire       [7:0]    dSP_106_d;
  wire       [7:0]    dSP_106_b;
  wire       [7:0]    dSP_106_a1;
  wire       [7:0]    dSP_106_d1;
  wire       [7:0]    dSP_107_a;
  wire       [7:0]    dSP_107_d;
  wire       [7:0]    dSP_107_b;
  wire       [7:0]    dSP_107_a1;
  wire       [7:0]    dSP_107_d1;
  wire       [7:0]    dSP_108_a;
  wire       [7:0]    dSP_108_d;
  wire       [7:0]    dSP_108_b;
  wire       [7:0]    dSP_108_a1;
  wire       [7:0]    dSP_108_d1;
  wire       [7:0]    dSP_109_a;
  wire       [7:0]    dSP_109_d;
  wire       [7:0]    dSP_109_b;
  wire       [7:0]    dSP_109_a1;
  wire       [7:0]    dSP_109_d1;
  wire       [7:0]    dSP_110_a;
  wire       [7:0]    dSP_110_d;
  wire       [7:0]    dSP_110_b;
  wire       [7:0]    dSP_110_a1;
  wire       [7:0]    dSP_110_d1;
  wire       [7:0]    dSP_111_a;
  wire       [7:0]    dSP_111_d;
  wire       [7:0]    dSP_111_b;
  wire       [7:0]    dSP_111_a1;
  wire       [7:0]    dSP_111_d1;
  wire       [7:0]    dSP_112_a;
  wire       [7:0]    dSP_112_d;
  wire       [7:0]    dSP_112_b;
  wire       [7:0]    dSP_112_a1;
  wire       [7:0]    dSP_112_d1;
  wire       [7:0]    dSP_113_a;
  wire       [7:0]    dSP_113_d;
  wire       [7:0]    dSP_113_b;
  wire       [7:0]    dSP_113_a1;
  wire       [7:0]    dSP_113_d1;
  wire       [7:0]    dSP_114_a;
  wire       [7:0]    dSP_114_d;
  wire       [7:0]    dSP_114_b;
  wire       [7:0]    dSP_114_a1;
  wire       [7:0]    dSP_114_d1;
  wire       [7:0]    dSP_115_a;
  wire       [7:0]    dSP_115_d;
  wire       [7:0]    dSP_115_b;
  wire       [7:0]    dSP_115_a1;
  wire       [7:0]    dSP_115_d1;
  wire       [7:0]    dSP_116_a;
  wire       [7:0]    dSP_116_d;
  wire       [7:0]    dSP_116_b;
  wire       [7:0]    dSP_116_a1;
  wire       [7:0]    dSP_116_d1;
  wire       [7:0]    dSP_117_a;
  wire       [7:0]    dSP_117_d;
  wire       [7:0]    dSP_117_b;
  wire       [7:0]    dSP_117_a1;
  wire       [7:0]    dSP_117_d1;
  wire       [7:0]    dSP_118_a;
  wire       [7:0]    dSP_118_d;
  wire       [7:0]    dSP_118_b;
  wire       [7:0]    dSP_118_a1;
  wire       [7:0]    dSP_118_d1;
  wire       [7:0]    dSP_119_a;
  wire       [7:0]    dSP_119_d;
  wire       [7:0]    dSP_119_b;
  wire       [7:0]    dSP_119_a1;
  wire       [7:0]    dSP_119_d1;
  wire       [7:0]    dSP_120_a;
  wire       [7:0]    dSP_120_d;
  wire       [7:0]    dSP_120_b;
  wire       [7:0]    dSP_120_a1;
  wire       [7:0]    dSP_120_d1;
  wire       [7:0]    dSP_121_a;
  wire       [7:0]    dSP_121_d;
  wire       [7:0]    dSP_121_b;
  wire       [7:0]    dSP_121_a1;
  wire       [7:0]    dSP_121_d1;
  wire       [7:0]    dSP_122_a;
  wire       [7:0]    dSP_122_d;
  wire       [7:0]    dSP_122_b;
  wire       [7:0]    dSP_122_a1;
  wire       [7:0]    dSP_122_d1;
  wire       [7:0]    dSP_123_a;
  wire       [7:0]    dSP_123_d;
  wire       [7:0]    dSP_123_b;
  wire       [7:0]    dSP_123_a1;
  wire       [7:0]    dSP_123_d1;
  wire       [7:0]    dSP_124_a;
  wire       [7:0]    dSP_124_d;
  wire       [7:0]    dSP_124_b;
  wire       [7:0]    dSP_124_a1;
  wire       [7:0]    dSP_124_d1;
  wire       [7:0]    dSP_125_a;
  wire       [7:0]    dSP_125_d;
  wire       [7:0]    dSP_125_b;
  wire       [7:0]    dSP_125_a1;
  wire       [7:0]    dSP_125_d1;
  wire       [7:0]    dSP_126_a;
  wire       [7:0]    dSP_126_d;
  wire       [7:0]    dSP_126_b;
  wire       [7:0]    dSP_126_a1;
  wire       [7:0]    dSP_126_d1;
  wire       [7:0]    dSP_127_a;
  wire       [7:0]    dSP_127_d;
  wire       [7:0]    dSP_127_b;
  wire       [7:0]    dSP_127_a1;
  wire       [7:0]    dSP_127_d1;
  wire       [7:0]    dSP_128_a;
  wire       [7:0]    dSP_128_d;
  wire       [7:0]    dSP_128_b;
  wire       [7:0]    dSP_128_a1;
  wire       [7:0]    dSP_128_d1;
  wire       [7:0]    dSP_129_a;
  wire       [7:0]    dSP_129_d;
  wire       [7:0]    dSP_129_b;
  wire       [7:0]    dSP_129_a1;
  wire       [7:0]    dSP_129_d1;
  wire       [7:0]    dSP_130_a;
  wire       [7:0]    dSP_130_d;
  wire       [7:0]    dSP_130_b;
  wire       [7:0]    dSP_130_a1;
  wire       [7:0]    dSP_130_d1;
  wire       [7:0]    dSP_131_a;
  wire       [7:0]    dSP_131_d;
  wire       [7:0]    dSP_131_b;
  wire       [7:0]    dSP_131_a1;
  wire       [7:0]    dSP_131_d1;
  wire       [7:0]    dSP_132_a;
  wire       [7:0]    dSP_132_d;
  wire       [7:0]    dSP_132_b;
  wire       [7:0]    dSP_132_a1;
  wire       [7:0]    dSP_132_d1;
  wire       [7:0]    dSP_133_a;
  wire       [7:0]    dSP_133_d;
  wire       [7:0]    dSP_133_b;
  wire       [7:0]    dSP_133_a1;
  wire       [7:0]    dSP_133_d1;
  wire       [7:0]    dSP_134_a;
  wire       [7:0]    dSP_134_d;
  wire       [7:0]    dSP_134_b;
  wire       [7:0]    dSP_134_a1;
  wire       [7:0]    dSP_134_d1;
  wire       [7:0]    dSP_135_a;
  wire       [7:0]    dSP_135_d;
  wire       [7:0]    dSP_135_b;
  wire       [7:0]    dSP_135_a1;
  wire       [7:0]    dSP_135_d1;
  wire       [7:0]    dSP_136_a;
  wire       [7:0]    dSP_136_d;
  wire       [7:0]    dSP_136_b;
  wire       [7:0]    dSP_136_a1;
  wire       [7:0]    dSP_136_d1;
  wire       [7:0]    dSP_137_a;
  wire       [7:0]    dSP_137_d;
  wire       [7:0]    dSP_137_b;
  wire       [7:0]    dSP_137_a1;
  wire       [7:0]    dSP_137_d1;
  wire       [7:0]    dSP_138_a;
  wire       [7:0]    dSP_138_d;
  wire       [7:0]    dSP_138_b;
  wire       [7:0]    dSP_138_a1;
  wire       [7:0]    dSP_138_d1;
  wire       [7:0]    dSP_139_a;
  wire       [7:0]    dSP_139_d;
  wire       [7:0]    dSP_139_b;
  wire       [7:0]    dSP_139_a1;
  wire       [7:0]    dSP_139_d1;
  wire       [7:0]    dSP_140_a;
  wire       [7:0]    dSP_140_d;
  wire       [7:0]    dSP_140_b;
  wire       [7:0]    dSP_140_a1;
  wire       [7:0]    dSP_140_d1;
  wire       [7:0]    dSP_141_a;
  wire       [7:0]    dSP_141_d;
  wire       [7:0]    dSP_141_b;
  wire       [7:0]    dSP_141_a1;
  wire       [7:0]    dSP_141_d1;
  wire       [7:0]    dSP_142_a;
  wire       [7:0]    dSP_142_d;
  wire       [7:0]    dSP_142_b;
  wire       [7:0]    dSP_142_a1;
  wire       [7:0]    dSP_142_d1;
  wire       [7:0]    dSP_143_a;
  wire       [7:0]    dSP_143_d;
  wire       [7:0]    dSP_143_b;
  wire       [7:0]    dSP_143_a1;
  wire       [7:0]    dSP_143_d1;
  wire       [7:0]    dSP_144_a;
  wire       [7:0]    dSP_144_d;
  wire       [7:0]    dSP_144_b;
  wire       [7:0]    dSP_144_a1;
  wire       [7:0]    dSP_144_d1;
  wire       [31:0]   addKernel_A_0;
  wire       [31:0]   addKernel_A_1;
  wire       [31:0]   addKernel_A_2;
  wire       [31:0]   addKernel_A_3;
  wire       [31:0]   addKernel_A_4;
  wire       [31:0]   addKernel_A_5;
  wire       [31:0]   addKernel_A_6;
  wire       [31:0]   addKernel_A_7;
  wire       [31:0]   addKernel_A_8;
  wire       [31:0]   addKernel_1_A_0;
  wire       [31:0]   addKernel_1_A_1;
  wire       [31:0]   addKernel_1_A_2;
  wire       [31:0]   addKernel_1_A_3;
  wire       [31:0]   addKernel_1_A_4;
  wire       [31:0]   addKernel_1_A_5;
  wire       [31:0]   addKernel_1_A_6;
  wire       [31:0]   addKernel_1_A_7;
  wire       [31:0]   addKernel_1_A_8;
  wire       [31:0]   addKernel_2_A_0;
  wire       [31:0]   addKernel_2_A_1;
  wire       [31:0]   addKernel_2_A_2;
  wire       [31:0]   addKernel_2_A_3;
  wire       [31:0]   addKernel_2_A_4;
  wire       [31:0]   addKernel_2_A_5;
  wire       [31:0]   addKernel_2_A_6;
  wire       [31:0]   addKernel_2_A_7;
  wire       [31:0]   addKernel_2_A_8;
  wire       [31:0]   addKernel_3_A_0;
  wire       [31:0]   addKernel_3_A_1;
  wire       [31:0]   addKernel_3_A_2;
  wire       [31:0]   addKernel_3_A_3;
  wire       [31:0]   addKernel_3_A_4;
  wire       [31:0]   addKernel_3_A_5;
  wire       [31:0]   addKernel_3_A_6;
  wire       [31:0]   addKernel_3_A_7;
  wire       [31:0]   addKernel_3_A_8;
  wire       [31:0]   addKernel_4_A_0;
  wire       [31:0]   addKernel_4_A_1;
  wire       [31:0]   addKernel_4_A_2;
  wire       [31:0]   addKernel_4_A_3;
  wire       [31:0]   addKernel_4_A_4;
  wire       [31:0]   addKernel_4_A_5;
  wire       [31:0]   addKernel_4_A_6;
  wire       [31:0]   addKernel_4_A_7;
  wire       [31:0]   addKernel_4_A_8;
  wire       [31:0]   addKernel_5_A_0;
  wire       [31:0]   addKernel_5_A_1;
  wire       [31:0]   addKernel_5_A_2;
  wire       [31:0]   addKernel_5_A_3;
  wire       [31:0]   addKernel_5_A_4;
  wire       [31:0]   addKernel_5_A_5;
  wire       [31:0]   addKernel_5_A_6;
  wire       [31:0]   addKernel_5_A_7;
  wire       [31:0]   addKernel_5_A_8;
  wire       [31:0]   addKernel_6_A_0;
  wire       [31:0]   addKernel_6_A_1;
  wire       [31:0]   addKernel_6_A_2;
  wire       [31:0]   addKernel_6_A_3;
  wire       [31:0]   addKernel_6_A_4;
  wire       [31:0]   addKernel_6_A_5;
  wire       [31:0]   addKernel_6_A_6;
  wire       [31:0]   addKernel_6_A_7;
  wire       [31:0]   addKernel_6_A_8;
  wire       [31:0]   addKernel_7_A_0;
  wire       [31:0]   addKernel_7_A_1;
  wire       [31:0]   addKernel_7_A_2;
  wire       [31:0]   addKernel_7_A_3;
  wire       [31:0]   addKernel_7_A_4;
  wire       [31:0]   addKernel_7_A_5;
  wire       [31:0]   addKernel_7_A_6;
  wire       [31:0]   addKernel_7_A_7;
  wire       [31:0]   addKernel_7_A_8;
  wire       [31:0]   addKernel_8_A_0;
  wire       [31:0]   addKernel_8_A_1;
  wire       [31:0]   addKernel_8_A_2;
  wire       [31:0]   addKernel_8_A_3;
  wire       [31:0]   addKernel_8_A_4;
  wire       [31:0]   addKernel_8_A_5;
  wire       [31:0]   addKernel_8_A_6;
  wire       [31:0]   addKernel_8_A_7;
  wire       [31:0]   addKernel_8_A_8;
  wire       [31:0]   addKernel_9_A_0;
  wire       [31:0]   addKernel_9_A_1;
  wire       [31:0]   addKernel_9_A_2;
  wire       [31:0]   addKernel_9_A_3;
  wire       [31:0]   addKernel_9_A_4;
  wire       [31:0]   addKernel_9_A_5;
  wire       [31:0]   addKernel_9_A_6;
  wire       [31:0]   addKernel_9_A_7;
  wire       [31:0]   addKernel_9_A_8;
  wire       [31:0]   addKernel_10_A_0;
  wire       [31:0]   addKernel_10_A_1;
  wire       [31:0]   addKernel_10_A_2;
  wire       [31:0]   addKernel_10_A_3;
  wire       [31:0]   addKernel_10_A_4;
  wire       [31:0]   addKernel_10_A_5;
  wire       [31:0]   addKernel_10_A_6;
  wire       [31:0]   addKernel_10_A_7;
  wire       [31:0]   addKernel_10_A_8;
  wire       [31:0]   addKernel_11_A_0;
  wire       [31:0]   addKernel_11_A_1;
  wire       [31:0]   addKernel_11_A_2;
  wire       [31:0]   addKernel_11_A_3;
  wire       [31:0]   addKernel_11_A_4;
  wire       [31:0]   addKernel_11_A_5;
  wire       [31:0]   addKernel_11_A_6;
  wire       [31:0]   addKernel_11_A_7;
  wire       [31:0]   addKernel_11_A_8;
  wire       [31:0]   addKernel_12_A_0;
  wire       [31:0]   addKernel_12_A_1;
  wire       [31:0]   addKernel_12_A_2;
  wire       [31:0]   addKernel_12_A_3;
  wire       [31:0]   addKernel_12_A_4;
  wire       [31:0]   addKernel_12_A_5;
  wire       [31:0]   addKernel_12_A_6;
  wire       [31:0]   addKernel_12_A_7;
  wire       [31:0]   addKernel_12_A_8;
  wire       [31:0]   addKernel_13_A_0;
  wire       [31:0]   addKernel_13_A_1;
  wire       [31:0]   addKernel_13_A_2;
  wire       [31:0]   addKernel_13_A_3;
  wire       [31:0]   addKernel_13_A_4;
  wire       [31:0]   addKernel_13_A_5;
  wire       [31:0]   addKernel_13_A_6;
  wire       [31:0]   addKernel_13_A_7;
  wire       [31:0]   addKernel_13_A_8;
  wire       [31:0]   addKernel_14_A_0;
  wire       [31:0]   addKernel_14_A_1;
  wire       [31:0]   addKernel_14_A_2;
  wire       [31:0]   addKernel_14_A_3;
  wire       [31:0]   addKernel_14_A_4;
  wire       [31:0]   addKernel_14_A_5;
  wire       [31:0]   addKernel_14_A_6;
  wire       [31:0]   addKernel_14_A_7;
  wire       [31:0]   addKernel_14_A_8;
  wire       [31:0]   addKernel_15_A_0;
  wire       [31:0]   addKernel_15_A_1;
  wire       [31:0]   addKernel_15_A_2;
  wire       [31:0]   addKernel_15_A_3;
  wire       [31:0]   addKernel_15_A_4;
  wire       [31:0]   addKernel_15_A_5;
  wire       [31:0]   addKernel_15_A_6;
  wire       [31:0]   addKernel_15_A_7;
  wire       [31:0]   addKernel_15_A_8;
  wire       [31:0]   addKernel_16_A_0;
  wire       [31:0]   addKernel_16_A_1;
  wire       [31:0]   addKernel_16_A_2;
  wire       [31:0]   addKernel_16_A_3;
  wire       [31:0]   addKernel_16_A_4;
  wire       [31:0]   addKernel_16_A_5;
  wire       [31:0]   addKernel_16_A_6;
  wire       [31:0]   addKernel_16_A_7;
  wire       [31:0]   addKernel_16_A_8;
  wire       [31:0]   addKernel_17_A_0;
  wire       [31:0]   addKernel_17_A_1;
  wire       [31:0]   addKernel_17_A_2;
  wire       [31:0]   addKernel_17_A_3;
  wire       [31:0]   addKernel_17_A_4;
  wire       [31:0]   addKernel_17_A_5;
  wire       [31:0]   addKernel_17_A_6;
  wire       [31:0]   addKernel_17_A_7;
  wire       [31:0]   addKernel_17_A_8;
  wire       [31:0]   addKernel_18_A_0;
  wire       [31:0]   addKernel_18_A_1;
  wire       [31:0]   addKernel_18_A_2;
  wire       [31:0]   addKernel_18_A_3;
  wire       [31:0]   addKernel_18_A_4;
  wire       [31:0]   addKernel_18_A_5;
  wire       [31:0]   addKernel_18_A_6;
  wire       [31:0]   addKernel_18_A_7;
  wire       [31:0]   addKernel_18_A_8;
  wire       [31:0]   addKernel_19_A_0;
  wire       [31:0]   addKernel_19_A_1;
  wire       [31:0]   addKernel_19_A_2;
  wire       [31:0]   addKernel_19_A_3;
  wire       [31:0]   addKernel_19_A_4;
  wire       [31:0]   addKernel_19_A_5;
  wire       [31:0]   addKernel_19_A_6;
  wire       [31:0]   addKernel_19_A_7;
  wire       [31:0]   addKernel_19_A_8;
  wire       [31:0]   addKernel_20_A_0;
  wire       [31:0]   addKernel_20_A_1;
  wire       [31:0]   addKernel_20_A_2;
  wire       [31:0]   addKernel_20_A_3;
  wire       [31:0]   addKernel_20_A_4;
  wire       [31:0]   addKernel_20_A_5;
  wire       [31:0]   addKernel_20_A_6;
  wire       [31:0]   addKernel_20_A_7;
  wire       [31:0]   addKernel_20_A_8;
  wire       [31:0]   addKernel_21_A_0;
  wire       [31:0]   addKernel_21_A_1;
  wire       [31:0]   addKernel_21_A_2;
  wire       [31:0]   addKernel_21_A_3;
  wire       [31:0]   addKernel_21_A_4;
  wire       [31:0]   addKernel_21_A_5;
  wire       [31:0]   addKernel_21_A_6;
  wire       [31:0]   addKernel_21_A_7;
  wire       [31:0]   addKernel_21_A_8;
  wire       [31:0]   addKernel_22_A_0;
  wire       [31:0]   addKernel_22_A_1;
  wire       [31:0]   addKernel_22_A_2;
  wire       [31:0]   addKernel_22_A_3;
  wire       [31:0]   addKernel_22_A_4;
  wire       [31:0]   addKernel_22_A_5;
  wire       [31:0]   addKernel_22_A_6;
  wire       [31:0]   addKernel_22_A_7;
  wire       [31:0]   addKernel_22_A_8;
  wire       [31:0]   addKernel_23_A_0;
  wire       [31:0]   addKernel_23_A_1;
  wire       [31:0]   addKernel_23_A_2;
  wire       [31:0]   addKernel_23_A_3;
  wire       [31:0]   addKernel_23_A_4;
  wire       [31:0]   addKernel_23_A_5;
  wire       [31:0]   addKernel_23_A_6;
  wire       [31:0]   addKernel_23_A_7;
  wire       [31:0]   addKernel_23_A_8;
  wire       [31:0]   addKernel_24_A_0;
  wire       [31:0]   addKernel_24_A_1;
  wire       [31:0]   addKernel_24_A_2;
  wire       [31:0]   addKernel_24_A_3;
  wire       [31:0]   addKernel_24_A_4;
  wire       [31:0]   addKernel_24_A_5;
  wire       [31:0]   addKernel_24_A_6;
  wire       [31:0]   addKernel_24_A_7;
  wire       [31:0]   addKernel_24_A_8;
  wire       [31:0]   addKernel_25_A_0;
  wire       [31:0]   addKernel_25_A_1;
  wire       [31:0]   addKernel_25_A_2;
  wire       [31:0]   addKernel_25_A_3;
  wire       [31:0]   addKernel_25_A_4;
  wire       [31:0]   addKernel_25_A_5;
  wire       [31:0]   addKernel_25_A_6;
  wire       [31:0]   addKernel_25_A_7;
  wire       [31:0]   addKernel_25_A_8;
  wire       [31:0]   addKernel_26_A_0;
  wire       [31:0]   addKernel_26_A_1;
  wire       [31:0]   addKernel_26_A_2;
  wire       [31:0]   addKernel_26_A_3;
  wire       [31:0]   addKernel_26_A_4;
  wire       [31:0]   addKernel_26_A_5;
  wire       [31:0]   addKernel_26_A_6;
  wire       [31:0]   addKernel_26_A_7;
  wire       [31:0]   addKernel_26_A_8;
  wire       [31:0]   addKernel_27_A_0;
  wire       [31:0]   addKernel_27_A_1;
  wire       [31:0]   addKernel_27_A_2;
  wire       [31:0]   addKernel_27_A_3;
  wire       [31:0]   addKernel_27_A_4;
  wire       [31:0]   addKernel_27_A_5;
  wire       [31:0]   addKernel_27_A_6;
  wire       [31:0]   addKernel_27_A_7;
  wire       [31:0]   addKernel_27_A_8;
  wire       [31:0]   addKernel_28_A_0;
  wire       [31:0]   addKernel_28_A_1;
  wire       [31:0]   addKernel_28_A_2;
  wire       [31:0]   addKernel_28_A_3;
  wire       [31:0]   addKernel_28_A_4;
  wire       [31:0]   addKernel_28_A_5;
  wire       [31:0]   addKernel_28_A_6;
  wire       [31:0]   addKernel_28_A_7;
  wire       [31:0]   addKernel_28_A_8;
  wire       [31:0]   addKernel_29_A_0;
  wire       [31:0]   addKernel_29_A_1;
  wire       [31:0]   addKernel_29_A_2;
  wire       [31:0]   addKernel_29_A_3;
  wire       [31:0]   addKernel_29_A_4;
  wire       [31:0]   addKernel_29_A_5;
  wire       [31:0]   addKernel_29_A_6;
  wire       [31:0]   addKernel_29_A_7;
  wire       [31:0]   addKernel_29_A_8;
  wire       [31:0]   addKernel_30_A_0;
  wire       [31:0]   addKernel_30_A_1;
  wire       [31:0]   addKernel_30_A_2;
  wire       [31:0]   addKernel_30_A_3;
  wire       [31:0]   addKernel_30_A_4;
  wire       [31:0]   addKernel_30_A_5;
  wire       [31:0]   addKernel_30_A_6;
  wire       [31:0]   addKernel_30_A_7;
  wire       [31:0]   addKernel_30_A_8;
  wire       [31:0]   addKernel_31_A_0;
  wire       [31:0]   addKernel_31_A_1;
  wire       [31:0]   addKernel_31_A_2;
  wire       [31:0]   addKernel_31_A_3;
  wire       [31:0]   addKernel_31_A_4;
  wire       [31:0]   addKernel_31_A_5;
  wire       [31:0]   addKernel_31_A_6;
  wire       [31:0]   addKernel_31_A_7;
  wire       [31:0]   addKernel_31_A_8;
  wire       [22:0]   xAddChannelTimes_8_A;
  wire       [22:0]   xAddChannelTimes_9_A;
  wire       [22:0]   xAddChannelTimes_10_A;
  wire       [22:0]   xAddChannelTimes_11_A;
  wire       [22:0]   xAddChannelTimes_12_A;
  wire       [22:0]   xAddChannelTimes_13_A;
  wire       [22:0]   xAddChannelTimes_14_A;
  wire       [22:0]   xAddChannelTimes_15_A;
  wire       [63:0]   _zz_featureMem_0_port1;
  wire       [63:0]   _zz_featureMem_1_port1;
  wire       [63:0]   _zz_featureMem_2_port1;
  wire       [63:0]   _zz_featureMem_3_port1;
  wire       [63:0]   _zz_featureMem_4_port1;
  wire       [63:0]   _zz_featureMem_5_port1;
  wire       [63:0]   _zz_featureMem_6_port1;
  wire       [63:0]   _zz_featureMem_7_port1;
  wire       [63:0]   _zz_featureMem_8_port1;
  wire                dataGenerate_1_sData_ready;
  wire                dataGenerate_1_mData_mData_0_valid;
  wire       [63:0]   dataGenerate_1_mData_mData_0_payload;
  wire                dataGenerate_1_mData_mData_1_valid;
  wire       [63:0]   dataGenerate_1_mData_mData_1_payload;
  wire                dataGenerate_1_mData_mData_2_valid;
  wire       [63:0]   dataGenerate_1_mData_mData_2_payload;
  wire                dataGenerate_1_mData_mData_3_valid;
  wire       [63:0]   dataGenerate_1_mData_mData_3_payload;
  wire                dataGenerate_1_mData_mData_4_valid;
  wire       [63:0]   dataGenerate_1_mData_mData_4_payload;
  wire                dataGenerate_1_mData_mData_5_valid;
  wire       [63:0]   dataGenerate_1_mData_mData_5_payload;
  wire                dataGenerate_1_mData_mData_6_valid;
  wire       [63:0]   dataGenerate_1_mData_mData_6_payload;
  wire                dataGenerate_1_mData_mData_7_valid;
  wire       [63:0]   dataGenerate_1_mData_mData_7_payload;
  wire                dataGenerate_1_mData_mData_8_valid;
  wire       [63:0]   dataGenerate_1_mData_mData_8_payload;
  wire                computeCtrl_mDataValid;
  wire                computeCtrl_normValid;
  wire                computeCtrl_normPreValid;
  wire                computeCtrl_normEnd;
  wire       [5:0]    computeCtrl_featureMemReadAddr;
  wire       [5:0]    computeCtrl_featureMemWriteAddr;
  wire                computeCtrl_featureMemWriteReady;
  wire       [9:0]    computeCtrl_weightReadAddr_0;
  wire       [9:0]    computeCtrl_weightReadAddr_1;
  wire       [9:0]    computeCtrl_weightReadAddr_2;
  wire       [9:0]    computeCtrl_weightReadAddr_3;
  wire       [9:0]    computeCtrl_weightReadAddr_4;
  wire       [9:0]    computeCtrl_weightReadAddr_5;
  wire       [9:0]    computeCtrl_weightReadAddr_6;
  wire       [9:0]    computeCtrl_weightReadAddr_7;
  wire       [9:0]    computeCtrl_weightReadAddr_8;
  wire       [6:0]    computeCtrl_biasReadAddr;
  wire       [6:0]    computeCtrl_scaleReadAddr;
  wire       [6:0]    computeCtrl_shiftReadAddr;
  wire       [10:0]   computeCtrl_sCount;
  wire       [10:0]   computeCtrl_mCount;
  wire                loadWeight_1_sData_ready;
  wire       [511:0]  loadWeight_1_weightRead_0_data;
  wire       [511:0]  loadWeight_1_weightRead_1_data;
  wire       [511:0]  loadWeight_1_weightRead_2_data;
  wire       [511:0]  loadWeight_1_weightRead_3_data;
  wire       [511:0]  loadWeight_1_weightRead_4_data;
  wire       [511:0]  loadWeight_1_weightRead_5_data;
  wire       [511:0]  loadWeight_1_weightRead_6_data;
  wire       [511:0]  loadWeight_1_weightRead_7_data;
  wire       [511:0]  loadWeight_1_weightRead_8_data;
  wire       [255:0]  loadWeight_1_biasRead_data;
  wire       [255:0]  loadWeight_1_scaleRead_data;
  wire       [255:0]  loadWeight_1_shiftRead_data;
  wire                loadWeight_1_copyWeightDone;
  wire                featureFifo_0_sReady;
  wire                featureFifo_0_mReady;
  wire       [63:0]   featureFifo_0_dout;
  wire                featureFifo_1_sReady;
  wire                featureFifo_1_mReady;
  wire       [63:0]   featureFifo_1_dout;
  wire                featureFifo_2_sReady;
  wire                featureFifo_2_mReady;
  wire       [63:0]   featureFifo_2_dout;
  wire                featureFifo_3_sReady;
  wire                featureFifo_3_mReady;
  wire       [63:0]   featureFifo_3_dout;
  wire                featureFifo_4_sReady;
  wire                featureFifo_4_mReady;
  wire       [63:0]   featureFifo_4_dout;
  wire                featureFifo_5_sReady;
  wire                featureFifo_5_mReady;
  wire       [63:0]   featureFifo_5_dout;
  wire                featureFifo_6_sReady;
  wire                featureFifo_6_mReady;
  wire       [63:0]   featureFifo_6_dout;
  wire                featureFifo_7_sReady;
  wire                featureFifo_7_mReady;
  wire       [63:0]   featureFifo_7_dout;
  wire                featureFifo_8_sReady;
  wire                featureFifo_8_mReady;
  wire       [63:0]   featureFifo_8_dout;
  wire       [63:0]   dSP_1_p;
  wire       [63:0]   dSP_2_p;
  wire       [63:0]   dSP_3_p;
  wire       [63:0]   dSP_4_p;
  wire       [63:0]   dSP_5_p;
  wire       [63:0]   dSP_6_p;
  wire       [63:0]   dSP_7_p;
  wire       [63:0]   dSP_8_p;
  wire       [63:0]   dSP_9_p;
  wire       [63:0]   dSP_10_p;
  wire       [63:0]   dSP_11_p;
  wire       [63:0]   dSP_12_p;
  wire       [63:0]   dSP_13_p;
  wire       [63:0]   dSP_14_p;
  wire       [63:0]   dSP_15_p;
  wire       [63:0]   dSP_16_p;
  wire       [63:0]   dSP_17_p;
  wire       [63:0]   dSP_18_p;
  wire       [63:0]   dSP_19_p;
  wire       [63:0]   dSP_20_p;
  wire       [63:0]   dSP_21_p;
  wire       [63:0]   dSP_22_p;
  wire       [63:0]   dSP_23_p;
  wire       [63:0]   dSP_24_p;
  wire       [63:0]   dSP_25_p;
  wire       [63:0]   dSP_26_p;
  wire       [63:0]   dSP_27_p;
  wire       [63:0]   dSP_28_p;
  wire       [63:0]   dSP_29_p;
  wire       [63:0]   dSP_30_p;
  wire       [63:0]   dSP_31_p;
  wire       [63:0]   dSP_32_p;
  wire       [63:0]   dSP_33_p;
  wire       [63:0]   dSP_34_p;
  wire       [63:0]   dSP_35_p;
  wire       [63:0]   dSP_36_p;
  wire       [63:0]   dSP_37_p;
  wire       [63:0]   dSP_38_p;
  wire       [63:0]   dSP_39_p;
  wire       [63:0]   dSP_40_p;
  wire       [63:0]   dSP_41_p;
  wire       [63:0]   dSP_42_p;
  wire       [63:0]   dSP_43_p;
  wire       [63:0]   dSP_44_p;
  wire       [63:0]   dSP_45_p;
  wire       [63:0]   dSP_46_p;
  wire       [63:0]   dSP_47_p;
  wire       [63:0]   dSP_48_p;
  wire       [63:0]   dSP_49_p;
  wire       [63:0]   dSP_50_p;
  wire       [63:0]   dSP_51_p;
  wire       [63:0]   dSP_52_p;
  wire       [63:0]   dSP_53_p;
  wire       [63:0]   dSP_54_p;
  wire       [63:0]   dSP_55_p;
  wire       [63:0]   dSP_56_p;
  wire       [63:0]   dSP_57_p;
  wire       [63:0]   dSP_58_p;
  wire       [63:0]   dSP_59_p;
  wire       [63:0]   dSP_60_p;
  wire       [63:0]   dSP_61_p;
  wire       [63:0]   dSP_62_p;
  wire       [63:0]   dSP_63_p;
  wire       [63:0]   dSP_64_p;
  wire       [63:0]   dSP_65_p;
  wire       [63:0]   dSP_66_p;
  wire       [63:0]   dSP_67_p;
  wire       [63:0]   dSP_68_p;
  wire       [63:0]   dSP_69_p;
  wire       [63:0]   dSP_70_p;
  wire       [63:0]   dSP_71_p;
  wire       [63:0]   dSP_72_p;
  wire       [63:0]   dSP_73_p;
  wire       [63:0]   dSP_74_p;
  wire       [63:0]   dSP_75_p;
  wire       [63:0]   dSP_76_p;
  wire       [63:0]   dSP_77_p;
  wire       [63:0]   dSP_78_p;
  wire       [63:0]   dSP_79_p;
  wire       [63:0]   dSP_80_p;
  wire       [63:0]   dSP_81_p;
  wire       [63:0]   dSP_82_p;
  wire       [63:0]   dSP_83_p;
  wire       [63:0]   dSP_84_p;
  wire       [63:0]   dSP_85_p;
  wire       [63:0]   dSP_86_p;
  wire       [63:0]   dSP_87_p;
  wire       [63:0]   dSP_88_p;
  wire       [63:0]   dSP_89_p;
  wire       [63:0]   dSP_90_p;
  wire       [63:0]   dSP_91_p;
  wire       [63:0]   dSP_92_p;
  wire       [63:0]   dSP_93_p;
  wire       [63:0]   dSP_94_p;
  wire       [63:0]   dSP_95_p;
  wire       [63:0]   dSP_96_p;
  wire       [63:0]   dSP_97_p;
  wire       [63:0]   dSP_98_p;
  wire       [63:0]   dSP_99_p;
  wire       [63:0]   dSP_100_p;
  wire       [63:0]   dSP_101_p;
  wire       [63:0]   dSP_102_p;
  wire       [63:0]   dSP_103_p;
  wire       [63:0]   dSP_104_p;
  wire       [63:0]   dSP_105_p;
  wire       [63:0]   dSP_106_p;
  wire       [63:0]   dSP_107_p;
  wire       [63:0]   dSP_108_p;
  wire       [63:0]   dSP_109_p;
  wire       [63:0]   dSP_110_p;
  wire       [63:0]   dSP_111_p;
  wire       [63:0]   dSP_112_p;
  wire       [63:0]   dSP_113_p;
  wire       [63:0]   dSP_114_p;
  wire       [63:0]   dSP_115_p;
  wire       [63:0]   dSP_116_p;
  wire       [63:0]   dSP_117_p;
  wire       [63:0]   dSP_118_p;
  wire       [63:0]   dSP_119_p;
  wire       [63:0]   dSP_120_p;
  wire       [63:0]   dSP_121_p;
  wire       [63:0]   dSP_122_p;
  wire       [63:0]   dSP_123_p;
  wire       [63:0]   dSP_124_p;
  wire       [63:0]   dSP_125_p;
  wire       [63:0]   dSP_126_p;
  wire       [63:0]   dSP_127_p;
  wire       [63:0]   dSP_128_p;
  wire       [63:0]   dSP_129_p;
  wire       [63:0]   dSP_130_p;
  wire       [63:0]   dSP_131_p;
  wire       [63:0]   dSP_132_p;
  wire       [63:0]   dSP_133_p;
  wire       [63:0]   dSP_134_p;
  wire       [63:0]   dSP_135_p;
  wire       [63:0]   dSP_136_p;
  wire       [63:0]   dSP_137_p;
  wire       [63:0]   dSP_138_p;
  wire       [63:0]   dSP_139_p;
  wire       [63:0]   dSP_140_p;
  wire       [63:0]   dSP_141_p;
  wire       [63:0]   dSP_142_p;
  wire       [63:0]   dSP_143_p;
  wire       [63:0]   dSP_144_p;
  wire       [39:0]   addKernel_S;
  wire       [39:0]   addKernel_1_S;
  wire       [39:0]   addKernel_2_S;
  wire       [39:0]   addKernel_3_S;
  wire       [39:0]   addKernel_4_S;
  wire       [39:0]   addKernel_5_S;
  wire       [39:0]   addKernel_6_S;
  wire       [39:0]   addKernel_7_S;
  wire       [39:0]   addKernel_8_S;
  wire       [39:0]   addKernel_9_S;
  wire       [39:0]   addKernel_10_S;
  wire       [39:0]   addKernel_11_S;
  wire       [39:0]   addKernel_12_S;
  wire       [39:0]   addKernel_13_S;
  wire       [39:0]   addKernel_14_S;
  wire       [39:0]   addKernel_15_S;
  wire       [39:0]   addKernel_16_S;
  wire       [39:0]   addKernel_17_S;
  wire       [39:0]   addKernel_18_S;
  wire       [39:0]   addKernel_19_S;
  wire       [39:0]   addKernel_20_S;
  wire       [39:0]   addKernel_21_S;
  wire       [39:0]   addKernel_22_S;
  wire       [39:0]   addKernel_23_S;
  wire       [39:0]   addKernel_24_S;
  wire       [39:0]   addKernel_25_S;
  wire       [39:0]   addKernel_26_S;
  wire       [39:0]   addKernel_27_S;
  wire       [39:0]   addKernel_28_S;
  wire       [39:0]   addKernel_29_S;
  wire       [39:0]   addKernel_30_S;
  wire       [39:0]   addKernel_31_S;
  wire       [45:0]   xAddTimes_36_S;
  wire       [45:0]   xAddTimes_37_S;
  wire       [45:0]   xAddTimes_38_S;
  wire       [45:0]   xAddTimes_39_S;
  wire       [31:0]   xAddChannelTimes_8_S;
  wire       [31:0]   xAddChannelTimes_9_S;
  wire       [31:0]   xAddChannelTimes_10_S;
  wire       [31:0]   xAddChannelTimes_11_S;
  wire       [31:0]   xAddChannelTimes_12_S;
  wire       [31:0]   xAddChannelTimes_13_S;
  wire       [31:0]   xAddChannelTimes_14_S;
  wire       [31:0]   xAddChannelTimes_15_S;
  wire       [63:0]   quan_1_dataOut;
  wire                stride_1_sData_ready;
  wire                stride_1_mData_valid;
  wire       [63:0]   stride_1_mData_payload;
  wire                stride_1_sReady;
  wire                stride_1_complete;
  wire       [63:0]   _zz_featureMem_0_port;
  wire       [63:0]   _zz_featureMem_1_port;
  wire       [63:0]   _zz_featureMem_2_port;
  wire       [63:0]   _zz_featureMem_3_port;
  wire       [63:0]   _zz_featureMem_4_port;
  wire       [63:0]   _zz_featureMem_5_port;
  wire       [63:0]   _zz_featureMem_6_port;
  wire       [63:0]   _zz_featureMem_7_port;
  wire       [63:0]   _zz_featureMem_8_port;
  reg        [1:0]    convType_1;
  wire                sReady_0;
  wire                sReady_1;
  wire                sReady_2;
  wire                sReady_3;
  wire                sReady_4;
  wire                sReady_5;
  wire                sReady_6;
  wire                sReady_7;
  wire                sReady_8;
  wire                mReady_0;
  wire                mReady_1;
  wire                mReady_2;
  wire                mReady_3;
  wire                mReady_4;
  wire                mReady_5;
  wire                mReady_6;
  wire                mReady_7;
  wire                mReady_8;
  wire       [63:0]   featureMemOutData_0;
  wire       [63:0]   featureMemOutData_1;
  wire       [63:0]   featureMemOutData_2;
  wire       [63:0]   featureMemOutData_3;
  wire       [63:0]   featureMemOutData_4;
  wire       [63:0]   featureMemOutData_5;
  wire       [63:0]   featureMemOutData_6;
  wire       [63:0]   featureMemOutData_7;
  wire       [63:0]   featureMemOutData_8;
  wire       [31:0]   mulFeatureWeightData_0_0_0;
  wire       [31:0]   mulFeatureWeightData_0_0_1;
  wire       [31:0]   mulFeatureWeightData_0_0_2;
  wire       [31:0]   mulFeatureWeightData_0_0_3;
  wire       [31:0]   mulFeatureWeightData_0_0_4;
  wire       [31:0]   mulFeatureWeightData_0_0_5;
  wire       [31:0]   mulFeatureWeightData_0_0_6;
  wire       [31:0]   mulFeatureWeightData_0_0_7;
  wire       [31:0]   mulFeatureWeightData_0_1_0;
  wire       [31:0]   mulFeatureWeightData_0_1_1;
  wire       [31:0]   mulFeatureWeightData_0_1_2;
  wire       [31:0]   mulFeatureWeightData_0_1_3;
  wire       [31:0]   mulFeatureWeightData_0_1_4;
  wire       [31:0]   mulFeatureWeightData_0_1_5;
  wire       [31:0]   mulFeatureWeightData_0_1_6;
  wire       [31:0]   mulFeatureWeightData_0_1_7;
  wire       [31:0]   mulFeatureWeightData_0_2_0;
  wire       [31:0]   mulFeatureWeightData_0_2_1;
  wire       [31:0]   mulFeatureWeightData_0_2_2;
  wire       [31:0]   mulFeatureWeightData_0_2_3;
  wire       [31:0]   mulFeatureWeightData_0_2_4;
  wire       [31:0]   mulFeatureWeightData_0_2_5;
  wire       [31:0]   mulFeatureWeightData_0_2_6;
  wire       [31:0]   mulFeatureWeightData_0_2_7;
  wire       [31:0]   mulFeatureWeightData_0_3_0;
  wire       [31:0]   mulFeatureWeightData_0_3_1;
  wire       [31:0]   mulFeatureWeightData_0_3_2;
  wire       [31:0]   mulFeatureWeightData_0_3_3;
  wire       [31:0]   mulFeatureWeightData_0_3_4;
  wire       [31:0]   mulFeatureWeightData_0_3_5;
  wire       [31:0]   mulFeatureWeightData_0_3_6;
  wire       [31:0]   mulFeatureWeightData_0_3_7;
  wire       [31:0]   mulFeatureWeightData_1_0_0;
  wire       [31:0]   mulFeatureWeightData_1_0_1;
  wire       [31:0]   mulFeatureWeightData_1_0_2;
  wire       [31:0]   mulFeatureWeightData_1_0_3;
  wire       [31:0]   mulFeatureWeightData_1_0_4;
  wire       [31:0]   mulFeatureWeightData_1_0_5;
  wire       [31:0]   mulFeatureWeightData_1_0_6;
  wire       [31:0]   mulFeatureWeightData_1_0_7;
  wire       [31:0]   mulFeatureWeightData_1_1_0;
  wire       [31:0]   mulFeatureWeightData_1_1_1;
  wire       [31:0]   mulFeatureWeightData_1_1_2;
  wire       [31:0]   mulFeatureWeightData_1_1_3;
  wire       [31:0]   mulFeatureWeightData_1_1_4;
  wire       [31:0]   mulFeatureWeightData_1_1_5;
  wire       [31:0]   mulFeatureWeightData_1_1_6;
  wire       [31:0]   mulFeatureWeightData_1_1_7;
  wire       [31:0]   mulFeatureWeightData_1_2_0;
  wire       [31:0]   mulFeatureWeightData_1_2_1;
  wire       [31:0]   mulFeatureWeightData_1_2_2;
  wire       [31:0]   mulFeatureWeightData_1_2_3;
  wire       [31:0]   mulFeatureWeightData_1_2_4;
  wire       [31:0]   mulFeatureWeightData_1_2_5;
  wire       [31:0]   mulFeatureWeightData_1_2_6;
  wire       [31:0]   mulFeatureWeightData_1_2_7;
  wire       [31:0]   mulFeatureWeightData_1_3_0;
  wire       [31:0]   mulFeatureWeightData_1_3_1;
  wire       [31:0]   mulFeatureWeightData_1_3_2;
  wire       [31:0]   mulFeatureWeightData_1_3_3;
  wire       [31:0]   mulFeatureWeightData_1_3_4;
  wire       [31:0]   mulFeatureWeightData_1_3_5;
  wire       [31:0]   mulFeatureWeightData_1_3_6;
  wire       [31:0]   mulFeatureWeightData_1_3_7;
  wire       [31:0]   mulFeatureWeightData_2_0_0;
  wire       [31:0]   mulFeatureWeightData_2_0_1;
  wire       [31:0]   mulFeatureWeightData_2_0_2;
  wire       [31:0]   mulFeatureWeightData_2_0_3;
  wire       [31:0]   mulFeatureWeightData_2_0_4;
  wire       [31:0]   mulFeatureWeightData_2_0_5;
  wire       [31:0]   mulFeatureWeightData_2_0_6;
  wire       [31:0]   mulFeatureWeightData_2_0_7;
  wire       [31:0]   mulFeatureWeightData_2_1_0;
  wire       [31:0]   mulFeatureWeightData_2_1_1;
  wire       [31:0]   mulFeatureWeightData_2_1_2;
  wire       [31:0]   mulFeatureWeightData_2_1_3;
  wire       [31:0]   mulFeatureWeightData_2_1_4;
  wire       [31:0]   mulFeatureWeightData_2_1_5;
  wire       [31:0]   mulFeatureWeightData_2_1_6;
  wire       [31:0]   mulFeatureWeightData_2_1_7;
  wire       [31:0]   mulFeatureWeightData_2_2_0;
  wire       [31:0]   mulFeatureWeightData_2_2_1;
  wire       [31:0]   mulFeatureWeightData_2_2_2;
  wire       [31:0]   mulFeatureWeightData_2_2_3;
  wire       [31:0]   mulFeatureWeightData_2_2_4;
  wire       [31:0]   mulFeatureWeightData_2_2_5;
  wire       [31:0]   mulFeatureWeightData_2_2_6;
  wire       [31:0]   mulFeatureWeightData_2_2_7;
  wire       [31:0]   mulFeatureWeightData_2_3_0;
  wire       [31:0]   mulFeatureWeightData_2_3_1;
  wire       [31:0]   mulFeatureWeightData_2_3_2;
  wire       [31:0]   mulFeatureWeightData_2_3_3;
  wire       [31:0]   mulFeatureWeightData_2_3_4;
  wire       [31:0]   mulFeatureWeightData_2_3_5;
  wire       [31:0]   mulFeatureWeightData_2_3_6;
  wire       [31:0]   mulFeatureWeightData_2_3_7;
  wire       [31:0]   mulFeatureWeightData_3_0_0;
  wire       [31:0]   mulFeatureWeightData_3_0_1;
  wire       [31:0]   mulFeatureWeightData_3_0_2;
  wire       [31:0]   mulFeatureWeightData_3_0_3;
  wire       [31:0]   mulFeatureWeightData_3_0_4;
  wire       [31:0]   mulFeatureWeightData_3_0_5;
  wire       [31:0]   mulFeatureWeightData_3_0_6;
  wire       [31:0]   mulFeatureWeightData_3_0_7;
  wire       [31:0]   mulFeatureWeightData_3_1_0;
  wire       [31:0]   mulFeatureWeightData_3_1_1;
  wire       [31:0]   mulFeatureWeightData_3_1_2;
  wire       [31:0]   mulFeatureWeightData_3_1_3;
  wire       [31:0]   mulFeatureWeightData_3_1_4;
  wire       [31:0]   mulFeatureWeightData_3_1_5;
  wire       [31:0]   mulFeatureWeightData_3_1_6;
  wire       [31:0]   mulFeatureWeightData_3_1_7;
  wire       [31:0]   mulFeatureWeightData_3_2_0;
  wire       [31:0]   mulFeatureWeightData_3_2_1;
  wire       [31:0]   mulFeatureWeightData_3_2_2;
  wire       [31:0]   mulFeatureWeightData_3_2_3;
  wire       [31:0]   mulFeatureWeightData_3_2_4;
  wire       [31:0]   mulFeatureWeightData_3_2_5;
  wire       [31:0]   mulFeatureWeightData_3_2_6;
  wire       [31:0]   mulFeatureWeightData_3_2_7;
  wire       [31:0]   mulFeatureWeightData_3_3_0;
  wire       [31:0]   mulFeatureWeightData_3_3_1;
  wire       [31:0]   mulFeatureWeightData_3_3_2;
  wire       [31:0]   mulFeatureWeightData_3_3_3;
  wire       [31:0]   mulFeatureWeightData_3_3_4;
  wire       [31:0]   mulFeatureWeightData_3_3_5;
  wire       [31:0]   mulFeatureWeightData_3_3_6;
  wire       [31:0]   mulFeatureWeightData_3_3_7;
  wire       [31:0]   mulFeatureWeightData_4_0_0;
  wire       [31:0]   mulFeatureWeightData_4_0_1;
  wire       [31:0]   mulFeatureWeightData_4_0_2;
  wire       [31:0]   mulFeatureWeightData_4_0_3;
  wire       [31:0]   mulFeatureWeightData_4_0_4;
  wire       [31:0]   mulFeatureWeightData_4_0_5;
  wire       [31:0]   mulFeatureWeightData_4_0_6;
  wire       [31:0]   mulFeatureWeightData_4_0_7;
  wire       [31:0]   mulFeatureWeightData_4_1_0;
  wire       [31:0]   mulFeatureWeightData_4_1_1;
  wire       [31:0]   mulFeatureWeightData_4_1_2;
  wire       [31:0]   mulFeatureWeightData_4_1_3;
  wire       [31:0]   mulFeatureWeightData_4_1_4;
  wire       [31:0]   mulFeatureWeightData_4_1_5;
  wire       [31:0]   mulFeatureWeightData_4_1_6;
  wire       [31:0]   mulFeatureWeightData_4_1_7;
  wire       [31:0]   mulFeatureWeightData_4_2_0;
  wire       [31:0]   mulFeatureWeightData_4_2_1;
  wire       [31:0]   mulFeatureWeightData_4_2_2;
  wire       [31:0]   mulFeatureWeightData_4_2_3;
  wire       [31:0]   mulFeatureWeightData_4_2_4;
  wire       [31:0]   mulFeatureWeightData_4_2_5;
  wire       [31:0]   mulFeatureWeightData_4_2_6;
  wire       [31:0]   mulFeatureWeightData_4_2_7;
  wire       [31:0]   mulFeatureWeightData_4_3_0;
  wire       [31:0]   mulFeatureWeightData_4_3_1;
  wire       [31:0]   mulFeatureWeightData_4_3_2;
  wire       [31:0]   mulFeatureWeightData_4_3_3;
  wire       [31:0]   mulFeatureWeightData_4_3_4;
  wire       [31:0]   mulFeatureWeightData_4_3_5;
  wire       [31:0]   mulFeatureWeightData_4_3_6;
  wire       [31:0]   mulFeatureWeightData_4_3_7;
  wire       [31:0]   mulFeatureWeightData_5_0_0;
  wire       [31:0]   mulFeatureWeightData_5_0_1;
  wire       [31:0]   mulFeatureWeightData_5_0_2;
  wire       [31:0]   mulFeatureWeightData_5_0_3;
  wire       [31:0]   mulFeatureWeightData_5_0_4;
  wire       [31:0]   mulFeatureWeightData_5_0_5;
  wire       [31:0]   mulFeatureWeightData_5_0_6;
  wire       [31:0]   mulFeatureWeightData_5_0_7;
  wire       [31:0]   mulFeatureWeightData_5_1_0;
  wire       [31:0]   mulFeatureWeightData_5_1_1;
  wire       [31:0]   mulFeatureWeightData_5_1_2;
  wire       [31:0]   mulFeatureWeightData_5_1_3;
  wire       [31:0]   mulFeatureWeightData_5_1_4;
  wire       [31:0]   mulFeatureWeightData_5_1_5;
  wire       [31:0]   mulFeatureWeightData_5_1_6;
  wire       [31:0]   mulFeatureWeightData_5_1_7;
  wire       [31:0]   mulFeatureWeightData_5_2_0;
  wire       [31:0]   mulFeatureWeightData_5_2_1;
  wire       [31:0]   mulFeatureWeightData_5_2_2;
  wire       [31:0]   mulFeatureWeightData_5_2_3;
  wire       [31:0]   mulFeatureWeightData_5_2_4;
  wire       [31:0]   mulFeatureWeightData_5_2_5;
  wire       [31:0]   mulFeatureWeightData_5_2_6;
  wire       [31:0]   mulFeatureWeightData_5_2_7;
  wire       [31:0]   mulFeatureWeightData_5_3_0;
  wire       [31:0]   mulFeatureWeightData_5_3_1;
  wire       [31:0]   mulFeatureWeightData_5_3_2;
  wire       [31:0]   mulFeatureWeightData_5_3_3;
  wire       [31:0]   mulFeatureWeightData_5_3_4;
  wire       [31:0]   mulFeatureWeightData_5_3_5;
  wire       [31:0]   mulFeatureWeightData_5_3_6;
  wire       [31:0]   mulFeatureWeightData_5_3_7;
  wire       [31:0]   mulFeatureWeightData_6_0_0;
  wire       [31:0]   mulFeatureWeightData_6_0_1;
  wire       [31:0]   mulFeatureWeightData_6_0_2;
  wire       [31:0]   mulFeatureWeightData_6_0_3;
  wire       [31:0]   mulFeatureWeightData_6_0_4;
  wire       [31:0]   mulFeatureWeightData_6_0_5;
  wire       [31:0]   mulFeatureWeightData_6_0_6;
  wire       [31:0]   mulFeatureWeightData_6_0_7;
  wire       [31:0]   mulFeatureWeightData_6_1_0;
  wire       [31:0]   mulFeatureWeightData_6_1_1;
  wire       [31:0]   mulFeatureWeightData_6_1_2;
  wire       [31:0]   mulFeatureWeightData_6_1_3;
  wire       [31:0]   mulFeatureWeightData_6_1_4;
  wire       [31:0]   mulFeatureWeightData_6_1_5;
  wire       [31:0]   mulFeatureWeightData_6_1_6;
  wire       [31:0]   mulFeatureWeightData_6_1_7;
  wire       [31:0]   mulFeatureWeightData_6_2_0;
  wire       [31:0]   mulFeatureWeightData_6_2_1;
  wire       [31:0]   mulFeatureWeightData_6_2_2;
  wire       [31:0]   mulFeatureWeightData_6_2_3;
  wire       [31:0]   mulFeatureWeightData_6_2_4;
  wire       [31:0]   mulFeatureWeightData_6_2_5;
  wire       [31:0]   mulFeatureWeightData_6_2_6;
  wire       [31:0]   mulFeatureWeightData_6_2_7;
  wire       [31:0]   mulFeatureWeightData_6_3_0;
  wire       [31:0]   mulFeatureWeightData_6_3_1;
  wire       [31:0]   mulFeatureWeightData_6_3_2;
  wire       [31:0]   mulFeatureWeightData_6_3_3;
  wire       [31:0]   mulFeatureWeightData_6_3_4;
  wire       [31:0]   mulFeatureWeightData_6_3_5;
  wire       [31:0]   mulFeatureWeightData_6_3_6;
  wire       [31:0]   mulFeatureWeightData_6_3_7;
  wire       [31:0]   mulFeatureWeightData_7_0_0;
  wire       [31:0]   mulFeatureWeightData_7_0_1;
  wire       [31:0]   mulFeatureWeightData_7_0_2;
  wire       [31:0]   mulFeatureWeightData_7_0_3;
  wire       [31:0]   mulFeatureWeightData_7_0_4;
  wire       [31:0]   mulFeatureWeightData_7_0_5;
  wire       [31:0]   mulFeatureWeightData_7_0_6;
  wire       [31:0]   mulFeatureWeightData_7_0_7;
  wire       [31:0]   mulFeatureWeightData_7_1_0;
  wire       [31:0]   mulFeatureWeightData_7_1_1;
  wire       [31:0]   mulFeatureWeightData_7_1_2;
  wire       [31:0]   mulFeatureWeightData_7_1_3;
  wire       [31:0]   mulFeatureWeightData_7_1_4;
  wire       [31:0]   mulFeatureWeightData_7_1_5;
  wire       [31:0]   mulFeatureWeightData_7_1_6;
  wire       [31:0]   mulFeatureWeightData_7_1_7;
  wire       [31:0]   mulFeatureWeightData_7_2_0;
  wire       [31:0]   mulFeatureWeightData_7_2_1;
  wire       [31:0]   mulFeatureWeightData_7_2_2;
  wire       [31:0]   mulFeatureWeightData_7_2_3;
  wire       [31:0]   mulFeatureWeightData_7_2_4;
  wire       [31:0]   mulFeatureWeightData_7_2_5;
  wire       [31:0]   mulFeatureWeightData_7_2_6;
  wire       [31:0]   mulFeatureWeightData_7_2_7;
  wire       [31:0]   mulFeatureWeightData_7_3_0;
  wire       [31:0]   mulFeatureWeightData_7_3_1;
  wire       [31:0]   mulFeatureWeightData_7_3_2;
  wire       [31:0]   mulFeatureWeightData_7_3_3;
  wire       [31:0]   mulFeatureWeightData_7_3_4;
  wire       [31:0]   mulFeatureWeightData_7_3_5;
  wire       [31:0]   mulFeatureWeightData_7_3_6;
  wire       [31:0]   mulFeatureWeightData_7_3_7;
  wire       [31:0]   mulFeatureWeightData_8_0_0;
  wire       [31:0]   mulFeatureWeightData_8_0_1;
  wire       [31:0]   mulFeatureWeightData_8_0_2;
  wire       [31:0]   mulFeatureWeightData_8_0_3;
  wire       [31:0]   mulFeatureWeightData_8_0_4;
  wire       [31:0]   mulFeatureWeightData_8_0_5;
  wire       [31:0]   mulFeatureWeightData_8_0_6;
  wire       [31:0]   mulFeatureWeightData_8_0_7;
  wire       [31:0]   mulFeatureWeightData_8_1_0;
  wire       [31:0]   mulFeatureWeightData_8_1_1;
  wire       [31:0]   mulFeatureWeightData_8_1_2;
  wire       [31:0]   mulFeatureWeightData_8_1_3;
  wire       [31:0]   mulFeatureWeightData_8_1_4;
  wire       [31:0]   mulFeatureWeightData_8_1_5;
  wire       [31:0]   mulFeatureWeightData_8_1_6;
  wire       [31:0]   mulFeatureWeightData_8_1_7;
  wire       [31:0]   mulFeatureWeightData_8_2_0;
  wire       [31:0]   mulFeatureWeightData_8_2_1;
  wire       [31:0]   mulFeatureWeightData_8_2_2;
  wire       [31:0]   mulFeatureWeightData_8_2_3;
  wire       [31:0]   mulFeatureWeightData_8_2_4;
  wire       [31:0]   mulFeatureWeightData_8_2_5;
  wire       [31:0]   mulFeatureWeightData_8_2_6;
  wire       [31:0]   mulFeatureWeightData_8_2_7;
  wire       [31:0]   mulFeatureWeightData_8_3_0;
  wire       [31:0]   mulFeatureWeightData_8_3_1;
  wire       [31:0]   mulFeatureWeightData_8_3_2;
  wire       [31:0]   mulFeatureWeightData_8_3_3;
  wire       [31:0]   mulFeatureWeightData_8_3_4;
  wire       [31:0]   mulFeatureWeightData_8_3_5;
  wire       [31:0]   mulFeatureWeightData_8_3_6;
  wire       [31:0]   mulFeatureWeightData_8_3_7;
  wire       [39:0]   addKernelData_0_0;
  wire       [39:0]   addKernelData_0_1;
  wire       [39:0]   addKernelData_0_2;
  wire       [39:0]   addKernelData_0_3;
  wire       [39:0]   addKernelData_0_4;
  wire       [39:0]   addKernelData_0_5;
  wire       [39:0]   addKernelData_0_6;
  wire       [39:0]   addKernelData_0_7;
  wire       [39:0]   addKernelData_1_0;
  wire       [39:0]   addKernelData_1_1;
  wire       [39:0]   addKernelData_1_2;
  wire       [39:0]   addKernelData_1_3;
  wire       [39:0]   addKernelData_1_4;
  wire       [39:0]   addKernelData_1_5;
  wire       [39:0]   addKernelData_1_6;
  wire       [39:0]   addKernelData_1_7;
  wire       [39:0]   addKernelData_2_0;
  wire       [39:0]   addKernelData_2_1;
  wire       [39:0]   addKernelData_2_2;
  wire       [39:0]   addKernelData_2_3;
  wire       [39:0]   addKernelData_2_4;
  wire       [39:0]   addKernelData_2_5;
  wire       [39:0]   addKernelData_2_6;
  wire       [39:0]   addKernelData_2_7;
  wire       [39:0]   addKernelData_3_0;
  wire       [39:0]   addKernelData_3_1;
  wire       [39:0]   addKernelData_3_2;
  wire       [39:0]   addKernelData_3_3;
  wire       [39:0]   addKernelData_3_4;
  wire       [39:0]   addKernelData_3_5;
  wire       [39:0]   addKernelData_3_6;
  wire       [39:0]   addKernelData_3_7;
  wire       [45:0]   addChannelData_0;
  wire       [45:0]   addChannelData_1;
  wire       [45:0]   addChannelData_2;
  wire       [45:0]   addChannelData_3;
  wire       [31:0]   addChannelTimesData_0;
  wire       [31:0]   addChannelTimesData_1;
  wire       [31:0]   addChannelTimesData_2;
  wire       [31:0]   addChannelTimesData_3;
  wire       [31:0]   addChannelTimesData_4;
  wire       [31:0]   addChannelTimesData_5;
  wire       [31:0]   addChannelTimesData_6;
  wire       [31:0]   addChannelTimesData_7;
  (* ram_style = "distributed" *) reg [63:0] featureMem_0 [0:63];
  (* ram_style = "distributed" *) reg [63:0] featureMem_1 [0:63];
  (* ram_style = "distributed" *) reg [63:0] featureMem_2 [0:63];
  (* ram_style = "distributed" *) reg [63:0] featureMem_3 [0:63];
  (* ram_style = "distributed" *) reg [63:0] featureMem_4 [0:63];
  (* ram_style = "distributed" *) reg [63:0] featureMem_5 [0:63];
  (* ram_style = "distributed" *) reg [63:0] featureMem_6 [0:63];
  (* ram_style = "distributed" *) reg [63:0] featureMem_7 [0:63];
  (* ram_style = "distributed" *) reg [63:0] featureMem_8 [0:63];

  assign _zz_featureMem_0_port = featureFifo_0_dout;
  assign _zz_featureMem_1_port = featureFifo_1_dout;
  assign _zz_featureMem_2_port = featureFifo_2_dout;
  assign _zz_featureMem_3_port = featureFifo_3_dout;
  assign _zz_featureMem_4_port = featureFifo_4_dout;
  assign _zz_featureMem_5_port = featureFifo_5_dout;
  assign _zz_featureMem_6_port = featureFifo_6_dout;
  assign _zz_featureMem_7_port = featureFifo_7_dout;
  assign _zz_featureMem_8_port = featureFifo_8_dout;
  always @(posedge clk) begin
    if(computeCtrl_featureMemWriteReady) begin
      featureMem_0[computeCtrl_featureMemWriteAddr] <= _zz_featureMem_0_port;
    end
  end

  assign _zz_featureMem_0_port1 = featureMem_0[computeCtrl_featureMemReadAddr];
  always @(posedge clk) begin
    if(computeCtrl_featureMemWriteReady) begin
      featureMem_1[computeCtrl_featureMemWriteAddr] <= _zz_featureMem_1_port;
    end
  end

  assign _zz_featureMem_1_port1 = featureMem_1[computeCtrl_featureMemReadAddr];
  always @(posedge clk) begin
    if(computeCtrl_featureMemWriteReady) begin
      featureMem_2[computeCtrl_featureMemWriteAddr] <= _zz_featureMem_2_port;
    end
  end

  assign _zz_featureMem_2_port1 = featureMem_2[computeCtrl_featureMemReadAddr];
  always @(posedge clk) begin
    if(computeCtrl_featureMemWriteReady) begin
      featureMem_3[computeCtrl_featureMemWriteAddr] <= _zz_featureMem_3_port;
    end
  end

  assign _zz_featureMem_3_port1 = featureMem_3[computeCtrl_featureMemReadAddr];
  always @(posedge clk) begin
    if(computeCtrl_featureMemWriteReady) begin
      featureMem_4[computeCtrl_featureMemWriteAddr] <= _zz_featureMem_4_port;
    end
  end

  assign _zz_featureMem_4_port1 = featureMem_4[computeCtrl_featureMemReadAddr];
  always @(posedge clk) begin
    if(computeCtrl_featureMemWriteReady) begin
      featureMem_5[computeCtrl_featureMemWriteAddr] <= _zz_featureMem_5_port;
    end
  end

  assign _zz_featureMem_5_port1 = featureMem_5[computeCtrl_featureMemReadAddr];
  always @(posedge clk) begin
    if(computeCtrl_featureMemWriteReady) begin
      featureMem_6[computeCtrl_featureMemWriteAddr] <= _zz_featureMem_6_port;
    end
  end

  assign _zz_featureMem_6_port1 = featureMem_6[computeCtrl_featureMemReadAddr];
  always @(posedge clk) begin
    if(computeCtrl_featureMemWriteReady) begin
      featureMem_7[computeCtrl_featureMemWriteAddr] <= _zz_featureMem_7_port;
    end
  end

  assign _zz_featureMem_7_port1 = featureMem_7[computeCtrl_featureMemReadAddr];
  always @(posedge clk) begin
    if(computeCtrl_featureMemWriteReady) begin
      featureMem_8[computeCtrl_featureMemWriteAddr] <= _zz_featureMem_8_port;
    end
  end

  assign _zz_featureMem_8_port1 = featureMem_8[computeCtrl_featureMemReadAddr];
  DataGenerate dataGenerate_1 (
    .sData_valid           (sFeatureData_valid                        ), //i
    .sData_ready           (dataGenerate_1_sData_ready                ), //o
    .sData_payload         (sFeatureData_payload[63:0]                ), //i
    .start                 (startCu                                   ), //i
    .enPadding             (enPadding                                 ), //i
    .channelIn             (channelIn[11:0]                           ), //i
    .rowNumIn              (rowNumIn[8:0]                             ), //i
    .colNumIn              (colNumIn[8:0]                             ), //i
    .zeroDara              (zeroDara[7:0]                             ), //i
    .zeroNum               (zeroNum                                   ), //i
    .mData_mData_0_valid   (dataGenerate_1_mData_mData_0_valid        ), //o
    .mData_mData_0_payload (dataGenerate_1_mData_mData_0_payload[63:0]), //o
    .mData_mData_1_valid   (dataGenerate_1_mData_mData_1_valid        ), //o
    .mData_mData_1_payload (dataGenerate_1_mData_mData_1_payload[63:0]), //o
    .mData_mData_2_valid   (dataGenerate_1_mData_mData_2_valid        ), //o
    .mData_mData_2_payload (dataGenerate_1_mData_mData_2_payload[63:0]), //o
    .mData_mData_3_valid   (dataGenerate_1_mData_mData_3_valid        ), //o
    .mData_mData_3_payload (dataGenerate_1_mData_mData_3_payload[63:0]), //o
    .mData_mData_4_valid   (dataGenerate_1_mData_mData_4_valid        ), //o
    .mData_mData_4_payload (dataGenerate_1_mData_mData_4_payload[63:0]), //o
    .mData_mData_5_valid   (dataGenerate_1_mData_mData_5_valid        ), //o
    .mData_mData_5_payload (dataGenerate_1_mData_mData_5_payload[63:0]), //o
    .mData_mData_6_valid   (dataGenerate_1_mData_mData_6_valid        ), //o
    .mData_mData_6_payload (dataGenerate_1_mData_mData_6_payload[63:0]), //o
    .mData_mData_7_valid   (dataGenerate_1_mData_mData_7_valid        ), //o
    .mData_mData_7_payload (dataGenerate_1_mData_mData_7_payload[63:0]), //o
    .mData_mData_8_valid   (dataGenerate_1_mData_mData_8_valid        ), //o
    .mData_mData_8_payload (dataGenerate_1_mData_mData_8_payload[63:0]), //o
    .mData_ready           (sReady_0                                  ), //i
    .convType              (convType_1[1:0]                           ), //i
    .reset                 (reset                                     ), //i
    .clk                   (clk                                       )  //i
  );
  ConvComputeCtrl computeCtrl (
    .start                (startCu                             ), //i
    .mDataValid           (computeCtrl_mDataValid              ), //o
    .mDataReady           (stride_1_sReady                     ), //i
    .normValid            (computeCtrl_normValid               ), //o
    .normPreValid         (computeCtrl_normPreValid            ), //o
    .normEnd              (computeCtrl_normEnd                 ), //o
    .sDataReady           (mReady_0                            ), //i
    .rowNumIn             (rowNumIn[8:0]                       ), //i
    .colNumIn             (colNumIn[8:0]                       ), //i
    .channelIn            (channelIn[11:0]                     ), //i
    .channelOut           (channelOut[11:0]                    ), //i
    .featureMemReadAddr   (computeCtrl_featureMemReadAddr[5:0] ), //o
    .featureMemWriteAddr  (computeCtrl_featureMemWriteAddr[5:0]), //o
    .featureMemWriteReady (computeCtrl_featureMemWriteReady    ), //o
    .weightReadAddr_0     (computeCtrl_weightReadAddr_0[9:0]   ), //o
    .weightReadAddr_1     (computeCtrl_weightReadAddr_1[9:0]   ), //o
    .weightReadAddr_2     (computeCtrl_weightReadAddr_2[9:0]   ), //o
    .weightReadAddr_3     (computeCtrl_weightReadAddr_3[9:0]   ), //o
    .weightReadAddr_4     (computeCtrl_weightReadAddr_4[9:0]   ), //o
    .weightReadAddr_5     (computeCtrl_weightReadAddr_5[9:0]   ), //o
    .weightReadAddr_6     (computeCtrl_weightReadAddr_6[9:0]   ), //o
    .weightReadAddr_7     (computeCtrl_weightReadAddr_7[9:0]   ), //o
    .weightReadAddr_8     (computeCtrl_weightReadAddr_8[9:0]   ), //o
    .biasReadAddr         (computeCtrl_biasReadAddr[6:0]       ), //o
    .scaleReadAddr        (computeCtrl_scaleReadAddr[6:0]      ), //o
    .shiftReadAddr        (computeCtrl_shiftReadAddr[6:0]      ), //o
    .activationEn         (enActivation                        ), //i
    .sCount               (computeCtrl_sCount[10:0]            ), //o
    .mCount               (computeCtrl_mCount[10:0]            ), //o
    .convType             (convType_1[1:0]                     ), //i
    .clk                  (clk                                 ), //i
    .reset                (reset                               )  //i
  );
  LoadWeight loadWeight_1 (
    .start             (startPa                              ), //i
    .sData_valid       (sParaData_valid                      ), //i
    .sData_ready       (loadWeight_1_sData_ready             ), //o
    .sData_payload     (sParaData_payload[63:0]              ), //i
    .weightNum         (weightNum[12:0]                      ), //i
    .quanNum           (quanNum[8:0]                         ), //i
    .weightRead_0_addr (computeCtrl_weightReadAddr_0[9:0]    ), //i
    .weightRead_0_data (loadWeight_1_weightRead_0_data[511:0]), //o
    .weightRead_1_addr (computeCtrl_weightReadAddr_1[9:0]    ), //i
    .weightRead_1_data (loadWeight_1_weightRead_1_data[511:0]), //o
    .weightRead_2_addr (computeCtrl_weightReadAddr_2[9:0]    ), //i
    .weightRead_2_data (loadWeight_1_weightRead_2_data[511:0]), //o
    .weightRead_3_addr (computeCtrl_weightReadAddr_3[9:0]    ), //i
    .weightRead_3_data (loadWeight_1_weightRead_3_data[511:0]), //o
    .weightRead_4_addr (computeCtrl_weightReadAddr_4[9:0]    ), //i
    .weightRead_4_data (loadWeight_1_weightRead_4_data[511:0]), //o
    .weightRead_5_addr (computeCtrl_weightReadAddr_5[9:0]    ), //i
    .weightRead_5_data (loadWeight_1_weightRead_5_data[511:0]), //o
    .weightRead_6_addr (computeCtrl_weightReadAddr_6[9:0]    ), //i
    .weightRead_6_data (loadWeight_1_weightRead_6_data[511:0]), //o
    .weightRead_7_addr (computeCtrl_weightReadAddr_7[9:0]    ), //i
    .weightRead_7_data (loadWeight_1_weightRead_7_data[511:0]), //o
    .weightRead_8_addr (computeCtrl_weightReadAddr_8[9:0]    ), //i
    .weightRead_8_data (loadWeight_1_weightRead_8_data[511:0]), //o
    .biasRead_addr     (computeCtrl_biasReadAddr[6:0]        ), //i
    .biasRead_data     (loadWeight_1_biasRead_data[255:0]    ), //o
    .scaleRead_addr    (computeCtrl_scaleReadAddr[6:0]       ), //i
    .scaleRead_data    (loadWeight_1_scaleRead_data[255:0]   ), //o
    .shiftRead_addr    (computeCtrl_shiftReadAddr[6:0]       ), //i
    .shiftRead_data    (loadWeight_1_shiftRead_data[255:0]   ), //o
    .copyWeightDone    (loadWeight_1_copyWeightDone          ), //o
    .convType          (convType[1:0]                        ), //i
    .channelIn         (channelIn[11:0]                      ), //i
    .channelOut        (channelOut[11:0]                     ), //i
    .clk               (clk                                  ), //i
    .reset             (reset                                )  //i
  );
  WaXpmSyncFifo featureFifo_0 (
    .sCount         (featureFifo_0_sCount[11:0]                ), //i
    .mCount         (featureFifo_0_mCount[11:0]                ), //i
    .sReady         (featureFifo_0_sReady                      ), //o
    .mReady         (featureFifo_0_mReady                      ), //o
    .reset          (reset                                     ), //i
    .clk            (clk                                       ), //i
    .dataIn_valid   (dataGenerate_1_mData_mData_0_valid        ), //i
    .dataIn_payload (dataGenerate_1_mData_mData_0_payload[63:0]), //i
    .rd_en          (computeCtrl_featureMemWriteReady          ), //i
    .dout           (featureFifo_0_dout[63:0]                  )  //o
  );
  WaXpmSyncFifo featureFifo_1 (
    .sCount         (featureFifo_1_sCount[11:0]                ), //i
    .mCount         (featureFifo_1_mCount[11:0]                ), //i
    .sReady         (featureFifo_1_sReady                      ), //o
    .mReady         (featureFifo_1_mReady                      ), //o
    .reset          (reset                                     ), //i
    .clk            (clk                                       ), //i
    .dataIn_valid   (dataGenerate_1_mData_mData_1_valid        ), //i
    .dataIn_payload (dataGenerate_1_mData_mData_1_payload[63:0]), //i
    .rd_en          (computeCtrl_featureMemWriteReady          ), //i
    .dout           (featureFifo_1_dout[63:0]                  )  //o
  );
  WaXpmSyncFifo featureFifo_2 (
    .sCount         (featureFifo_2_sCount[11:0]                ), //i
    .mCount         (featureFifo_2_mCount[11:0]                ), //i
    .sReady         (featureFifo_2_sReady                      ), //o
    .mReady         (featureFifo_2_mReady                      ), //o
    .reset          (reset                                     ), //i
    .clk            (clk                                       ), //i
    .dataIn_valid   (dataGenerate_1_mData_mData_2_valid        ), //i
    .dataIn_payload (dataGenerate_1_mData_mData_2_payload[63:0]), //i
    .rd_en          (computeCtrl_featureMemWriteReady          ), //i
    .dout           (featureFifo_2_dout[63:0]                  )  //o
  );
  WaXpmSyncFifo featureFifo_3 (
    .sCount         (featureFifo_3_sCount[11:0]                ), //i
    .mCount         (featureFifo_3_mCount[11:0]                ), //i
    .sReady         (featureFifo_3_sReady                      ), //o
    .mReady         (featureFifo_3_mReady                      ), //o
    .reset          (reset                                     ), //i
    .clk            (clk                                       ), //i
    .dataIn_valid   (dataGenerate_1_mData_mData_3_valid        ), //i
    .dataIn_payload (dataGenerate_1_mData_mData_3_payload[63:0]), //i
    .rd_en          (computeCtrl_featureMemWriteReady          ), //i
    .dout           (featureFifo_3_dout[63:0]                  )  //o
  );
  WaXpmSyncFifo featureFifo_4 (
    .sCount         (featureFifo_4_sCount[11:0]                ), //i
    .mCount         (featureFifo_4_mCount[11:0]                ), //i
    .sReady         (featureFifo_4_sReady                      ), //o
    .mReady         (featureFifo_4_mReady                      ), //o
    .reset          (reset                                     ), //i
    .clk            (clk                                       ), //i
    .dataIn_valid   (dataGenerate_1_mData_mData_4_valid        ), //i
    .dataIn_payload (dataGenerate_1_mData_mData_4_payload[63:0]), //i
    .rd_en          (computeCtrl_featureMemWriteReady          ), //i
    .dout           (featureFifo_4_dout[63:0]                  )  //o
  );
  WaXpmSyncFifo featureFifo_5 (
    .sCount         (featureFifo_5_sCount[11:0]                ), //i
    .mCount         (featureFifo_5_mCount[11:0]                ), //i
    .sReady         (featureFifo_5_sReady                      ), //o
    .mReady         (featureFifo_5_mReady                      ), //o
    .reset          (reset                                     ), //i
    .clk            (clk                                       ), //i
    .dataIn_valid   (dataGenerate_1_mData_mData_5_valid        ), //i
    .dataIn_payload (dataGenerate_1_mData_mData_5_payload[63:0]), //i
    .rd_en          (computeCtrl_featureMemWriteReady          ), //i
    .dout           (featureFifo_5_dout[63:0]                  )  //o
  );
  WaXpmSyncFifo featureFifo_6 (
    .sCount         (featureFifo_6_sCount[11:0]                ), //i
    .mCount         (featureFifo_6_mCount[11:0]                ), //i
    .sReady         (featureFifo_6_sReady                      ), //o
    .mReady         (featureFifo_6_mReady                      ), //o
    .reset          (reset                                     ), //i
    .clk            (clk                                       ), //i
    .dataIn_valid   (dataGenerate_1_mData_mData_6_valid        ), //i
    .dataIn_payload (dataGenerate_1_mData_mData_6_payload[63:0]), //i
    .rd_en          (computeCtrl_featureMemWriteReady          ), //i
    .dout           (featureFifo_6_dout[63:0]                  )  //o
  );
  WaXpmSyncFifo featureFifo_7 (
    .sCount         (featureFifo_7_sCount[11:0]                ), //i
    .mCount         (featureFifo_7_mCount[11:0]                ), //i
    .sReady         (featureFifo_7_sReady                      ), //o
    .mReady         (featureFifo_7_mReady                      ), //o
    .reset          (reset                                     ), //i
    .clk            (clk                                       ), //i
    .dataIn_valid   (dataGenerate_1_mData_mData_7_valid        ), //i
    .dataIn_payload (dataGenerate_1_mData_mData_7_payload[63:0]), //i
    .rd_en          (computeCtrl_featureMemWriteReady          ), //i
    .dout           (featureFifo_7_dout[63:0]                  )  //o
  );
  WaXpmSyncFifo featureFifo_8 (
    .sCount         (featureFifo_8_sCount[11:0]                ), //i
    .mCount         (featureFifo_8_mCount[11:0]                ), //i
    .sReady         (featureFifo_8_sReady                      ), //o
    .mReady         (featureFifo_8_mReady                      ), //o
    .reset          (reset                                     ), //i
    .clk            (clk                                       ), //i
    .dataIn_valid   (dataGenerate_1_mData_mData_8_valid        ), //i
    .dataIn_payload (dataGenerate_1_mData_mData_8_payload[63:0]), //i
    .rd_en          (computeCtrl_featureMemWriteReady          ), //i
    .dout           (featureFifo_8_dout[63:0]                  )  //o
  );
  DSP dSP_1 (
    .a      (dSP_1_a[7:0] ), //i
    .d      (dSP_1_d[7:0] ), //i
    .b      (dSP_1_b[7:0] ), //i
    .p      (dSP_1_p[63:0]), //o
    .CLK    (clk          ), //i
    .a1     (dSP_1_a1[7:0]), //i
    .d1     (dSP_1_d1[7:0]), //i
    .CLK_2X (CLK_2X       ), //i
    .RST_2X (RST_2X       )  //i
  );
  DSP dSP_2 (
    .a      (dSP_2_a[7:0] ), //i
    .d      (dSP_2_d[7:0] ), //i
    .b      (dSP_2_b[7:0] ), //i
    .p      (dSP_2_p[63:0]), //o
    .CLK    (clk          ), //i
    .a1     (dSP_2_a1[7:0]), //i
    .d1     (dSP_2_d1[7:0]), //i
    .CLK_2X (CLK_2X       ), //i
    .RST_2X (RST_2X       )  //i
  );
  DSP dSP_3 (
    .a      (dSP_3_a[7:0] ), //i
    .d      (dSP_3_d[7:0] ), //i
    .b      (dSP_3_b[7:0] ), //i
    .p      (dSP_3_p[63:0]), //o
    .CLK    (clk          ), //i
    .a1     (dSP_3_a1[7:0]), //i
    .d1     (dSP_3_d1[7:0]), //i
    .CLK_2X (CLK_2X       ), //i
    .RST_2X (RST_2X       )  //i
  );
  DSP dSP_4 (
    .a      (dSP_4_a[7:0] ), //i
    .d      (dSP_4_d[7:0] ), //i
    .b      (dSP_4_b[7:0] ), //i
    .p      (dSP_4_p[63:0]), //o
    .CLK    (clk          ), //i
    .a1     (dSP_4_a1[7:0]), //i
    .d1     (dSP_4_d1[7:0]), //i
    .CLK_2X (CLK_2X       ), //i
    .RST_2X (RST_2X       )  //i
  );
  DSP dSP_5 (
    .a      (dSP_5_a[7:0] ), //i
    .d      (dSP_5_d[7:0] ), //i
    .b      (dSP_5_b[7:0] ), //i
    .p      (dSP_5_p[63:0]), //o
    .CLK    (clk          ), //i
    .a1     (dSP_5_a1[7:0]), //i
    .d1     (dSP_5_d1[7:0]), //i
    .CLK_2X (CLK_2X       ), //i
    .RST_2X (RST_2X       )  //i
  );
  DSP dSP_6 (
    .a      (dSP_6_a[7:0] ), //i
    .d      (dSP_6_d[7:0] ), //i
    .b      (dSP_6_b[7:0] ), //i
    .p      (dSP_6_p[63:0]), //o
    .CLK    (clk          ), //i
    .a1     (dSP_6_a1[7:0]), //i
    .d1     (dSP_6_d1[7:0]), //i
    .CLK_2X (CLK_2X       ), //i
    .RST_2X (RST_2X       )  //i
  );
  DSP dSP_7 (
    .a      (dSP_7_a[7:0] ), //i
    .d      (dSP_7_d[7:0] ), //i
    .b      (dSP_7_b[7:0] ), //i
    .p      (dSP_7_p[63:0]), //o
    .CLK    (clk          ), //i
    .a1     (dSP_7_a1[7:0]), //i
    .d1     (dSP_7_d1[7:0]), //i
    .CLK_2X (CLK_2X       ), //i
    .RST_2X (RST_2X       )  //i
  );
  DSP dSP_8 (
    .a      (dSP_8_a[7:0] ), //i
    .d      (dSP_8_d[7:0] ), //i
    .b      (dSP_8_b[7:0] ), //i
    .p      (dSP_8_p[63:0]), //o
    .CLK    (clk          ), //i
    .a1     (dSP_8_a1[7:0]), //i
    .d1     (dSP_8_d1[7:0]), //i
    .CLK_2X (CLK_2X       ), //i
    .RST_2X (RST_2X       )  //i
  );
  DSP dSP_9 (
    .a      (dSP_9_a[7:0] ), //i
    .d      (dSP_9_d[7:0] ), //i
    .b      (dSP_9_b[7:0] ), //i
    .p      (dSP_9_p[63:0]), //o
    .CLK    (clk          ), //i
    .a1     (dSP_9_a1[7:0]), //i
    .d1     (dSP_9_d1[7:0]), //i
    .CLK_2X (CLK_2X       ), //i
    .RST_2X (RST_2X       )  //i
  );
  DSP dSP_10 (
    .a      (dSP_10_a[7:0] ), //i
    .d      (dSP_10_d[7:0] ), //i
    .b      (dSP_10_b[7:0] ), //i
    .p      (dSP_10_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_10_a1[7:0]), //i
    .d1     (dSP_10_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_11 (
    .a      (dSP_11_a[7:0] ), //i
    .d      (dSP_11_d[7:0] ), //i
    .b      (dSP_11_b[7:0] ), //i
    .p      (dSP_11_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_11_a1[7:0]), //i
    .d1     (dSP_11_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_12 (
    .a      (dSP_12_a[7:0] ), //i
    .d      (dSP_12_d[7:0] ), //i
    .b      (dSP_12_b[7:0] ), //i
    .p      (dSP_12_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_12_a1[7:0]), //i
    .d1     (dSP_12_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_13 (
    .a      (dSP_13_a[7:0] ), //i
    .d      (dSP_13_d[7:0] ), //i
    .b      (dSP_13_b[7:0] ), //i
    .p      (dSP_13_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_13_a1[7:0]), //i
    .d1     (dSP_13_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_14 (
    .a      (dSP_14_a[7:0] ), //i
    .d      (dSP_14_d[7:0] ), //i
    .b      (dSP_14_b[7:0] ), //i
    .p      (dSP_14_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_14_a1[7:0]), //i
    .d1     (dSP_14_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_15 (
    .a      (dSP_15_a[7:0] ), //i
    .d      (dSP_15_d[7:0] ), //i
    .b      (dSP_15_b[7:0] ), //i
    .p      (dSP_15_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_15_a1[7:0]), //i
    .d1     (dSP_15_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_16 (
    .a      (dSP_16_a[7:0] ), //i
    .d      (dSP_16_d[7:0] ), //i
    .b      (dSP_16_b[7:0] ), //i
    .p      (dSP_16_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_16_a1[7:0]), //i
    .d1     (dSP_16_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_17 (
    .a      (dSP_17_a[7:0] ), //i
    .d      (dSP_17_d[7:0] ), //i
    .b      (dSP_17_b[7:0] ), //i
    .p      (dSP_17_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_17_a1[7:0]), //i
    .d1     (dSP_17_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_18 (
    .a      (dSP_18_a[7:0] ), //i
    .d      (dSP_18_d[7:0] ), //i
    .b      (dSP_18_b[7:0] ), //i
    .p      (dSP_18_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_18_a1[7:0]), //i
    .d1     (dSP_18_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_19 (
    .a      (dSP_19_a[7:0] ), //i
    .d      (dSP_19_d[7:0] ), //i
    .b      (dSP_19_b[7:0] ), //i
    .p      (dSP_19_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_19_a1[7:0]), //i
    .d1     (dSP_19_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_20 (
    .a      (dSP_20_a[7:0] ), //i
    .d      (dSP_20_d[7:0] ), //i
    .b      (dSP_20_b[7:0] ), //i
    .p      (dSP_20_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_20_a1[7:0]), //i
    .d1     (dSP_20_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_21 (
    .a      (dSP_21_a[7:0] ), //i
    .d      (dSP_21_d[7:0] ), //i
    .b      (dSP_21_b[7:0] ), //i
    .p      (dSP_21_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_21_a1[7:0]), //i
    .d1     (dSP_21_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_22 (
    .a      (dSP_22_a[7:0] ), //i
    .d      (dSP_22_d[7:0] ), //i
    .b      (dSP_22_b[7:0] ), //i
    .p      (dSP_22_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_22_a1[7:0]), //i
    .d1     (dSP_22_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_23 (
    .a      (dSP_23_a[7:0] ), //i
    .d      (dSP_23_d[7:0] ), //i
    .b      (dSP_23_b[7:0] ), //i
    .p      (dSP_23_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_23_a1[7:0]), //i
    .d1     (dSP_23_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_24 (
    .a      (dSP_24_a[7:0] ), //i
    .d      (dSP_24_d[7:0] ), //i
    .b      (dSP_24_b[7:0] ), //i
    .p      (dSP_24_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_24_a1[7:0]), //i
    .d1     (dSP_24_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_25 (
    .a      (dSP_25_a[7:0] ), //i
    .d      (dSP_25_d[7:0] ), //i
    .b      (dSP_25_b[7:0] ), //i
    .p      (dSP_25_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_25_a1[7:0]), //i
    .d1     (dSP_25_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_26 (
    .a      (dSP_26_a[7:0] ), //i
    .d      (dSP_26_d[7:0] ), //i
    .b      (dSP_26_b[7:0] ), //i
    .p      (dSP_26_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_26_a1[7:0]), //i
    .d1     (dSP_26_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_27 (
    .a      (dSP_27_a[7:0] ), //i
    .d      (dSP_27_d[7:0] ), //i
    .b      (dSP_27_b[7:0] ), //i
    .p      (dSP_27_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_27_a1[7:0]), //i
    .d1     (dSP_27_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_28 (
    .a      (dSP_28_a[7:0] ), //i
    .d      (dSP_28_d[7:0] ), //i
    .b      (dSP_28_b[7:0] ), //i
    .p      (dSP_28_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_28_a1[7:0]), //i
    .d1     (dSP_28_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_29 (
    .a      (dSP_29_a[7:0] ), //i
    .d      (dSP_29_d[7:0] ), //i
    .b      (dSP_29_b[7:0] ), //i
    .p      (dSP_29_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_29_a1[7:0]), //i
    .d1     (dSP_29_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_30 (
    .a      (dSP_30_a[7:0] ), //i
    .d      (dSP_30_d[7:0] ), //i
    .b      (dSP_30_b[7:0] ), //i
    .p      (dSP_30_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_30_a1[7:0]), //i
    .d1     (dSP_30_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_31 (
    .a      (dSP_31_a[7:0] ), //i
    .d      (dSP_31_d[7:0] ), //i
    .b      (dSP_31_b[7:0] ), //i
    .p      (dSP_31_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_31_a1[7:0]), //i
    .d1     (dSP_31_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_32 (
    .a      (dSP_32_a[7:0] ), //i
    .d      (dSP_32_d[7:0] ), //i
    .b      (dSP_32_b[7:0] ), //i
    .p      (dSP_32_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_32_a1[7:0]), //i
    .d1     (dSP_32_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_33 (
    .a      (dSP_33_a[7:0] ), //i
    .d      (dSP_33_d[7:0] ), //i
    .b      (dSP_33_b[7:0] ), //i
    .p      (dSP_33_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_33_a1[7:0]), //i
    .d1     (dSP_33_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_34 (
    .a      (dSP_34_a[7:0] ), //i
    .d      (dSP_34_d[7:0] ), //i
    .b      (dSP_34_b[7:0] ), //i
    .p      (dSP_34_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_34_a1[7:0]), //i
    .d1     (dSP_34_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_35 (
    .a      (dSP_35_a[7:0] ), //i
    .d      (dSP_35_d[7:0] ), //i
    .b      (dSP_35_b[7:0] ), //i
    .p      (dSP_35_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_35_a1[7:0]), //i
    .d1     (dSP_35_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_36 (
    .a      (dSP_36_a[7:0] ), //i
    .d      (dSP_36_d[7:0] ), //i
    .b      (dSP_36_b[7:0] ), //i
    .p      (dSP_36_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_36_a1[7:0]), //i
    .d1     (dSP_36_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_37 (
    .a      (dSP_37_a[7:0] ), //i
    .d      (dSP_37_d[7:0] ), //i
    .b      (dSP_37_b[7:0] ), //i
    .p      (dSP_37_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_37_a1[7:0]), //i
    .d1     (dSP_37_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_38 (
    .a      (dSP_38_a[7:0] ), //i
    .d      (dSP_38_d[7:0] ), //i
    .b      (dSP_38_b[7:0] ), //i
    .p      (dSP_38_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_38_a1[7:0]), //i
    .d1     (dSP_38_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_39 (
    .a      (dSP_39_a[7:0] ), //i
    .d      (dSP_39_d[7:0] ), //i
    .b      (dSP_39_b[7:0] ), //i
    .p      (dSP_39_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_39_a1[7:0]), //i
    .d1     (dSP_39_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_40 (
    .a      (dSP_40_a[7:0] ), //i
    .d      (dSP_40_d[7:0] ), //i
    .b      (dSP_40_b[7:0] ), //i
    .p      (dSP_40_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_40_a1[7:0]), //i
    .d1     (dSP_40_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_41 (
    .a      (dSP_41_a[7:0] ), //i
    .d      (dSP_41_d[7:0] ), //i
    .b      (dSP_41_b[7:0] ), //i
    .p      (dSP_41_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_41_a1[7:0]), //i
    .d1     (dSP_41_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_42 (
    .a      (dSP_42_a[7:0] ), //i
    .d      (dSP_42_d[7:0] ), //i
    .b      (dSP_42_b[7:0] ), //i
    .p      (dSP_42_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_42_a1[7:0]), //i
    .d1     (dSP_42_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_43 (
    .a      (dSP_43_a[7:0] ), //i
    .d      (dSP_43_d[7:0] ), //i
    .b      (dSP_43_b[7:0] ), //i
    .p      (dSP_43_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_43_a1[7:0]), //i
    .d1     (dSP_43_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_44 (
    .a      (dSP_44_a[7:0] ), //i
    .d      (dSP_44_d[7:0] ), //i
    .b      (dSP_44_b[7:0] ), //i
    .p      (dSP_44_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_44_a1[7:0]), //i
    .d1     (dSP_44_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_45 (
    .a      (dSP_45_a[7:0] ), //i
    .d      (dSP_45_d[7:0] ), //i
    .b      (dSP_45_b[7:0] ), //i
    .p      (dSP_45_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_45_a1[7:0]), //i
    .d1     (dSP_45_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_46 (
    .a      (dSP_46_a[7:0] ), //i
    .d      (dSP_46_d[7:0] ), //i
    .b      (dSP_46_b[7:0] ), //i
    .p      (dSP_46_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_46_a1[7:0]), //i
    .d1     (dSP_46_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_47 (
    .a      (dSP_47_a[7:0] ), //i
    .d      (dSP_47_d[7:0] ), //i
    .b      (dSP_47_b[7:0] ), //i
    .p      (dSP_47_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_47_a1[7:0]), //i
    .d1     (dSP_47_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_48 (
    .a      (dSP_48_a[7:0] ), //i
    .d      (dSP_48_d[7:0] ), //i
    .b      (dSP_48_b[7:0] ), //i
    .p      (dSP_48_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_48_a1[7:0]), //i
    .d1     (dSP_48_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_49 (
    .a      (dSP_49_a[7:0] ), //i
    .d      (dSP_49_d[7:0] ), //i
    .b      (dSP_49_b[7:0] ), //i
    .p      (dSP_49_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_49_a1[7:0]), //i
    .d1     (dSP_49_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_50 (
    .a      (dSP_50_a[7:0] ), //i
    .d      (dSP_50_d[7:0] ), //i
    .b      (dSP_50_b[7:0] ), //i
    .p      (dSP_50_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_50_a1[7:0]), //i
    .d1     (dSP_50_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_51 (
    .a      (dSP_51_a[7:0] ), //i
    .d      (dSP_51_d[7:0] ), //i
    .b      (dSP_51_b[7:0] ), //i
    .p      (dSP_51_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_51_a1[7:0]), //i
    .d1     (dSP_51_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_52 (
    .a      (dSP_52_a[7:0] ), //i
    .d      (dSP_52_d[7:0] ), //i
    .b      (dSP_52_b[7:0] ), //i
    .p      (dSP_52_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_52_a1[7:0]), //i
    .d1     (dSP_52_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_53 (
    .a      (dSP_53_a[7:0] ), //i
    .d      (dSP_53_d[7:0] ), //i
    .b      (dSP_53_b[7:0] ), //i
    .p      (dSP_53_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_53_a1[7:0]), //i
    .d1     (dSP_53_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_54 (
    .a      (dSP_54_a[7:0] ), //i
    .d      (dSP_54_d[7:0] ), //i
    .b      (dSP_54_b[7:0] ), //i
    .p      (dSP_54_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_54_a1[7:0]), //i
    .d1     (dSP_54_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_55 (
    .a      (dSP_55_a[7:0] ), //i
    .d      (dSP_55_d[7:0] ), //i
    .b      (dSP_55_b[7:0] ), //i
    .p      (dSP_55_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_55_a1[7:0]), //i
    .d1     (dSP_55_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_56 (
    .a      (dSP_56_a[7:0] ), //i
    .d      (dSP_56_d[7:0] ), //i
    .b      (dSP_56_b[7:0] ), //i
    .p      (dSP_56_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_56_a1[7:0]), //i
    .d1     (dSP_56_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_57 (
    .a      (dSP_57_a[7:0] ), //i
    .d      (dSP_57_d[7:0] ), //i
    .b      (dSP_57_b[7:0] ), //i
    .p      (dSP_57_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_57_a1[7:0]), //i
    .d1     (dSP_57_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_58 (
    .a      (dSP_58_a[7:0] ), //i
    .d      (dSP_58_d[7:0] ), //i
    .b      (dSP_58_b[7:0] ), //i
    .p      (dSP_58_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_58_a1[7:0]), //i
    .d1     (dSP_58_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_59 (
    .a      (dSP_59_a[7:0] ), //i
    .d      (dSP_59_d[7:0] ), //i
    .b      (dSP_59_b[7:0] ), //i
    .p      (dSP_59_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_59_a1[7:0]), //i
    .d1     (dSP_59_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_60 (
    .a      (dSP_60_a[7:0] ), //i
    .d      (dSP_60_d[7:0] ), //i
    .b      (dSP_60_b[7:0] ), //i
    .p      (dSP_60_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_60_a1[7:0]), //i
    .d1     (dSP_60_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_61 (
    .a      (dSP_61_a[7:0] ), //i
    .d      (dSP_61_d[7:0] ), //i
    .b      (dSP_61_b[7:0] ), //i
    .p      (dSP_61_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_61_a1[7:0]), //i
    .d1     (dSP_61_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_62 (
    .a      (dSP_62_a[7:0] ), //i
    .d      (dSP_62_d[7:0] ), //i
    .b      (dSP_62_b[7:0] ), //i
    .p      (dSP_62_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_62_a1[7:0]), //i
    .d1     (dSP_62_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_63 (
    .a      (dSP_63_a[7:0] ), //i
    .d      (dSP_63_d[7:0] ), //i
    .b      (dSP_63_b[7:0] ), //i
    .p      (dSP_63_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_63_a1[7:0]), //i
    .d1     (dSP_63_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_64 (
    .a      (dSP_64_a[7:0] ), //i
    .d      (dSP_64_d[7:0] ), //i
    .b      (dSP_64_b[7:0] ), //i
    .p      (dSP_64_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_64_a1[7:0]), //i
    .d1     (dSP_64_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_65 (
    .a      (dSP_65_a[7:0] ), //i
    .d      (dSP_65_d[7:0] ), //i
    .b      (dSP_65_b[7:0] ), //i
    .p      (dSP_65_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_65_a1[7:0]), //i
    .d1     (dSP_65_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_66 (
    .a      (dSP_66_a[7:0] ), //i
    .d      (dSP_66_d[7:0] ), //i
    .b      (dSP_66_b[7:0] ), //i
    .p      (dSP_66_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_66_a1[7:0]), //i
    .d1     (dSP_66_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_67 (
    .a      (dSP_67_a[7:0] ), //i
    .d      (dSP_67_d[7:0] ), //i
    .b      (dSP_67_b[7:0] ), //i
    .p      (dSP_67_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_67_a1[7:0]), //i
    .d1     (dSP_67_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_68 (
    .a      (dSP_68_a[7:0] ), //i
    .d      (dSP_68_d[7:0] ), //i
    .b      (dSP_68_b[7:0] ), //i
    .p      (dSP_68_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_68_a1[7:0]), //i
    .d1     (dSP_68_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_69 (
    .a      (dSP_69_a[7:0] ), //i
    .d      (dSP_69_d[7:0] ), //i
    .b      (dSP_69_b[7:0] ), //i
    .p      (dSP_69_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_69_a1[7:0]), //i
    .d1     (dSP_69_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_70 (
    .a      (dSP_70_a[7:0] ), //i
    .d      (dSP_70_d[7:0] ), //i
    .b      (dSP_70_b[7:0] ), //i
    .p      (dSP_70_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_70_a1[7:0]), //i
    .d1     (dSP_70_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_71 (
    .a      (dSP_71_a[7:0] ), //i
    .d      (dSP_71_d[7:0] ), //i
    .b      (dSP_71_b[7:0] ), //i
    .p      (dSP_71_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_71_a1[7:0]), //i
    .d1     (dSP_71_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_72 (
    .a      (dSP_72_a[7:0] ), //i
    .d      (dSP_72_d[7:0] ), //i
    .b      (dSP_72_b[7:0] ), //i
    .p      (dSP_72_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_72_a1[7:0]), //i
    .d1     (dSP_72_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_73 (
    .a      (dSP_73_a[7:0] ), //i
    .d      (dSP_73_d[7:0] ), //i
    .b      (dSP_73_b[7:0] ), //i
    .p      (dSP_73_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_73_a1[7:0]), //i
    .d1     (dSP_73_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_74 (
    .a      (dSP_74_a[7:0] ), //i
    .d      (dSP_74_d[7:0] ), //i
    .b      (dSP_74_b[7:0] ), //i
    .p      (dSP_74_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_74_a1[7:0]), //i
    .d1     (dSP_74_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_75 (
    .a      (dSP_75_a[7:0] ), //i
    .d      (dSP_75_d[7:0] ), //i
    .b      (dSP_75_b[7:0] ), //i
    .p      (dSP_75_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_75_a1[7:0]), //i
    .d1     (dSP_75_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_76 (
    .a      (dSP_76_a[7:0] ), //i
    .d      (dSP_76_d[7:0] ), //i
    .b      (dSP_76_b[7:0] ), //i
    .p      (dSP_76_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_76_a1[7:0]), //i
    .d1     (dSP_76_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_77 (
    .a      (dSP_77_a[7:0] ), //i
    .d      (dSP_77_d[7:0] ), //i
    .b      (dSP_77_b[7:0] ), //i
    .p      (dSP_77_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_77_a1[7:0]), //i
    .d1     (dSP_77_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_78 (
    .a      (dSP_78_a[7:0] ), //i
    .d      (dSP_78_d[7:0] ), //i
    .b      (dSP_78_b[7:0] ), //i
    .p      (dSP_78_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_78_a1[7:0]), //i
    .d1     (dSP_78_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_79 (
    .a      (dSP_79_a[7:0] ), //i
    .d      (dSP_79_d[7:0] ), //i
    .b      (dSP_79_b[7:0] ), //i
    .p      (dSP_79_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_79_a1[7:0]), //i
    .d1     (dSP_79_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_80 (
    .a      (dSP_80_a[7:0] ), //i
    .d      (dSP_80_d[7:0] ), //i
    .b      (dSP_80_b[7:0] ), //i
    .p      (dSP_80_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_80_a1[7:0]), //i
    .d1     (dSP_80_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_81 (
    .a      (dSP_81_a[7:0] ), //i
    .d      (dSP_81_d[7:0] ), //i
    .b      (dSP_81_b[7:0] ), //i
    .p      (dSP_81_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_81_a1[7:0]), //i
    .d1     (dSP_81_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_82 (
    .a      (dSP_82_a[7:0] ), //i
    .d      (dSP_82_d[7:0] ), //i
    .b      (dSP_82_b[7:0] ), //i
    .p      (dSP_82_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_82_a1[7:0]), //i
    .d1     (dSP_82_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_83 (
    .a      (dSP_83_a[7:0] ), //i
    .d      (dSP_83_d[7:0] ), //i
    .b      (dSP_83_b[7:0] ), //i
    .p      (dSP_83_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_83_a1[7:0]), //i
    .d1     (dSP_83_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_84 (
    .a      (dSP_84_a[7:0] ), //i
    .d      (dSP_84_d[7:0] ), //i
    .b      (dSP_84_b[7:0] ), //i
    .p      (dSP_84_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_84_a1[7:0]), //i
    .d1     (dSP_84_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_85 (
    .a      (dSP_85_a[7:0] ), //i
    .d      (dSP_85_d[7:0] ), //i
    .b      (dSP_85_b[7:0] ), //i
    .p      (dSP_85_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_85_a1[7:0]), //i
    .d1     (dSP_85_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_86 (
    .a      (dSP_86_a[7:0] ), //i
    .d      (dSP_86_d[7:0] ), //i
    .b      (dSP_86_b[7:0] ), //i
    .p      (dSP_86_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_86_a1[7:0]), //i
    .d1     (dSP_86_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_87 (
    .a      (dSP_87_a[7:0] ), //i
    .d      (dSP_87_d[7:0] ), //i
    .b      (dSP_87_b[7:0] ), //i
    .p      (dSP_87_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_87_a1[7:0]), //i
    .d1     (dSP_87_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_88 (
    .a      (dSP_88_a[7:0] ), //i
    .d      (dSP_88_d[7:0] ), //i
    .b      (dSP_88_b[7:0] ), //i
    .p      (dSP_88_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_88_a1[7:0]), //i
    .d1     (dSP_88_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_89 (
    .a      (dSP_89_a[7:0] ), //i
    .d      (dSP_89_d[7:0] ), //i
    .b      (dSP_89_b[7:0] ), //i
    .p      (dSP_89_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_89_a1[7:0]), //i
    .d1     (dSP_89_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_90 (
    .a      (dSP_90_a[7:0] ), //i
    .d      (dSP_90_d[7:0] ), //i
    .b      (dSP_90_b[7:0] ), //i
    .p      (dSP_90_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_90_a1[7:0]), //i
    .d1     (dSP_90_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_91 (
    .a      (dSP_91_a[7:0] ), //i
    .d      (dSP_91_d[7:0] ), //i
    .b      (dSP_91_b[7:0] ), //i
    .p      (dSP_91_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_91_a1[7:0]), //i
    .d1     (dSP_91_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_92 (
    .a      (dSP_92_a[7:0] ), //i
    .d      (dSP_92_d[7:0] ), //i
    .b      (dSP_92_b[7:0] ), //i
    .p      (dSP_92_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_92_a1[7:0]), //i
    .d1     (dSP_92_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_93 (
    .a      (dSP_93_a[7:0] ), //i
    .d      (dSP_93_d[7:0] ), //i
    .b      (dSP_93_b[7:0] ), //i
    .p      (dSP_93_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_93_a1[7:0]), //i
    .d1     (dSP_93_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_94 (
    .a      (dSP_94_a[7:0] ), //i
    .d      (dSP_94_d[7:0] ), //i
    .b      (dSP_94_b[7:0] ), //i
    .p      (dSP_94_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_94_a1[7:0]), //i
    .d1     (dSP_94_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_95 (
    .a      (dSP_95_a[7:0] ), //i
    .d      (dSP_95_d[7:0] ), //i
    .b      (dSP_95_b[7:0] ), //i
    .p      (dSP_95_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_95_a1[7:0]), //i
    .d1     (dSP_95_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_96 (
    .a      (dSP_96_a[7:0] ), //i
    .d      (dSP_96_d[7:0] ), //i
    .b      (dSP_96_b[7:0] ), //i
    .p      (dSP_96_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_96_a1[7:0]), //i
    .d1     (dSP_96_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_97 (
    .a      (dSP_97_a[7:0] ), //i
    .d      (dSP_97_d[7:0] ), //i
    .b      (dSP_97_b[7:0] ), //i
    .p      (dSP_97_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_97_a1[7:0]), //i
    .d1     (dSP_97_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_98 (
    .a      (dSP_98_a[7:0] ), //i
    .d      (dSP_98_d[7:0] ), //i
    .b      (dSP_98_b[7:0] ), //i
    .p      (dSP_98_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_98_a1[7:0]), //i
    .d1     (dSP_98_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_99 (
    .a      (dSP_99_a[7:0] ), //i
    .d      (dSP_99_d[7:0] ), //i
    .b      (dSP_99_b[7:0] ), //i
    .p      (dSP_99_p[63:0]), //o
    .CLK    (clk           ), //i
    .a1     (dSP_99_a1[7:0]), //i
    .d1     (dSP_99_d1[7:0]), //i
    .CLK_2X (CLK_2X        ), //i
    .RST_2X (RST_2X        )  //i
  );
  DSP dSP_100 (
    .a      (dSP_100_a[7:0] ), //i
    .d      (dSP_100_d[7:0] ), //i
    .b      (dSP_100_b[7:0] ), //i
    .p      (dSP_100_p[63:0]), //o
    .CLK    (clk            ), //i
    .a1     (dSP_100_a1[7:0]), //i
    .d1     (dSP_100_d1[7:0]), //i
    .CLK_2X (CLK_2X         ), //i
    .RST_2X (RST_2X         )  //i
  );
  DSP dSP_101 (
    .a      (dSP_101_a[7:0] ), //i
    .d      (dSP_101_d[7:0] ), //i
    .b      (dSP_101_b[7:0] ), //i
    .p      (dSP_101_p[63:0]), //o
    .CLK    (clk            ), //i
    .a1     (dSP_101_a1[7:0]), //i
    .d1     (dSP_101_d1[7:0]), //i
    .CLK_2X (CLK_2X         ), //i
    .RST_2X (RST_2X         )  //i
  );
  DSP dSP_102 (
    .a      (dSP_102_a[7:0] ), //i
    .d      (dSP_102_d[7:0] ), //i
    .b      (dSP_102_b[7:0] ), //i
    .p      (dSP_102_p[63:0]), //o
    .CLK    (clk            ), //i
    .a1     (dSP_102_a1[7:0]), //i
    .d1     (dSP_102_d1[7:0]), //i
    .CLK_2X (CLK_2X         ), //i
    .RST_2X (RST_2X         )  //i
  );
  DSP dSP_103 (
    .a      (dSP_103_a[7:0] ), //i
    .d      (dSP_103_d[7:0] ), //i
    .b      (dSP_103_b[7:0] ), //i
    .p      (dSP_103_p[63:0]), //o
    .CLK    (clk            ), //i
    .a1     (dSP_103_a1[7:0]), //i
    .d1     (dSP_103_d1[7:0]), //i
    .CLK_2X (CLK_2X         ), //i
    .RST_2X (RST_2X         )  //i
  );
  DSP dSP_104 (
    .a      (dSP_104_a[7:0] ), //i
    .d      (dSP_104_d[7:0] ), //i
    .b      (dSP_104_b[7:0] ), //i
    .p      (dSP_104_p[63:0]), //o
    .CLK    (clk            ), //i
    .a1     (dSP_104_a1[7:0]), //i
    .d1     (dSP_104_d1[7:0]), //i
    .CLK_2X (CLK_2X         ), //i
    .RST_2X (RST_2X         )  //i
  );
  DSP dSP_105 (
    .a      (dSP_105_a[7:0] ), //i
    .d      (dSP_105_d[7:0] ), //i
    .b      (dSP_105_b[7:0] ), //i
    .p      (dSP_105_p[63:0]), //o
    .CLK    (clk            ), //i
    .a1     (dSP_105_a1[7:0]), //i
    .d1     (dSP_105_d1[7:0]), //i
    .CLK_2X (CLK_2X         ), //i
    .RST_2X (RST_2X         )  //i
  );
  DSP dSP_106 (
    .a      (dSP_106_a[7:0] ), //i
    .d      (dSP_106_d[7:0] ), //i
    .b      (dSP_106_b[7:0] ), //i
    .p      (dSP_106_p[63:0]), //o
    .CLK    (clk            ), //i
    .a1     (dSP_106_a1[7:0]), //i
    .d1     (dSP_106_d1[7:0]), //i
    .CLK_2X (CLK_2X         ), //i
    .RST_2X (RST_2X         )  //i
  );
  DSP dSP_107 (
    .a      (dSP_107_a[7:0] ), //i
    .d      (dSP_107_d[7:0] ), //i
    .b      (dSP_107_b[7:0] ), //i
    .p      (dSP_107_p[63:0]), //o
    .CLK    (clk            ), //i
    .a1     (dSP_107_a1[7:0]), //i
    .d1     (dSP_107_d1[7:0]), //i
    .CLK_2X (CLK_2X         ), //i
    .RST_2X (RST_2X         )  //i
  );
  DSP dSP_108 (
    .a      (dSP_108_a[7:0] ), //i
    .d      (dSP_108_d[7:0] ), //i
    .b      (dSP_108_b[7:0] ), //i
    .p      (dSP_108_p[63:0]), //o
    .CLK    (clk            ), //i
    .a1     (dSP_108_a1[7:0]), //i
    .d1     (dSP_108_d1[7:0]), //i
    .CLK_2X (CLK_2X         ), //i
    .RST_2X (RST_2X         )  //i
  );
  DSP dSP_109 (
    .a      (dSP_109_a[7:0] ), //i
    .d      (dSP_109_d[7:0] ), //i
    .b      (dSP_109_b[7:0] ), //i
    .p      (dSP_109_p[63:0]), //o
    .CLK    (clk            ), //i
    .a1     (dSP_109_a1[7:0]), //i
    .d1     (dSP_109_d1[7:0]), //i
    .CLK_2X (CLK_2X         ), //i
    .RST_2X (RST_2X         )  //i
  );
  DSP dSP_110 (
    .a      (dSP_110_a[7:0] ), //i
    .d      (dSP_110_d[7:0] ), //i
    .b      (dSP_110_b[7:0] ), //i
    .p      (dSP_110_p[63:0]), //o
    .CLK    (clk            ), //i
    .a1     (dSP_110_a1[7:0]), //i
    .d1     (dSP_110_d1[7:0]), //i
    .CLK_2X (CLK_2X         ), //i
    .RST_2X (RST_2X         )  //i
  );
  DSP dSP_111 (
    .a      (dSP_111_a[7:0] ), //i
    .d      (dSP_111_d[7:0] ), //i
    .b      (dSP_111_b[7:0] ), //i
    .p      (dSP_111_p[63:0]), //o
    .CLK    (clk            ), //i
    .a1     (dSP_111_a1[7:0]), //i
    .d1     (dSP_111_d1[7:0]), //i
    .CLK_2X (CLK_2X         ), //i
    .RST_2X (RST_2X         )  //i
  );
  DSP dSP_112 (
    .a      (dSP_112_a[7:0] ), //i
    .d      (dSP_112_d[7:0] ), //i
    .b      (dSP_112_b[7:0] ), //i
    .p      (dSP_112_p[63:0]), //o
    .CLK    (clk            ), //i
    .a1     (dSP_112_a1[7:0]), //i
    .d1     (dSP_112_d1[7:0]), //i
    .CLK_2X (CLK_2X         ), //i
    .RST_2X (RST_2X         )  //i
  );
  DSP dSP_113 (
    .a      (dSP_113_a[7:0] ), //i
    .d      (dSP_113_d[7:0] ), //i
    .b      (dSP_113_b[7:0] ), //i
    .p      (dSP_113_p[63:0]), //o
    .CLK    (clk            ), //i
    .a1     (dSP_113_a1[7:0]), //i
    .d1     (dSP_113_d1[7:0]), //i
    .CLK_2X (CLK_2X         ), //i
    .RST_2X (RST_2X         )  //i
  );
  DSP dSP_114 (
    .a      (dSP_114_a[7:0] ), //i
    .d      (dSP_114_d[7:0] ), //i
    .b      (dSP_114_b[7:0] ), //i
    .p      (dSP_114_p[63:0]), //o
    .CLK    (clk            ), //i
    .a1     (dSP_114_a1[7:0]), //i
    .d1     (dSP_114_d1[7:0]), //i
    .CLK_2X (CLK_2X         ), //i
    .RST_2X (RST_2X         )  //i
  );
  DSP dSP_115 (
    .a      (dSP_115_a[7:0] ), //i
    .d      (dSP_115_d[7:0] ), //i
    .b      (dSP_115_b[7:0] ), //i
    .p      (dSP_115_p[63:0]), //o
    .CLK    (clk            ), //i
    .a1     (dSP_115_a1[7:0]), //i
    .d1     (dSP_115_d1[7:0]), //i
    .CLK_2X (CLK_2X         ), //i
    .RST_2X (RST_2X         )  //i
  );
  DSP dSP_116 (
    .a      (dSP_116_a[7:0] ), //i
    .d      (dSP_116_d[7:0] ), //i
    .b      (dSP_116_b[7:0] ), //i
    .p      (dSP_116_p[63:0]), //o
    .CLK    (clk            ), //i
    .a1     (dSP_116_a1[7:0]), //i
    .d1     (dSP_116_d1[7:0]), //i
    .CLK_2X (CLK_2X         ), //i
    .RST_2X (RST_2X         )  //i
  );
  DSP dSP_117 (
    .a      (dSP_117_a[7:0] ), //i
    .d      (dSP_117_d[7:0] ), //i
    .b      (dSP_117_b[7:0] ), //i
    .p      (dSP_117_p[63:0]), //o
    .CLK    (clk            ), //i
    .a1     (dSP_117_a1[7:0]), //i
    .d1     (dSP_117_d1[7:0]), //i
    .CLK_2X (CLK_2X         ), //i
    .RST_2X (RST_2X         )  //i
  );
  DSP dSP_118 (
    .a      (dSP_118_a[7:0] ), //i
    .d      (dSP_118_d[7:0] ), //i
    .b      (dSP_118_b[7:0] ), //i
    .p      (dSP_118_p[63:0]), //o
    .CLK    (clk            ), //i
    .a1     (dSP_118_a1[7:0]), //i
    .d1     (dSP_118_d1[7:0]), //i
    .CLK_2X (CLK_2X         ), //i
    .RST_2X (RST_2X         )  //i
  );
  DSP dSP_119 (
    .a      (dSP_119_a[7:0] ), //i
    .d      (dSP_119_d[7:0] ), //i
    .b      (dSP_119_b[7:0] ), //i
    .p      (dSP_119_p[63:0]), //o
    .CLK    (clk            ), //i
    .a1     (dSP_119_a1[7:0]), //i
    .d1     (dSP_119_d1[7:0]), //i
    .CLK_2X (CLK_2X         ), //i
    .RST_2X (RST_2X         )  //i
  );
  DSP dSP_120 (
    .a      (dSP_120_a[7:0] ), //i
    .d      (dSP_120_d[7:0] ), //i
    .b      (dSP_120_b[7:0] ), //i
    .p      (dSP_120_p[63:0]), //o
    .CLK    (clk            ), //i
    .a1     (dSP_120_a1[7:0]), //i
    .d1     (dSP_120_d1[7:0]), //i
    .CLK_2X (CLK_2X         ), //i
    .RST_2X (RST_2X         )  //i
  );
  DSP dSP_121 (
    .a      (dSP_121_a[7:0] ), //i
    .d      (dSP_121_d[7:0] ), //i
    .b      (dSP_121_b[7:0] ), //i
    .p      (dSP_121_p[63:0]), //o
    .CLK    (clk            ), //i
    .a1     (dSP_121_a1[7:0]), //i
    .d1     (dSP_121_d1[7:0]), //i
    .CLK_2X (CLK_2X         ), //i
    .RST_2X (RST_2X         )  //i
  );
  DSP dSP_122 (
    .a      (dSP_122_a[7:0] ), //i
    .d      (dSP_122_d[7:0] ), //i
    .b      (dSP_122_b[7:0] ), //i
    .p      (dSP_122_p[63:0]), //o
    .CLK    (clk            ), //i
    .a1     (dSP_122_a1[7:0]), //i
    .d1     (dSP_122_d1[7:0]), //i
    .CLK_2X (CLK_2X         ), //i
    .RST_2X (RST_2X         )  //i
  );
  DSP dSP_123 (
    .a      (dSP_123_a[7:0] ), //i
    .d      (dSP_123_d[7:0] ), //i
    .b      (dSP_123_b[7:0] ), //i
    .p      (dSP_123_p[63:0]), //o
    .CLK    (clk            ), //i
    .a1     (dSP_123_a1[7:0]), //i
    .d1     (dSP_123_d1[7:0]), //i
    .CLK_2X (CLK_2X         ), //i
    .RST_2X (RST_2X         )  //i
  );
  DSP dSP_124 (
    .a      (dSP_124_a[7:0] ), //i
    .d      (dSP_124_d[7:0] ), //i
    .b      (dSP_124_b[7:0] ), //i
    .p      (dSP_124_p[63:0]), //o
    .CLK    (clk            ), //i
    .a1     (dSP_124_a1[7:0]), //i
    .d1     (dSP_124_d1[7:0]), //i
    .CLK_2X (CLK_2X         ), //i
    .RST_2X (RST_2X         )  //i
  );
  DSP dSP_125 (
    .a      (dSP_125_a[7:0] ), //i
    .d      (dSP_125_d[7:0] ), //i
    .b      (dSP_125_b[7:0] ), //i
    .p      (dSP_125_p[63:0]), //o
    .CLK    (clk            ), //i
    .a1     (dSP_125_a1[7:0]), //i
    .d1     (dSP_125_d1[7:0]), //i
    .CLK_2X (CLK_2X         ), //i
    .RST_2X (RST_2X         )  //i
  );
  DSP dSP_126 (
    .a      (dSP_126_a[7:0] ), //i
    .d      (dSP_126_d[7:0] ), //i
    .b      (dSP_126_b[7:0] ), //i
    .p      (dSP_126_p[63:0]), //o
    .CLK    (clk            ), //i
    .a1     (dSP_126_a1[7:0]), //i
    .d1     (dSP_126_d1[7:0]), //i
    .CLK_2X (CLK_2X         ), //i
    .RST_2X (RST_2X         )  //i
  );
  DSP dSP_127 (
    .a      (dSP_127_a[7:0] ), //i
    .d      (dSP_127_d[7:0] ), //i
    .b      (dSP_127_b[7:0] ), //i
    .p      (dSP_127_p[63:0]), //o
    .CLK    (clk            ), //i
    .a1     (dSP_127_a1[7:0]), //i
    .d1     (dSP_127_d1[7:0]), //i
    .CLK_2X (CLK_2X         ), //i
    .RST_2X (RST_2X         )  //i
  );
  DSP dSP_128 (
    .a      (dSP_128_a[7:0] ), //i
    .d      (dSP_128_d[7:0] ), //i
    .b      (dSP_128_b[7:0] ), //i
    .p      (dSP_128_p[63:0]), //o
    .CLK    (clk            ), //i
    .a1     (dSP_128_a1[7:0]), //i
    .d1     (dSP_128_d1[7:0]), //i
    .CLK_2X (CLK_2X         ), //i
    .RST_2X (RST_2X         )  //i
  );
  DSP dSP_129 (
    .a      (dSP_129_a[7:0] ), //i
    .d      (dSP_129_d[7:0] ), //i
    .b      (dSP_129_b[7:0] ), //i
    .p      (dSP_129_p[63:0]), //o
    .CLK    (clk            ), //i
    .a1     (dSP_129_a1[7:0]), //i
    .d1     (dSP_129_d1[7:0]), //i
    .CLK_2X (CLK_2X         ), //i
    .RST_2X (RST_2X         )  //i
  );
  DSP dSP_130 (
    .a      (dSP_130_a[7:0] ), //i
    .d      (dSP_130_d[7:0] ), //i
    .b      (dSP_130_b[7:0] ), //i
    .p      (dSP_130_p[63:0]), //o
    .CLK    (clk            ), //i
    .a1     (dSP_130_a1[7:0]), //i
    .d1     (dSP_130_d1[7:0]), //i
    .CLK_2X (CLK_2X         ), //i
    .RST_2X (RST_2X         )  //i
  );
  DSP dSP_131 (
    .a      (dSP_131_a[7:0] ), //i
    .d      (dSP_131_d[7:0] ), //i
    .b      (dSP_131_b[7:0] ), //i
    .p      (dSP_131_p[63:0]), //o
    .CLK    (clk            ), //i
    .a1     (dSP_131_a1[7:0]), //i
    .d1     (dSP_131_d1[7:0]), //i
    .CLK_2X (CLK_2X         ), //i
    .RST_2X (RST_2X         )  //i
  );
  DSP dSP_132 (
    .a      (dSP_132_a[7:0] ), //i
    .d      (dSP_132_d[7:0] ), //i
    .b      (dSP_132_b[7:0] ), //i
    .p      (dSP_132_p[63:0]), //o
    .CLK    (clk            ), //i
    .a1     (dSP_132_a1[7:0]), //i
    .d1     (dSP_132_d1[7:0]), //i
    .CLK_2X (CLK_2X         ), //i
    .RST_2X (RST_2X         )  //i
  );
  DSP dSP_133 (
    .a      (dSP_133_a[7:0] ), //i
    .d      (dSP_133_d[7:0] ), //i
    .b      (dSP_133_b[7:0] ), //i
    .p      (dSP_133_p[63:0]), //o
    .CLK    (clk            ), //i
    .a1     (dSP_133_a1[7:0]), //i
    .d1     (dSP_133_d1[7:0]), //i
    .CLK_2X (CLK_2X         ), //i
    .RST_2X (RST_2X         )  //i
  );
  DSP dSP_134 (
    .a      (dSP_134_a[7:0] ), //i
    .d      (dSP_134_d[7:0] ), //i
    .b      (dSP_134_b[7:0] ), //i
    .p      (dSP_134_p[63:0]), //o
    .CLK    (clk            ), //i
    .a1     (dSP_134_a1[7:0]), //i
    .d1     (dSP_134_d1[7:0]), //i
    .CLK_2X (CLK_2X         ), //i
    .RST_2X (RST_2X         )  //i
  );
  DSP dSP_135 (
    .a      (dSP_135_a[7:0] ), //i
    .d      (dSP_135_d[7:0] ), //i
    .b      (dSP_135_b[7:0] ), //i
    .p      (dSP_135_p[63:0]), //o
    .CLK    (clk            ), //i
    .a1     (dSP_135_a1[7:0]), //i
    .d1     (dSP_135_d1[7:0]), //i
    .CLK_2X (CLK_2X         ), //i
    .RST_2X (RST_2X         )  //i
  );
  DSP dSP_136 (
    .a      (dSP_136_a[7:0] ), //i
    .d      (dSP_136_d[7:0] ), //i
    .b      (dSP_136_b[7:0] ), //i
    .p      (dSP_136_p[63:0]), //o
    .CLK    (clk            ), //i
    .a1     (dSP_136_a1[7:0]), //i
    .d1     (dSP_136_d1[7:0]), //i
    .CLK_2X (CLK_2X         ), //i
    .RST_2X (RST_2X         )  //i
  );
  DSP dSP_137 (
    .a      (dSP_137_a[7:0] ), //i
    .d      (dSP_137_d[7:0] ), //i
    .b      (dSP_137_b[7:0] ), //i
    .p      (dSP_137_p[63:0]), //o
    .CLK    (clk            ), //i
    .a1     (dSP_137_a1[7:0]), //i
    .d1     (dSP_137_d1[7:0]), //i
    .CLK_2X (CLK_2X         ), //i
    .RST_2X (RST_2X         )  //i
  );
  DSP dSP_138 (
    .a      (dSP_138_a[7:0] ), //i
    .d      (dSP_138_d[7:0] ), //i
    .b      (dSP_138_b[7:0] ), //i
    .p      (dSP_138_p[63:0]), //o
    .CLK    (clk            ), //i
    .a1     (dSP_138_a1[7:0]), //i
    .d1     (dSP_138_d1[7:0]), //i
    .CLK_2X (CLK_2X         ), //i
    .RST_2X (RST_2X         )  //i
  );
  DSP dSP_139 (
    .a      (dSP_139_a[7:0] ), //i
    .d      (dSP_139_d[7:0] ), //i
    .b      (dSP_139_b[7:0] ), //i
    .p      (dSP_139_p[63:0]), //o
    .CLK    (clk            ), //i
    .a1     (dSP_139_a1[7:0]), //i
    .d1     (dSP_139_d1[7:0]), //i
    .CLK_2X (CLK_2X         ), //i
    .RST_2X (RST_2X         )  //i
  );
  DSP dSP_140 (
    .a      (dSP_140_a[7:0] ), //i
    .d      (dSP_140_d[7:0] ), //i
    .b      (dSP_140_b[7:0] ), //i
    .p      (dSP_140_p[63:0]), //o
    .CLK    (clk            ), //i
    .a1     (dSP_140_a1[7:0]), //i
    .d1     (dSP_140_d1[7:0]), //i
    .CLK_2X (CLK_2X         ), //i
    .RST_2X (RST_2X         )  //i
  );
  DSP dSP_141 (
    .a      (dSP_141_a[7:0] ), //i
    .d      (dSP_141_d[7:0] ), //i
    .b      (dSP_141_b[7:0] ), //i
    .p      (dSP_141_p[63:0]), //o
    .CLK    (clk            ), //i
    .a1     (dSP_141_a1[7:0]), //i
    .d1     (dSP_141_d1[7:0]), //i
    .CLK_2X (CLK_2X         ), //i
    .RST_2X (RST_2X         )  //i
  );
  DSP dSP_142 (
    .a      (dSP_142_a[7:0] ), //i
    .d      (dSP_142_d[7:0] ), //i
    .b      (dSP_142_b[7:0] ), //i
    .p      (dSP_142_p[63:0]), //o
    .CLK    (clk            ), //i
    .a1     (dSP_142_a1[7:0]), //i
    .d1     (dSP_142_d1[7:0]), //i
    .CLK_2X (CLK_2X         ), //i
    .RST_2X (RST_2X         )  //i
  );
  DSP dSP_143 (
    .a      (dSP_143_a[7:0] ), //i
    .d      (dSP_143_d[7:0] ), //i
    .b      (dSP_143_b[7:0] ), //i
    .p      (dSP_143_p[63:0]), //o
    .CLK    (clk            ), //i
    .a1     (dSP_143_a1[7:0]), //i
    .d1     (dSP_143_d1[7:0]), //i
    .CLK_2X (CLK_2X         ), //i
    .RST_2X (RST_2X         )  //i
  );
  DSP dSP_144 (
    .a      (dSP_144_a[7:0] ), //i
    .d      (dSP_144_d[7:0] ), //i
    .b      (dSP_144_b[7:0] ), //i
    .p      (dSP_144_p[63:0]), //o
    .CLK    (clk            ), //i
    .a1     (dSP_144_a1[7:0]), //i
    .d1     (dSP_144_d1[7:0]), //i
    .CLK_2X (CLK_2X         ), //i
    .RST_2X (RST_2X         )  //i
  );
  xAddTimes addKernel (
    .A_0   (addKernel_A_0[31:0]), //i
    .A_1   (addKernel_A_1[31:0]), //i
    .A_2   (addKernel_A_2[31:0]), //i
    .A_3   (addKernel_A_3[31:0]), //i
    .A_4   (addKernel_A_4[31:0]), //i
    .A_5   (addKernel_A_5[31:0]), //i
    .A_6   (addKernel_A_6[31:0]), //i
    .A_7   (addKernel_A_7[31:0]), //i
    .A_8   (addKernel_A_8[31:0]), //i
    .S     (addKernel_S[39:0]  ), //o
    .clk   (clk                ), //i
    .reset (reset              )  //i
  );
  xAddTimes addKernel_1 (
    .A_0   (addKernel_1_A_0[31:0]), //i
    .A_1   (addKernel_1_A_1[31:0]), //i
    .A_2   (addKernel_1_A_2[31:0]), //i
    .A_3   (addKernel_1_A_3[31:0]), //i
    .A_4   (addKernel_1_A_4[31:0]), //i
    .A_5   (addKernel_1_A_5[31:0]), //i
    .A_6   (addKernel_1_A_6[31:0]), //i
    .A_7   (addKernel_1_A_7[31:0]), //i
    .A_8   (addKernel_1_A_8[31:0]), //i
    .S     (addKernel_1_S[39:0]  ), //o
    .clk   (clk                  ), //i
    .reset (reset                )  //i
  );
  xAddTimes addKernel_2 (
    .A_0   (addKernel_2_A_0[31:0]), //i
    .A_1   (addKernel_2_A_1[31:0]), //i
    .A_2   (addKernel_2_A_2[31:0]), //i
    .A_3   (addKernel_2_A_3[31:0]), //i
    .A_4   (addKernel_2_A_4[31:0]), //i
    .A_5   (addKernel_2_A_5[31:0]), //i
    .A_6   (addKernel_2_A_6[31:0]), //i
    .A_7   (addKernel_2_A_7[31:0]), //i
    .A_8   (addKernel_2_A_8[31:0]), //i
    .S     (addKernel_2_S[39:0]  ), //o
    .clk   (clk                  ), //i
    .reset (reset                )  //i
  );
  xAddTimes addKernel_3 (
    .A_0   (addKernel_3_A_0[31:0]), //i
    .A_1   (addKernel_3_A_1[31:0]), //i
    .A_2   (addKernel_3_A_2[31:0]), //i
    .A_3   (addKernel_3_A_3[31:0]), //i
    .A_4   (addKernel_3_A_4[31:0]), //i
    .A_5   (addKernel_3_A_5[31:0]), //i
    .A_6   (addKernel_3_A_6[31:0]), //i
    .A_7   (addKernel_3_A_7[31:0]), //i
    .A_8   (addKernel_3_A_8[31:0]), //i
    .S     (addKernel_3_S[39:0]  ), //o
    .clk   (clk                  ), //i
    .reset (reset                )  //i
  );
  xAddTimes addKernel_4 (
    .A_0   (addKernel_4_A_0[31:0]), //i
    .A_1   (addKernel_4_A_1[31:0]), //i
    .A_2   (addKernel_4_A_2[31:0]), //i
    .A_3   (addKernel_4_A_3[31:0]), //i
    .A_4   (addKernel_4_A_4[31:0]), //i
    .A_5   (addKernel_4_A_5[31:0]), //i
    .A_6   (addKernel_4_A_6[31:0]), //i
    .A_7   (addKernel_4_A_7[31:0]), //i
    .A_8   (addKernel_4_A_8[31:0]), //i
    .S     (addKernel_4_S[39:0]  ), //o
    .clk   (clk                  ), //i
    .reset (reset                )  //i
  );
  xAddTimes addKernel_5 (
    .A_0   (addKernel_5_A_0[31:0]), //i
    .A_1   (addKernel_5_A_1[31:0]), //i
    .A_2   (addKernel_5_A_2[31:0]), //i
    .A_3   (addKernel_5_A_3[31:0]), //i
    .A_4   (addKernel_5_A_4[31:0]), //i
    .A_5   (addKernel_5_A_5[31:0]), //i
    .A_6   (addKernel_5_A_6[31:0]), //i
    .A_7   (addKernel_5_A_7[31:0]), //i
    .A_8   (addKernel_5_A_8[31:0]), //i
    .S     (addKernel_5_S[39:0]  ), //o
    .clk   (clk                  ), //i
    .reset (reset                )  //i
  );
  xAddTimes addKernel_6 (
    .A_0   (addKernel_6_A_0[31:0]), //i
    .A_1   (addKernel_6_A_1[31:0]), //i
    .A_2   (addKernel_6_A_2[31:0]), //i
    .A_3   (addKernel_6_A_3[31:0]), //i
    .A_4   (addKernel_6_A_4[31:0]), //i
    .A_5   (addKernel_6_A_5[31:0]), //i
    .A_6   (addKernel_6_A_6[31:0]), //i
    .A_7   (addKernel_6_A_7[31:0]), //i
    .A_8   (addKernel_6_A_8[31:0]), //i
    .S     (addKernel_6_S[39:0]  ), //o
    .clk   (clk                  ), //i
    .reset (reset                )  //i
  );
  xAddTimes addKernel_7 (
    .A_0   (addKernel_7_A_0[31:0]), //i
    .A_1   (addKernel_7_A_1[31:0]), //i
    .A_2   (addKernel_7_A_2[31:0]), //i
    .A_3   (addKernel_7_A_3[31:0]), //i
    .A_4   (addKernel_7_A_4[31:0]), //i
    .A_5   (addKernel_7_A_5[31:0]), //i
    .A_6   (addKernel_7_A_6[31:0]), //i
    .A_7   (addKernel_7_A_7[31:0]), //i
    .A_8   (addKernel_7_A_8[31:0]), //i
    .S     (addKernel_7_S[39:0]  ), //o
    .clk   (clk                  ), //i
    .reset (reset                )  //i
  );
  xAddTimes addKernel_8 (
    .A_0   (addKernel_8_A_0[31:0]), //i
    .A_1   (addKernel_8_A_1[31:0]), //i
    .A_2   (addKernel_8_A_2[31:0]), //i
    .A_3   (addKernel_8_A_3[31:0]), //i
    .A_4   (addKernel_8_A_4[31:0]), //i
    .A_5   (addKernel_8_A_5[31:0]), //i
    .A_6   (addKernel_8_A_6[31:0]), //i
    .A_7   (addKernel_8_A_7[31:0]), //i
    .A_8   (addKernel_8_A_8[31:0]), //i
    .S     (addKernel_8_S[39:0]  ), //o
    .clk   (clk                  ), //i
    .reset (reset                )  //i
  );
  xAddTimes addKernel_9 (
    .A_0   (addKernel_9_A_0[31:0]), //i
    .A_1   (addKernel_9_A_1[31:0]), //i
    .A_2   (addKernel_9_A_2[31:0]), //i
    .A_3   (addKernel_9_A_3[31:0]), //i
    .A_4   (addKernel_9_A_4[31:0]), //i
    .A_5   (addKernel_9_A_5[31:0]), //i
    .A_6   (addKernel_9_A_6[31:0]), //i
    .A_7   (addKernel_9_A_7[31:0]), //i
    .A_8   (addKernel_9_A_8[31:0]), //i
    .S     (addKernel_9_S[39:0]  ), //o
    .clk   (clk                  ), //i
    .reset (reset                )  //i
  );
  xAddTimes addKernel_10 (
    .A_0   (addKernel_10_A_0[31:0]), //i
    .A_1   (addKernel_10_A_1[31:0]), //i
    .A_2   (addKernel_10_A_2[31:0]), //i
    .A_3   (addKernel_10_A_3[31:0]), //i
    .A_4   (addKernel_10_A_4[31:0]), //i
    .A_5   (addKernel_10_A_5[31:0]), //i
    .A_6   (addKernel_10_A_6[31:0]), //i
    .A_7   (addKernel_10_A_7[31:0]), //i
    .A_8   (addKernel_10_A_8[31:0]), //i
    .S     (addKernel_10_S[39:0]  ), //o
    .clk   (clk                   ), //i
    .reset (reset                 )  //i
  );
  xAddTimes addKernel_11 (
    .A_0   (addKernel_11_A_0[31:0]), //i
    .A_1   (addKernel_11_A_1[31:0]), //i
    .A_2   (addKernel_11_A_2[31:0]), //i
    .A_3   (addKernel_11_A_3[31:0]), //i
    .A_4   (addKernel_11_A_4[31:0]), //i
    .A_5   (addKernel_11_A_5[31:0]), //i
    .A_6   (addKernel_11_A_6[31:0]), //i
    .A_7   (addKernel_11_A_7[31:0]), //i
    .A_8   (addKernel_11_A_8[31:0]), //i
    .S     (addKernel_11_S[39:0]  ), //o
    .clk   (clk                   ), //i
    .reset (reset                 )  //i
  );
  xAddTimes addKernel_12 (
    .A_0   (addKernel_12_A_0[31:0]), //i
    .A_1   (addKernel_12_A_1[31:0]), //i
    .A_2   (addKernel_12_A_2[31:0]), //i
    .A_3   (addKernel_12_A_3[31:0]), //i
    .A_4   (addKernel_12_A_4[31:0]), //i
    .A_5   (addKernel_12_A_5[31:0]), //i
    .A_6   (addKernel_12_A_6[31:0]), //i
    .A_7   (addKernel_12_A_7[31:0]), //i
    .A_8   (addKernel_12_A_8[31:0]), //i
    .S     (addKernel_12_S[39:0]  ), //o
    .clk   (clk                   ), //i
    .reset (reset                 )  //i
  );
  xAddTimes addKernel_13 (
    .A_0   (addKernel_13_A_0[31:0]), //i
    .A_1   (addKernel_13_A_1[31:0]), //i
    .A_2   (addKernel_13_A_2[31:0]), //i
    .A_3   (addKernel_13_A_3[31:0]), //i
    .A_4   (addKernel_13_A_4[31:0]), //i
    .A_5   (addKernel_13_A_5[31:0]), //i
    .A_6   (addKernel_13_A_6[31:0]), //i
    .A_7   (addKernel_13_A_7[31:0]), //i
    .A_8   (addKernel_13_A_8[31:0]), //i
    .S     (addKernel_13_S[39:0]  ), //o
    .clk   (clk                   ), //i
    .reset (reset                 )  //i
  );
  xAddTimes addKernel_14 (
    .A_0   (addKernel_14_A_0[31:0]), //i
    .A_1   (addKernel_14_A_1[31:0]), //i
    .A_2   (addKernel_14_A_2[31:0]), //i
    .A_3   (addKernel_14_A_3[31:0]), //i
    .A_4   (addKernel_14_A_4[31:0]), //i
    .A_5   (addKernel_14_A_5[31:0]), //i
    .A_6   (addKernel_14_A_6[31:0]), //i
    .A_7   (addKernel_14_A_7[31:0]), //i
    .A_8   (addKernel_14_A_8[31:0]), //i
    .S     (addKernel_14_S[39:0]  ), //o
    .clk   (clk                   ), //i
    .reset (reset                 )  //i
  );
  xAddTimes addKernel_15 (
    .A_0   (addKernel_15_A_0[31:0]), //i
    .A_1   (addKernel_15_A_1[31:0]), //i
    .A_2   (addKernel_15_A_2[31:0]), //i
    .A_3   (addKernel_15_A_3[31:0]), //i
    .A_4   (addKernel_15_A_4[31:0]), //i
    .A_5   (addKernel_15_A_5[31:0]), //i
    .A_6   (addKernel_15_A_6[31:0]), //i
    .A_7   (addKernel_15_A_7[31:0]), //i
    .A_8   (addKernel_15_A_8[31:0]), //i
    .S     (addKernel_15_S[39:0]  ), //o
    .clk   (clk                   ), //i
    .reset (reset                 )  //i
  );
  xAddTimes addKernel_16 (
    .A_0   (addKernel_16_A_0[31:0]), //i
    .A_1   (addKernel_16_A_1[31:0]), //i
    .A_2   (addKernel_16_A_2[31:0]), //i
    .A_3   (addKernel_16_A_3[31:0]), //i
    .A_4   (addKernel_16_A_4[31:0]), //i
    .A_5   (addKernel_16_A_5[31:0]), //i
    .A_6   (addKernel_16_A_6[31:0]), //i
    .A_7   (addKernel_16_A_7[31:0]), //i
    .A_8   (addKernel_16_A_8[31:0]), //i
    .S     (addKernel_16_S[39:0]  ), //o
    .clk   (clk                   ), //i
    .reset (reset                 )  //i
  );
  xAddTimes addKernel_17 (
    .A_0   (addKernel_17_A_0[31:0]), //i
    .A_1   (addKernel_17_A_1[31:0]), //i
    .A_2   (addKernel_17_A_2[31:0]), //i
    .A_3   (addKernel_17_A_3[31:0]), //i
    .A_4   (addKernel_17_A_4[31:0]), //i
    .A_5   (addKernel_17_A_5[31:0]), //i
    .A_6   (addKernel_17_A_6[31:0]), //i
    .A_7   (addKernel_17_A_7[31:0]), //i
    .A_8   (addKernel_17_A_8[31:0]), //i
    .S     (addKernel_17_S[39:0]  ), //o
    .clk   (clk                   ), //i
    .reset (reset                 )  //i
  );
  xAddTimes addKernel_18 (
    .A_0   (addKernel_18_A_0[31:0]), //i
    .A_1   (addKernel_18_A_1[31:0]), //i
    .A_2   (addKernel_18_A_2[31:0]), //i
    .A_3   (addKernel_18_A_3[31:0]), //i
    .A_4   (addKernel_18_A_4[31:0]), //i
    .A_5   (addKernel_18_A_5[31:0]), //i
    .A_6   (addKernel_18_A_6[31:0]), //i
    .A_7   (addKernel_18_A_7[31:0]), //i
    .A_8   (addKernel_18_A_8[31:0]), //i
    .S     (addKernel_18_S[39:0]  ), //o
    .clk   (clk                   ), //i
    .reset (reset                 )  //i
  );
  xAddTimes addKernel_19 (
    .A_0   (addKernel_19_A_0[31:0]), //i
    .A_1   (addKernel_19_A_1[31:0]), //i
    .A_2   (addKernel_19_A_2[31:0]), //i
    .A_3   (addKernel_19_A_3[31:0]), //i
    .A_4   (addKernel_19_A_4[31:0]), //i
    .A_5   (addKernel_19_A_5[31:0]), //i
    .A_6   (addKernel_19_A_6[31:0]), //i
    .A_7   (addKernel_19_A_7[31:0]), //i
    .A_8   (addKernel_19_A_8[31:0]), //i
    .S     (addKernel_19_S[39:0]  ), //o
    .clk   (clk                   ), //i
    .reset (reset                 )  //i
  );
  xAddTimes addKernel_20 (
    .A_0   (addKernel_20_A_0[31:0]), //i
    .A_1   (addKernel_20_A_1[31:0]), //i
    .A_2   (addKernel_20_A_2[31:0]), //i
    .A_3   (addKernel_20_A_3[31:0]), //i
    .A_4   (addKernel_20_A_4[31:0]), //i
    .A_5   (addKernel_20_A_5[31:0]), //i
    .A_6   (addKernel_20_A_6[31:0]), //i
    .A_7   (addKernel_20_A_7[31:0]), //i
    .A_8   (addKernel_20_A_8[31:0]), //i
    .S     (addKernel_20_S[39:0]  ), //o
    .clk   (clk                   ), //i
    .reset (reset                 )  //i
  );
  xAddTimes addKernel_21 (
    .A_0   (addKernel_21_A_0[31:0]), //i
    .A_1   (addKernel_21_A_1[31:0]), //i
    .A_2   (addKernel_21_A_2[31:0]), //i
    .A_3   (addKernel_21_A_3[31:0]), //i
    .A_4   (addKernel_21_A_4[31:0]), //i
    .A_5   (addKernel_21_A_5[31:0]), //i
    .A_6   (addKernel_21_A_6[31:0]), //i
    .A_7   (addKernel_21_A_7[31:0]), //i
    .A_8   (addKernel_21_A_8[31:0]), //i
    .S     (addKernel_21_S[39:0]  ), //o
    .clk   (clk                   ), //i
    .reset (reset                 )  //i
  );
  xAddTimes addKernel_22 (
    .A_0   (addKernel_22_A_0[31:0]), //i
    .A_1   (addKernel_22_A_1[31:0]), //i
    .A_2   (addKernel_22_A_2[31:0]), //i
    .A_3   (addKernel_22_A_3[31:0]), //i
    .A_4   (addKernel_22_A_4[31:0]), //i
    .A_5   (addKernel_22_A_5[31:0]), //i
    .A_6   (addKernel_22_A_6[31:0]), //i
    .A_7   (addKernel_22_A_7[31:0]), //i
    .A_8   (addKernel_22_A_8[31:0]), //i
    .S     (addKernel_22_S[39:0]  ), //o
    .clk   (clk                   ), //i
    .reset (reset                 )  //i
  );
  xAddTimes addKernel_23 (
    .A_0   (addKernel_23_A_0[31:0]), //i
    .A_1   (addKernel_23_A_1[31:0]), //i
    .A_2   (addKernel_23_A_2[31:0]), //i
    .A_3   (addKernel_23_A_3[31:0]), //i
    .A_4   (addKernel_23_A_4[31:0]), //i
    .A_5   (addKernel_23_A_5[31:0]), //i
    .A_6   (addKernel_23_A_6[31:0]), //i
    .A_7   (addKernel_23_A_7[31:0]), //i
    .A_8   (addKernel_23_A_8[31:0]), //i
    .S     (addKernel_23_S[39:0]  ), //o
    .clk   (clk                   ), //i
    .reset (reset                 )  //i
  );
  xAddTimes addKernel_24 (
    .A_0   (addKernel_24_A_0[31:0]), //i
    .A_1   (addKernel_24_A_1[31:0]), //i
    .A_2   (addKernel_24_A_2[31:0]), //i
    .A_3   (addKernel_24_A_3[31:0]), //i
    .A_4   (addKernel_24_A_4[31:0]), //i
    .A_5   (addKernel_24_A_5[31:0]), //i
    .A_6   (addKernel_24_A_6[31:0]), //i
    .A_7   (addKernel_24_A_7[31:0]), //i
    .A_8   (addKernel_24_A_8[31:0]), //i
    .S     (addKernel_24_S[39:0]  ), //o
    .clk   (clk                   ), //i
    .reset (reset                 )  //i
  );
  xAddTimes addKernel_25 (
    .A_0   (addKernel_25_A_0[31:0]), //i
    .A_1   (addKernel_25_A_1[31:0]), //i
    .A_2   (addKernel_25_A_2[31:0]), //i
    .A_3   (addKernel_25_A_3[31:0]), //i
    .A_4   (addKernel_25_A_4[31:0]), //i
    .A_5   (addKernel_25_A_5[31:0]), //i
    .A_6   (addKernel_25_A_6[31:0]), //i
    .A_7   (addKernel_25_A_7[31:0]), //i
    .A_8   (addKernel_25_A_8[31:0]), //i
    .S     (addKernel_25_S[39:0]  ), //o
    .clk   (clk                   ), //i
    .reset (reset                 )  //i
  );
  xAddTimes addKernel_26 (
    .A_0   (addKernel_26_A_0[31:0]), //i
    .A_1   (addKernel_26_A_1[31:0]), //i
    .A_2   (addKernel_26_A_2[31:0]), //i
    .A_3   (addKernel_26_A_3[31:0]), //i
    .A_4   (addKernel_26_A_4[31:0]), //i
    .A_5   (addKernel_26_A_5[31:0]), //i
    .A_6   (addKernel_26_A_6[31:0]), //i
    .A_7   (addKernel_26_A_7[31:0]), //i
    .A_8   (addKernel_26_A_8[31:0]), //i
    .S     (addKernel_26_S[39:0]  ), //o
    .clk   (clk                   ), //i
    .reset (reset                 )  //i
  );
  xAddTimes addKernel_27 (
    .A_0   (addKernel_27_A_0[31:0]), //i
    .A_1   (addKernel_27_A_1[31:0]), //i
    .A_2   (addKernel_27_A_2[31:0]), //i
    .A_3   (addKernel_27_A_3[31:0]), //i
    .A_4   (addKernel_27_A_4[31:0]), //i
    .A_5   (addKernel_27_A_5[31:0]), //i
    .A_6   (addKernel_27_A_6[31:0]), //i
    .A_7   (addKernel_27_A_7[31:0]), //i
    .A_8   (addKernel_27_A_8[31:0]), //i
    .S     (addKernel_27_S[39:0]  ), //o
    .clk   (clk                   ), //i
    .reset (reset                 )  //i
  );
  xAddTimes addKernel_28 (
    .A_0   (addKernel_28_A_0[31:0]), //i
    .A_1   (addKernel_28_A_1[31:0]), //i
    .A_2   (addKernel_28_A_2[31:0]), //i
    .A_3   (addKernel_28_A_3[31:0]), //i
    .A_4   (addKernel_28_A_4[31:0]), //i
    .A_5   (addKernel_28_A_5[31:0]), //i
    .A_6   (addKernel_28_A_6[31:0]), //i
    .A_7   (addKernel_28_A_7[31:0]), //i
    .A_8   (addKernel_28_A_8[31:0]), //i
    .S     (addKernel_28_S[39:0]  ), //o
    .clk   (clk                   ), //i
    .reset (reset                 )  //i
  );
  xAddTimes addKernel_29 (
    .A_0   (addKernel_29_A_0[31:0]), //i
    .A_1   (addKernel_29_A_1[31:0]), //i
    .A_2   (addKernel_29_A_2[31:0]), //i
    .A_3   (addKernel_29_A_3[31:0]), //i
    .A_4   (addKernel_29_A_4[31:0]), //i
    .A_5   (addKernel_29_A_5[31:0]), //i
    .A_6   (addKernel_29_A_6[31:0]), //i
    .A_7   (addKernel_29_A_7[31:0]), //i
    .A_8   (addKernel_29_A_8[31:0]), //i
    .S     (addKernel_29_S[39:0]  ), //o
    .clk   (clk                   ), //i
    .reset (reset                 )  //i
  );
  xAddTimes addKernel_30 (
    .A_0   (addKernel_30_A_0[31:0]), //i
    .A_1   (addKernel_30_A_1[31:0]), //i
    .A_2   (addKernel_30_A_2[31:0]), //i
    .A_3   (addKernel_30_A_3[31:0]), //i
    .A_4   (addKernel_30_A_4[31:0]), //i
    .A_5   (addKernel_30_A_5[31:0]), //i
    .A_6   (addKernel_30_A_6[31:0]), //i
    .A_7   (addKernel_30_A_7[31:0]), //i
    .A_8   (addKernel_30_A_8[31:0]), //i
    .S     (addKernel_30_S[39:0]  ), //o
    .clk   (clk                   ), //i
    .reset (reset                 )  //i
  );
  xAddTimes addKernel_31 (
    .A_0   (addKernel_31_A_0[31:0]), //i
    .A_1   (addKernel_31_A_1[31:0]), //i
    .A_2   (addKernel_31_A_2[31:0]), //i
    .A_3   (addKernel_31_A_3[31:0]), //i
    .A_4   (addKernel_31_A_4[31:0]), //i
    .A_5   (addKernel_31_A_5[31:0]), //i
    .A_6   (addKernel_31_A_6[31:0]), //i
    .A_7   (addKernel_31_A_7[31:0]), //i
    .A_8   (addKernel_31_A_8[31:0]), //i
    .S     (addKernel_31_S[39:0]  ), //o
    .clk   (clk                   ), //i
    .reset (reset                 )  //i
  );
  xAddTimes_32 xAddTimes_36 (
    .A_0   (addKernelData_0_0[39:0]), //i
    .A_1   (addKernelData_0_1[39:0]), //i
    .A_2   (addKernelData_0_2[39:0]), //i
    .A_3   (addKernelData_0_3[39:0]), //i
    .A_4   (addKernelData_0_4[39:0]), //i
    .A_5   (addKernelData_0_5[39:0]), //i
    .A_6   (addKernelData_0_6[39:0]), //i
    .A_7   (addKernelData_0_7[39:0]), //i
    .S     (xAddTimes_36_S[45:0]   ), //o
    .clk   (clk                    ), //i
    .reset (reset                  )  //i
  );
  xAddTimes_32 xAddTimes_37 (
    .A_0   (addKernelData_1_0[39:0]), //i
    .A_1   (addKernelData_1_1[39:0]), //i
    .A_2   (addKernelData_1_2[39:0]), //i
    .A_3   (addKernelData_1_3[39:0]), //i
    .A_4   (addKernelData_1_4[39:0]), //i
    .A_5   (addKernelData_1_5[39:0]), //i
    .A_6   (addKernelData_1_6[39:0]), //i
    .A_7   (addKernelData_1_7[39:0]), //i
    .S     (xAddTimes_37_S[45:0]   ), //o
    .clk   (clk                    ), //i
    .reset (reset                  )  //i
  );
  xAddTimes_32 xAddTimes_38 (
    .A_0   (addKernelData_2_0[39:0]), //i
    .A_1   (addKernelData_2_1[39:0]), //i
    .A_2   (addKernelData_2_2[39:0]), //i
    .A_3   (addKernelData_2_3[39:0]), //i
    .A_4   (addKernelData_2_4[39:0]), //i
    .A_5   (addKernelData_2_5[39:0]), //i
    .A_6   (addKernelData_2_6[39:0]), //i
    .A_7   (addKernelData_2_7[39:0]), //i
    .S     (xAddTimes_38_S[45:0]   ), //o
    .clk   (clk                    ), //i
    .reset (reset                  )  //i
  );
  xAddTimes_32 xAddTimes_39 (
    .A_0   (addKernelData_3_0[39:0]), //i
    .A_1   (addKernelData_3_1[39:0]), //i
    .A_2   (addKernelData_3_2[39:0]), //i
    .A_3   (addKernelData_3_3[39:0]), //i
    .A_4   (addKernelData_3_4[39:0]), //i
    .A_5   (addKernelData_3_5[39:0]), //i
    .A_6   (addKernelData_3_6[39:0]), //i
    .A_7   (addKernelData_3_7[39:0]), //i
    .S     (xAddTimes_39_S[45:0]   ), //o
    .clk   (clk                    ), //i
    .reset (reset                  )  //i
  );
  xAddChannelTimes xAddChannelTimes_8 (
    .A     (xAddChannelTimes_8_A[22:0]), //i
    .S     (xAddChannelTimes_8_S[31:0]), //o
    .init  (computeCtrl_normPreValid  ), //i
    .clk   (clk                       ), //i
    .reset (reset                     )  //i
  );
  xAddChannelTimes xAddChannelTimes_9 (
    .A     (xAddChannelTimes_9_A[22:0]), //i
    .S     (xAddChannelTimes_9_S[31:0]), //o
    .init  (computeCtrl_normPreValid  ), //i
    .clk   (clk                       ), //i
    .reset (reset                     )  //i
  );
  xAddChannelTimes xAddChannelTimes_10 (
    .A     (xAddChannelTimes_10_A[22:0]), //i
    .S     (xAddChannelTimes_10_S[31:0]), //o
    .init  (computeCtrl_normPreValid   ), //i
    .clk   (clk                        ), //i
    .reset (reset                      )  //i
  );
  xAddChannelTimes xAddChannelTimes_11 (
    .A     (xAddChannelTimes_11_A[22:0]), //i
    .S     (xAddChannelTimes_11_S[31:0]), //o
    .init  (computeCtrl_normPreValid   ), //i
    .clk   (clk                        ), //i
    .reset (reset                      )  //i
  );
  xAddChannelTimes xAddChannelTimes_12 (
    .A     (xAddChannelTimes_12_A[22:0]), //i
    .S     (xAddChannelTimes_12_S[31:0]), //o
    .init  (computeCtrl_normPreValid   ), //i
    .clk   (clk                        ), //i
    .reset (reset                      )  //i
  );
  xAddChannelTimes xAddChannelTimes_13 (
    .A     (xAddChannelTimes_13_A[22:0]), //i
    .S     (xAddChannelTimes_13_S[31:0]), //o
    .init  (computeCtrl_normPreValid   ), //i
    .clk   (clk                        ), //i
    .reset (reset                      )  //i
  );
  xAddChannelTimes xAddChannelTimes_14 (
    .A     (xAddChannelTimes_14_A[22:0]), //i
    .S     (xAddChannelTimes_14_S[31:0]), //o
    .init  (computeCtrl_normPreValid   ), //i
    .clk   (clk                        ), //i
    .reset (reset                      )  //i
  );
  xAddChannelTimes xAddChannelTimes_15 (
    .A     (xAddChannelTimes_15_A[22:0]), //i
    .S     (xAddChannelTimes_15_S[31:0]), //o
    .init  (computeCtrl_normPreValid   ), //i
    .clk   (clk                        ), //i
    .reset (reset                      )  //i
  );
  Quan quan_1 (
    .dataIn_0     (addChannelTimesData_0[31:0]       ), //i
    .dataIn_1     (addChannelTimesData_1[31:0]       ), //i
    .dataIn_2     (addChannelTimesData_2[31:0]       ), //i
    .dataIn_3     (addChannelTimesData_3[31:0]       ), //i
    .dataIn_4     (addChannelTimesData_4[31:0]       ), //i
    .dataIn_5     (addChannelTimesData_5[31:0]       ), //i
    .dataIn_6     (addChannelTimesData_6[31:0]       ), //i
    .dataIn_7     (addChannelTimesData_7[31:0]       ), //i
    .biasIn       (loadWeight_1_biasRead_data[255:0] ), //i
    .scaleIn      (loadWeight_1_scaleRead_data[255:0]), //i
    .shiftIn      (loadWeight_1_shiftRead_data[255:0]), //i
    .zeroIn       (quanZeroData[7:0]                 ), //i
    .activationEn (enActivation                      ), //i
    .dataOut      (quan_1_dataOut[63:0]              ), //o
    .clk          (clk                               ), //i
    .reset        (reset                             )  //i
  );
  Stride stride_1 (
    .sData_valid   (computeCtrl_mDataValid      ), //i
    .sData_ready   (stride_1_sData_ready        ), //o
    .sData_payload (quan_1_dataOut[63:0]        ), //i
    .mData_valid   (stride_1_mData_valid        ), //o
    .mData_ready   (mFeatureData_ready          ), //i
    .mData_payload (stride_1_mData_payload[63:0]), //o
    .sReady        (stride_1_sReady             ), //o
    .complete      (stride_1_complete           ), //o
    .enStride      (enStride                    ), //i
    .rowNumIn      (rowNumIn[8:0]               ), //i
    .colNumIn      (colNumIn[8:0]               ), //i
    .channelOut    (channelOut[11:0]            ), //i
    .start         (startCu                     ), //i
    .clk           (clk                         ), //i
    .reset         (reset                       )  //i
  );
  assign sFeatureData_ready = dataGenerate_1_sData_ready;
  assign sParaData_ready = loadWeight_1_sData_ready;
  assign copyWeightDone = loadWeight_1_copyWeightDone;
  assign featureFifo_0_sCount = {1'd0, computeCtrl_sCount};
  assign featureFifo_0_mCount = {1'd0, computeCtrl_mCount};
  assign sReady_0 = featureFifo_0_sReady;
  assign mReady_0 = featureFifo_0_mReady;
  assign featureFifo_1_sCount = {1'd0, computeCtrl_sCount};
  assign featureFifo_1_mCount = {1'd0, computeCtrl_mCount};
  assign sReady_1 = featureFifo_1_sReady;
  assign mReady_1 = featureFifo_1_mReady;
  assign featureFifo_2_sCount = {1'd0, computeCtrl_sCount};
  assign featureFifo_2_mCount = {1'd0, computeCtrl_mCount};
  assign sReady_2 = featureFifo_2_sReady;
  assign mReady_2 = featureFifo_2_mReady;
  assign featureFifo_3_sCount = {1'd0, computeCtrl_sCount};
  assign featureFifo_3_mCount = {1'd0, computeCtrl_mCount};
  assign sReady_3 = featureFifo_3_sReady;
  assign mReady_3 = featureFifo_3_mReady;
  assign featureFifo_4_sCount = {1'd0, computeCtrl_sCount};
  assign featureFifo_4_mCount = {1'd0, computeCtrl_mCount};
  assign sReady_4 = featureFifo_4_sReady;
  assign mReady_4 = featureFifo_4_mReady;
  assign featureFifo_5_sCount = {1'd0, computeCtrl_sCount};
  assign featureFifo_5_mCount = {1'd0, computeCtrl_mCount};
  assign sReady_5 = featureFifo_5_sReady;
  assign mReady_5 = featureFifo_5_mReady;
  assign featureFifo_6_sCount = {1'd0, computeCtrl_sCount};
  assign featureFifo_6_mCount = {1'd0, computeCtrl_mCount};
  assign sReady_6 = featureFifo_6_sReady;
  assign mReady_6 = featureFifo_6_mReady;
  assign featureFifo_7_sCount = {1'd0, computeCtrl_sCount};
  assign featureFifo_7_mCount = {1'd0, computeCtrl_mCount};
  assign sReady_7 = featureFifo_7_sReady;
  assign mReady_7 = featureFifo_7_mReady;
  assign featureFifo_8_sCount = {1'd0, computeCtrl_sCount};
  assign featureFifo_8_mCount = {1'd0, computeCtrl_mCount};
  assign sReady_8 = featureFifo_8_sReady;
  assign mReady_8 = featureFifo_8_mReady;
  assign featureMemOutData_0 = _zz_featureMem_0_port1;
  assign featureMemOutData_1 = _zz_featureMem_1_port1;
  assign featureMemOutData_2 = _zz_featureMem_2_port1;
  assign featureMemOutData_3 = _zz_featureMem_3_port1;
  assign featureMemOutData_4 = _zz_featureMem_4_port1;
  assign featureMemOutData_5 = _zz_featureMem_5_port1;
  assign featureMemOutData_6 = _zz_featureMem_6_port1;
  assign featureMemOutData_7 = _zz_featureMem_7_port1;
  assign featureMemOutData_8 = _zz_featureMem_8_port1;
  assign dSP_1_a = loadWeight_1_weightRead_0_data[7 : 0];
  assign dSP_1_d = loadWeight_1_weightRead_0_data[71 : 64];
  assign dSP_1_a1 = loadWeight_1_weightRead_0_data[135 : 128];
  assign dSP_1_d1 = loadWeight_1_weightRead_0_data[199 : 192];
  assign dSP_1_b = featureMemOutData_0[7 : 0];
  assign mulFeatureWeightData_0_0_0 = dSP_1_p[31 : 0];
  assign mulFeatureWeightData_0_1_0 = dSP_1_p[63 : 32];
  assign dSP_2_a = loadWeight_1_weightRead_0_data[15 : 8];
  assign dSP_2_d = loadWeight_1_weightRead_0_data[79 : 72];
  assign dSP_2_a1 = loadWeight_1_weightRead_0_data[143 : 136];
  assign dSP_2_d1 = loadWeight_1_weightRead_0_data[207 : 200];
  assign dSP_2_b = featureMemOutData_0[15 : 8];
  assign mulFeatureWeightData_0_0_1 = dSP_2_p[31 : 0];
  assign mulFeatureWeightData_0_1_1 = dSP_2_p[63 : 32];
  assign dSP_3_a = loadWeight_1_weightRead_0_data[23 : 16];
  assign dSP_3_d = loadWeight_1_weightRead_0_data[87 : 80];
  assign dSP_3_a1 = loadWeight_1_weightRead_0_data[151 : 144];
  assign dSP_3_d1 = loadWeight_1_weightRead_0_data[215 : 208];
  assign dSP_3_b = featureMemOutData_0[23 : 16];
  assign mulFeatureWeightData_0_0_2 = dSP_3_p[31 : 0];
  assign mulFeatureWeightData_0_1_2 = dSP_3_p[63 : 32];
  assign dSP_4_a = loadWeight_1_weightRead_0_data[31 : 24];
  assign dSP_4_d = loadWeight_1_weightRead_0_data[95 : 88];
  assign dSP_4_a1 = loadWeight_1_weightRead_0_data[159 : 152];
  assign dSP_4_d1 = loadWeight_1_weightRead_0_data[223 : 216];
  assign dSP_4_b = featureMemOutData_0[31 : 24];
  assign mulFeatureWeightData_0_0_3 = dSP_4_p[31 : 0];
  assign mulFeatureWeightData_0_1_3 = dSP_4_p[63 : 32];
  assign dSP_5_a = loadWeight_1_weightRead_0_data[39 : 32];
  assign dSP_5_d = loadWeight_1_weightRead_0_data[103 : 96];
  assign dSP_5_a1 = loadWeight_1_weightRead_0_data[167 : 160];
  assign dSP_5_d1 = loadWeight_1_weightRead_0_data[231 : 224];
  assign dSP_5_b = featureMemOutData_0[39 : 32];
  assign mulFeatureWeightData_0_0_4 = dSP_5_p[31 : 0];
  assign mulFeatureWeightData_0_1_4 = dSP_5_p[63 : 32];
  assign dSP_6_a = loadWeight_1_weightRead_0_data[47 : 40];
  assign dSP_6_d = loadWeight_1_weightRead_0_data[111 : 104];
  assign dSP_6_a1 = loadWeight_1_weightRead_0_data[175 : 168];
  assign dSP_6_d1 = loadWeight_1_weightRead_0_data[239 : 232];
  assign dSP_6_b = featureMemOutData_0[47 : 40];
  assign mulFeatureWeightData_0_0_5 = dSP_6_p[31 : 0];
  assign mulFeatureWeightData_0_1_5 = dSP_6_p[63 : 32];
  assign dSP_7_a = loadWeight_1_weightRead_0_data[55 : 48];
  assign dSP_7_d = loadWeight_1_weightRead_0_data[119 : 112];
  assign dSP_7_a1 = loadWeight_1_weightRead_0_data[183 : 176];
  assign dSP_7_d1 = loadWeight_1_weightRead_0_data[247 : 240];
  assign dSP_7_b = featureMemOutData_0[55 : 48];
  assign mulFeatureWeightData_0_0_6 = dSP_7_p[31 : 0];
  assign mulFeatureWeightData_0_1_6 = dSP_7_p[63 : 32];
  assign dSP_8_a = loadWeight_1_weightRead_0_data[63 : 56];
  assign dSP_8_d = loadWeight_1_weightRead_0_data[127 : 120];
  assign dSP_8_a1 = loadWeight_1_weightRead_0_data[191 : 184];
  assign dSP_8_d1 = loadWeight_1_weightRead_0_data[255 : 248];
  assign dSP_8_b = featureMemOutData_0[63 : 56];
  assign mulFeatureWeightData_0_0_7 = dSP_8_p[31 : 0];
  assign mulFeatureWeightData_0_1_7 = dSP_8_p[63 : 32];
  assign dSP_9_a = loadWeight_1_weightRead_0_data[263 : 256];
  assign dSP_9_d = loadWeight_1_weightRead_0_data[327 : 320];
  assign dSP_9_a1 = loadWeight_1_weightRead_0_data[391 : 384];
  assign dSP_9_d1 = loadWeight_1_weightRead_0_data[455 : 448];
  assign dSP_9_b = featureMemOutData_0[7 : 0];
  assign mulFeatureWeightData_0_2_0 = dSP_9_p[31 : 0];
  assign mulFeatureWeightData_0_3_0 = dSP_9_p[63 : 32];
  assign dSP_10_a = loadWeight_1_weightRead_0_data[271 : 264];
  assign dSP_10_d = loadWeight_1_weightRead_0_data[335 : 328];
  assign dSP_10_a1 = loadWeight_1_weightRead_0_data[399 : 392];
  assign dSP_10_d1 = loadWeight_1_weightRead_0_data[463 : 456];
  assign dSP_10_b = featureMemOutData_0[15 : 8];
  assign mulFeatureWeightData_0_2_1 = dSP_10_p[31 : 0];
  assign mulFeatureWeightData_0_3_1 = dSP_10_p[63 : 32];
  assign dSP_11_a = loadWeight_1_weightRead_0_data[279 : 272];
  assign dSP_11_d = loadWeight_1_weightRead_0_data[343 : 336];
  assign dSP_11_a1 = loadWeight_1_weightRead_0_data[407 : 400];
  assign dSP_11_d1 = loadWeight_1_weightRead_0_data[471 : 464];
  assign dSP_11_b = featureMemOutData_0[23 : 16];
  assign mulFeatureWeightData_0_2_2 = dSP_11_p[31 : 0];
  assign mulFeatureWeightData_0_3_2 = dSP_11_p[63 : 32];
  assign dSP_12_a = loadWeight_1_weightRead_0_data[287 : 280];
  assign dSP_12_d = loadWeight_1_weightRead_0_data[351 : 344];
  assign dSP_12_a1 = loadWeight_1_weightRead_0_data[415 : 408];
  assign dSP_12_d1 = loadWeight_1_weightRead_0_data[479 : 472];
  assign dSP_12_b = featureMemOutData_0[31 : 24];
  assign mulFeatureWeightData_0_2_3 = dSP_12_p[31 : 0];
  assign mulFeatureWeightData_0_3_3 = dSP_12_p[63 : 32];
  assign dSP_13_a = loadWeight_1_weightRead_0_data[295 : 288];
  assign dSP_13_d = loadWeight_1_weightRead_0_data[359 : 352];
  assign dSP_13_a1 = loadWeight_1_weightRead_0_data[423 : 416];
  assign dSP_13_d1 = loadWeight_1_weightRead_0_data[487 : 480];
  assign dSP_13_b = featureMemOutData_0[39 : 32];
  assign mulFeatureWeightData_0_2_4 = dSP_13_p[31 : 0];
  assign mulFeatureWeightData_0_3_4 = dSP_13_p[63 : 32];
  assign dSP_14_a = loadWeight_1_weightRead_0_data[303 : 296];
  assign dSP_14_d = loadWeight_1_weightRead_0_data[367 : 360];
  assign dSP_14_a1 = loadWeight_1_weightRead_0_data[431 : 424];
  assign dSP_14_d1 = loadWeight_1_weightRead_0_data[495 : 488];
  assign dSP_14_b = featureMemOutData_0[47 : 40];
  assign mulFeatureWeightData_0_2_5 = dSP_14_p[31 : 0];
  assign mulFeatureWeightData_0_3_5 = dSP_14_p[63 : 32];
  assign dSP_15_a = loadWeight_1_weightRead_0_data[311 : 304];
  assign dSP_15_d = loadWeight_1_weightRead_0_data[375 : 368];
  assign dSP_15_a1 = loadWeight_1_weightRead_0_data[439 : 432];
  assign dSP_15_d1 = loadWeight_1_weightRead_0_data[503 : 496];
  assign dSP_15_b = featureMemOutData_0[55 : 48];
  assign mulFeatureWeightData_0_2_6 = dSP_15_p[31 : 0];
  assign mulFeatureWeightData_0_3_6 = dSP_15_p[63 : 32];
  assign dSP_16_a = loadWeight_1_weightRead_0_data[319 : 312];
  assign dSP_16_d = loadWeight_1_weightRead_0_data[383 : 376];
  assign dSP_16_a1 = loadWeight_1_weightRead_0_data[447 : 440];
  assign dSP_16_d1 = loadWeight_1_weightRead_0_data[511 : 504];
  assign dSP_16_b = featureMemOutData_0[63 : 56];
  assign mulFeatureWeightData_0_2_7 = dSP_16_p[31 : 0];
  assign mulFeatureWeightData_0_3_7 = dSP_16_p[63 : 32];
  assign dSP_17_a = loadWeight_1_weightRead_1_data[7 : 0];
  assign dSP_17_d = loadWeight_1_weightRead_1_data[71 : 64];
  assign dSP_17_a1 = loadWeight_1_weightRead_1_data[135 : 128];
  assign dSP_17_d1 = loadWeight_1_weightRead_1_data[199 : 192];
  assign dSP_17_b = featureMemOutData_1[7 : 0];
  assign mulFeatureWeightData_1_0_0 = dSP_17_p[31 : 0];
  assign mulFeatureWeightData_1_1_0 = dSP_17_p[63 : 32];
  assign dSP_18_a = loadWeight_1_weightRead_1_data[15 : 8];
  assign dSP_18_d = loadWeight_1_weightRead_1_data[79 : 72];
  assign dSP_18_a1 = loadWeight_1_weightRead_1_data[143 : 136];
  assign dSP_18_d1 = loadWeight_1_weightRead_1_data[207 : 200];
  assign dSP_18_b = featureMemOutData_1[15 : 8];
  assign mulFeatureWeightData_1_0_1 = dSP_18_p[31 : 0];
  assign mulFeatureWeightData_1_1_1 = dSP_18_p[63 : 32];
  assign dSP_19_a = loadWeight_1_weightRead_1_data[23 : 16];
  assign dSP_19_d = loadWeight_1_weightRead_1_data[87 : 80];
  assign dSP_19_a1 = loadWeight_1_weightRead_1_data[151 : 144];
  assign dSP_19_d1 = loadWeight_1_weightRead_1_data[215 : 208];
  assign dSP_19_b = featureMemOutData_1[23 : 16];
  assign mulFeatureWeightData_1_0_2 = dSP_19_p[31 : 0];
  assign mulFeatureWeightData_1_1_2 = dSP_19_p[63 : 32];
  assign dSP_20_a = loadWeight_1_weightRead_1_data[31 : 24];
  assign dSP_20_d = loadWeight_1_weightRead_1_data[95 : 88];
  assign dSP_20_a1 = loadWeight_1_weightRead_1_data[159 : 152];
  assign dSP_20_d1 = loadWeight_1_weightRead_1_data[223 : 216];
  assign dSP_20_b = featureMemOutData_1[31 : 24];
  assign mulFeatureWeightData_1_0_3 = dSP_20_p[31 : 0];
  assign mulFeatureWeightData_1_1_3 = dSP_20_p[63 : 32];
  assign dSP_21_a = loadWeight_1_weightRead_1_data[39 : 32];
  assign dSP_21_d = loadWeight_1_weightRead_1_data[103 : 96];
  assign dSP_21_a1 = loadWeight_1_weightRead_1_data[167 : 160];
  assign dSP_21_d1 = loadWeight_1_weightRead_1_data[231 : 224];
  assign dSP_21_b = featureMemOutData_1[39 : 32];
  assign mulFeatureWeightData_1_0_4 = dSP_21_p[31 : 0];
  assign mulFeatureWeightData_1_1_4 = dSP_21_p[63 : 32];
  assign dSP_22_a = loadWeight_1_weightRead_1_data[47 : 40];
  assign dSP_22_d = loadWeight_1_weightRead_1_data[111 : 104];
  assign dSP_22_a1 = loadWeight_1_weightRead_1_data[175 : 168];
  assign dSP_22_d1 = loadWeight_1_weightRead_1_data[239 : 232];
  assign dSP_22_b = featureMemOutData_1[47 : 40];
  assign mulFeatureWeightData_1_0_5 = dSP_22_p[31 : 0];
  assign mulFeatureWeightData_1_1_5 = dSP_22_p[63 : 32];
  assign dSP_23_a = loadWeight_1_weightRead_1_data[55 : 48];
  assign dSP_23_d = loadWeight_1_weightRead_1_data[119 : 112];
  assign dSP_23_a1 = loadWeight_1_weightRead_1_data[183 : 176];
  assign dSP_23_d1 = loadWeight_1_weightRead_1_data[247 : 240];
  assign dSP_23_b = featureMemOutData_1[55 : 48];
  assign mulFeatureWeightData_1_0_6 = dSP_23_p[31 : 0];
  assign mulFeatureWeightData_1_1_6 = dSP_23_p[63 : 32];
  assign dSP_24_a = loadWeight_1_weightRead_1_data[63 : 56];
  assign dSP_24_d = loadWeight_1_weightRead_1_data[127 : 120];
  assign dSP_24_a1 = loadWeight_1_weightRead_1_data[191 : 184];
  assign dSP_24_d1 = loadWeight_1_weightRead_1_data[255 : 248];
  assign dSP_24_b = featureMemOutData_1[63 : 56];
  assign mulFeatureWeightData_1_0_7 = dSP_24_p[31 : 0];
  assign mulFeatureWeightData_1_1_7 = dSP_24_p[63 : 32];
  assign dSP_25_a = loadWeight_1_weightRead_1_data[263 : 256];
  assign dSP_25_d = loadWeight_1_weightRead_1_data[327 : 320];
  assign dSP_25_a1 = loadWeight_1_weightRead_1_data[391 : 384];
  assign dSP_25_d1 = loadWeight_1_weightRead_1_data[455 : 448];
  assign dSP_25_b = featureMemOutData_1[7 : 0];
  assign mulFeatureWeightData_1_2_0 = dSP_25_p[31 : 0];
  assign mulFeatureWeightData_1_3_0 = dSP_25_p[63 : 32];
  assign dSP_26_a = loadWeight_1_weightRead_1_data[271 : 264];
  assign dSP_26_d = loadWeight_1_weightRead_1_data[335 : 328];
  assign dSP_26_a1 = loadWeight_1_weightRead_1_data[399 : 392];
  assign dSP_26_d1 = loadWeight_1_weightRead_1_data[463 : 456];
  assign dSP_26_b = featureMemOutData_1[15 : 8];
  assign mulFeatureWeightData_1_2_1 = dSP_26_p[31 : 0];
  assign mulFeatureWeightData_1_3_1 = dSP_26_p[63 : 32];
  assign dSP_27_a = loadWeight_1_weightRead_1_data[279 : 272];
  assign dSP_27_d = loadWeight_1_weightRead_1_data[343 : 336];
  assign dSP_27_a1 = loadWeight_1_weightRead_1_data[407 : 400];
  assign dSP_27_d1 = loadWeight_1_weightRead_1_data[471 : 464];
  assign dSP_27_b = featureMemOutData_1[23 : 16];
  assign mulFeatureWeightData_1_2_2 = dSP_27_p[31 : 0];
  assign mulFeatureWeightData_1_3_2 = dSP_27_p[63 : 32];
  assign dSP_28_a = loadWeight_1_weightRead_1_data[287 : 280];
  assign dSP_28_d = loadWeight_1_weightRead_1_data[351 : 344];
  assign dSP_28_a1 = loadWeight_1_weightRead_1_data[415 : 408];
  assign dSP_28_d1 = loadWeight_1_weightRead_1_data[479 : 472];
  assign dSP_28_b = featureMemOutData_1[31 : 24];
  assign mulFeatureWeightData_1_2_3 = dSP_28_p[31 : 0];
  assign mulFeatureWeightData_1_3_3 = dSP_28_p[63 : 32];
  assign dSP_29_a = loadWeight_1_weightRead_1_data[295 : 288];
  assign dSP_29_d = loadWeight_1_weightRead_1_data[359 : 352];
  assign dSP_29_a1 = loadWeight_1_weightRead_1_data[423 : 416];
  assign dSP_29_d1 = loadWeight_1_weightRead_1_data[487 : 480];
  assign dSP_29_b = featureMemOutData_1[39 : 32];
  assign mulFeatureWeightData_1_2_4 = dSP_29_p[31 : 0];
  assign mulFeatureWeightData_1_3_4 = dSP_29_p[63 : 32];
  assign dSP_30_a = loadWeight_1_weightRead_1_data[303 : 296];
  assign dSP_30_d = loadWeight_1_weightRead_1_data[367 : 360];
  assign dSP_30_a1 = loadWeight_1_weightRead_1_data[431 : 424];
  assign dSP_30_d1 = loadWeight_1_weightRead_1_data[495 : 488];
  assign dSP_30_b = featureMemOutData_1[47 : 40];
  assign mulFeatureWeightData_1_2_5 = dSP_30_p[31 : 0];
  assign mulFeatureWeightData_1_3_5 = dSP_30_p[63 : 32];
  assign dSP_31_a = loadWeight_1_weightRead_1_data[311 : 304];
  assign dSP_31_d = loadWeight_1_weightRead_1_data[375 : 368];
  assign dSP_31_a1 = loadWeight_1_weightRead_1_data[439 : 432];
  assign dSP_31_d1 = loadWeight_1_weightRead_1_data[503 : 496];
  assign dSP_31_b = featureMemOutData_1[55 : 48];
  assign mulFeatureWeightData_1_2_6 = dSP_31_p[31 : 0];
  assign mulFeatureWeightData_1_3_6 = dSP_31_p[63 : 32];
  assign dSP_32_a = loadWeight_1_weightRead_1_data[319 : 312];
  assign dSP_32_d = loadWeight_1_weightRead_1_data[383 : 376];
  assign dSP_32_a1 = loadWeight_1_weightRead_1_data[447 : 440];
  assign dSP_32_d1 = loadWeight_1_weightRead_1_data[511 : 504];
  assign dSP_32_b = featureMemOutData_1[63 : 56];
  assign mulFeatureWeightData_1_2_7 = dSP_32_p[31 : 0];
  assign mulFeatureWeightData_1_3_7 = dSP_32_p[63 : 32];
  assign dSP_33_a = loadWeight_1_weightRead_2_data[7 : 0];
  assign dSP_33_d = loadWeight_1_weightRead_2_data[71 : 64];
  assign dSP_33_a1 = loadWeight_1_weightRead_2_data[135 : 128];
  assign dSP_33_d1 = loadWeight_1_weightRead_2_data[199 : 192];
  assign dSP_33_b = featureMemOutData_2[7 : 0];
  assign mulFeatureWeightData_2_0_0 = dSP_33_p[31 : 0];
  assign mulFeatureWeightData_2_1_0 = dSP_33_p[63 : 32];
  assign dSP_34_a = loadWeight_1_weightRead_2_data[15 : 8];
  assign dSP_34_d = loadWeight_1_weightRead_2_data[79 : 72];
  assign dSP_34_a1 = loadWeight_1_weightRead_2_data[143 : 136];
  assign dSP_34_d1 = loadWeight_1_weightRead_2_data[207 : 200];
  assign dSP_34_b = featureMemOutData_2[15 : 8];
  assign mulFeatureWeightData_2_0_1 = dSP_34_p[31 : 0];
  assign mulFeatureWeightData_2_1_1 = dSP_34_p[63 : 32];
  assign dSP_35_a = loadWeight_1_weightRead_2_data[23 : 16];
  assign dSP_35_d = loadWeight_1_weightRead_2_data[87 : 80];
  assign dSP_35_a1 = loadWeight_1_weightRead_2_data[151 : 144];
  assign dSP_35_d1 = loadWeight_1_weightRead_2_data[215 : 208];
  assign dSP_35_b = featureMemOutData_2[23 : 16];
  assign mulFeatureWeightData_2_0_2 = dSP_35_p[31 : 0];
  assign mulFeatureWeightData_2_1_2 = dSP_35_p[63 : 32];
  assign dSP_36_a = loadWeight_1_weightRead_2_data[31 : 24];
  assign dSP_36_d = loadWeight_1_weightRead_2_data[95 : 88];
  assign dSP_36_a1 = loadWeight_1_weightRead_2_data[159 : 152];
  assign dSP_36_d1 = loadWeight_1_weightRead_2_data[223 : 216];
  assign dSP_36_b = featureMemOutData_2[31 : 24];
  assign mulFeatureWeightData_2_0_3 = dSP_36_p[31 : 0];
  assign mulFeatureWeightData_2_1_3 = dSP_36_p[63 : 32];
  assign dSP_37_a = loadWeight_1_weightRead_2_data[39 : 32];
  assign dSP_37_d = loadWeight_1_weightRead_2_data[103 : 96];
  assign dSP_37_a1 = loadWeight_1_weightRead_2_data[167 : 160];
  assign dSP_37_d1 = loadWeight_1_weightRead_2_data[231 : 224];
  assign dSP_37_b = featureMemOutData_2[39 : 32];
  assign mulFeatureWeightData_2_0_4 = dSP_37_p[31 : 0];
  assign mulFeatureWeightData_2_1_4 = dSP_37_p[63 : 32];
  assign dSP_38_a = loadWeight_1_weightRead_2_data[47 : 40];
  assign dSP_38_d = loadWeight_1_weightRead_2_data[111 : 104];
  assign dSP_38_a1 = loadWeight_1_weightRead_2_data[175 : 168];
  assign dSP_38_d1 = loadWeight_1_weightRead_2_data[239 : 232];
  assign dSP_38_b = featureMemOutData_2[47 : 40];
  assign mulFeatureWeightData_2_0_5 = dSP_38_p[31 : 0];
  assign mulFeatureWeightData_2_1_5 = dSP_38_p[63 : 32];
  assign dSP_39_a = loadWeight_1_weightRead_2_data[55 : 48];
  assign dSP_39_d = loadWeight_1_weightRead_2_data[119 : 112];
  assign dSP_39_a1 = loadWeight_1_weightRead_2_data[183 : 176];
  assign dSP_39_d1 = loadWeight_1_weightRead_2_data[247 : 240];
  assign dSP_39_b = featureMemOutData_2[55 : 48];
  assign mulFeatureWeightData_2_0_6 = dSP_39_p[31 : 0];
  assign mulFeatureWeightData_2_1_6 = dSP_39_p[63 : 32];
  assign dSP_40_a = loadWeight_1_weightRead_2_data[63 : 56];
  assign dSP_40_d = loadWeight_1_weightRead_2_data[127 : 120];
  assign dSP_40_a1 = loadWeight_1_weightRead_2_data[191 : 184];
  assign dSP_40_d1 = loadWeight_1_weightRead_2_data[255 : 248];
  assign dSP_40_b = featureMemOutData_2[63 : 56];
  assign mulFeatureWeightData_2_0_7 = dSP_40_p[31 : 0];
  assign mulFeatureWeightData_2_1_7 = dSP_40_p[63 : 32];
  assign dSP_41_a = loadWeight_1_weightRead_2_data[263 : 256];
  assign dSP_41_d = loadWeight_1_weightRead_2_data[327 : 320];
  assign dSP_41_a1 = loadWeight_1_weightRead_2_data[391 : 384];
  assign dSP_41_d1 = loadWeight_1_weightRead_2_data[455 : 448];
  assign dSP_41_b = featureMemOutData_2[7 : 0];
  assign mulFeatureWeightData_2_2_0 = dSP_41_p[31 : 0];
  assign mulFeatureWeightData_2_3_0 = dSP_41_p[63 : 32];
  assign dSP_42_a = loadWeight_1_weightRead_2_data[271 : 264];
  assign dSP_42_d = loadWeight_1_weightRead_2_data[335 : 328];
  assign dSP_42_a1 = loadWeight_1_weightRead_2_data[399 : 392];
  assign dSP_42_d1 = loadWeight_1_weightRead_2_data[463 : 456];
  assign dSP_42_b = featureMemOutData_2[15 : 8];
  assign mulFeatureWeightData_2_2_1 = dSP_42_p[31 : 0];
  assign mulFeatureWeightData_2_3_1 = dSP_42_p[63 : 32];
  assign dSP_43_a = loadWeight_1_weightRead_2_data[279 : 272];
  assign dSP_43_d = loadWeight_1_weightRead_2_data[343 : 336];
  assign dSP_43_a1 = loadWeight_1_weightRead_2_data[407 : 400];
  assign dSP_43_d1 = loadWeight_1_weightRead_2_data[471 : 464];
  assign dSP_43_b = featureMemOutData_2[23 : 16];
  assign mulFeatureWeightData_2_2_2 = dSP_43_p[31 : 0];
  assign mulFeatureWeightData_2_3_2 = dSP_43_p[63 : 32];
  assign dSP_44_a = loadWeight_1_weightRead_2_data[287 : 280];
  assign dSP_44_d = loadWeight_1_weightRead_2_data[351 : 344];
  assign dSP_44_a1 = loadWeight_1_weightRead_2_data[415 : 408];
  assign dSP_44_d1 = loadWeight_1_weightRead_2_data[479 : 472];
  assign dSP_44_b = featureMemOutData_2[31 : 24];
  assign mulFeatureWeightData_2_2_3 = dSP_44_p[31 : 0];
  assign mulFeatureWeightData_2_3_3 = dSP_44_p[63 : 32];
  assign dSP_45_a = loadWeight_1_weightRead_2_data[295 : 288];
  assign dSP_45_d = loadWeight_1_weightRead_2_data[359 : 352];
  assign dSP_45_a1 = loadWeight_1_weightRead_2_data[423 : 416];
  assign dSP_45_d1 = loadWeight_1_weightRead_2_data[487 : 480];
  assign dSP_45_b = featureMemOutData_2[39 : 32];
  assign mulFeatureWeightData_2_2_4 = dSP_45_p[31 : 0];
  assign mulFeatureWeightData_2_3_4 = dSP_45_p[63 : 32];
  assign dSP_46_a = loadWeight_1_weightRead_2_data[303 : 296];
  assign dSP_46_d = loadWeight_1_weightRead_2_data[367 : 360];
  assign dSP_46_a1 = loadWeight_1_weightRead_2_data[431 : 424];
  assign dSP_46_d1 = loadWeight_1_weightRead_2_data[495 : 488];
  assign dSP_46_b = featureMemOutData_2[47 : 40];
  assign mulFeatureWeightData_2_2_5 = dSP_46_p[31 : 0];
  assign mulFeatureWeightData_2_3_5 = dSP_46_p[63 : 32];
  assign dSP_47_a = loadWeight_1_weightRead_2_data[311 : 304];
  assign dSP_47_d = loadWeight_1_weightRead_2_data[375 : 368];
  assign dSP_47_a1 = loadWeight_1_weightRead_2_data[439 : 432];
  assign dSP_47_d1 = loadWeight_1_weightRead_2_data[503 : 496];
  assign dSP_47_b = featureMemOutData_2[55 : 48];
  assign mulFeatureWeightData_2_2_6 = dSP_47_p[31 : 0];
  assign mulFeatureWeightData_2_3_6 = dSP_47_p[63 : 32];
  assign dSP_48_a = loadWeight_1_weightRead_2_data[319 : 312];
  assign dSP_48_d = loadWeight_1_weightRead_2_data[383 : 376];
  assign dSP_48_a1 = loadWeight_1_weightRead_2_data[447 : 440];
  assign dSP_48_d1 = loadWeight_1_weightRead_2_data[511 : 504];
  assign dSP_48_b = featureMemOutData_2[63 : 56];
  assign mulFeatureWeightData_2_2_7 = dSP_48_p[31 : 0];
  assign mulFeatureWeightData_2_3_7 = dSP_48_p[63 : 32];
  assign dSP_49_a = loadWeight_1_weightRead_3_data[7 : 0];
  assign dSP_49_d = loadWeight_1_weightRead_3_data[71 : 64];
  assign dSP_49_a1 = loadWeight_1_weightRead_3_data[135 : 128];
  assign dSP_49_d1 = loadWeight_1_weightRead_3_data[199 : 192];
  assign dSP_49_b = featureMemOutData_3[7 : 0];
  assign mulFeatureWeightData_3_0_0 = dSP_49_p[31 : 0];
  assign mulFeatureWeightData_3_1_0 = dSP_49_p[63 : 32];
  assign dSP_50_a = loadWeight_1_weightRead_3_data[15 : 8];
  assign dSP_50_d = loadWeight_1_weightRead_3_data[79 : 72];
  assign dSP_50_a1 = loadWeight_1_weightRead_3_data[143 : 136];
  assign dSP_50_d1 = loadWeight_1_weightRead_3_data[207 : 200];
  assign dSP_50_b = featureMemOutData_3[15 : 8];
  assign mulFeatureWeightData_3_0_1 = dSP_50_p[31 : 0];
  assign mulFeatureWeightData_3_1_1 = dSP_50_p[63 : 32];
  assign dSP_51_a = loadWeight_1_weightRead_3_data[23 : 16];
  assign dSP_51_d = loadWeight_1_weightRead_3_data[87 : 80];
  assign dSP_51_a1 = loadWeight_1_weightRead_3_data[151 : 144];
  assign dSP_51_d1 = loadWeight_1_weightRead_3_data[215 : 208];
  assign dSP_51_b = featureMemOutData_3[23 : 16];
  assign mulFeatureWeightData_3_0_2 = dSP_51_p[31 : 0];
  assign mulFeatureWeightData_3_1_2 = dSP_51_p[63 : 32];
  assign dSP_52_a = loadWeight_1_weightRead_3_data[31 : 24];
  assign dSP_52_d = loadWeight_1_weightRead_3_data[95 : 88];
  assign dSP_52_a1 = loadWeight_1_weightRead_3_data[159 : 152];
  assign dSP_52_d1 = loadWeight_1_weightRead_3_data[223 : 216];
  assign dSP_52_b = featureMemOutData_3[31 : 24];
  assign mulFeatureWeightData_3_0_3 = dSP_52_p[31 : 0];
  assign mulFeatureWeightData_3_1_3 = dSP_52_p[63 : 32];
  assign dSP_53_a = loadWeight_1_weightRead_3_data[39 : 32];
  assign dSP_53_d = loadWeight_1_weightRead_3_data[103 : 96];
  assign dSP_53_a1 = loadWeight_1_weightRead_3_data[167 : 160];
  assign dSP_53_d1 = loadWeight_1_weightRead_3_data[231 : 224];
  assign dSP_53_b = featureMemOutData_3[39 : 32];
  assign mulFeatureWeightData_3_0_4 = dSP_53_p[31 : 0];
  assign mulFeatureWeightData_3_1_4 = dSP_53_p[63 : 32];
  assign dSP_54_a = loadWeight_1_weightRead_3_data[47 : 40];
  assign dSP_54_d = loadWeight_1_weightRead_3_data[111 : 104];
  assign dSP_54_a1 = loadWeight_1_weightRead_3_data[175 : 168];
  assign dSP_54_d1 = loadWeight_1_weightRead_3_data[239 : 232];
  assign dSP_54_b = featureMemOutData_3[47 : 40];
  assign mulFeatureWeightData_3_0_5 = dSP_54_p[31 : 0];
  assign mulFeatureWeightData_3_1_5 = dSP_54_p[63 : 32];
  assign dSP_55_a = loadWeight_1_weightRead_3_data[55 : 48];
  assign dSP_55_d = loadWeight_1_weightRead_3_data[119 : 112];
  assign dSP_55_a1 = loadWeight_1_weightRead_3_data[183 : 176];
  assign dSP_55_d1 = loadWeight_1_weightRead_3_data[247 : 240];
  assign dSP_55_b = featureMemOutData_3[55 : 48];
  assign mulFeatureWeightData_3_0_6 = dSP_55_p[31 : 0];
  assign mulFeatureWeightData_3_1_6 = dSP_55_p[63 : 32];
  assign dSP_56_a = loadWeight_1_weightRead_3_data[63 : 56];
  assign dSP_56_d = loadWeight_1_weightRead_3_data[127 : 120];
  assign dSP_56_a1 = loadWeight_1_weightRead_3_data[191 : 184];
  assign dSP_56_d1 = loadWeight_1_weightRead_3_data[255 : 248];
  assign dSP_56_b = featureMemOutData_3[63 : 56];
  assign mulFeatureWeightData_3_0_7 = dSP_56_p[31 : 0];
  assign mulFeatureWeightData_3_1_7 = dSP_56_p[63 : 32];
  assign dSP_57_a = loadWeight_1_weightRead_3_data[263 : 256];
  assign dSP_57_d = loadWeight_1_weightRead_3_data[327 : 320];
  assign dSP_57_a1 = loadWeight_1_weightRead_3_data[391 : 384];
  assign dSP_57_d1 = loadWeight_1_weightRead_3_data[455 : 448];
  assign dSP_57_b = featureMemOutData_3[7 : 0];
  assign mulFeatureWeightData_3_2_0 = dSP_57_p[31 : 0];
  assign mulFeatureWeightData_3_3_0 = dSP_57_p[63 : 32];
  assign dSP_58_a = loadWeight_1_weightRead_3_data[271 : 264];
  assign dSP_58_d = loadWeight_1_weightRead_3_data[335 : 328];
  assign dSP_58_a1 = loadWeight_1_weightRead_3_data[399 : 392];
  assign dSP_58_d1 = loadWeight_1_weightRead_3_data[463 : 456];
  assign dSP_58_b = featureMemOutData_3[15 : 8];
  assign mulFeatureWeightData_3_2_1 = dSP_58_p[31 : 0];
  assign mulFeatureWeightData_3_3_1 = dSP_58_p[63 : 32];
  assign dSP_59_a = loadWeight_1_weightRead_3_data[279 : 272];
  assign dSP_59_d = loadWeight_1_weightRead_3_data[343 : 336];
  assign dSP_59_a1 = loadWeight_1_weightRead_3_data[407 : 400];
  assign dSP_59_d1 = loadWeight_1_weightRead_3_data[471 : 464];
  assign dSP_59_b = featureMemOutData_3[23 : 16];
  assign mulFeatureWeightData_3_2_2 = dSP_59_p[31 : 0];
  assign mulFeatureWeightData_3_3_2 = dSP_59_p[63 : 32];
  assign dSP_60_a = loadWeight_1_weightRead_3_data[287 : 280];
  assign dSP_60_d = loadWeight_1_weightRead_3_data[351 : 344];
  assign dSP_60_a1 = loadWeight_1_weightRead_3_data[415 : 408];
  assign dSP_60_d1 = loadWeight_1_weightRead_3_data[479 : 472];
  assign dSP_60_b = featureMemOutData_3[31 : 24];
  assign mulFeatureWeightData_3_2_3 = dSP_60_p[31 : 0];
  assign mulFeatureWeightData_3_3_3 = dSP_60_p[63 : 32];
  assign dSP_61_a = loadWeight_1_weightRead_3_data[295 : 288];
  assign dSP_61_d = loadWeight_1_weightRead_3_data[359 : 352];
  assign dSP_61_a1 = loadWeight_1_weightRead_3_data[423 : 416];
  assign dSP_61_d1 = loadWeight_1_weightRead_3_data[487 : 480];
  assign dSP_61_b = featureMemOutData_3[39 : 32];
  assign mulFeatureWeightData_3_2_4 = dSP_61_p[31 : 0];
  assign mulFeatureWeightData_3_3_4 = dSP_61_p[63 : 32];
  assign dSP_62_a = loadWeight_1_weightRead_3_data[303 : 296];
  assign dSP_62_d = loadWeight_1_weightRead_3_data[367 : 360];
  assign dSP_62_a1 = loadWeight_1_weightRead_3_data[431 : 424];
  assign dSP_62_d1 = loadWeight_1_weightRead_3_data[495 : 488];
  assign dSP_62_b = featureMemOutData_3[47 : 40];
  assign mulFeatureWeightData_3_2_5 = dSP_62_p[31 : 0];
  assign mulFeatureWeightData_3_3_5 = dSP_62_p[63 : 32];
  assign dSP_63_a = loadWeight_1_weightRead_3_data[311 : 304];
  assign dSP_63_d = loadWeight_1_weightRead_3_data[375 : 368];
  assign dSP_63_a1 = loadWeight_1_weightRead_3_data[439 : 432];
  assign dSP_63_d1 = loadWeight_1_weightRead_3_data[503 : 496];
  assign dSP_63_b = featureMemOutData_3[55 : 48];
  assign mulFeatureWeightData_3_2_6 = dSP_63_p[31 : 0];
  assign mulFeatureWeightData_3_3_6 = dSP_63_p[63 : 32];
  assign dSP_64_a = loadWeight_1_weightRead_3_data[319 : 312];
  assign dSP_64_d = loadWeight_1_weightRead_3_data[383 : 376];
  assign dSP_64_a1 = loadWeight_1_weightRead_3_data[447 : 440];
  assign dSP_64_d1 = loadWeight_1_weightRead_3_data[511 : 504];
  assign dSP_64_b = featureMemOutData_3[63 : 56];
  assign mulFeatureWeightData_3_2_7 = dSP_64_p[31 : 0];
  assign mulFeatureWeightData_3_3_7 = dSP_64_p[63 : 32];
  assign dSP_65_a = loadWeight_1_weightRead_4_data[7 : 0];
  assign dSP_65_d = loadWeight_1_weightRead_4_data[71 : 64];
  assign dSP_65_a1 = loadWeight_1_weightRead_4_data[135 : 128];
  assign dSP_65_d1 = loadWeight_1_weightRead_4_data[199 : 192];
  assign dSP_65_b = featureMemOutData_4[7 : 0];
  assign mulFeatureWeightData_4_0_0 = dSP_65_p[31 : 0];
  assign mulFeatureWeightData_4_1_0 = dSP_65_p[63 : 32];
  assign dSP_66_a = loadWeight_1_weightRead_4_data[15 : 8];
  assign dSP_66_d = loadWeight_1_weightRead_4_data[79 : 72];
  assign dSP_66_a1 = loadWeight_1_weightRead_4_data[143 : 136];
  assign dSP_66_d1 = loadWeight_1_weightRead_4_data[207 : 200];
  assign dSP_66_b = featureMemOutData_4[15 : 8];
  assign mulFeatureWeightData_4_0_1 = dSP_66_p[31 : 0];
  assign mulFeatureWeightData_4_1_1 = dSP_66_p[63 : 32];
  assign dSP_67_a = loadWeight_1_weightRead_4_data[23 : 16];
  assign dSP_67_d = loadWeight_1_weightRead_4_data[87 : 80];
  assign dSP_67_a1 = loadWeight_1_weightRead_4_data[151 : 144];
  assign dSP_67_d1 = loadWeight_1_weightRead_4_data[215 : 208];
  assign dSP_67_b = featureMemOutData_4[23 : 16];
  assign mulFeatureWeightData_4_0_2 = dSP_67_p[31 : 0];
  assign mulFeatureWeightData_4_1_2 = dSP_67_p[63 : 32];
  assign dSP_68_a = loadWeight_1_weightRead_4_data[31 : 24];
  assign dSP_68_d = loadWeight_1_weightRead_4_data[95 : 88];
  assign dSP_68_a1 = loadWeight_1_weightRead_4_data[159 : 152];
  assign dSP_68_d1 = loadWeight_1_weightRead_4_data[223 : 216];
  assign dSP_68_b = featureMemOutData_4[31 : 24];
  assign mulFeatureWeightData_4_0_3 = dSP_68_p[31 : 0];
  assign mulFeatureWeightData_4_1_3 = dSP_68_p[63 : 32];
  assign dSP_69_a = loadWeight_1_weightRead_4_data[39 : 32];
  assign dSP_69_d = loadWeight_1_weightRead_4_data[103 : 96];
  assign dSP_69_a1 = loadWeight_1_weightRead_4_data[167 : 160];
  assign dSP_69_d1 = loadWeight_1_weightRead_4_data[231 : 224];
  assign dSP_69_b = featureMemOutData_4[39 : 32];
  assign mulFeatureWeightData_4_0_4 = dSP_69_p[31 : 0];
  assign mulFeatureWeightData_4_1_4 = dSP_69_p[63 : 32];
  assign dSP_70_a = loadWeight_1_weightRead_4_data[47 : 40];
  assign dSP_70_d = loadWeight_1_weightRead_4_data[111 : 104];
  assign dSP_70_a1 = loadWeight_1_weightRead_4_data[175 : 168];
  assign dSP_70_d1 = loadWeight_1_weightRead_4_data[239 : 232];
  assign dSP_70_b = featureMemOutData_4[47 : 40];
  assign mulFeatureWeightData_4_0_5 = dSP_70_p[31 : 0];
  assign mulFeatureWeightData_4_1_5 = dSP_70_p[63 : 32];
  assign dSP_71_a = loadWeight_1_weightRead_4_data[55 : 48];
  assign dSP_71_d = loadWeight_1_weightRead_4_data[119 : 112];
  assign dSP_71_a1 = loadWeight_1_weightRead_4_data[183 : 176];
  assign dSP_71_d1 = loadWeight_1_weightRead_4_data[247 : 240];
  assign dSP_71_b = featureMemOutData_4[55 : 48];
  assign mulFeatureWeightData_4_0_6 = dSP_71_p[31 : 0];
  assign mulFeatureWeightData_4_1_6 = dSP_71_p[63 : 32];
  assign dSP_72_a = loadWeight_1_weightRead_4_data[63 : 56];
  assign dSP_72_d = loadWeight_1_weightRead_4_data[127 : 120];
  assign dSP_72_a1 = loadWeight_1_weightRead_4_data[191 : 184];
  assign dSP_72_d1 = loadWeight_1_weightRead_4_data[255 : 248];
  assign dSP_72_b = featureMemOutData_4[63 : 56];
  assign mulFeatureWeightData_4_0_7 = dSP_72_p[31 : 0];
  assign mulFeatureWeightData_4_1_7 = dSP_72_p[63 : 32];
  assign dSP_73_a = loadWeight_1_weightRead_4_data[263 : 256];
  assign dSP_73_d = loadWeight_1_weightRead_4_data[327 : 320];
  assign dSP_73_a1 = loadWeight_1_weightRead_4_data[391 : 384];
  assign dSP_73_d1 = loadWeight_1_weightRead_4_data[455 : 448];
  assign dSP_73_b = featureMemOutData_4[7 : 0];
  assign mulFeatureWeightData_4_2_0 = dSP_73_p[31 : 0];
  assign mulFeatureWeightData_4_3_0 = dSP_73_p[63 : 32];
  assign dSP_74_a = loadWeight_1_weightRead_4_data[271 : 264];
  assign dSP_74_d = loadWeight_1_weightRead_4_data[335 : 328];
  assign dSP_74_a1 = loadWeight_1_weightRead_4_data[399 : 392];
  assign dSP_74_d1 = loadWeight_1_weightRead_4_data[463 : 456];
  assign dSP_74_b = featureMemOutData_4[15 : 8];
  assign mulFeatureWeightData_4_2_1 = dSP_74_p[31 : 0];
  assign mulFeatureWeightData_4_3_1 = dSP_74_p[63 : 32];
  assign dSP_75_a = loadWeight_1_weightRead_4_data[279 : 272];
  assign dSP_75_d = loadWeight_1_weightRead_4_data[343 : 336];
  assign dSP_75_a1 = loadWeight_1_weightRead_4_data[407 : 400];
  assign dSP_75_d1 = loadWeight_1_weightRead_4_data[471 : 464];
  assign dSP_75_b = featureMemOutData_4[23 : 16];
  assign mulFeatureWeightData_4_2_2 = dSP_75_p[31 : 0];
  assign mulFeatureWeightData_4_3_2 = dSP_75_p[63 : 32];
  assign dSP_76_a = loadWeight_1_weightRead_4_data[287 : 280];
  assign dSP_76_d = loadWeight_1_weightRead_4_data[351 : 344];
  assign dSP_76_a1 = loadWeight_1_weightRead_4_data[415 : 408];
  assign dSP_76_d1 = loadWeight_1_weightRead_4_data[479 : 472];
  assign dSP_76_b = featureMemOutData_4[31 : 24];
  assign mulFeatureWeightData_4_2_3 = dSP_76_p[31 : 0];
  assign mulFeatureWeightData_4_3_3 = dSP_76_p[63 : 32];
  assign dSP_77_a = loadWeight_1_weightRead_4_data[295 : 288];
  assign dSP_77_d = loadWeight_1_weightRead_4_data[359 : 352];
  assign dSP_77_a1 = loadWeight_1_weightRead_4_data[423 : 416];
  assign dSP_77_d1 = loadWeight_1_weightRead_4_data[487 : 480];
  assign dSP_77_b = featureMemOutData_4[39 : 32];
  assign mulFeatureWeightData_4_2_4 = dSP_77_p[31 : 0];
  assign mulFeatureWeightData_4_3_4 = dSP_77_p[63 : 32];
  assign dSP_78_a = loadWeight_1_weightRead_4_data[303 : 296];
  assign dSP_78_d = loadWeight_1_weightRead_4_data[367 : 360];
  assign dSP_78_a1 = loadWeight_1_weightRead_4_data[431 : 424];
  assign dSP_78_d1 = loadWeight_1_weightRead_4_data[495 : 488];
  assign dSP_78_b = featureMemOutData_4[47 : 40];
  assign mulFeatureWeightData_4_2_5 = dSP_78_p[31 : 0];
  assign mulFeatureWeightData_4_3_5 = dSP_78_p[63 : 32];
  assign dSP_79_a = loadWeight_1_weightRead_4_data[311 : 304];
  assign dSP_79_d = loadWeight_1_weightRead_4_data[375 : 368];
  assign dSP_79_a1 = loadWeight_1_weightRead_4_data[439 : 432];
  assign dSP_79_d1 = loadWeight_1_weightRead_4_data[503 : 496];
  assign dSP_79_b = featureMemOutData_4[55 : 48];
  assign mulFeatureWeightData_4_2_6 = dSP_79_p[31 : 0];
  assign mulFeatureWeightData_4_3_6 = dSP_79_p[63 : 32];
  assign dSP_80_a = loadWeight_1_weightRead_4_data[319 : 312];
  assign dSP_80_d = loadWeight_1_weightRead_4_data[383 : 376];
  assign dSP_80_a1 = loadWeight_1_weightRead_4_data[447 : 440];
  assign dSP_80_d1 = loadWeight_1_weightRead_4_data[511 : 504];
  assign dSP_80_b = featureMemOutData_4[63 : 56];
  assign mulFeatureWeightData_4_2_7 = dSP_80_p[31 : 0];
  assign mulFeatureWeightData_4_3_7 = dSP_80_p[63 : 32];
  assign dSP_81_a = loadWeight_1_weightRead_5_data[7 : 0];
  assign dSP_81_d = loadWeight_1_weightRead_5_data[71 : 64];
  assign dSP_81_a1 = loadWeight_1_weightRead_5_data[135 : 128];
  assign dSP_81_d1 = loadWeight_1_weightRead_5_data[199 : 192];
  assign dSP_81_b = featureMemOutData_5[7 : 0];
  assign mulFeatureWeightData_5_0_0 = dSP_81_p[31 : 0];
  assign mulFeatureWeightData_5_1_0 = dSP_81_p[63 : 32];
  assign dSP_82_a = loadWeight_1_weightRead_5_data[15 : 8];
  assign dSP_82_d = loadWeight_1_weightRead_5_data[79 : 72];
  assign dSP_82_a1 = loadWeight_1_weightRead_5_data[143 : 136];
  assign dSP_82_d1 = loadWeight_1_weightRead_5_data[207 : 200];
  assign dSP_82_b = featureMemOutData_5[15 : 8];
  assign mulFeatureWeightData_5_0_1 = dSP_82_p[31 : 0];
  assign mulFeatureWeightData_5_1_1 = dSP_82_p[63 : 32];
  assign dSP_83_a = loadWeight_1_weightRead_5_data[23 : 16];
  assign dSP_83_d = loadWeight_1_weightRead_5_data[87 : 80];
  assign dSP_83_a1 = loadWeight_1_weightRead_5_data[151 : 144];
  assign dSP_83_d1 = loadWeight_1_weightRead_5_data[215 : 208];
  assign dSP_83_b = featureMemOutData_5[23 : 16];
  assign mulFeatureWeightData_5_0_2 = dSP_83_p[31 : 0];
  assign mulFeatureWeightData_5_1_2 = dSP_83_p[63 : 32];
  assign dSP_84_a = loadWeight_1_weightRead_5_data[31 : 24];
  assign dSP_84_d = loadWeight_1_weightRead_5_data[95 : 88];
  assign dSP_84_a1 = loadWeight_1_weightRead_5_data[159 : 152];
  assign dSP_84_d1 = loadWeight_1_weightRead_5_data[223 : 216];
  assign dSP_84_b = featureMemOutData_5[31 : 24];
  assign mulFeatureWeightData_5_0_3 = dSP_84_p[31 : 0];
  assign mulFeatureWeightData_5_1_3 = dSP_84_p[63 : 32];
  assign dSP_85_a = loadWeight_1_weightRead_5_data[39 : 32];
  assign dSP_85_d = loadWeight_1_weightRead_5_data[103 : 96];
  assign dSP_85_a1 = loadWeight_1_weightRead_5_data[167 : 160];
  assign dSP_85_d1 = loadWeight_1_weightRead_5_data[231 : 224];
  assign dSP_85_b = featureMemOutData_5[39 : 32];
  assign mulFeatureWeightData_5_0_4 = dSP_85_p[31 : 0];
  assign mulFeatureWeightData_5_1_4 = dSP_85_p[63 : 32];
  assign dSP_86_a = loadWeight_1_weightRead_5_data[47 : 40];
  assign dSP_86_d = loadWeight_1_weightRead_5_data[111 : 104];
  assign dSP_86_a1 = loadWeight_1_weightRead_5_data[175 : 168];
  assign dSP_86_d1 = loadWeight_1_weightRead_5_data[239 : 232];
  assign dSP_86_b = featureMemOutData_5[47 : 40];
  assign mulFeatureWeightData_5_0_5 = dSP_86_p[31 : 0];
  assign mulFeatureWeightData_5_1_5 = dSP_86_p[63 : 32];
  assign dSP_87_a = loadWeight_1_weightRead_5_data[55 : 48];
  assign dSP_87_d = loadWeight_1_weightRead_5_data[119 : 112];
  assign dSP_87_a1 = loadWeight_1_weightRead_5_data[183 : 176];
  assign dSP_87_d1 = loadWeight_1_weightRead_5_data[247 : 240];
  assign dSP_87_b = featureMemOutData_5[55 : 48];
  assign mulFeatureWeightData_5_0_6 = dSP_87_p[31 : 0];
  assign mulFeatureWeightData_5_1_6 = dSP_87_p[63 : 32];
  assign dSP_88_a = loadWeight_1_weightRead_5_data[63 : 56];
  assign dSP_88_d = loadWeight_1_weightRead_5_data[127 : 120];
  assign dSP_88_a1 = loadWeight_1_weightRead_5_data[191 : 184];
  assign dSP_88_d1 = loadWeight_1_weightRead_5_data[255 : 248];
  assign dSP_88_b = featureMemOutData_5[63 : 56];
  assign mulFeatureWeightData_5_0_7 = dSP_88_p[31 : 0];
  assign mulFeatureWeightData_5_1_7 = dSP_88_p[63 : 32];
  assign dSP_89_a = loadWeight_1_weightRead_5_data[263 : 256];
  assign dSP_89_d = loadWeight_1_weightRead_5_data[327 : 320];
  assign dSP_89_a1 = loadWeight_1_weightRead_5_data[391 : 384];
  assign dSP_89_d1 = loadWeight_1_weightRead_5_data[455 : 448];
  assign dSP_89_b = featureMemOutData_5[7 : 0];
  assign mulFeatureWeightData_5_2_0 = dSP_89_p[31 : 0];
  assign mulFeatureWeightData_5_3_0 = dSP_89_p[63 : 32];
  assign dSP_90_a = loadWeight_1_weightRead_5_data[271 : 264];
  assign dSP_90_d = loadWeight_1_weightRead_5_data[335 : 328];
  assign dSP_90_a1 = loadWeight_1_weightRead_5_data[399 : 392];
  assign dSP_90_d1 = loadWeight_1_weightRead_5_data[463 : 456];
  assign dSP_90_b = featureMemOutData_5[15 : 8];
  assign mulFeatureWeightData_5_2_1 = dSP_90_p[31 : 0];
  assign mulFeatureWeightData_5_3_1 = dSP_90_p[63 : 32];
  assign dSP_91_a = loadWeight_1_weightRead_5_data[279 : 272];
  assign dSP_91_d = loadWeight_1_weightRead_5_data[343 : 336];
  assign dSP_91_a1 = loadWeight_1_weightRead_5_data[407 : 400];
  assign dSP_91_d1 = loadWeight_1_weightRead_5_data[471 : 464];
  assign dSP_91_b = featureMemOutData_5[23 : 16];
  assign mulFeatureWeightData_5_2_2 = dSP_91_p[31 : 0];
  assign mulFeatureWeightData_5_3_2 = dSP_91_p[63 : 32];
  assign dSP_92_a = loadWeight_1_weightRead_5_data[287 : 280];
  assign dSP_92_d = loadWeight_1_weightRead_5_data[351 : 344];
  assign dSP_92_a1 = loadWeight_1_weightRead_5_data[415 : 408];
  assign dSP_92_d1 = loadWeight_1_weightRead_5_data[479 : 472];
  assign dSP_92_b = featureMemOutData_5[31 : 24];
  assign mulFeatureWeightData_5_2_3 = dSP_92_p[31 : 0];
  assign mulFeatureWeightData_5_3_3 = dSP_92_p[63 : 32];
  assign dSP_93_a = loadWeight_1_weightRead_5_data[295 : 288];
  assign dSP_93_d = loadWeight_1_weightRead_5_data[359 : 352];
  assign dSP_93_a1 = loadWeight_1_weightRead_5_data[423 : 416];
  assign dSP_93_d1 = loadWeight_1_weightRead_5_data[487 : 480];
  assign dSP_93_b = featureMemOutData_5[39 : 32];
  assign mulFeatureWeightData_5_2_4 = dSP_93_p[31 : 0];
  assign mulFeatureWeightData_5_3_4 = dSP_93_p[63 : 32];
  assign dSP_94_a = loadWeight_1_weightRead_5_data[303 : 296];
  assign dSP_94_d = loadWeight_1_weightRead_5_data[367 : 360];
  assign dSP_94_a1 = loadWeight_1_weightRead_5_data[431 : 424];
  assign dSP_94_d1 = loadWeight_1_weightRead_5_data[495 : 488];
  assign dSP_94_b = featureMemOutData_5[47 : 40];
  assign mulFeatureWeightData_5_2_5 = dSP_94_p[31 : 0];
  assign mulFeatureWeightData_5_3_5 = dSP_94_p[63 : 32];
  assign dSP_95_a = loadWeight_1_weightRead_5_data[311 : 304];
  assign dSP_95_d = loadWeight_1_weightRead_5_data[375 : 368];
  assign dSP_95_a1 = loadWeight_1_weightRead_5_data[439 : 432];
  assign dSP_95_d1 = loadWeight_1_weightRead_5_data[503 : 496];
  assign dSP_95_b = featureMemOutData_5[55 : 48];
  assign mulFeatureWeightData_5_2_6 = dSP_95_p[31 : 0];
  assign mulFeatureWeightData_5_3_6 = dSP_95_p[63 : 32];
  assign dSP_96_a = loadWeight_1_weightRead_5_data[319 : 312];
  assign dSP_96_d = loadWeight_1_weightRead_5_data[383 : 376];
  assign dSP_96_a1 = loadWeight_1_weightRead_5_data[447 : 440];
  assign dSP_96_d1 = loadWeight_1_weightRead_5_data[511 : 504];
  assign dSP_96_b = featureMemOutData_5[63 : 56];
  assign mulFeatureWeightData_5_2_7 = dSP_96_p[31 : 0];
  assign mulFeatureWeightData_5_3_7 = dSP_96_p[63 : 32];
  assign dSP_97_a = loadWeight_1_weightRead_6_data[7 : 0];
  assign dSP_97_d = loadWeight_1_weightRead_6_data[71 : 64];
  assign dSP_97_a1 = loadWeight_1_weightRead_6_data[135 : 128];
  assign dSP_97_d1 = loadWeight_1_weightRead_6_data[199 : 192];
  assign dSP_97_b = featureMemOutData_6[7 : 0];
  assign mulFeatureWeightData_6_0_0 = dSP_97_p[31 : 0];
  assign mulFeatureWeightData_6_1_0 = dSP_97_p[63 : 32];
  assign dSP_98_a = loadWeight_1_weightRead_6_data[15 : 8];
  assign dSP_98_d = loadWeight_1_weightRead_6_data[79 : 72];
  assign dSP_98_a1 = loadWeight_1_weightRead_6_data[143 : 136];
  assign dSP_98_d1 = loadWeight_1_weightRead_6_data[207 : 200];
  assign dSP_98_b = featureMemOutData_6[15 : 8];
  assign mulFeatureWeightData_6_0_1 = dSP_98_p[31 : 0];
  assign mulFeatureWeightData_6_1_1 = dSP_98_p[63 : 32];
  assign dSP_99_a = loadWeight_1_weightRead_6_data[23 : 16];
  assign dSP_99_d = loadWeight_1_weightRead_6_data[87 : 80];
  assign dSP_99_a1 = loadWeight_1_weightRead_6_data[151 : 144];
  assign dSP_99_d1 = loadWeight_1_weightRead_6_data[215 : 208];
  assign dSP_99_b = featureMemOutData_6[23 : 16];
  assign mulFeatureWeightData_6_0_2 = dSP_99_p[31 : 0];
  assign mulFeatureWeightData_6_1_2 = dSP_99_p[63 : 32];
  assign dSP_100_a = loadWeight_1_weightRead_6_data[31 : 24];
  assign dSP_100_d = loadWeight_1_weightRead_6_data[95 : 88];
  assign dSP_100_a1 = loadWeight_1_weightRead_6_data[159 : 152];
  assign dSP_100_d1 = loadWeight_1_weightRead_6_data[223 : 216];
  assign dSP_100_b = featureMemOutData_6[31 : 24];
  assign mulFeatureWeightData_6_0_3 = dSP_100_p[31 : 0];
  assign mulFeatureWeightData_6_1_3 = dSP_100_p[63 : 32];
  assign dSP_101_a = loadWeight_1_weightRead_6_data[39 : 32];
  assign dSP_101_d = loadWeight_1_weightRead_6_data[103 : 96];
  assign dSP_101_a1 = loadWeight_1_weightRead_6_data[167 : 160];
  assign dSP_101_d1 = loadWeight_1_weightRead_6_data[231 : 224];
  assign dSP_101_b = featureMemOutData_6[39 : 32];
  assign mulFeatureWeightData_6_0_4 = dSP_101_p[31 : 0];
  assign mulFeatureWeightData_6_1_4 = dSP_101_p[63 : 32];
  assign dSP_102_a = loadWeight_1_weightRead_6_data[47 : 40];
  assign dSP_102_d = loadWeight_1_weightRead_6_data[111 : 104];
  assign dSP_102_a1 = loadWeight_1_weightRead_6_data[175 : 168];
  assign dSP_102_d1 = loadWeight_1_weightRead_6_data[239 : 232];
  assign dSP_102_b = featureMemOutData_6[47 : 40];
  assign mulFeatureWeightData_6_0_5 = dSP_102_p[31 : 0];
  assign mulFeatureWeightData_6_1_5 = dSP_102_p[63 : 32];
  assign dSP_103_a = loadWeight_1_weightRead_6_data[55 : 48];
  assign dSP_103_d = loadWeight_1_weightRead_6_data[119 : 112];
  assign dSP_103_a1 = loadWeight_1_weightRead_6_data[183 : 176];
  assign dSP_103_d1 = loadWeight_1_weightRead_6_data[247 : 240];
  assign dSP_103_b = featureMemOutData_6[55 : 48];
  assign mulFeatureWeightData_6_0_6 = dSP_103_p[31 : 0];
  assign mulFeatureWeightData_6_1_6 = dSP_103_p[63 : 32];
  assign dSP_104_a = loadWeight_1_weightRead_6_data[63 : 56];
  assign dSP_104_d = loadWeight_1_weightRead_6_data[127 : 120];
  assign dSP_104_a1 = loadWeight_1_weightRead_6_data[191 : 184];
  assign dSP_104_d1 = loadWeight_1_weightRead_6_data[255 : 248];
  assign dSP_104_b = featureMemOutData_6[63 : 56];
  assign mulFeatureWeightData_6_0_7 = dSP_104_p[31 : 0];
  assign mulFeatureWeightData_6_1_7 = dSP_104_p[63 : 32];
  assign dSP_105_a = loadWeight_1_weightRead_6_data[263 : 256];
  assign dSP_105_d = loadWeight_1_weightRead_6_data[327 : 320];
  assign dSP_105_a1 = loadWeight_1_weightRead_6_data[391 : 384];
  assign dSP_105_d1 = loadWeight_1_weightRead_6_data[455 : 448];
  assign dSP_105_b = featureMemOutData_6[7 : 0];
  assign mulFeatureWeightData_6_2_0 = dSP_105_p[31 : 0];
  assign mulFeatureWeightData_6_3_0 = dSP_105_p[63 : 32];
  assign dSP_106_a = loadWeight_1_weightRead_6_data[271 : 264];
  assign dSP_106_d = loadWeight_1_weightRead_6_data[335 : 328];
  assign dSP_106_a1 = loadWeight_1_weightRead_6_data[399 : 392];
  assign dSP_106_d1 = loadWeight_1_weightRead_6_data[463 : 456];
  assign dSP_106_b = featureMemOutData_6[15 : 8];
  assign mulFeatureWeightData_6_2_1 = dSP_106_p[31 : 0];
  assign mulFeatureWeightData_6_3_1 = dSP_106_p[63 : 32];
  assign dSP_107_a = loadWeight_1_weightRead_6_data[279 : 272];
  assign dSP_107_d = loadWeight_1_weightRead_6_data[343 : 336];
  assign dSP_107_a1 = loadWeight_1_weightRead_6_data[407 : 400];
  assign dSP_107_d1 = loadWeight_1_weightRead_6_data[471 : 464];
  assign dSP_107_b = featureMemOutData_6[23 : 16];
  assign mulFeatureWeightData_6_2_2 = dSP_107_p[31 : 0];
  assign mulFeatureWeightData_6_3_2 = dSP_107_p[63 : 32];
  assign dSP_108_a = loadWeight_1_weightRead_6_data[287 : 280];
  assign dSP_108_d = loadWeight_1_weightRead_6_data[351 : 344];
  assign dSP_108_a1 = loadWeight_1_weightRead_6_data[415 : 408];
  assign dSP_108_d1 = loadWeight_1_weightRead_6_data[479 : 472];
  assign dSP_108_b = featureMemOutData_6[31 : 24];
  assign mulFeatureWeightData_6_2_3 = dSP_108_p[31 : 0];
  assign mulFeatureWeightData_6_3_3 = dSP_108_p[63 : 32];
  assign dSP_109_a = loadWeight_1_weightRead_6_data[295 : 288];
  assign dSP_109_d = loadWeight_1_weightRead_6_data[359 : 352];
  assign dSP_109_a1 = loadWeight_1_weightRead_6_data[423 : 416];
  assign dSP_109_d1 = loadWeight_1_weightRead_6_data[487 : 480];
  assign dSP_109_b = featureMemOutData_6[39 : 32];
  assign mulFeatureWeightData_6_2_4 = dSP_109_p[31 : 0];
  assign mulFeatureWeightData_6_3_4 = dSP_109_p[63 : 32];
  assign dSP_110_a = loadWeight_1_weightRead_6_data[303 : 296];
  assign dSP_110_d = loadWeight_1_weightRead_6_data[367 : 360];
  assign dSP_110_a1 = loadWeight_1_weightRead_6_data[431 : 424];
  assign dSP_110_d1 = loadWeight_1_weightRead_6_data[495 : 488];
  assign dSP_110_b = featureMemOutData_6[47 : 40];
  assign mulFeatureWeightData_6_2_5 = dSP_110_p[31 : 0];
  assign mulFeatureWeightData_6_3_5 = dSP_110_p[63 : 32];
  assign dSP_111_a = loadWeight_1_weightRead_6_data[311 : 304];
  assign dSP_111_d = loadWeight_1_weightRead_6_data[375 : 368];
  assign dSP_111_a1 = loadWeight_1_weightRead_6_data[439 : 432];
  assign dSP_111_d1 = loadWeight_1_weightRead_6_data[503 : 496];
  assign dSP_111_b = featureMemOutData_6[55 : 48];
  assign mulFeatureWeightData_6_2_6 = dSP_111_p[31 : 0];
  assign mulFeatureWeightData_6_3_6 = dSP_111_p[63 : 32];
  assign dSP_112_a = loadWeight_1_weightRead_6_data[319 : 312];
  assign dSP_112_d = loadWeight_1_weightRead_6_data[383 : 376];
  assign dSP_112_a1 = loadWeight_1_weightRead_6_data[447 : 440];
  assign dSP_112_d1 = loadWeight_1_weightRead_6_data[511 : 504];
  assign dSP_112_b = featureMemOutData_6[63 : 56];
  assign mulFeatureWeightData_6_2_7 = dSP_112_p[31 : 0];
  assign mulFeatureWeightData_6_3_7 = dSP_112_p[63 : 32];
  assign dSP_113_a = loadWeight_1_weightRead_7_data[7 : 0];
  assign dSP_113_d = loadWeight_1_weightRead_7_data[71 : 64];
  assign dSP_113_a1 = loadWeight_1_weightRead_7_data[135 : 128];
  assign dSP_113_d1 = loadWeight_1_weightRead_7_data[199 : 192];
  assign dSP_113_b = featureMemOutData_7[7 : 0];
  assign mulFeatureWeightData_7_0_0 = dSP_113_p[31 : 0];
  assign mulFeatureWeightData_7_1_0 = dSP_113_p[63 : 32];
  assign dSP_114_a = loadWeight_1_weightRead_7_data[15 : 8];
  assign dSP_114_d = loadWeight_1_weightRead_7_data[79 : 72];
  assign dSP_114_a1 = loadWeight_1_weightRead_7_data[143 : 136];
  assign dSP_114_d1 = loadWeight_1_weightRead_7_data[207 : 200];
  assign dSP_114_b = featureMemOutData_7[15 : 8];
  assign mulFeatureWeightData_7_0_1 = dSP_114_p[31 : 0];
  assign mulFeatureWeightData_7_1_1 = dSP_114_p[63 : 32];
  assign dSP_115_a = loadWeight_1_weightRead_7_data[23 : 16];
  assign dSP_115_d = loadWeight_1_weightRead_7_data[87 : 80];
  assign dSP_115_a1 = loadWeight_1_weightRead_7_data[151 : 144];
  assign dSP_115_d1 = loadWeight_1_weightRead_7_data[215 : 208];
  assign dSP_115_b = featureMemOutData_7[23 : 16];
  assign mulFeatureWeightData_7_0_2 = dSP_115_p[31 : 0];
  assign mulFeatureWeightData_7_1_2 = dSP_115_p[63 : 32];
  assign dSP_116_a = loadWeight_1_weightRead_7_data[31 : 24];
  assign dSP_116_d = loadWeight_1_weightRead_7_data[95 : 88];
  assign dSP_116_a1 = loadWeight_1_weightRead_7_data[159 : 152];
  assign dSP_116_d1 = loadWeight_1_weightRead_7_data[223 : 216];
  assign dSP_116_b = featureMemOutData_7[31 : 24];
  assign mulFeatureWeightData_7_0_3 = dSP_116_p[31 : 0];
  assign mulFeatureWeightData_7_1_3 = dSP_116_p[63 : 32];
  assign dSP_117_a = loadWeight_1_weightRead_7_data[39 : 32];
  assign dSP_117_d = loadWeight_1_weightRead_7_data[103 : 96];
  assign dSP_117_a1 = loadWeight_1_weightRead_7_data[167 : 160];
  assign dSP_117_d1 = loadWeight_1_weightRead_7_data[231 : 224];
  assign dSP_117_b = featureMemOutData_7[39 : 32];
  assign mulFeatureWeightData_7_0_4 = dSP_117_p[31 : 0];
  assign mulFeatureWeightData_7_1_4 = dSP_117_p[63 : 32];
  assign dSP_118_a = loadWeight_1_weightRead_7_data[47 : 40];
  assign dSP_118_d = loadWeight_1_weightRead_7_data[111 : 104];
  assign dSP_118_a1 = loadWeight_1_weightRead_7_data[175 : 168];
  assign dSP_118_d1 = loadWeight_1_weightRead_7_data[239 : 232];
  assign dSP_118_b = featureMemOutData_7[47 : 40];
  assign mulFeatureWeightData_7_0_5 = dSP_118_p[31 : 0];
  assign mulFeatureWeightData_7_1_5 = dSP_118_p[63 : 32];
  assign dSP_119_a = loadWeight_1_weightRead_7_data[55 : 48];
  assign dSP_119_d = loadWeight_1_weightRead_7_data[119 : 112];
  assign dSP_119_a1 = loadWeight_1_weightRead_7_data[183 : 176];
  assign dSP_119_d1 = loadWeight_1_weightRead_7_data[247 : 240];
  assign dSP_119_b = featureMemOutData_7[55 : 48];
  assign mulFeatureWeightData_7_0_6 = dSP_119_p[31 : 0];
  assign mulFeatureWeightData_7_1_6 = dSP_119_p[63 : 32];
  assign dSP_120_a = loadWeight_1_weightRead_7_data[63 : 56];
  assign dSP_120_d = loadWeight_1_weightRead_7_data[127 : 120];
  assign dSP_120_a1 = loadWeight_1_weightRead_7_data[191 : 184];
  assign dSP_120_d1 = loadWeight_1_weightRead_7_data[255 : 248];
  assign dSP_120_b = featureMemOutData_7[63 : 56];
  assign mulFeatureWeightData_7_0_7 = dSP_120_p[31 : 0];
  assign mulFeatureWeightData_7_1_7 = dSP_120_p[63 : 32];
  assign dSP_121_a = loadWeight_1_weightRead_7_data[263 : 256];
  assign dSP_121_d = loadWeight_1_weightRead_7_data[327 : 320];
  assign dSP_121_a1 = loadWeight_1_weightRead_7_data[391 : 384];
  assign dSP_121_d1 = loadWeight_1_weightRead_7_data[455 : 448];
  assign dSP_121_b = featureMemOutData_7[7 : 0];
  assign mulFeatureWeightData_7_2_0 = dSP_121_p[31 : 0];
  assign mulFeatureWeightData_7_3_0 = dSP_121_p[63 : 32];
  assign dSP_122_a = loadWeight_1_weightRead_7_data[271 : 264];
  assign dSP_122_d = loadWeight_1_weightRead_7_data[335 : 328];
  assign dSP_122_a1 = loadWeight_1_weightRead_7_data[399 : 392];
  assign dSP_122_d1 = loadWeight_1_weightRead_7_data[463 : 456];
  assign dSP_122_b = featureMemOutData_7[15 : 8];
  assign mulFeatureWeightData_7_2_1 = dSP_122_p[31 : 0];
  assign mulFeatureWeightData_7_3_1 = dSP_122_p[63 : 32];
  assign dSP_123_a = loadWeight_1_weightRead_7_data[279 : 272];
  assign dSP_123_d = loadWeight_1_weightRead_7_data[343 : 336];
  assign dSP_123_a1 = loadWeight_1_weightRead_7_data[407 : 400];
  assign dSP_123_d1 = loadWeight_1_weightRead_7_data[471 : 464];
  assign dSP_123_b = featureMemOutData_7[23 : 16];
  assign mulFeatureWeightData_7_2_2 = dSP_123_p[31 : 0];
  assign mulFeatureWeightData_7_3_2 = dSP_123_p[63 : 32];
  assign dSP_124_a = loadWeight_1_weightRead_7_data[287 : 280];
  assign dSP_124_d = loadWeight_1_weightRead_7_data[351 : 344];
  assign dSP_124_a1 = loadWeight_1_weightRead_7_data[415 : 408];
  assign dSP_124_d1 = loadWeight_1_weightRead_7_data[479 : 472];
  assign dSP_124_b = featureMemOutData_7[31 : 24];
  assign mulFeatureWeightData_7_2_3 = dSP_124_p[31 : 0];
  assign mulFeatureWeightData_7_3_3 = dSP_124_p[63 : 32];
  assign dSP_125_a = loadWeight_1_weightRead_7_data[295 : 288];
  assign dSP_125_d = loadWeight_1_weightRead_7_data[359 : 352];
  assign dSP_125_a1 = loadWeight_1_weightRead_7_data[423 : 416];
  assign dSP_125_d1 = loadWeight_1_weightRead_7_data[487 : 480];
  assign dSP_125_b = featureMemOutData_7[39 : 32];
  assign mulFeatureWeightData_7_2_4 = dSP_125_p[31 : 0];
  assign mulFeatureWeightData_7_3_4 = dSP_125_p[63 : 32];
  assign dSP_126_a = loadWeight_1_weightRead_7_data[303 : 296];
  assign dSP_126_d = loadWeight_1_weightRead_7_data[367 : 360];
  assign dSP_126_a1 = loadWeight_1_weightRead_7_data[431 : 424];
  assign dSP_126_d1 = loadWeight_1_weightRead_7_data[495 : 488];
  assign dSP_126_b = featureMemOutData_7[47 : 40];
  assign mulFeatureWeightData_7_2_5 = dSP_126_p[31 : 0];
  assign mulFeatureWeightData_7_3_5 = dSP_126_p[63 : 32];
  assign dSP_127_a = loadWeight_1_weightRead_7_data[311 : 304];
  assign dSP_127_d = loadWeight_1_weightRead_7_data[375 : 368];
  assign dSP_127_a1 = loadWeight_1_weightRead_7_data[439 : 432];
  assign dSP_127_d1 = loadWeight_1_weightRead_7_data[503 : 496];
  assign dSP_127_b = featureMemOutData_7[55 : 48];
  assign mulFeatureWeightData_7_2_6 = dSP_127_p[31 : 0];
  assign mulFeatureWeightData_7_3_6 = dSP_127_p[63 : 32];
  assign dSP_128_a = loadWeight_1_weightRead_7_data[319 : 312];
  assign dSP_128_d = loadWeight_1_weightRead_7_data[383 : 376];
  assign dSP_128_a1 = loadWeight_1_weightRead_7_data[447 : 440];
  assign dSP_128_d1 = loadWeight_1_weightRead_7_data[511 : 504];
  assign dSP_128_b = featureMemOutData_7[63 : 56];
  assign mulFeatureWeightData_7_2_7 = dSP_128_p[31 : 0];
  assign mulFeatureWeightData_7_3_7 = dSP_128_p[63 : 32];
  assign dSP_129_a = loadWeight_1_weightRead_8_data[7 : 0];
  assign dSP_129_d = loadWeight_1_weightRead_8_data[71 : 64];
  assign dSP_129_a1 = loadWeight_1_weightRead_8_data[135 : 128];
  assign dSP_129_d1 = loadWeight_1_weightRead_8_data[199 : 192];
  assign dSP_129_b = featureMemOutData_8[7 : 0];
  assign mulFeatureWeightData_8_0_0 = dSP_129_p[31 : 0];
  assign mulFeatureWeightData_8_1_0 = dSP_129_p[63 : 32];
  assign dSP_130_a = loadWeight_1_weightRead_8_data[15 : 8];
  assign dSP_130_d = loadWeight_1_weightRead_8_data[79 : 72];
  assign dSP_130_a1 = loadWeight_1_weightRead_8_data[143 : 136];
  assign dSP_130_d1 = loadWeight_1_weightRead_8_data[207 : 200];
  assign dSP_130_b = featureMemOutData_8[15 : 8];
  assign mulFeatureWeightData_8_0_1 = dSP_130_p[31 : 0];
  assign mulFeatureWeightData_8_1_1 = dSP_130_p[63 : 32];
  assign dSP_131_a = loadWeight_1_weightRead_8_data[23 : 16];
  assign dSP_131_d = loadWeight_1_weightRead_8_data[87 : 80];
  assign dSP_131_a1 = loadWeight_1_weightRead_8_data[151 : 144];
  assign dSP_131_d1 = loadWeight_1_weightRead_8_data[215 : 208];
  assign dSP_131_b = featureMemOutData_8[23 : 16];
  assign mulFeatureWeightData_8_0_2 = dSP_131_p[31 : 0];
  assign mulFeatureWeightData_8_1_2 = dSP_131_p[63 : 32];
  assign dSP_132_a = loadWeight_1_weightRead_8_data[31 : 24];
  assign dSP_132_d = loadWeight_1_weightRead_8_data[95 : 88];
  assign dSP_132_a1 = loadWeight_1_weightRead_8_data[159 : 152];
  assign dSP_132_d1 = loadWeight_1_weightRead_8_data[223 : 216];
  assign dSP_132_b = featureMemOutData_8[31 : 24];
  assign mulFeatureWeightData_8_0_3 = dSP_132_p[31 : 0];
  assign mulFeatureWeightData_8_1_3 = dSP_132_p[63 : 32];
  assign dSP_133_a = loadWeight_1_weightRead_8_data[39 : 32];
  assign dSP_133_d = loadWeight_1_weightRead_8_data[103 : 96];
  assign dSP_133_a1 = loadWeight_1_weightRead_8_data[167 : 160];
  assign dSP_133_d1 = loadWeight_1_weightRead_8_data[231 : 224];
  assign dSP_133_b = featureMemOutData_8[39 : 32];
  assign mulFeatureWeightData_8_0_4 = dSP_133_p[31 : 0];
  assign mulFeatureWeightData_8_1_4 = dSP_133_p[63 : 32];
  assign dSP_134_a = loadWeight_1_weightRead_8_data[47 : 40];
  assign dSP_134_d = loadWeight_1_weightRead_8_data[111 : 104];
  assign dSP_134_a1 = loadWeight_1_weightRead_8_data[175 : 168];
  assign dSP_134_d1 = loadWeight_1_weightRead_8_data[239 : 232];
  assign dSP_134_b = featureMemOutData_8[47 : 40];
  assign mulFeatureWeightData_8_0_5 = dSP_134_p[31 : 0];
  assign mulFeatureWeightData_8_1_5 = dSP_134_p[63 : 32];
  assign dSP_135_a = loadWeight_1_weightRead_8_data[55 : 48];
  assign dSP_135_d = loadWeight_1_weightRead_8_data[119 : 112];
  assign dSP_135_a1 = loadWeight_1_weightRead_8_data[183 : 176];
  assign dSP_135_d1 = loadWeight_1_weightRead_8_data[247 : 240];
  assign dSP_135_b = featureMemOutData_8[55 : 48];
  assign mulFeatureWeightData_8_0_6 = dSP_135_p[31 : 0];
  assign mulFeatureWeightData_8_1_6 = dSP_135_p[63 : 32];
  assign dSP_136_a = loadWeight_1_weightRead_8_data[63 : 56];
  assign dSP_136_d = loadWeight_1_weightRead_8_data[127 : 120];
  assign dSP_136_a1 = loadWeight_1_weightRead_8_data[191 : 184];
  assign dSP_136_d1 = loadWeight_1_weightRead_8_data[255 : 248];
  assign dSP_136_b = featureMemOutData_8[63 : 56];
  assign mulFeatureWeightData_8_0_7 = dSP_136_p[31 : 0];
  assign mulFeatureWeightData_8_1_7 = dSP_136_p[63 : 32];
  assign dSP_137_a = loadWeight_1_weightRead_8_data[263 : 256];
  assign dSP_137_d = loadWeight_1_weightRead_8_data[327 : 320];
  assign dSP_137_a1 = loadWeight_1_weightRead_8_data[391 : 384];
  assign dSP_137_d1 = loadWeight_1_weightRead_8_data[455 : 448];
  assign dSP_137_b = featureMemOutData_8[7 : 0];
  assign mulFeatureWeightData_8_2_0 = dSP_137_p[31 : 0];
  assign mulFeatureWeightData_8_3_0 = dSP_137_p[63 : 32];
  assign dSP_138_a = loadWeight_1_weightRead_8_data[271 : 264];
  assign dSP_138_d = loadWeight_1_weightRead_8_data[335 : 328];
  assign dSP_138_a1 = loadWeight_1_weightRead_8_data[399 : 392];
  assign dSP_138_d1 = loadWeight_1_weightRead_8_data[463 : 456];
  assign dSP_138_b = featureMemOutData_8[15 : 8];
  assign mulFeatureWeightData_8_2_1 = dSP_138_p[31 : 0];
  assign mulFeatureWeightData_8_3_1 = dSP_138_p[63 : 32];
  assign dSP_139_a = loadWeight_1_weightRead_8_data[279 : 272];
  assign dSP_139_d = loadWeight_1_weightRead_8_data[343 : 336];
  assign dSP_139_a1 = loadWeight_1_weightRead_8_data[407 : 400];
  assign dSP_139_d1 = loadWeight_1_weightRead_8_data[471 : 464];
  assign dSP_139_b = featureMemOutData_8[23 : 16];
  assign mulFeatureWeightData_8_2_2 = dSP_139_p[31 : 0];
  assign mulFeatureWeightData_8_3_2 = dSP_139_p[63 : 32];
  assign dSP_140_a = loadWeight_1_weightRead_8_data[287 : 280];
  assign dSP_140_d = loadWeight_1_weightRead_8_data[351 : 344];
  assign dSP_140_a1 = loadWeight_1_weightRead_8_data[415 : 408];
  assign dSP_140_d1 = loadWeight_1_weightRead_8_data[479 : 472];
  assign dSP_140_b = featureMemOutData_8[31 : 24];
  assign mulFeatureWeightData_8_2_3 = dSP_140_p[31 : 0];
  assign mulFeatureWeightData_8_3_3 = dSP_140_p[63 : 32];
  assign dSP_141_a = loadWeight_1_weightRead_8_data[295 : 288];
  assign dSP_141_d = loadWeight_1_weightRead_8_data[359 : 352];
  assign dSP_141_a1 = loadWeight_1_weightRead_8_data[423 : 416];
  assign dSP_141_d1 = loadWeight_1_weightRead_8_data[487 : 480];
  assign dSP_141_b = featureMemOutData_8[39 : 32];
  assign mulFeatureWeightData_8_2_4 = dSP_141_p[31 : 0];
  assign mulFeatureWeightData_8_3_4 = dSP_141_p[63 : 32];
  assign dSP_142_a = loadWeight_1_weightRead_8_data[303 : 296];
  assign dSP_142_d = loadWeight_1_weightRead_8_data[367 : 360];
  assign dSP_142_a1 = loadWeight_1_weightRead_8_data[431 : 424];
  assign dSP_142_d1 = loadWeight_1_weightRead_8_data[495 : 488];
  assign dSP_142_b = featureMemOutData_8[47 : 40];
  assign mulFeatureWeightData_8_2_5 = dSP_142_p[31 : 0];
  assign mulFeatureWeightData_8_3_5 = dSP_142_p[63 : 32];
  assign dSP_143_a = loadWeight_1_weightRead_8_data[311 : 304];
  assign dSP_143_d = loadWeight_1_weightRead_8_data[375 : 368];
  assign dSP_143_a1 = loadWeight_1_weightRead_8_data[439 : 432];
  assign dSP_143_d1 = loadWeight_1_weightRead_8_data[503 : 496];
  assign dSP_143_b = featureMemOutData_8[55 : 48];
  assign mulFeatureWeightData_8_2_6 = dSP_143_p[31 : 0];
  assign mulFeatureWeightData_8_3_6 = dSP_143_p[63 : 32];
  assign dSP_144_a = loadWeight_1_weightRead_8_data[319 : 312];
  assign dSP_144_d = loadWeight_1_weightRead_8_data[383 : 376];
  assign dSP_144_a1 = loadWeight_1_weightRead_8_data[447 : 440];
  assign dSP_144_d1 = loadWeight_1_weightRead_8_data[511 : 504];
  assign dSP_144_b = featureMemOutData_8[63 : 56];
  assign mulFeatureWeightData_8_2_7 = dSP_144_p[31 : 0];
  assign mulFeatureWeightData_8_3_7 = dSP_144_p[63 : 32];
  assign addKernel_A_0 = mulFeatureWeightData_0_0_0;
  assign addKernel_A_1 = mulFeatureWeightData_1_0_0;
  assign addKernel_A_2 = mulFeatureWeightData_2_0_0;
  assign addKernel_A_3 = mulFeatureWeightData_3_0_0;
  assign addKernel_A_4 = mulFeatureWeightData_4_0_0;
  assign addKernel_A_5 = mulFeatureWeightData_5_0_0;
  assign addKernel_A_6 = mulFeatureWeightData_6_0_0;
  assign addKernel_A_7 = mulFeatureWeightData_7_0_0;
  assign addKernel_A_8 = mulFeatureWeightData_8_0_0;
  assign addKernelData_0_0 = addKernel_S;
  assign addKernel_1_A_0 = mulFeatureWeightData_0_0_1;
  assign addKernel_1_A_1 = mulFeatureWeightData_1_0_1;
  assign addKernel_1_A_2 = mulFeatureWeightData_2_0_1;
  assign addKernel_1_A_3 = mulFeatureWeightData_3_0_1;
  assign addKernel_1_A_4 = mulFeatureWeightData_4_0_1;
  assign addKernel_1_A_5 = mulFeatureWeightData_5_0_1;
  assign addKernel_1_A_6 = mulFeatureWeightData_6_0_1;
  assign addKernel_1_A_7 = mulFeatureWeightData_7_0_1;
  assign addKernel_1_A_8 = mulFeatureWeightData_8_0_1;
  assign addKernelData_0_1 = addKernel_1_S;
  assign addKernel_2_A_0 = mulFeatureWeightData_0_0_2;
  assign addKernel_2_A_1 = mulFeatureWeightData_1_0_2;
  assign addKernel_2_A_2 = mulFeatureWeightData_2_0_2;
  assign addKernel_2_A_3 = mulFeatureWeightData_3_0_2;
  assign addKernel_2_A_4 = mulFeatureWeightData_4_0_2;
  assign addKernel_2_A_5 = mulFeatureWeightData_5_0_2;
  assign addKernel_2_A_6 = mulFeatureWeightData_6_0_2;
  assign addKernel_2_A_7 = mulFeatureWeightData_7_0_2;
  assign addKernel_2_A_8 = mulFeatureWeightData_8_0_2;
  assign addKernelData_0_2 = addKernel_2_S;
  assign addKernel_3_A_0 = mulFeatureWeightData_0_0_3;
  assign addKernel_3_A_1 = mulFeatureWeightData_1_0_3;
  assign addKernel_3_A_2 = mulFeatureWeightData_2_0_3;
  assign addKernel_3_A_3 = mulFeatureWeightData_3_0_3;
  assign addKernel_3_A_4 = mulFeatureWeightData_4_0_3;
  assign addKernel_3_A_5 = mulFeatureWeightData_5_0_3;
  assign addKernel_3_A_6 = mulFeatureWeightData_6_0_3;
  assign addKernel_3_A_7 = mulFeatureWeightData_7_0_3;
  assign addKernel_3_A_8 = mulFeatureWeightData_8_0_3;
  assign addKernelData_0_3 = addKernel_3_S;
  assign addKernel_4_A_0 = mulFeatureWeightData_0_0_4;
  assign addKernel_4_A_1 = mulFeatureWeightData_1_0_4;
  assign addKernel_4_A_2 = mulFeatureWeightData_2_0_4;
  assign addKernel_4_A_3 = mulFeatureWeightData_3_0_4;
  assign addKernel_4_A_4 = mulFeatureWeightData_4_0_4;
  assign addKernel_4_A_5 = mulFeatureWeightData_5_0_4;
  assign addKernel_4_A_6 = mulFeatureWeightData_6_0_4;
  assign addKernel_4_A_7 = mulFeatureWeightData_7_0_4;
  assign addKernel_4_A_8 = mulFeatureWeightData_8_0_4;
  assign addKernelData_0_4 = addKernel_4_S;
  assign addKernel_5_A_0 = mulFeatureWeightData_0_0_5;
  assign addKernel_5_A_1 = mulFeatureWeightData_1_0_5;
  assign addKernel_5_A_2 = mulFeatureWeightData_2_0_5;
  assign addKernel_5_A_3 = mulFeatureWeightData_3_0_5;
  assign addKernel_5_A_4 = mulFeatureWeightData_4_0_5;
  assign addKernel_5_A_5 = mulFeatureWeightData_5_0_5;
  assign addKernel_5_A_6 = mulFeatureWeightData_6_0_5;
  assign addKernel_5_A_7 = mulFeatureWeightData_7_0_5;
  assign addKernel_5_A_8 = mulFeatureWeightData_8_0_5;
  assign addKernelData_0_5 = addKernel_5_S;
  assign addKernel_6_A_0 = mulFeatureWeightData_0_0_6;
  assign addKernel_6_A_1 = mulFeatureWeightData_1_0_6;
  assign addKernel_6_A_2 = mulFeatureWeightData_2_0_6;
  assign addKernel_6_A_3 = mulFeatureWeightData_3_0_6;
  assign addKernel_6_A_4 = mulFeatureWeightData_4_0_6;
  assign addKernel_6_A_5 = mulFeatureWeightData_5_0_6;
  assign addKernel_6_A_6 = mulFeatureWeightData_6_0_6;
  assign addKernel_6_A_7 = mulFeatureWeightData_7_0_6;
  assign addKernel_6_A_8 = mulFeatureWeightData_8_0_6;
  assign addKernelData_0_6 = addKernel_6_S;
  assign addKernel_7_A_0 = mulFeatureWeightData_0_0_7;
  assign addKernel_7_A_1 = mulFeatureWeightData_1_0_7;
  assign addKernel_7_A_2 = mulFeatureWeightData_2_0_7;
  assign addKernel_7_A_3 = mulFeatureWeightData_3_0_7;
  assign addKernel_7_A_4 = mulFeatureWeightData_4_0_7;
  assign addKernel_7_A_5 = mulFeatureWeightData_5_0_7;
  assign addKernel_7_A_6 = mulFeatureWeightData_6_0_7;
  assign addKernel_7_A_7 = mulFeatureWeightData_7_0_7;
  assign addKernel_7_A_8 = mulFeatureWeightData_8_0_7;
  assign addKernelData_0_7 = addKernel_7_S;
  assign addKernel_8_A_0 = mulFeatureWeightData_0_1_0;
  assign addKernel_8_A_1 = mulFeatureWeightData_1_1_0;
  assign addKernel_8_A_2 = mulFeatureWeightData_2_1_0;
  assign addKernel_8_A_3 = mulFeatureWeightData_3_1_0;
  assign addKernel_8_A_4 = mulFeatureWeightData_4_1_0;
  assign addKernel_8_A_5 = mulFeatureWeightData_5_1_0;
  assign addKernel_8_A_6 = mulFeatureWeightData_6_1_0;
  assign addKernel_8_A_7 = mulFeatureWeightData_7_1_0;
  assign addKernel_8_A_8 = mulFeatureWeightData_8_1_0;
  assign addKernelData_1_0 = addKernel_8_S;
  assign addKernel_9_A_0 = mulFeatureWeightData_0_1_1;
  assign addKernel_9_A_1 = mulFeatureWeightData_1_1_1;
  assign addKernel_9_A_2 = mulFeatureWeightData_2_1_1;
  assign addKernel_9_A_3 = mulFeatureWeightData_3_1_1;
  assign addKernel_9_A_4 = mulFeatureWeightData_4_1_1;
  assign addKernel_9_A_5 = mulFeatureWeightData_5_1_1;
  assign addKernel_9_A_6 = mulFeatureWeightData_6_1_1;
  assign addKernel_9_A_7 = mulFeatureWeightData_7_1_1;
  assign addKernel_9_A_8 = mulFeatureWeightData_8_1_1;
  assign addKernelData_1_1 = addKernel_9_S;
  assign addKernel_10_A_0 = mulFeatureWeightData_0_1_2;
  assign addKernel_10_A_1 = mulFeatureWeightData_1_1_2;
  assign addKernel_10_A_2 = mulFeatureWeightData_2_1_2;
  assign addKernel_10_A_3 = mulFeatureWeightData_3_1_2;
  assign addKernel_10_A_4 = mulFeatureWeightData_4_1_2;
  assign addKernel_10_A_5 = mulFeatureWeightData_5_1_2;
  assign addKernel_10_A_6 = mulFeatureWeightData_6_1_2;
  assign addKernel_10_A_7 = mulFeatureWeightData_7_1_2;
  assign addKernel_10_A_8 = mulFeatureWeightData_8_1_2;
  assign addKernelData_1_2 = addKernel_10_S;
  assign addKernel_11_A_0 = mulFeatureWeightData_0_1_3;
  assign addKernel_11_A_1 = mulFeatureWeightData_1_1_3;
  assign addKernel_11_A_2 = mulFeatureWeightData_2_1_3;
  assign addKernel_11_A_3 = mulFeatureWeightData_3_1_3;
  assign addKernel_11_A_4 = mulFeatureWeightData_4_1_3;
  assign addKernel_11_A_5 = mulFeatureWeightData_5_1_3;
  assign addKernel_11_A_6 = mulFeatureWeightData_6_1_3;
  assign addKernel_11_A_7 = mulFeatureWeightData_7_1_3;
  assign addKernel_11_A_8 = mulFeatureWeightData_8_1_3;
  assign addKernelData_1_3 = addKernel_11_S;
  assign addKernel_12_A_0 = mulFeatureWeightData_0_1_4;
  assign addKernel_12_A_1 = mulFeatureWeightData_1_1_4;
  assign addKernel_12_A_2 = mulFeatureWeightData_2_1_4;
  assign addKernel_12_A_3 = mulFeatureWeightData_3_1_4;
  assign addKernel_12_A_4 = mulFeatureWeightData_4_1_4;
  assign addKernel_12_A_5 = mulFeatureWeightData_5_1_4;
  assign addKernel_12_A_6 = mulFeatureWeightData_6_1_4;
  assign addKernel_12_A_7 = mulFeatureWeightData_7_1_4;
  assign addKernel_12_A_8 = mulFeatureWeightData_8_1_4;
  assign addKernelData_1_4 = addKernel_12_S;
  assign addKernel_13_A_0 = mulFeatureWeightData_0_1_5;
  assign addKernel_13_A_1 = mulFeatureWeightData_1_1_5;
  assign addKernel_13_A_2 = mulFeatureWeightData_2_1_5;
  assign addKernel_13_A_3 = mulFeatureWeightData_3_1_5;
  assign addKernel_13_A_4 = mulFeatureWeightData_4_1_5;
  assign addKernel_13_A_5 = mulFeatureWeightData_5_1_5;
  assign addKernel_13_A_6 = mulFeatureWeightData_6_1_5;
  assign addKernel_13_A_7 = mulFeatureWeightData_7_1_5;
  assign addKernel_13_A_8 = mulFeatureWeightData_8_1_5;
  assign addKernelData_1_5 = addKernel_13_S;
  assign addKernel_14_A_0 = mulFeatureWeightData_0_1_6;
  assign addKernel_14_A_1 = mulFeatureWeightData_1_1_6;
  assign addKernel_14_A_2 = mulFeatureWeightData_2_1_6;
  assign addKernel_14_A_3 = mulFeatureWeightData_3_1_6;
  assign addKernel_14_A_4 = mulFeatureWeightData_4_1_6;
  assign addKernel_14_A_5 = mulFeatureWeightData_5_1_6;
  assign addKernel_14_A_6 = mulFeatureWeightData_6_1_6;
  assign addKernel_14_A_7 = mulFeatureWeightData_7_1_6;
  assign addKernel_14_A_8 = mulFeatureWeightData_8_1_6;
  assign addKernelData_1_6 = addKernel_14_S;
  assign addKernel_15_A_0 = mulFeatureWeightData_0_1_7;
  assign addKernel_15_A_1 = mulFeatureWeightData_1_1_7;
  assign addKernel_15_A_2 = mulFeatureWeightData_2_1_7;
  assign addKernel_15_A_3 = mulFeatureWeightData_3_1_7;
  assign addKernel_15_A_4 = mulFeatureWeightData_4_1_7;
  assign addKernel_15_A_5 = mulFeatureWeightData_5_1_7;
  assign addKernel_15_A_6 = mulFeatureWeightData_6_1_7;
  assign addKernel_15_A_7 = mulFeatureWeightData_7_1_7;
  assign addKernel_15_A_8 = mulFeatureWeightData_8_1_7;
  assign addKernelData_1_7 = addKernel_15_S;
  assign addKernel_16_A_0 = mulFeatureWeightData_0_2_0;
  assign addKernel_16_A_1 = mulFeatureWeightData_1_2_0;
  assign addKernel_16_A_2 = mulFeatureWeightData_2_2_0;
  assign addKernel_16_A_3 = mulFeatureWeightData_3_2_0;
  assign addKernel_16_A_4 = mulFeatureWeightData_4_2_0;
  assign addKernel_16_A_5 = mulFeatureWeightData_5_2_0;
  assign addKernel_16_A_6 = mulFeatureWeightData_6_2_0;
  assign addKernel_16_A_7 = mulFeatureWeightData_7_2_0;
  assign addKernel_16_A_8 = mulFeatureWeightData_8_2_0;
  assign addKernelData_2_0 = addKernel_16_S;
  assign addKernel_17_A_0 = mulFeatureWeightData_0_2_1;
  assign addKernel_17_A_1 = mulFeatureWeightData_1_2_1;
  assign addKernel_17_A_2 = mulFeatureWeightData_2_2_1;
  assign addKernel_17_A_3 = mulFeatureWeightData_3_2_1;
  assign addKernel_17_A_4 = mulFeatureWeightData_4_2_1;
  assign addKernel_17_A_5 = mulFeatureWeightData_5_2_1;
  assign addKernel_17_A_6 = mulFeatureWeightData_6_2_1;
  assign addKernel_17_A_7 = mulFeatureWeightData_7_2_1;
  assign addKernel_17_A_8 = mulFeatureWeightData_8_2_1;
  assign addKernelData_2_1 = addKernel_17_S;
  assign addKernel_18_A_0 = mulFeatureWeightData_0_2_2;
  assign addKernel_18_A_1 = mulFeatureWeightData_1_2_2;
  assign addKernel_18_A_2 = mulFeatureWeightData_2_2_2;
  assign addKernel_18_A_3 = mulFeatureWeightData_3_2_2;
  assign addKernel_18_A_4 = mulFeatureWeightData_4_2_2;
  assign addKernel_18_A_5 = mulFeatureWeightData_5_2_2;
  assign addKernel_18_A_6 = mulFeatureWeightData_6_2_2;
  assign addKernel_18_A_7 = mulFeatureWeightData_7_2_2;
  assign addKernel_18_A_8 = mulFeatureWeightData_8_2_2;
  assign addKernelData_2_2 = addKernel_18_S;
  assign addKernel_19_A_0 = mulFeatureWeightData_0_2_3;
  assign addKernel_19_A_1 = mulFeatureWeightData_1_2_3;
  assign addKernel_19_A_2 = mulFeatureWeightData_2_2_3;
  assign addKernel_19_A_3 = mulFeatureWeightData_3_2_3;
  assign addKernel_19_A_4 = mulFeatureWeightData_4_2_3;
  assign addKernel_19_A_5 = mulFeatureWeightData_5_2_3;
  assign addKernel_19_A_6 = mulFeatureWeightData_6_2_3;
  assign addKernel_19_A_7 = mulFeatureWeightData_7_2_3;
  assign addKernel_19_A_8 = mulFeatureWeightData_8_2_3;
  assign addKernelData_2_3 = addKernel_19_S;
  assign addKernel_20_A_0 = mulFeatureWeightData_0_2_4;
  assign addKernel_20_A_1 = mulFeatureWeightData_1_2_4;
  assign addKernel_20_A_2 = mulFeatureWeightData_2_2_4;
  assign addKernel_20_A_3 = mulFeatureWeightData_3_2_4;
  assign addKernel_20_A_4 = mulFeatureWeightData_4_2_4;
  assign addKernel_20_A_5 = mulFeatureWeightData_5_2_4;
  assign addKernel_20_A_6 = mulFeatureWeightData_6_2_4;
  assign addKernel_20_A_7 = mulFeatureWeightData_7_2_4;
  assign addKernel_20_A_8 = mulFeatureWeightData_8_2_4;
  assign addKernelData_2_4 = addKernel_20_S;
  assign addKernel_21_A_0 = mulFeatureWeightData_0_2_5;
  assign addKernel_21_A_1 = mulFeatureWeightData_1_2_5;
  assign addKernel_21_A_2 = mulFeatureWeightData_2_2_5;
  assign addKernel_21_A_3 = mulFeatureWeightData_3_2_5;
  assign addKernel_21_A_4 = mulFeatureWeightData_4_2_5;
  assign addKernel_21_A_5 = mulFeatureWeightData_5_2_5;
  assign addKernel_21_A_6 = mulFeatureWeightData_6_2_5;
  assign addKernel_21_A_7 = mulFeatureWeightData_7_2_5;
  assign addKernel_21_A_8 = mulFeatureWeightData_8_2_5;
  assign addKernelData_2_5 = addKernel_21_S;
  assign addKernel_22_A_0 = mulFeatureWeightData_0_2_6;
  assign addKernel_22_A_1 = mulFeatureWeightData_1_2_6;
  assign addKernel_22_A_2 = mulFeatureWeightData_2_2_6;
  assign addKernel_22_A_3 = mulFeatureWeightData_3_2_6;
  assign addKernel_22_A_4 = mulFeatureWeightData_4_2_6;
  assign addKernel_22_A_5 = mulFeatureWeightData_5_2_6;
  assign addKernel_22_A_6 = mulFeatureWeightData_6_2_6;
  assign addKernel_22_A_7 = mulFeatureWeightData_7_2_6;
  assign addKernel_22_A_8 = mulFeatureWeightData_8_2_6;
  assign addKernelData_2_6 = addKernel_22_S;
  assign addKernel_23_A_0 = mulFeatureWeightData_0_2_7;
  assign addKernel_23_A_1 = mulFeatureWeightData_1_2_7;
  assign addKernel_23_A_2 = mulFeatureWeightData_2_2_7;
  assign addKernel_23_A_3 = mulFeatureWeightData_3_2_7;
  assign addKernel_23_A_4 = mulFeatureWeightData_4_2_7;
  assign addKernel_23_A_5 = mulFeatureWeightData_5_2_7;
  assign addKernel_23_A_6 = mulFeatureWeightData_6_2_7;
  assign addKernel_23_A_7 = mulFeatureWeightData_7_2_7;
  assign addKernel_23_A_8 = mulFeatureWeightData_8_2_7;
  assign addKernelData_2_7 = addKernel_23_S;
  assign addKernel_24_A_0 = mulFeatureWeightData_0_3_0;
  assign addKernel_24_A_1 = mulFeatureWeightData_1_3_0;
  assign addKernel_24_A_2 = mulFeatureWeightData_2_3_0;
  assign addKernel_24_A_3 = mulFeatureWeightData_3_3_0;
  assign addKernel_24_A_4 = mulFeatureWeightData_4_3_0;
  assign addKernel_24_A_5 = mulFeatureWeightData_5_3_0;
  assign addKernel_24_A_6 = mulFeatureWeightData_6_3_0;
  assign addKernel_24_A_7 = mulFeatureWeightData_7_3_0;
  assign addKernel_24_A_8 = mulFeatureWeightData_8_3_0;
  assign addKernelData_3_0 = addKernel_24_S;
  assign addKernel_25_A_0 = mulFeatureWeightData_0_3_1;
  assign addKernel_25_A_1 = mulFeatureWeightData_1_3_1;
  assign addKernel_25_A_2 = mulFeatureWeightData_2_3_1;
  assign addKernel_25_A_3 = mulFeatureWeightData_3_3_1;
  assign addKernel_25_A_4 = mulFeatureWeightData_4_3_1;
  assign addKernel_25_A_5 = mulFeatureWeightData_5_3_1;
  assign addKernel_25_A_6 = mulFeatureWeightData_6_3_1;
  assign addKernel_25_A_7 = mulFeatureWeightData_7_3_1;
  assign addKernel_25_A_8 = mulFeatureWeightData_8_3_1;
  assign addKernelData_3_1 = addKernel_25_S;
  assign addKernel_26_A_0 = mulFeatureWeightData_0_3_2;
  assign addKernel_26_A_1 = mulFeatureWeightData_1_3_2;
  assign addKernel_26_A_2 = mulFeatureWeightData_2_3_2;
  assign addKernel_26_A_3 = mulFeatureWeightData_3_3_2;
  assign addKernel_26_A_4 = mulFeatureWeightData_4_3_2;
  assign addKernel_26_A_5 = mulFeatureWeightData_5_3_2;
  assign addKernel_26_A_6 = mulFeatureWeightData_6_3_2;
  assign addKernel_26_A_7 = mulFeatureWeightData_7_3_2;
  assign addKernel_26_A_8 = mulFeatureWeightData_8_3_2;
  assign addKernelData_3_2 = addKernel_26_S;
  assign addKernel_27_A_0 = mulFeatureWeightData_0_3_3;
  assign addKernel_27_A_1 = mulFeatureWeightData_1_3_3;
  assign addKernel_27_A_2 = mulFeatureWeightData_2_3_3;
  assign addKernel_27_A_3 = mulFeatureWeightData_3_3_3;
  assign addKernel_27_A_4 = mulFeatureWeightData_4_3_3;
  assign addKernel_27_A_5 = mulFeatureWeightData_5_3_3;
  assign addKernel_27_A_6 = mulFeatureWeightData_6_3_3;
  assign addKernel_27_A_7 = mulFeatureWeightData_7_3_3;
  assign addKernel_27_A_8 = mulFeatureWeightData_8_3_3;
  assign addKernelData_3_3 = addKernel_27_S;
  assign addKernel_28_A_0 = mulFeatureWeightData_0_3_4;
  assign addKernel_28_A_1 = mulFeatureWeightData_1_3_4;
  assign addKernel_28_A_2 = mulFeatureWeightData_2_3_4;
  assign addKernel_28_A_3 = mulFeatureWeightData_3_3_4;
  assign addKernel_28_A_4 = mulFeatureWeightData_4_3_4;
  assign addKernel_28_A_5 = mulFeatureWeightData_5_3_4;
  assign addKernel_28_A_6 = mulFeatureWeightData_6_3_4;
  assign addKernel_28_A_7 = mulFeatureWeightData_7_3_4;
  assign addKernel_28_A_8 = mulFeatureWeightData_8_3_4;
  assign addKernelData_3_4 = addKernel_28_S;
  assign addKernel_29_A_0 = mulFeatureWeightData_0_3_5;
  assign addKernel_29_A_1 = mulFeatureWeightData_1_3_5;
  assign addKernel_29_A_2 = mulFeatureWeightData_2_3_5;
  assign addKernel_29_A_3 = mulFeatureWeightData_3_3_5;
  assign addKernel_29_A_4 = mulFeatureWeightData_4_3_5;
  assign addKernel_29_A_5 = mulFeatureWeightData_5_3_5;
  assign addKernel_29_A_6 = mulFeatureWeightData_6_3_5;
  assign addKernel_29_A_7 = mulFeatureWeightData_7_3_5;
  assign addKernel_29_A_8 = mulFeatureWeightData_8_3_5;
  assign addKernelData_3_5 = addKernel_29_S;
  assign addKernel_30_A_0 = mulFeatureWeightData_0_3_6;
  assign addKernel_30_A_1 = mulFeatureWeightData_1_3_6;
  assign addKernel_30_A_2 = mulFeatureWeightData_2_3_6;
  assign addKernel_30_A_3 = mulFeatureWeightData_3_3_6;
  assign addKernel_30_A_4 = mulFeatureWeightData_4_3_6;
  assign addKernel_30_A_5 = mulFeatureWeightData_5_3_6;
  assign addKernel_30_A_6 = mulFeatureWeightData_6_3_6;
  assign addKernel_30_A_7 = mulFeatureWeightData_7_3_6;
  assign addKernel_30_A_8 = mulFeatureWeightData_8_3_6;
  assign addKernelData_3_6 = addKernel_30_S;
  assign addKernel_31_A_0 = mulFeatureWeightData_0_3_7;
  assign addKernel_31_A_1 = mulFeatureWeightData_1_3_7;
  assign addKernel_31_A_2 = mulFeatureWeightData_2_3_7;
  assign addKernel_31_A_3 = mulFeatureWeightData_3_3_7;
  assign addKernel_31_A_4 = mulFeatureWeightData_4_3_7;
  assign addKernel_31_A_5 = mulFeatureWeightData_5_3_7;
  assign addKernel_31_A_6 = mulFeatureWeightData_6_3_7;
  assign addKernel_31_A_7 = mulFeatureWeightData_7_3_7;
  assign addKernel_31_A_8 = mulFeatureWeightData_8_3_7;
  assign addKernelData_3_7 = addKernel_31_S;
  assign addChannelData_0 = xAddTimes_36_S;
  assign addChannelData_1 = xAddTimes_37_S;
  assign addChannelData_2 = xAddTimes_38_S;
  assign addChannelData_3 = xAddTimes_39_S;
  assign xAddChannelTimes_8_A = addChannelData_0[22 : 0];
  assign addChannelTimesData_0 = xAddChannelTimes_8_S;
  assign xAddChannelTimes_9_A = addChannelData_0[45 : 23];
  assign addChannelTimesData_1 = xAddChannelTimes_9_S;
  assign xAddChannelTimes_10_A = addChannelData_1[22 : 0];
  assign addChannelTimesData_2 = xAddChannelTimes_10_S;
  assign xAddChannelTimes_11_A = addChannelData_1[45 : 23];
  assign addChannelTimesData_3 = xAddChannelTimes_11_S;
  assign xAddChannelTimes_12_A = addChannelData_2[22 : 0];
  assign addChannelTimesData_4 = xAddChannelTimes_12_S;
  assign xAddChannelTimes_13_A = addChannelData_2[45 : 23];
  assign addChannelTimesData_5 = xAddChannelTimes_13_S;
  assign xAddChannelTimes_14_A = addChannelData_3[22 : 0];
  assign addChannelTimesData_6 = xAddChannelTimes_14_S;
  assign xAddChannelTimes_15_A = addChannelData_3[45 : 23];
  assign addChannelTimesData_7 = xAddChannelTimes_15_S;
  assign mNormData_valid = computeCtrl_normValid;
  assign mNormData_payload_0 = addChannelTimesData_0;
  assign mNormData_payload_1 = addChannelTimesData_1;
  assign mNormData_payload_2 = addChannelTimesData_2;
  assign mNormData_payload_3 = addChannelTimesData_3;
  assign mNormData_payload_4 = addChannelTimesData_4;
  assign mNormData_payload_5 = addChannelTimesData_5;
  assign mNormData_payload_6 = addChannelTimesData_6;
  assign mNormData_payload_7 = addChannelTimesData_7;
  assign mFeatureData_valid = stride_1_mData_valid;
  assign mFeatureData_payload = stride_1_mData_payload;
  assign computeComplete = stride_1_complete;
  always @(posedge clk) begin
    if(startPa) begin
      convType_1 <= convType;
    end
  end


endmodule

module ConvState (
  input      [3:0]    control,
  input      [3:0]    complete,
  output reg [3:0]    state,
  output reg [3:0]    sign,
  output reg          dmaReadValid,
  output reg          dmaWriteValid,
  input               clk,
  input               reset
);
  localparam ConvStateEnum_IDLE = 5'd1;
  localparam ConvStateEnum_PARA = 5'd2;
  localparam ConvStateEnum_PARA_IRQ = 5'd4;
  localparam ConvStateEnum_COMPUTE = 5'd8;
  localparam ConvStateEnum_COMPUTE_IRQ = 5'd16;

  reg        [4:0]    fsm_currentState;
  reg        [4:0]    fsm_nextState;
  wire                when_ConvState_l56;
  wire                when_ConvState_l58;
  wire                when_ConvState_l65;
  wire                when_ConvState_l72;
  wire                when_ConvState_l79;
  wire                when_ConvState_l86;
  wire                when_ConvState_l128;
  wire                when_ConvState_l132;
  `ifndef SYNTHESIS
  reg [87:0] fsm_currentState_string;
  reg [87:0] fsm_nextState_string;
  `endif


  `ifndef SYNTHESIS
  always @(*) begin
    case(fsm_currentState)
      ConvStateEnum_IDLE : fsm_currentState_string = "IDLE       ";
      ConvStateEnum_PARA : fsm_currentState_string = "PARA       ";
      ConvStateEnum_PARA_IRQ : fsm_currentState_string = "PARA_IRQ   ";
      ConvStateEnum_COMPUTE : fsm_currentState_string = "COMPUTE    ";
      ConvStateEnum_COMPUTE_IRQ : fsm_currentState_string = "COMPUTE_IRQ";
      default : fsm_currentState_string = "???????????";
    endcase
  end
  always @(*) begin
    case(fsm_nextState)
      ConvStateEnum_IDLE : fsm_nextState_string = "IDLE       ";
      ConvStateEnum_PARA : fsm_nextState_string = "PARA       ";
      ConvStateEnum_PARA_IRQ : fsm_nextState_string = "PARA_IRQ   ";
      ConvStateEnum_COMPUTE : fsm_nextState_string = "COMPUTE    ";
      ConvStateEnum_COMPUTE_IRQ : fsm_nextState_string = "COMPUTE_IRQ";
      default : fsm_nextState_string = "???????????";
    endcase
  end
  `endif

  assign when_ConvState_l56 = (control == 4'b0001);
  always @(*) begin
    (* parallel_case *)
    case(1) // synthesis parallel_case
      (((fsm_currentState) & ConvStateEnum_IDLE) == ConvStateEnum_IDLE) : begin
        if(when_ConvState_l56) begin
          fsm_nextState = ConvStateEnum_PARA;
        end else begin
          if(when_ConvState_l58) begin
            fsm_nextState = ConvStateEnum_COMPUTE;
          end else begin
            fsm_nextState = ConvStateEnum_IDLE;
          end
        end
      end
      (((fsm_currentState) & ConvStateEnum_PARA) == ConvStateEnum_PARA) : begin
        if(when_ConvState_l65) begin
          fsm_nextState = ConvStateEnum_PARA_IRQ;
        end else begin
          fsm_nextState = ConvStateEnum_PARA;
        end
      end
      (((fsm_currentState) & ConvStateEnum_PARA_IRQ) == ConvStateEnum_PARA_IRQ) : begin
        if(when_ConvState_l72) begin
          fsm_nextState = ConvStateEnum_IDLE;
        end else begin
          fsm_nextState = ConvStateEnum_PARA_IRQ;
        end
      end
      (((fsm_currentState) & ConvStateEnum_COMPUTE) == ConvStateEnum_COMPUTE) : begin
        if(when_ConvState_l79) begin
          fsm_nextState = ConvStateEnum_COMPUTE_IRQ;
        end else begin
          fsm_nextState = ConvStateEnum_COMPUTE;
        end
      end
      default : begin
        if(when_ConvState_l86) begin
          fsm_nextState = ConvStateEnum_IDLE;
        end else begin
          fsm_nextState = ConvStateEnum_COMPUTE_IRQ;
        end
      end
    endcase
  end

  assign when_ConvState_l58 = (control == 4'b0010);
  assign when_ConvState_l65 = (complete == 4'b0001);
  assign when_ConvState_l72 = (control == 4'b1111);
  assign when_ConvState_l79 = (complete == 4'b0010);
  assign when_ConvState_l86 = (control == 4'b1111);
  assign when_ConvState_l128 = (((fsm_currentState & ConvStateEnum_IDLE) != 5'b00000) && ((fsm_nextState & ConvStateEnum_PARA) != 5'b00000));
  always @(*) begin
    if(when_ConvState_l128) begin
      dmaReadValid = 1'b1;
    end else begin
      if(when_ConvState_l132) begin
        dmaReadValid = 1'b1;
      end else begin
        dmaReadValid = 1'b0;
      end
    end
  end

  always @(*) begin
    if(when_ConvState_l128) begin
      dmaWriteValid = 1'b0;
    end else begin
      if(when_ConvState_l132) begin
        dmaWriteValid = 1'b1;
      end else begin
        dmaWriteValid = 1'b0;
      end
    end
  end

  assign when_ConvState_l132 = (((fsm_currentState & ConvStateEnum_IDLE) != 5'b00000) && ((fsm_nextState & ConvStateEnum_COMPUTE) != 5'b00000));
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      fsm_currentState <= ConvStateEnum_IDLE;
    end else begin
      fsm_currentState <= fsm_nextState;
    end
  end

  always @(posedge clk) begin
    (* parallel_case *)
    case(1) // synthesis parallel_case
      (((fsm_currentState) & ConvStateEnum_IDLE) == ConvStateEnum_IDLE) : begin
        state <= 4'b0000;
      end
      (((fsm_currentState) & ConvStateEnum_PARA) == ConvStateEnum_PARA) : begin
        state <= 4'b0001;
      end
      (((fsm_currentState) & ConvStateEnum_COMPUTE) == ConvStateEnum_COMPUTE) : begin
        state <= 4'b0010;
      end
      (((fsm_currentState) & ConvStateEnum_COMPUTE_IRQ) == ConvStateEnum_COMPUTE_IRQ) : begin
        state <= 4'b1111;
      end
      default : begin
        state <= 4'b1111;
      end
    endcase
    if(when_ConvState_l128) begin
      sign <= 4'b0001;
    end else begin
      if(when_ConvState_l132) begin
        sign <= 4'b0010;
      end else begin
        sign <= 4'b0000;
      end
    end
  end


endmodule

module StreamFifo_2 (
  input               io_push_valid,
  output              io_push_ready,
  input      [63:0]   io_push_payload,
  output              io_pop_valid,
  input               io_pop_ready,
  output     [63:0]   io_pop_payload,
  input               io_flush,
  output     [6:0]    io_occupancy,
  output     [6:0]    io_availability,
  input               clk,
  input               reset
);

  reg        [63:0]   _zz_logic_ram_port0;
  wire       [5:0]    _zz_logic_pushPtr_valueNext;
  wire       [0:0]    _zz_logic_pushPtr_valueNext_1;
  wire       [5:0]    _zz_logic_popPtr_valueNext;
  wire       [0:0]    _zz_logic_popPtr_valueNext_1;
  wire                _zz_logic_ram_port;
  wire                _zz_io_pop_payload;
  wire       [63:0]   _zz_logic_ram_port_1;
  wire       [5:0]    _zz_io_availability;
  reg                 _zz_1;
  reg                 logic_pushPtr_willIncrement;
  reg                 logic_pushPtr_willClear;
  reg        [5:0]    logic_pushPtr_valueNext;
  reg        [5:0]    logic_pushPtr_value;
  wire                logic_pushPtr_willOverflowIfInc;
  wire                logic_pushPtr_willOverflow;
  reg                 logic_popPtr_willIncrement;
  reg                 logic_popPtr_willClear;
  reg        [5:0]    logic_popPtr_valueNext;
  reg        [5:0]    logic_popPtr_value;
  wire                logic_popPtr_willOverflowIfInc;
  wire                logic_popPtr_willOverflow;
  wire                logic_ptrMatch;
  reg                 logic_risingOccupancy;
  wire                logic_pushing;
  wire                logic_popping;
  wire                logic_empty;
  wire                logic_full;
  reg                 _zz_io_pop_valid;
  wire                when_Stream_l1021;
  wire       [5:0]    logic_ptrDif;
  reg [63:0] logic_ram [0:63];

  assign _zz_logic_pushPtr_valueNext_1 = logic_pushPtr_willIncrement;
  assign _zz_logic_pushPtr_valueNext = {5'd0, _zz_logic_pushPtr_valueNext_1};
  assign _zz_logic_popPtr_valueNext_1 = logic_popPtr_willIncrement;
  assign _zz_logic_popPtr_valueNext = {5'd0, _zz_logic_popPtr_valueNext_1};
  assign _zz_io_availability = (logic_popPtr_value - logic_pushPtr_value);
  assign _zz_io_pop_payload = 1'b1;
  assign _zz_logic_ram_port_1 = io_push_payload;
  always @(posedge clk) begin
    if(_zz_io_pop_payload) begin
      _zz_logic_ram_port0 <= logic_ram[logic_popPtr_valueNext];
    end
  end

  always @(posedge clk) begin
    if(_zz_1) begin
      logic_ram[logic_pushPtr_value] <= _zz_logic_ram_port_1;
    end
  end

  always @(*) begin
    _zz_1 = 1'b0;
    if(logic_pushing) begin
      _zz_1 = 1'b1;
    end
  end

  always @(*) begin
    logic_pushPtr_willIncrement = 1'b0;
    if(logic_pushing) begin
      logic_pushPtr_willIncrement = 1'b1;
    end
  end

  always @(*) begin
    logic_pushPtr_willClear = 1'b0;
    if(io_flush) begin
      logic_pushPtr_willClear = 1'b1;
    end
  end

  assign logic_pushPtr_willOverflowIfInc = (logic_pushPtr_value == 6'h3f);
  assign logic_pushPtr_willOverflow = (logic_pushPtr_willOverflowIfInc && logic_pushPtr_willIncrement);
  always @(*) begin
    logic_pushPtr_valueNext = (logic_pushPtr_value + _zz_logic_pushPtr_valueNext);
    if(logic_pushPtr_willClear) begin
      logic_pushPtr_valueNext = 6'h0;
    end
  end

  always @(*) begin
    logic_popPtr_willIncrement = 1'b0;
    if(logic_popping) begin
      logic_popPtr_willIncrement = 1'b1;
    end
  end

  always @(*) begin
    logic_popPtr_willClear = 1'b0;
    if(io_flush) begin
      logic_popPtr_willClear = 1'b1;
    end
  end

  assign logic_popPtr_willOverflowIfInc = (logic_popPtr_value == 6'h3f);
  assign logic_popPtr_willOverflow = (logic_popPtr_willOverflowIfInc && logic_popPtr_willIncrement);
  always @(*) begin
    logic_popPtr_valueNext = (logic_popPtr_value + _zz_logic_popPtr_valueNext);
    if(logic_popPtr_willClear) begin
      logic_popPtr_valueNext = 6'h0;
    end
  end

  assign logic_ptrMatch = (logic_pushPtr_value == logic_popPtr_value);
  assign logic_pushing = (io_push_valid && io_push_ready);
  assign logic_popping = (io_pop_valid && io_pop_ready);
  assign logic_empty = (logic_ptrMatch && (! logic_risingOccupancy));
  assign logic_full = (logic_ptrMatch && logic_risingOccupancy);
  assign io_push_ready = (! logic_full);
  assign io_pop_valid = ((! logic_empty) && (! (_zz_io_pop_valid && (! logic_full))));
  assign io_pop_payload = _zz_logic_ram_port0;
  assign when_Stream_l1021 = (logic_pushing != logic_popping);
  assign logic_ptrDif = (logic_pushPtr_value - logic_popPtr_value);
  assign io_occupancy = {(logic_risingOccupancy && logic_ptrMatch),logic_ptrDif};
  assign io_availability = {((! logic_risingOccupancy) && logic_ptrMatch),_zz_io_availability};
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      logic_pushPtr_value <= 6'h0;
      logic_popPtr_value <= 6'h0;
      logic_risingOccupancy <= 1'b0;
      _zz_io_pop_valid <= 1'b0;
    end else begin
      logic_pushPtr_value <= logic_pushPtr_valueNext;
      logic_popPtr_value <= logic_popPtr_valueNext;
      _zz_io_pop_valid <= (logic_popPtr_valueNext == logic_pushPtr_value);
      if(when_Stream_l1021) begin
        logic_risingOccupancy <= logic_pushing;
      end
      if(io_flush) begin
        logic_risingOccupancy <= 1'b0;
      end
    end
  end


endmodule

module StreamFifo_1 (
  input               io_push_valid,
  output              io_push_ready,
  input      [63:0]   io_push_payload,
  output              io_pop_valid,
  input               io_pop_ready,
  output     [63:0]   io_pop_payload,
  input               io_flush,
  output     [10:0]   io_occupancy,
  output     [10:0]   io_availability,
  input               clk,
  input               reset
);

  reg        [63:0]   _zz_logic_ram_port0;
  wire       [9:0]    _zz_logic_pushPtr_valueNext;
  wire       [0:0]    _zz_logic_pushPtr_valueNext_1;
  wire       [9:0]    _zz_logic_popPtr_valueNext;
  wire       [0:0]    _zz_logic_popPtr_valueNext_1;
  wire                _zz_logic_ram_port;
  wire                _zz_io_pop_payload;
  wire       [63:0]   _zz_logic_ram_port_1;
  wire       [9:0]    _zz_io_availability;
  reg                 _zz_1;
  reg                 logic_pushPtr_willIncrement;
  reg                 logic_pushPtr_willClear;
  reg        [9:0]    logic_pushPtr_valueNext;
  reg        [9:0]    logic_pushPtr_value;
  wire                logic_pushPtr_willOverflowIfInc;
  wire                logic_pushPtr_willOverflow;
  reg                 logic_popPtr_willIncrement;
  reg                 logic_popPtr_willClear;
  reg        [9:0]    logic_popPtr_valueNext;
  reg        [9:0]    logic_popPtr_value;
  wire                logic_popPtr_willOverflowIfInc;
  wire                logic_popPtr_willOverflow;
  wire                logic_ptrMatch;
  reg                 logic_risingOccupancy;
  wire                logic_pushing;
  wire                logic_popping;
  wire                logic_empty;
  wire                logic_full;
  reg                 _zz_io_pop_valid;
  wire                when_Stream_l1021;
  wire       [9:0]    logic_ptrDif;
  reg [63:0] logic_ram [0:1023];

  assign _zz_logic_pushPtr_valueNext_1 = logic_pushPtr_willIncrement;
  assign _zz_logic_pushPtr_valueNext = {9'd0, _zz_logic_pushPtr_valueNext_1};
  assign _zz_logic_popPtr_valueNext_1 = logic_popPtr_willIncrement;
  assign _zz_logic_popPtr_valueNext = {9'd0, _zz_logic_popPtr_valueNext_1};
  assign _zz_io_availability = (logic_popPtr_value - logic_pushPtr_value);
  assign _zz_io_pop_payload = 1'b1;
  assign _zz_logic_ram_port_1 = io_push_payload;
  always @(posedge clk) begin
    if(_zz_io_pop_payload) begin
      _zz_logic_ram_port0 <= logic_ram[logic_popPtr_valueNext];
    end
  end

  always @(posedge clk) begin
    if(_zz_1) begin
      logic_ram[logic_pushPtr_value] <= _zz_logic_ram_port_1;
    end
  end

  always @(*) begin
    _zz_1 = 1'b0;
    if(logic_pushing) begin
      _zz_1 = 1'b1;
    end
  end

  always @(*) begin
    logic_pushPtr_willIncrement = 1'b0;
    if(logic_pushing) begin
      logic_pushPtr_willIncrement = 1'b1;
    end
  end

  always @(*) begin
    logic_pushPtr_willClear = 1'b0;
    if(io_flush) begin
      logic_pushPtr_willClear = 1'b1;
    end
  end

  assign logic_pushPtr_willOverflowIfInc = (logic_pushPtr_value == 10'h3ff);
  assign logic_pushPtr_willOverflow = (logic_pushPtr_willOverflowIfInc && logic_pushPtr_willIncrement);
  always @(*) begin
    logic_pushPtr_valueNext = (logic_pushPtr_value + _zz_logic_pushPtr_valueNext);
    if(logic_pushPtr_willClear) begin
      logic_pushPtr_valueNext = 10'h0;
    end
  end

  always @(*) begin
    logic_popPtr_willIncrement = 1'b0;
    if(logic_popping) begin
      logic_popPtr_willIncrement = 1'b1;
    end
  end

  always @(*) begin
    logic_popPtr_willClear = 1'b0;
    if(io_flush) begin
      logic_popPtr_willClear = 1'b1;
    end
  end

  assign logic_popPtr_willOverflowIfInc = (logic_popPtr_value == 10'h3ff);
  assign logic_popPtr_willOverflow = (logic_popPtr_willOverflowIfInc && logic_popPtr_willIncrement);
  always @(*) begin
    logic_popPtr_valueNext = (logic_popPtr_value + _zz_logic_popPtr_valueNext);
    if(logic_popPtr_willClear) begin
      logic_popPtr_valueNext = 10'h0;
    end
  end

  assign logic_ptrMatch = (logic_pushPtr_value == logic_popPtr_value);
  assign logic_pushing = (io_push_valid && io_push_ready);
  assign logic_popping = (io_pop_valid && io_pop_ready);
  assign logic_empty = (logic_ptrMatch && (! logic_risingOccupancy));
  assign logic_full = (logic_ptrMatch && logic_risingOccupancy);
  assign io_push_ready = (! logic_full);
  assign io_pop_valid = ((! logic_empty) && (! (_zz_io_pop_valid && (! logic_full))));
  assign io_pop_payload = _zz_logic_ram_port0;
  assign when_Stream_l1021 = (logic_pushing != logic_popping);
  assign logic_ptrDif = (logic_pushPtr_value - logic_popPtr_value);
  assign io_occupancy = {(logic_risingOccupancy && logic_ptrMatch),logic_ptrDif};
  assign io_availability = {((! logic_risingOccupancy) && logic_ptrMatch),_zz_io_availability};
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      logic_pushPtr_value <= 10'h0;
      logic_popPtr_value <= 10'h0;
      logic_risingOccupancy <= 1'b0;
      _zz_io_pop_valid <= 1'b0;
    end else begin
      logic_pushPtr_value <= logic_pushPtr_valueNext;
      logic_popPtr_value <= logic_popPtr_valueNext;
      _zz_io_pop_valid <= (logic_popPtr_valueNext == logic_pushPtr_value);
      if(when_Stream_l1021) begin
        logic_risingOccupancy <= logic_pushing;
      end
      if(io_flush) begin
        logic_risingOccupancy <= 1'b0;
      end
    end
  end


endmodule

module ConcatScale (
  input      [31:0]   dataIn_0,
  input      [31:0]   dataIn_1,
  input      [31:0]   dataIn_2,
  input      [31:0]   dataIn_3,
  input      [31:0]   dataIn_4,
  input      [31:0]   dataIn_5,
  input      [31:0]   dataIn_6,
  input      [31:0]   dataIn_7,
  input      [31:0]   scale_1,
  output     [7:0]    dataOut_0,
  output     [7:0]    dataOut_1,
  output     [7:0]    dataOut_2,
  output     [7:0]    dataOut_3,
  output     [7:0]    dataOut_4,
  output     [7:0]    dataOut_5,
  output     [7:0]    dataOut_6,
  output     [7:0]    dataOut_7,
  input               clk,
  input               reset
);

  wire       [32:0]   mulScale_0_P;
  wire       [32:0]   mulScale_1_P;
  wire       [32:0]   mulScale_2_P;
  wire       [32:0]   mulScale_3_P;
  wire       [32:0]   mulScale_4_P;
  wire       [32:0]   mulScale_5_P;
  wire       [32:0]   mulScale_6_P;
  wire       [32:0]   mulScale_7_P;
  wire       [31:0]   _zz__zz_dataOut_0_1;
  wire       [31:0]   _zz__zz_dataOut_0_1_1;
  wire       [7:0]    _zz__zz_dataOut_0;
  wire       [31:0]   _zz_when_Concat_l134;
  wire       [31:0]   _zz__zz_dataOut_1_1;
  wire       [31:0]   _zz__zz_dataOut_1_1_1;
  wire       [7:0]    _zz__zz_dataOut_1;
  wire       [31:0]   _zz_when_Concat_l134_1;
  wire       [31:0]   _zz__zz_dataOut_2_1;
  wire       [31:0]   _zz__zz_dataOut_2_1_1;
  wire       [7:0]    _zz__zz_dataOut_2;
  wire       [31:0]   _zz_when_Concat_l134_2;
  wire       [31:0]   _zz__zz_dataOut_3_1;
  wire       [31:0]   _zz__zz_dataOut_3_1_1;
  wire       [7:0]    _zz__zz_dataOut_3;
  wire       [31:0]   _zz_when_Concat_l134_3;
  wire       [31:0]   _zz__zz_dataOut_4_1;
  wire       [31:0]   _zz__zz_dataOut_4_1_1;
  wire       [7:0]    _zz__zz_dataOut_4;
  wire       [31:0]   _zz_when_Concat_l134_4;
  wire       [31:0]   _zz__zz_dataOut_5_1;
  wire       [31:0]   _zz__zz_dataOut_5_1_1;
  wire       [7:0]    _zz__zz_dataOut_5;
  wire       [31:0]   _zz_when_Concat_l134_5;
  wire       [31:0]   _zz__zz_dataOut_6_1;
  wire       [31:0]   _zz__zz_dataOut_6_1_1;
  wire       [7:0]    _zz__zz_dataOut_6;
  wire       [31:0]   _zz_when_Concat_l134_6;
  wire       [31:0]   _zz__zz_dataOut_7_1;
  wire       [31:0]   _zz__zz_dataOut_7_1_1;
  wire       [7:0]    _zz__zz_dataOut_7;
  wire       [31:0]   _zz_when_Concat_l134_7;
  wire       [32:0]   mulDataOut_0;
  wire       [32:0]   mulDataOut_1;
  wire       [32:0]   mulDataOut_2;
  wire       [32:0]   mulDataOut_3;
  wire       [32:0]   mulDataOut_4;
  wire       [32:0]   mulDataOut_5;
  wire       [32:0]   mulDataOut_6;
  wire       [32:0]   mulDataOut_7;
  reg        [7:0]    _zz_dataOut_0;
  reg        [31:0]   _zz_dataOut_0_1;
  wire                when_Concat_l127;
  wire                when_Concat_l132;
  wire                when_Concat_l134;
  reg        [7:0]    _zz_dataOut_1;
  reg        [31:0]   _zz_dataOut_1_1;
  wire                when_Concat_l127_1;
  wire                when_Concat_l132_1;
  wire                when_Concat_l134_1;
  reg        [7:0]    _zz_dataOut_2;
  reg        [31:0]   _zz_dataOut_2_1;
  wire                when_Concat_l127_2;
  wire                when_Concat_l132_2;
  wire                when_Concat_l134_2;
  reg        [7:0]    _zz_dataOut_3;
  reg        [31:0]   _zz_dataOut_3_1;
  wire                when_Concat_l127_3;
  wire                when_Concat_l132_3;
  wire                when_Concat_l134_3;
  reg        [7:0]    _zz_dataOut_4;
  reg        [31:0]   _zz_dataOut_4_1;
  wire                when_Concat_l127_4;
  wire                when_Concat_l132_4;
  wire                when_Concat_l134_4;
  reg        [7:0]    _zz_dataOut_5;
  reg        [31:0]   _zz_dataOut_5_1;
  wire                when_Concat_l127_5;
  wire                when_Concat_l132_5;
  wire                when_Concat_l134_5;
  reg        [7:0]    _zz_dataOut_6;
  reg        [31:0]   _zz_dataOut_6_1;
  wire                when_Concat_l127_6;
  wire                when_Concat_l132_6;
  wire                when_Concat_l134_6;
  reg        [7:0]    _zz_dataOut_7;
  reg        [31:0]   _zz_dataOut_7_1;
  wire                when_Concat_l127_7;
  wire                when_Concat_l132_7;
  wire                when_Concat_l134_7;

  assign _zz__zz_dataOut_0_1 = mulDataOut_0[32 : 1];
  assign _zz__zz_dataOut_0_1_1 = 32'h00000001;
  assign _zz__zz_dataOut_0 = _zz_dataOut_0_1[7 : 0];
  assign _zz_when_Concat_l134 = 32'h000000ff;
  assign _zz__zz_dataOut_1_1 = mulDataOut_1[32 : 1];
  assign _zz__zz_dataOut_1_1_1 = 32'h00000001;
  assign _zz__zz_dataOut_1 = _zz_dataOut_1_1[7 : 0];
  assign _zz_when_Concat_l134_1 = 32'h000000ff;
  assign _zz__zz_dataOut_2_1 = mulDataOut_2[32 : 1];
  assign _zz__zz_dataOut_2_1_1 = 32'h00000001;
  assign _zz__zz_dataOut_2 = _zz_dataOut_2_1[7 : 0];
  assign _zz_when_Concat_l134_2 = 32'h000000ff;
  assign _zz__zz_dataOut_3_1 = mulDataOut_3[32 : 1];
  assign _zz__zz_dataOut_3_1_1 = 32'h00000001;
  assign _zz__zz_dataOut_3 = _zz_dataOut_3_1[7 : 0];
  assign _zz_when_Concat_l134_3 = 32'h000000ff;
  assign _zz__zz_dataOut_4_1 = mulDataOut_4[32 : 1];
  assign _zz__zz_dataOut_4_1_1 = 32'h00000001;
  assign _zz__zz_dataOut_4 = _zz_dataOut_4_1[7 : 0];
  assign _zz_when_Concat_l134_4 = 32'h000000ff;
  assign _zz__zz_dataOut_5_1 = mulDataOut_5[32 : 1];
  assign _zz__zz_dataOut_5_1_1 = 32'h00000001;
  assign _zz__zz_dataOut_5 = _zz_dataOut_5_1[7 : 0];
  assign _zz_when_Concat_l134_5 = 32'h000000ff;
  assign _zz__zz_dataOut_6_1 = mulDataOut_6[32 : 1];
  assign _zz__zz_dataOut_6_1_1 = 32'h00000001;
  assign _zz__zz_dataOut_6 = _zz_dataOut_6_1[7 : 0];
  assign _zz_when_Concat_l134_6 = 32'h000000ff;
  assign _zz__zz_dataOut_7_1 = mulDataOut_7[32 : 1];
  assign _zz__zz_dataOut_7_1_1 = 32'h00000001;
  assign _zz__zz_dataOut_7 = _zz_dataOut_7_1[7 : 0];
  assign _zz_when_Concat_l134_7 = 32'h000000ff;
  concatMul mulScale_0 (
    .A   (dataIn_0[31:0]    ), //i
    .B   (scale_1[31:0]     ), //i
    .P   (mulScale_0_P[32:0]), //o
    .CLK (clk               )  //i
  );
  concatMul mulScale_1 (
    .A   (dataIn_1[31:0]    ), //i
    .B   (scale_1[31:0]     ), //i
    .P   (mulScale_1_P[32:0]), //o
    .CLK (clk               )  //i
  );
  concatMul mulScale_2 (
    .A   (dataIn_2[31:0]    ), //i
    .B   (scale_1[31:0]     ), //i
    .P   (mulScale_2_P[32:0]), //o
    .CLK (clk               )  //i
  );
  concatMul mulScale_3 (
    .A   (dataIn_3[31:0]    ), //i
    .B   (scale_1[31:0]     ), //i
    .P   (mulScale_3_P[32:0]), //o
    .CLK (clk               )  //i
  );
  concatMul mulScale_4 (
    .A   (dataIn_4[31:0]    ), //i
    .B   (scale_1[31:0]     ), //i
    .P   (mulScale_4_P[32:0]), //o
    .CLK (clk               )  //i
  );
  concatMul mulScale_5 (
    .A   (dataIn_5[31:0]    ), //i
    .B   (scale_1[31:0]     ), //i
    .P   (mulScale_5_P[32:0]), //o
    .CLK (clk               )  //i
  );
  concatMul mulScale_6 (
    .A   (dataIn_6[31:0]    ), //i
    .B   (scale_1[31:0]     ), //i
    .P   (mulScale_6_P[32:0]), //o
    .CLK (clk               )  //i
  );
  concatMul mulScale_7 (
    .A   (dataIn_7[31:0]    ), //i
    .B   (scale_1[31:0]     ), //i
    .P   (mulScale_7_P[32:0]), //o
    .CLK (clk               )  //i
  );
  assign mulDataOut_0 = mulScale_0_P;
  assign mulDataOut_1 = mulScale_1_P;
  assign mulDataOut_2 = mulScale_2_P;
  assign mulDataOut_3 = mulScale_3_P;
  assign mulDataOut_4 = mulScale_4_P;
  assign mulDataOut_5 = mulScale_5_P;
  assign mulDataOut_6 = mulScale_6_P;
  assign mulDataOut_7 = mulScale_7_P;
  assign when_Concat_l127 = mulDataOut_0[0];
  assign when_Concat_l132 = _zz_dataOut_0_1[31];
  assign when_Concat_l134 = ($signed(_zz_when_Concat_l134) < $signed(_zz_dataOut_0_1));
  assign dataOut_0 = _zz_dataOut_0;
  assign when_Concat_l127_1 = mulDataOut_1[0];
  assign when_Concat_l132_1 = _zz_dataOut_1_1[31];
  assign when_Concat_l134_1 = ($signed(_zz_when_Concat_l134_1) < $signed(_zz_dataOut_1_1));
  assign dataOut_1 = _zz_dataOut_1;
  assign when_Concat_l127_2 = mulDataOut_2[0];
  assign when_Concat_l132_2 = _zz_dataOut_2_1[31];
  assign when_Concat_l134_2 = ($signed(_zz_when_Concat_l134_2) < $signed(_zz_dataOut_2_1));
  assign dataOut_2 = _zz_dataOut_2;
  assign when_Concat_l127_3 = mulDataOut_3[0];
  assign when_Concat_l132_3 = _zz_dataOut_3_1[31];
  assign when_Concat_l134_3 = ($signed(_zz_when_Concat_l134_3) < $signed(_zz_dataOut_3_1));
  assign dataOut_3 = _zz_dataOut_3;
  assign when_Concat_l127_4 = mulDataOut_4[0];
  assign when_Concat_l132_4 = _zz_dataOut_4_1[31];
  assign when_Concat_l134_4 = ($signed(_zz_when_Concat_l134_4) < $signed(_zz_dataOut_4_1));
  assign dataOut_4 = _zz_dataOut_4;
  assign when_Concat_l127_5 = mulDataOut_5[0];
  assign when_Concat_l132_5 = _zz_dataOut_5_1[31];
  assign when_Concat_l134_5 = ($signed(_zz_when_Concat_l134_5) < $signed(_zz_dataOut_5_1));
  assign dataOut_5 = _zz_dataOut_5;
  assign when_Concat_l127_6 = mulDataOut_6[0];
  assign when_Concat_l132_6 = _zz_dataOut_6_1[31];
  assign when_Concat_l134_6 = ($signed(_zz_when_Concat_l134_6) < $signed(_zz_dataOut_6_1));
  assign dataOut_6 = _zz_dataOut_6;
  assign when_Concat_l127_7 = mulDataOut_7[0];
  assign when_Concat_l132_7 = _zz_dataOut_7_1[31];
  assign when_Concat_l134_7 = ($signed(_zz_when_Concat_l134_7) < $signed(_zz_dataOut_7_1));
  assign dataOut_7 = _zz_dataOut_7;
  always @(posedge clk) begin
    if(when_Concat_l127) begin
      _zz_dataOut_0_1 <= ($signed(_zz__zz_dataOut_0_1) + $signed(_zz__zz_dataOut_0_1_1));
    end else begin
      _zz_dataOut_0_1 <= mulDataOut_0[32 : 1];
    end
    if(when_Concat_l132) begin
      _zz_dataOut_0 <= 8'h0;
    end else begin
      if(when_Concat_l134) begin
        _zz_dataOut_0 <= 8'hff;
      end else begin
        _zz_dataOut_0 <= _zz__zz_dataOut_0;
      end
    end
    if(when_Concat_l127_1) begin
      _zz_dataOut_1_1 <= ($signed(_zz__zz_dataOut_1_1) + $signed(_zz__zz_dataOut_1_1_1));
    end else begin
      _zz_dataOut_1_1 <= mulDataOut_1[32 : 1];
    end
    if(when_Concat_l132_1) begin
      _zz_dataOut_1 <= 8'h0;
    end else begin
      if(when_Concat_l134_1) begin
        _zz_dataOut_1 <= 8'hff;
      end else begin
        _zz_dataOut_1 <= _zz__zz_dataOut_1;
      end
    end
    if(when_Concat_l127_2) begin
      _zz_dataOut_2_1 <= ($signed(_zz__zz_dataOut_2_1) + $signed(_zz__zz_dataOut_2_1_1));
    end else begin
      _zz_dataOut_2_1 <= mulDataOut_2[32 : 1];
    end
    if(when_Concat_l132_2) begin
      _zz_dataOut_2 <= 8'h0;
    end else begin
      if(when_Concat_l134_2) begin
        _zz_dataOut_2 <= 8'hff;
      end else begin
        _zz_dataOut_2 <= _zz__zz_dataOut_2;
      end
    end
    if(when_Concat_l127_3) begin
      _zz_dataOut_3_1 <= ($signed(_zz__zz_dataOut_3_1) + $signed(_zz__zz_dataOut_3_1_1));
    end else begin
      _zz_dataOut_3_1 <= mulDataOut_3[32 : 1];
    end
    if(when_Concat_l132_3) begin
      _zz_dataOut_3 <= 8'h0;
    end else begin
      if(when_Concat_l134_3) begin
        _zz_dataOut_3 <= 8'hff;
      end else begin
        _zz_dataOut_3 <= _zz__zz_dataOut_3;
      end
    end
    if(when_Concat_l127_4) begin
      _zz_dataOut_4_1 <= ($signed(_zz__zz_dataOut_4_1) + $signed(_zz__zz_dataOut_4_1_1));
    end else begin
      _zz_dataOut_4_1 <= mulDataOut_4[32 : 1];
    end
    if(when_Concat_l132_4) begin
      _zz_dataOut_4 <= 8'h0;
    end else begin
      if(when_Concat_l134_4) begin
        _zz_dataOut_4 <= 8'hff;
      end else begin
        _zz_dataOut_4 <= _zz__zz_dataOut_4;
      end
    end
    if(when_Concat_l127_5) begin
      _zz_dataOut_5_1 <= ($signed(_zz__zz_dataOut_5_1) + $signed(_zz__zz_dataOut_5_1_1));
    end else begin
      _zz_dataOut_5_1 <= mulDataOut_5[32 : 1];
    end
    if(when_Concat_l132_5) begin
      _zz_dataOut_5 <= 8'h0;
    end else begin
      if(when_Concat_l134_5) begin
        _zz_dataOut_5 <= 8'hff;
      end else begin
        _zz_dataOut_5 <= _zz__zz_dataOut_5;
      end
    end
    if(when_Concat_l127_6) begin
      _zz_dataOut_6_1 <= ($signed(_zz__zz_dataOut_6_1) + $signed(_zz__zz_dataOut_6_1_1));
    end else begin
      _zz_dataOut_6_1 <= mulDataOut_6[32 : 1];
    end
    if(when_Concat_l132_6) begin
      _zz_dataOut_6 <= 8'h0;
    end else begin
      if(when_Concat_l134_6) begin
        _zz_dataOut_6 <= 8'hff;
      end else begin
        _zz_dataOut_6 <= _zz__zz_dataOut_6;
      end
    end
    if(when_Concat_l127_7) begin
      _zz_dataOut_7_1 <= ($signed(_zz__zz_dataOut_7_1) + $signed(_zz__zz_dataOut_7_1_1));
    end else begin
      _zz_dataOut_7_1 <= mulDataOut_7[32 : 1];
    end
    if(when_Concat_l132_7) begin
      _zz_dataOut_7 <= 8'h0;
    end else begin
      if(when_Concat_l134_7) begin
        _zz_dataOut_7 <= 8'hff;
      end else begin
        _zz_dataOut_7 <= _zz__zz_dataOut_7;
      end
    end
  end


endmodule

module ConcatZero (
  input      [63:0]   dataIn,
  input      [31:0]   zero_1,
  output     [31:0]   dataOut_0,
  output     [31:0]   dataOut_1,
  output     [31:0]   dataOut_2,
  output     [31:0]   dataOut_3,
  output     [31:0]   dataOut_4,
  output     [31:0]   dataOut_5,
  output     [31:0]   dataOut_6,
  output     [31:0]   dataOut_7,
  input               clk
);

  wire       [31:0]   add_0_A;
  wire       [31:0]   add_1_A;
  wire       [31:0]   add_2_A;
  wire       [31:0]   add_3_A;
  wire       [31:0]   add_4_A;
  wire       [31:0]   add_5_A;
  wire       [31:0]   add_6_A;
  wire       [31:0]   add_7_A;
  wire       [31:0]   add_0_S;
  wire       [31:0]   add_1_S;
  wire       [31:0]   add_2_S;
  wire       [31:0]   add_3_S;
  wire       [31:0]   add_4_S;
  wire       [31:0]   add_5_S;
  wire       [31:0]   add_6_S;
  wire       [31:0]   add_7_S;
  wire       [15:0]   _zz_A;
  wire       [7:0]    _zz_A_1;
  wire       [15:0]   _zz_A_2;
  wire       [15:0]   _zz_A_3;
  wire       [7:0]    _zz_A_4;
  wire       [15:0]   _zz_A_5;
  wire       [15:0]   _zz_A_6;
  wire       [7:0]    _zz_A_7;
  wire       [15:0]   _zz_A_8;
  wire       [15:0]   _zz_A_9;
  wire       [7:0]    _zz_A_10;
  wire       [15:0]   _zz_A_11;
  wire       [15:0]   _zz_A_12;
  wire       [7:0]    _zz_A_13;
  wire       [15:0]   _zz_A_14;
  wire       [15:0]   _zz_A_15;
  wire       [7:0]    _zz_A_16;
  wire       [15:0]   _zz_A_17;
  wire       [15:0]   _zz_A_18;
  wire       [7:0]    _zz_A_19;
  wire       [15:0]   _zz_A_20;
  wire       [15:0]   _zz_A_21;
  wire       [7:0]    _zz_A_22;
  wire       [15:0]   _zz_A_23;
  wire       [7:0]    dataInTemp_0;
  wire       [7:0]    dataInTemp_1;
  wire       [7:0]    dataInTemp_2;
  wire       [7:0]    dataInTemp_3;
  wire       [7:0]    dataInTemp_4;
  wire       [7:0]    dataInTemp_5;
  wire       [7:0]    dataInTemp_6;
  wire       [7:0]    dataInTemp_7;

  assign _zz_A = {_zz_A_1,dataInTemp_0};
  assign _zz_A_1 = 8'h0;
  assign _zz_A_2 = 16'h0;
  assign _zz_A_3 = {_zz_A_4,dataInTemp_1};
  assign _zz_A_4 = 8'h0;
  assign _zz_A_5 = 16'h0;
  assign _zz_A_6 = {_zz_A_7,dataInTemp_2};
  assign _zz_A_7 = 8'h0;
  assign _zz_A_8 = 16'h0;
  assign _zz_A_9 = {_zz_A_10,dataInTemp_3};
  assign _zz_A_10 = 8'h0;
  assign _zz_A_11 = 16'h0;
  assign _zz_A_12 = {_zz_A_13,dataInTemp_4};
  assign _zz_A_13 = 8'h0;
  assign _zz_A_14 = 16'h0;
  assign _zz_A_15 = {_zz_A_16,dataInTemp_5};
  assign _zz_A_16 = 8'h0;
  assign _zz_A_17 = 16'h0;
  assign _zz_A_18 = {_zz_A_19,dataInTemp_6};
  assign _zz_A_19 = 8'h0;
  assign _zz_A_20 = 16'h0;
  assign _zz_A_21 = {_zz_A_22,dataInTemp_7};
  assign _zz_A_22 = 8'h0;
  assign _zz_A_23 = 16'h0;
  concatAdd add_0 (
    .A   (add_0_A[31:0]), //i
    .B   (zero_1[31:0] ), //i
    .S   (add_0_S[31:0]), //o
    .CLK (clk          )  //i
  );
  concatAdd add_1 (
    .A   (add_1_A[31:0]), //i
    .B   (zero_1[31:0] ), //i
    .S   (add_1_S[31:0]), //o
    .CLK (clk          )  //i
  );
  concatAdd add_2 (
    .A   (add_2_A[31:0]), //i
    .B   (zero_1[31:0] ), //i
    .S   (add_2_S[31:0]), //o
    .CLK (clk          )  //i
  );
  concatAdd add_3 (
    .A   (add_3_A[31:0]), //i
    .B   (zero_1[31:0] ), //i
    .S   (add_3_S[31:0]), //o
    .CLK (clk          )  //i
  );
  concatAdd add_4 (
    .A   (add_4_A[31:0]), //i
    .B   (zero_1[31:0] ), //i
    .S   (add_4_S[31:0]), //o
    .CLK (clk          )  //i
  );
  concatAdd add_5 (
    .A   (add_5_A[31:0]), //i
    .B   (zero_1[31:0] ), //i
    .S   (add_5_S[31:0]), //o
    .CLK (clk          )  //i
  );
  concatAdd add_6 (
    .A   (add_6_A[31:0]), //i
    .B   (zero_1[31:0] ), //i
    .S   (add_6_S[31:0]), //o
    .CLK (clk          )  //i
  );
  concatAdd add_7 (
    .A   (add_7_A[31:0]), //i
    .B   (zero_1[31:0] ), //i
    .S   (add_7_S[31:0]), //o
    .CLK (clk          )  //i
  );
  assign dataInTemp_0 = dataIn[7 : 0];
  assign dataInTemp_1 = dataIn[15 : 8];
  assign dataInTemp_2 = dataIn[23 : 16];
  assign dataInTemp_3 = dataIn[31 : 24];
  assign dataInTemp_4 = dataIn[39 : 32];
  assign dataInTemp_5 = dataIn[47 : 40];
  assign dataInTemp_6 = dataIn[55 : 48];
  assign dataInTemp_7 = dataIn[63 : 56];
  assign add_0_A = {_zz_A,_zz_A_2};
  assign dataOut_0 = add_0_S;
  assign add_1_A = {_zz_A_3,_zz_A_5};
  assign dataOut_1 = add_1_S;
  assign add_2_A = {_zz_A_6,_zz_A_8};
  assign dataOut_2 = add_2_S;
  assign add_3_A = {_zz_A_9,_zz_A_11};
  assign dataOut_3 = add_3_S;
  assign add_4_A = {_zz_A_12,_zz_A_14};
  assign dataOut_4 = add_4_S;
  assign add_5_A = {_zz_A_15,_zz_A_17};
  assign dataOut_5 = add_5_S;
  assign add_6_A = {_zz_A_18,_zz_A_20};
  assign dataOut_6 = add_6_S;
  assign add_7_A = {_zz_A_21,_zz_A_23};
  assign dataOut_7 = add_7_S;

endmodule

module Stride (
  input               sData_valid,
  output reg          sData_ready,
  input      [63:0]   sData_payload,
  output              mData_valid,
  input               mData_ready,
  output     [63:0]   mData_payload,
  output reg          sReady,
  output              complete,
  input               enStride,
  input      [8:0]    rowNumIn,
  input      [8:0]    colNumIn,
  input      [11:0]   channelOut,
  input               start,
  input               clk,
  input               reset
);
  localparam StrideEnum_IDLE = 3'd1;
  localparam StrideEnum_INIT = 3'd2;
  localparam StrideEnum_STRIDE = 3'd4;

  reg                 fifo_io_push_valid;
  wire                fifo_io_push_ready;
  wire                fifo_io_pop_valid;
  wire       [63:0]   fifo_io_pop_payload;
  wire       [12:0]   fifo_io_occupancy;
  wire       [12:0]   fifo_io_availability;
  wire       [8:0]    _zz_when_WaCounter_l12_1;
  wire       [8:0]    _zz_when_WaCounter_l12_2;
  wire       [8:0]    _zz_when_WaCounter_l12_3;
  wire       [17:0]   _zz_when_Stride_l97;
  wire                fsm_initEnd;
  reg        [2:0]    fsm_currentState;
  reg        [2:0]    fsm_nextState;
  wire                when_WaCounter_l17;
  reg        [2:0]    initCnt_count;
  reg                 initCnt_valid;
  wire                when_WaCounter_l12;
  wire                when_Stride_l65;
  reg        [8:0]    channelTimes;
  wire                when_Stride_l66;
  reg        [8:0]    colTimes;
  wire                when_Stride_l67;
  reg        [8:0]    rowTimes;
  reg        [17:0]   dataCount;
  wire                sData_fire;
  wire                when_WaCounter_l17_1;
  reg        [8:0]    channelCnt_count;
  reg                 channelCnt_valid;
  wire                when_WaCounter_l12_1;
  wire                sData_fire_1;
  wire                when_WaCounter_l17_2;
  reg        [8:0]    colCnt_count;
  reg                 colCnt_valid;
  wire                when_WaCounter_l12_2;
  wire                sData_fire_2;
  wire                when_WaCounter_l17_3;
  reg        [8:0]    rowCnt_count;
  reg                 rowCnt_valid;
  wire                when_WaCounter_l12_3;
  wire                when_Stride_l78;
  wire                when_Stride_l84;
  wire                when_Stream_l434;
  reg                 sData_thrown_valid;
  wire                sData_thrown_ready;
  wire       [63:0]   sData_thrown_payload;
  wire                when_Stride_l97;
  `ifndef SYNTHESIS
  reg [47:0] fsm_currentState_string;
  reg [47:0] fsm_nextState_string;
  `endif


  assign _zz_when_WaCounter_l12_1 = (channelTimes - 9'h001);
  assign _zz_when_WaCounter_l12_2 = (colTimes - 9'h001);
  assign _zz_when_WaCounter_l12_3 = (rowTimes - 9'h001);
  assign _zz_when_Stride_l97 = {5'd0, fifo_io_availability};
  StreamFifo fifo (
    .io_push_valid   (fifo_io_push_valid        ), //i
    .io_push_ready   (fifo_io_push_ready        ), //o
    .io_push_payload (sData_payload[63:0]       ), //i
    .io_pop_valid    (fifo_io_pop_valid         ), //o
    .io_pop_ready    (mData_ready               ), //i
    .io_pop_payload  (fifo_io_pop_payload[63:0] ), //o
    .io_flush        (1'b0                      ), //i
    .io_occupancy    (fifo_io_occupancy[12:0]   ), //o
    .io_availability (fifo_io_availability[12:0]), //o
    .clk             (clk                       ), //i
    .reset           (reset                     )  //i
  );
  `ifndef SYNTHESIS
  always @(*) begin
    case(fsm_currentState)
      StrideEnum_IDLE : fsm_currentState_string = "IDLE  ";
      StrideEnum_INIT : fsm_currentState_string = "INIT  ";
      StrideEnum_STRIDE : fsm_currentState_string = "STRIDE";
      default : fsm_currentState_string = "??????";
    endcase
  end
  always @(*) begin
    case(fsm_nextState)
      StrideEnum_IDLE : fsm_nextState_string = "IDLE  ";
      StrideEnum_INIT : fsm_nextState_string = "INIT  ";
      StrideEnum_STRIDE : fsm_nextState_string = "STRIDE";
      default : fsm_nextState_string = "??????";
    endcase
  end
  `endif

  always @(*) begin
    (* parallel_case *)
    case(1) // synthesis parallel_case
      (((fsm_currentState) & StrideEnum_IDLE) == StrideEnum_IDLE) : begin
        if(start) begin
          fsm_nextState = StrideEnum_INIT;
        end else begin
          fsm_nextState = StrideEnum_IDLE;
        end
      end
      (((fsm_currentState) & StrideEnum_INIT) == StrideEnum_INIT) : begin
        if(fsm_initEnd) begin
          fsm_nextState = StrideEnum_STRIDE;
        end else begin
          fsm_nextState = StrideEnum_INIT;
        end
      end
      default : begin
        if(complete) begin
          fsm_nextState = StrideEnum_IDLE;
        end else begin
          fsm_nextState = StrideEnum_STRIDE;
        end
      end
    endcase
  end

  assign when_WaCounter_l17 = ((fsm_currentState & StrideEnum_INIT) != 3'b000);
  assign when_WaCounter_l12 = (initCnt_count == 3'b111);
  always @(*) begin
    if(when_WaCounter_l12) begin
      initCnt_valid = 1'b1;
    end else begin
      initCnt_valid = 1'b0;
    end
    if(when_Stride_l78) begin
      initCnt_valid = 1'b0;
    end
  end

  assign fsm_initEnd = initCnt_valid;
  assign when_Stride_l65 = ((fsm_currentState & StrideEnum_INIT) != 3'b000);
  assign when_Stride_l66 = ((fsm_currentState & StrideEnum_INIT) != 3'b000);
  assign when_Stride_l67 = ((fsm_currentState & StrideEnum_INIT) != 3'b000);
  assign sData_fire = (sData_valid && sData_ready);
  assign when_WaCounter_l17_1 = (((fsm_currentState & StrideEnum_STRIDE) != 3'b000) && sData_fire);
  assign when_WaCounter_l12_1 = (channelCnt_count == _zz_when_WaCounter_l12_1);
  always @(*) begin
    if(when_WaCounter_l12_1) begin
      channelCnt_valid = 1'b1;
    end else begin
      channelCnt_valid = 1'b0;
    end
    if(when_Stride_l78) begin
      channelCnt_valid = 1'b0;
    end
  end

  assign sData_fire_1 = (sData_valid && sData_ready);
  assign when_WaCounter_l17_2 = (channelCnt_valid && sData_fire_1);
  assign when_WaCounter_l12_2 = (colCnt_count == _zz_when_WaCounter_l12_2);
  always @(*) begin
    if(when_WaCounter_l12_2) begin
      colCnt_valid = 1'b1;
    end else begin
      colCnt_valid = 1'b0;
    end
    if(when_Stride_l78) begin
      colCnt_valid = 1'b0;
    end
  end

  assign sData_fire_2 = (sData_valid && sData_ready);
  assign when_WaCounter_l17_3 = ((channelCnt_valid && colCnt_valid) && sData_fire_2);
  assign when_WaCounter_l12_3 = (rowCnt_count == _zz_when_WaCounter_l12_3);
  always @(*) begin
    if(when_WaCounter_l12_3) begin
      rowCnt_valid = 1'b1;
    end else begin
      rowCnt_valid = 1'b0;
    end
    if(when_Stride_l78) begin
      rowCnt_valid = 1'b0;
    end
  end

  assign complete = ((rowCnt_valid && colCnt_valid) && channelCnt_valid);
  assign when_Stride_l78 = ((fsm_currentState & StrideEnum_IDLE) != 3'b000);
  assign when_Stride_l84 = ((fsm_currentState & StrideEnum_STRIDE) != 3'b000);
  assign when_Stream_l434 = (colCnt_count[0] || rowCnt_count[0]);
  always @(*) begin
    sData_thrown_valid = sData_valid;
    if(when_Stream_l434) begin
      sData_thrown_valid = 1'b0;
    end
  end

  always @(*) begin
    if(when_Stride_l84) begin
      if(enStride) begin
        sData_ready = sData_thrown_ready;
        if(when_Stream_l434) begin
          sData_ready = 1'b1;
        end
      end else begin
        sData_ready = fifo_io_push_ready;
      end
    end else begin
      sData_ready = 1'b0;
    end
  end

  assign sData_thrown_payload = sData_payload;
  always @(*) begin
    if(when_Stride_l84) begin
      if(enStride) begin
        fifo_io_push_valid = sData_thrown_valid;
      end else begin
        fifo_io_push_valid = sData_valid;
      end
    end else begin
      fifo_io_push_valid = 1'b0;
    end
  end

  assign sData_thrown_ready = fifo_io_push_ready;
  assign when_Stride_l97 = (dataCount < _zz_when_Stride_l97);
  always @(*) begin
    if(when_Stride_l97) begin
      sReady = 1'b1;
    end else begin
      sReady = 1'b0;
    end
  end

  assign mData_valid = fifo_io_pop_valid;
  assign mData_payload = fifo_io_pop_payload;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      fsm_currentState <= StrideEnum_IDLE;
      initCnt_count <= 3'b000;
      channelCnt_count <= 9'h0;
      colCnt_count <= 9'h0;
      rowCnt_count <= 9'h0;
    end else begin
      fsm_currentState <= fsm_nextState;
      if(when_WaCounter_l17) begin
        initCnt_count <= (initCnt_count + 3'b001);
        if(initCnt_valid) begin
          initCnt_count <= 3'b000;
        end
      end
      if(when_WaCounter_l17_1) begin
        channelCnt_count <= (channelCnt_count + 9'h001);
        if(channelCnt_valid) begin
          channelCnt_count <= 9'h0;
        end
      end
      if(when_WaCounter_l17_2) begin
        colCnt_count <= (colCnt_count + 9'h001);
        if(colCnt_valid) begin
          colCnt_count <= 9'h0;
        end
      end
      if(when_WaCounter_l17_3) begin
        rowCnt_count <= (rowCnt_count + 9'h001);
        if(rowCnt_valid) begin
          rowCnt_count <= 9'h0;
        end
      end
      if(when_Stride_l78) begin
        initCnt_count <= 3'b000;
        channelCnt_count <= 9'h0;
        colCnt_count <= 9'h0;
        rowCnt_count <= 9'h0;
      end
    end
  end

  always @(posedge clk) begin
    if(when_Stride_l65) begin
      channelTimes <= (channelOut >>> 3);
    end
    if(when_Stride_l66) begin
      colTimes <= colNumIn;
    end
    if(when_Stride_l67) begin
      rowTimes <= rowNumIn;
    end
    dataCount <= (channelTimes * colTimes);
  end


endmodule

module Quan (
  input      [31:0]   dataIn_0,
  input      [31:0]   dataIn_1,
  input      [31:0]   dataIn_2,
  input      [31:0]   dataIn_3,
  input      [31:0]   dataIn_4,
  input      [31:0]   dataIn_5,
  input      [31:0]   dataIn_6,
  input      [31:0]   dataIn_7,
  input      [255:0]  biasIn,
  input      [255:0]  scaleIn,
  input      [255:0]  shiftIn,
  input      [7:0]    zeroIn,
  input               activationEn,
  output reg [63:0]   dataOut,
  input               clk,
  input               reset
);

  wire       [31:0]   bias_1_Bias_quan_0;
  wire       [31:0]   bias_1_Bias_quan_1;
  wire       [31:0]   bias_1_Bias_quan_2;
  wire       [31:0]   bias_1_Bias_quan_3;
  wire       [31:0]   bias_1_Bias_quan_4;
  wire       [31:0]   bias_1_Bias_quan_5;
  wire       [31:0]   bias_1_Bias_quan_6;
  wire       [31:0]   bias_1_Bias_quan_7;
  wire       [31:0]   bias_1_Bias_dataOut_0;
  wire       [31:0]   bias_1_Bias_dataOut_1;
  wire       [31:0]   bias_1_Bias_dataOut_2;
  wire       [31:0]   bias_1_Bias_dataOut_3;
  wire       [31:0]   bias_1_Bias_dataOut_4;
  wire       [31:0]   bias_1_Bias_dataOut_5;
  wire       [31:0]   bias_1_Bias_dataOut_6;
  wire       [31:0]   bias_1_Bias_dataOut_7;
  wire       [31:0]   scale_1_Scale_dataOut_0;
  wire       [31:0]   scale_1_Scale_dataOut_1;
  wire       [31:0]   scale_1_Scale_dataOut_2;
  wire       [31:0]   scale_1_Scale_dataOut_3;
  wire       [31:0]   scale_1_Scale_dataOut_4;
  wire       [31:0]   scale_1_Scale_dataOut_5;
  wire       [31:0]   scale_1_Scale_dataOut_6;
  wire       [31:0]   scale_1_Scale_dataOut_7;
  wire       [15:0]   shift_1_shift_dataOut_0;
  wire       [15:0]   shift_1_shift_dataOut_1;
  wire       [15:0]   shift_1_shift_dataOut_2;
  wire       [15:0]   shift_1_shift_dataOut_3;
  wire       [15:0]   shift_1_shift_dataOut_4;
  wire       [15:0]   shift_1_shift_dataOut_5;
  wire       [15:0]   shift_1_shift_dataOut_6;
  wire       [15:0]   shift_1_shift_dataOut_7;
  wire       [7:0]    zero_1_dataOut_0;
  wire       [7:0]    zero_1_dataOut_1;
  wire       [7:0]    zero_1_dataOut_2;
  wire       [7:0]    zero_1_dataOut_3;
  wire       [7:0]    zero_1_dataOut_4;
  wire       [7:0]    zero_1_dataOut_5;
  wire       [7:0]    zero_1_dataOut_6;
  wire       [7:0]    zero_1_dataOut_7;
  wire       [7:0]    leakyRelu_1_dataOut_0;
  wire       [7:0]    leakyRelu_1_dataOut_1;
  wire       [7:0]    leakyRelu_1_dataOut_2;
  wire       [7:0]    leakyRelu_1_dataOut_3;
  wire       [7:0]    leakyRelu_1_dataOut_4;
  wire       [7:0]    leakyRelu_1_dataOut_5;
  wire       [7:0]    leakyRelu_1_dataOut_6;
  wire       [7:0]    leakyRelu_1_dataOut_7;
  reg        [31:0]   _zz_Scale_quan_0;
  reg        [31:0]   _zz_Scale_quan_1;
  reg        [31:0]   _zz_Scale_quan_2;
  reg        [31:0]   _zz_Scale_quan_3;
  reg        [31:0]   _zz_Scale_quan_4;
  reg        [31:0]   _zz_Scale_quan_5;
  reg        [31:0]   _zz_Scale_quan_6;
  reg        [31:0]   _zz_Scale_quan_7;
  reg        [31:0]   _zz_shift_quan_0;
  reg        [31:0]   _zz_shift_quan_1;
  reg        [31:0]   _zz_shift_quan_2;
  reg        [31:0]   _zz_shift_quan_3;
  reg        [31:0]   _zz_shift_quan_4;
  reg        [31:0]   _zz_shift_quan_5;
  reg        [31:0]   _zz_shift_quan_6;
  reg        [31:0]   _zz_shift_quan_7;
  reg        [31:0]   _zz_shift_quan_0_1;
  reg        [31:0]   _zz_shift_quan_1_1;
  reg        [31:0]   _zz_shift_quan_2_1;
  reg        [31:0]   _zz_shift_quan_3_1;
  reg        [31:0]   _zz_shift_quan_4_1;
  reg        [31:0]   _zz_shift_quan_5_1;
  reg        [31:0]   _zz_shift_quan_6_1;
  reg        [31:0]   _zz_shift_quan_7_1;
  reg        [31:0]   _zz_shift_quan_0_2;
  reg        [31:0]   _zz_shift_quan_1_2;
  reg        [31:0]   _zz_shift_quan_2_2;
  reg        [31:0]   _zz_shift_quan_3_2;
  reg        [31:0]   _zz_shift_quan_4_2;
  reg        [31:0]   _zz_shift_quan_5_2;
  reg        [31:0]   _zz_shift_quan_6_2;
  reg        [31:0]   _zz_shift_quan_7_2;
  reg        [31:0]   _zz_shift_quan_0_3;
  reg        [31:0]   _zz_shift_quan_1_3;
  reg        [31:0]   _zz_shift_quan_2_3;
  reg        [31:0]   _zz_shift_quan_3_3;
  reg        [31:0]   _zz_shift_quan_4_3;
  reg        [31:0]   _zz_shift_quan_5_3;
  reg        [31:0]   _zz_shift_quan_6_3;
  reg        [31:0]   _zz_shift_quan_7_3;

  Bias bias_1 (
    .Bias_dataIn_0  (dataIn_0[31:0]             ), //i
    .Bias_dataIn_1  (dataIn_1[31:0]             ), //i
    .Bias_dataIn_2  (dataIn_2[31:0]             ), //i
    .Bias_dataIn_3  (dataIn_3[31:0]             ), //i
    .Bias_dataIn_4  (dataIn_4[31:0]             ), //i
    .Bias_dataIn_5  (dataIn_5[31:0]             ), //i
    .Bias_dataIn_6  (dataIn_6[31:0]             ), //i
    .Bias_dataIn_7  (dataIn_7[31:0]             ), //i
    .Bias_quan_0    (bias_1_Bias_quan_0[31:0]   ), //i
    .Bias_quan_1    (bias_1_Bias_quan_1[31:0]   ), //i
    .Bias_quan_2    (bias_1_Bias_quan_2[31:0]   ), //i
    .Bias_quan_3    (bias_1_Bias_quan_3[31:0]   ), //i
    .Bias_quan_4    (bias_1_Bias_quan_4[31:0]   ), //i
    .Bias_quan_5    (bias_1_Bias_quan_5[31:0]   ), //i
    .Bias_quan_6    (bias_1_Bias_quan_6[31:0]   ), //i
    .Bias_quan_7    (bias_1_Bias_quan_7[31:0]   ), //i
    .Bias_dataOut_0 (bias_1_Bias_dataOut_0[31:0]), //o
    .Bias_dataOut_1 (bias_1_Bias_dataOut_1[31:0]), //o
    .Bias_dataOut_2 (bias_1_Bias_dataOut_2[31:0]), //o
    .Bias_dataOut_3 (bias_1_Bias_dataOut_3[31:0]), //o
    .Bias_dataOut_4 (bias_1_Bias_dataOut_4[31:0]), //o
    .Bias_dataOut_5 (bias_1_Bias_dataOut_5[31:0]), //o
    .Bias_dataOut_6 (bias_1_Bias_dataOut_6[31:0]), //o
    .Bias_dataOut_7 (bias_1_Bias_dataOut_7[31:0]), //o
    .clk            (clk                        )  //i
  );
  Scale scale_1 (
    .Scale_dataIn_0  (bias_1_Bias_dataOut_0[31:0]  ), //i
    .Scale_dataIn_1  (bias_1_Bias_dataOut_1[31:0]  ), //i
    .Scale_dataIn_2  (bias_1_Bias_dataOut_2[31:0]  ), //i
    .Scale_dataIn_3  (bias_1_Bias_dataOut_3[31:0]  ), //i
    .Scale_dataIn_4  (bias_1_Bias_dataOut_4[31:0]  ), //i
    .Scale_dataIn_5  (bias_1_Bias_dataOut_5[31:0]  ), //i
    .Scale_dataIn_6  (bias_1_Bias_dataOut_6[31:0]  ), //i
    .Scale_dataIn_7  (bias_1_Bias_dataOut_7[31:0]  ), //i
    .Scale_quan_0    (_zz_Scale_quan_0[31:0]       ), //i
    .Scale_quan_1    (_zz_Scale_quan_1[31:0]       ), //i
    .Scale_quan_2    (_zz_Scale_quan_2[31:0]       ), //i
    .Scale_quan_3    (_zz_Scale_quan_3[31:0]       ), //i
    .Scale_quan_4    (_zz_Scale_quan_4[31:0]       ), //i
    .Scale_quan_5    (_zz_Scale_quan_5[31:0]       ), //i
    .Scale_quan_6    (_zz_Scale_quan_6[31:0]       ), //i
    .Scale_quan_7    (_zz_Scale_quan_7[31:0]       ), //i
    .Scale_dataOut_0 (scale_1_Scale_dataOut_0[31:0]), //o
    .Scale_dataOut_1 (scale_1_Scale_dataOut_1[31:0]), //o
    .Scale_dataOut_2 (scale_1_Scale_dataOut_2[31:0]), //o
    .Scale_dataOut_3 (scale_1_Scale_dataOut_3[31:0]), //o
    .Scale_dataOut_4 (scale_1_Scale_dataOut_4[31:0]), //o
    .Scale_dataOut_5 (scale_1_Scale_dataOut_5[31:0]), //o
    .Scale_dataOut_6 (scale_1_Scale_dataOut_6[31:0]), //o
    .Scale_dataOut_7 (scale_1_Scale_dataOut_7[31:0]), //o
    .clk             (clk                          )  //i
  );
  Shift shift_1 (
    .shift_dataIn_0  (scale_1_Scale_dataOut_0[31:0]), //i
    .shift_dataIn_1  (scale_1_Scale_dataOut_1[31:0]), //i
    .shift_dataIn_2  (scale_1_Scale_dataOut_2[31:0]), //i
    .shift_dataIn_3  (scale_1_Scale_dataOut_3[31:0]), //i
    .shift_dataIn_4  (scale_1_Scale_dataOut_4[31:0]), //i
    .shift_dataIn_5  (scale_1_Scale_dataOut_5[31:0]), //i
    .shift_dataIn_6  (scale_1_Scale_dataOut_6[31:0]), //i
    .shift_dataIn_7  (scale_1_Scale_dataOut_7[31:0]), //i
    .shift_quan_0    (_zz_shift_quan_0_3[31:0]     ), //i
    .shift_quan_1    (_zz_shift_quan_1_3[31:0]     ), //i
    .shift_quan_2    (_zz_shift_quan_2_3[31:0]     ), //i
    .shift_quan_3    (_zz_shift_quan_3_3[31:0]     ), //i
    .shift_quan_4    (_zz_shift_quan_4_3[31:0]     ), //i
    .shift_quan_5    (_zz_shift_quan_5_3[31:0]     ), //i
    .shift_quan_6    (_zz_shift_quan_6_3[31:0]     ), //i
    .shift_quan_7    (_zz_shift_quan_7_3[31:0]     ), //i
    .shift_dataOut_0 (shift_1_shift_dataOut_0[15:0]), //o
    .shift_dataOut_1 (shift_1_shift_dataOut_1[15:0]), //o
    .shift_dataOut_2 (shift_1_shift_dataOut_2[15:0]), //o
    .shift_dataOut_3 (shift_1_shift_dataOut_3[15:0]), //o
    .shift_dataOut_4 (shift_1_shift_dataOut_4[15:0]), //o
    .shift_dataOut_5 (shift_1_shift_dataOut_5[15:0]), //o
    .shift_dataOut_6 (shift_1_shift_dataOut_6[15:0]), //o
    .shift_dataOut_7 (shift_1_shift_dataOut_7[15:0]), //o
    .clk             (clk                          ), //i
    .reset           (reset                        )  //i
  );
  Zero zero_1 (
    .dataIn_0  (shift_1_shift_dataOut_0[15:0]), //i
    .dataIn_1  (shift_1_shift_dataOut_1[15:0]), //i
    .dataIn_2  (shift_1_shift_dataOut_2[15:0]), //i
    .dataIn_3  (shift_1_shift_dataOut_3[15:0]), //i
    .dataIn_4  (shift_1_shift_dataOut_4[15:0]), //i
    .dataIn_5  (shift_1_shift_dataOut_5[15:0]), //i
    .dataIn_6  (shift_1_shift_dataOut_6[15:0]), //i
    .dataIn_7  (shift_1_shift_dataOut_7[15:0]), //i
    .quan_1    (zeroIn[7:0]                  ), //i
    .dataOut_0 (zero_1_dataOut_0[7:0]        ), //o
    .dataOut_1 (zero_1_dataOut_1[7:0]        ), //o
    .dataOut_2 (zero_1_dataOut_2[7:0]        ), //o
    .dataOut_3 (zero_1_dataOut_3[7:0]        ), //o
    .dataOut_4 (zero_1_dataOut_4[7:0]        ), //o
    .dataOut_5 (zero_1_dataOut_5[7:0]        ), //o
    .dataOut_6 (zero_1_dataOut_6[7:0]        ), //o
    .dataOut_7 (zero_1_dataOut_7[7:0]        ), //o
    .clk       (clk                          ), //i
    .reset     (reset                        )  //i
  );
  LeakyRelu leakyRelu_1 (
    .dataIn_0  (zero_1_dataOut_0[7:0]     ), //i
    .dataIn_1  (zero_1_dataOut_1[7:0]     ), //i
    .dataIn_2  (zero_1_dataOut_2[7:0]     ), //i
    .dataIn_3  (zero_1_dataOut_3[7:0]     ), //i
    .dataIn_4  (zero_1_dataOut_4[7:0]     ), //i
    .dataIn_5  (zero_1_dataOut_5[7:0]     ), //i
    .dataIn_6  (zero_1_dataOut_6[7:0]     ), //i
    .dataIn_7  (zero_1_dataOut_7[7:0]     ), //i
    .quanZero  (zeroIn[7:0]               ), //i
    .dataOut_0 (leakyRelu_1_dataOut_0[7:0]), //o
    .dataOut_1 (leakyRelu_1_dataOut_1[7:0]), //o
    .dataOut_2 (leakyRelu_1_dataOut_2[7:0]), //o
    .dataOut_3 (leakyRelu_1_dataOut_3[7:0]), //o
    .dataOut_4 (leakyRelu_1_dataOut_4[7:0]), //o
    .dataOut_5 (leakyRelu_1_dataOut_5[7:0]), //o
    .dataOut_6 (leakyRelu_1_dataOut_6[7:0]), //o
    .dataOut_7 (leakyRelu_1_dataOut_7[7:0]), //o
    .clk       (clk                       ), //i
    .reset     (reset                     )  //i
  );
  assign bias_1_Bias_quan_0 = biasIn[31 : 0];
  assign bias_1_Bias_quan_1 = biasIn[63 : 32];
  assign bias_1_Bias_quan_2 = biasIn[95 : 64];
  assign bias_1_Bias_quan_3 = biasIn[127 : 96];
  assign bias_1_Bias_quan_4 = biasIn[159 : 128];
  assign bias_1_Bias_quan_5 = biasIn[191 : 160];
  assign bias_1_Bias_quan_6 = biasIn[223 : 192];
  assign bias_1_Bias_quan_7 = biasIn[255 : 224];
  always @(*) begin
    if(activationEn) begin
      dataOut[7 : 0] = leakyRelu_1_dataOut_0;
      dataOut[15 : 8] = leakyRelu_1_dataOut_1;
      dataOut[23 : 16] = leakyRelu_1_dataOut_2;
      dataOut[31 : 24] = leakyRelu_1_dataOut_3;
      dataOut[39 : 32] = leakyRelu_1_dataOut_4;
      dataOut[47 : 40] = leakyRelu_1_dataOut_5;
      dataOut[55 : 48] = leakyRelu_1_dataOut_6;
      dataOut[63 : 56] = leakyRelu_1_dataOut_7;
    end else begin
      dataOut[7 : 0] = zero_1_dataOut_0;
      dataOut[15 : 8] = zero_1_dataOut_1;
      dataOut[23 : 16] = zero_1_dataOut_2;
      dataOut[31 : 24] = zero_1_dataOut_3;
      dataOut[39 : 32] = zero_1_dataOut_4;
      dataOut[47 : 40] = zero_1_dataOut_5;
      dataOut[55 : 48] = zero_1_dataOut_6;
      dataOut[63 : 56] = zero_1_dataOut_7;
    end
  end

  always @(posedge clk) begin
    _zz_Scale_quan_0 <= scaleIn[31 : 0];
    _zz_Scale_quan_1 <= scaleIn[63 : 32];
    _zz_Scale_quan_2 <= scaleIn[95 : 64];
    _zz_Scale_quan_3 <= scaleIn[127 : 96];
    _zz_Scale_quan_4 <= scaleIn[159 : 128];
    _zz_Scale_quan_5 <= scaleIn[191 : 160];
    _zz_Scale_quan_6 <= scaleIn[223 : 192];
    _zz_Scale_quan_7 <= scaleIn[255 : 224];
    _zz_shift_quan_0 <= shiftIn[31 : 0];
    _zz_shift_quan_1 <= shiftIn[63 : 32];
    _zz_shift_quan_2 <= shiftIn[95 : 64];
    _zz_shift_quan_3 <= shiftIn[127 : 96];
    _zz_shift_quan_4 <= shiftIn[159 : 128];
    _zz_shift_quan_5 <= shiftIn[191 : 160];
    _zz_shift_quan_6 <= shiftIn[223 : 192];
    _zz_shift_quan_7 <= shiftIn[255 : 224];
    _zz_shift_quan_0_1 <= _zz_shift_quan_0;
    _zz_shift_quan_1_1 <= _zz_shift_quan_1;
    _zz_shift_quan_2_1 <= _zz_shift_quan_2;
    _zz_shift_quan_3_1 <= _zz_shift_quan_3;
    _zz_shift_quan_4_1 <= _zz_shift_quan_4;
    _zz_shift_quan_5_1 <= _zz_shift_quan_5;
    _zz_shift_quan_6_1 <= _zz_shift_quan_6;
    _zz_shift_quan_7_1 <= _zz_shift_quan_7;
    _zz_shift_quan_0_2 <= _zz_shift_quan_0_1;
    _zz_shift_quan_1_2 <= _zz_shift_quan_1_1;
    _zz_shift_quan_2_2 <= _zz_shift_quan_2_1;
    _zz_shift_quan_3_2 <= _zz_shift_quan_3_1;
    _zz_shift_quan_4_2 <= _zz_shift_quan_4_1;
    _zz_shift_quan_5_2 <= _zz_shift_quan_5_1;
    _zz_shift_quan_6_2 <= _zz_shift_quan_6_1;
    _zz_shift_quan_7_2 <= _zz_shift_quan_7_1;
    _zz_shift_quan_0_3 <= _zz_shift_quan_0_2;
    _zz_shift_quan_1_3 <= _zz_shift_quan_1_2;
    _zz_shift_quan_2_3 <= _zz_shift_quan_2_2;
    _zz_shift_quan_3_3 <= _zz_shift_quan_3_2;
    _zz_shift_quan_4_3 <= _zz_shift_quan_4_2;
    _zz_shift_quan_5_3 <= _zz_shift_quan_5_2;
    _zz_shift_quan_6_3 <= _zz_shift_quan_6_2;
    _zz_shift_quan_7_3 <= _zz_shift_quan_7_2;
  end


endmodule

//xAddChannelTimes replaced by xAddChannelTimes

//xAddChannelTimes replaced by xAddChannelTimes

//xAddChannelTimes replaced by xAddChannelTimes

//xAddChannelTimes replaced by xAddChannelTimes

//xAddChannelTimes replaced by xAddChannelTimes

//xAddChannelTimes replaced by xAddChannelTimes

//xAddChannelTimes replaced by xAddChannelTimes

module xAddChannelTimes (
  input      [22:0]   A,
  output reg [31:0]   S,
  input               init,
  input               clk,
  input               reset
);

  wire       [31:0]   _zz_S;

  assign _zz_S = {{9{A[22]}}, A};
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      S <= 32'h0;
    end else begin
      if(init) begin
        S <= {{9{A[22]}}, A};
      end else begin
        S <= ($signed(_zz_S) + $signed(S));
      end
    end
  end


endmodule

//xAddTimes_32 replaced by xAddTimes_32

//xAddTimes_32 replaced by xAddTimes_32

//xAddTimes_32 replaced by xAddTimes_32

module xAddTimes_32 (
  input      [39:0]   A_0,
  input      [39:0]   A_1,
  input      [39:0]   A_2,
  input      [39:0]   A_3,
  input      [39:0]   A_4,
  input      [39:0]   A_5,
  input      [39:0]   A_6,
  input      [39:0]   A_7,
  output     [45:0]   S,
  input               clk,
  input               reset
);

  wire       [20:0]   _zz__zz_S;
  wire       [20:0]   _zz__zz_S_1;
  wire       [20:0]   _zz__zz_S_1_1;
  wire       [20:0]   _zz__zz_S_1_2;
  wire       [20:0]   _zz__zz_S_2;
  wire       [20:0]   _zz__zz_S_2_1;
  wire       [20:0]   _zz__zz_S_3;
  wire       [20:0]   _zz__zz_S_3_1;
  wire       [21:0]   _zz__zz_S_4;
  wire       [21:0]   _zz__zz_S_4_1;
  wire       [21:0]   _zz__zz_S_5;
  wire       [21:0]   _zz__zz_S_5_1;
  wire       [22:0]   _zz__zz_S_6;
  wire       [22:0]   _zz__zz_S_6_1;
  wire       [20:0]   _zz__zz_S_7;
  wire       [20:0]   _zz__zz_S_7_1;
  wire       [20:0]   _zz__zz_S_8;
  wire       [20:0]   _zz__zz_S_8_1;
  wire       [20:0]   _zz__zz_S_9;
  wire       [20:0]   _zz__zz_S_9_1;
  wire       [20:0]   _zz__zz_S_10;
  wire       [20:0]   _zz__zz_S_10_1;
  wire       [21:0]   _zz__zz_S_11;
  wire       [21:0]   _zz__zz_S_11_1;
  wire       [21:0]   _zz__zz_S_12;
  wire       [21:0]   _zz__zz_S_12_1;
  wire       [22:0]   _zz__zz_S_13;
  wire       [22:0]   _zz__zz_S_13_1;
  wire       [19:0]   a1Temp_0;
  wire       [19:0]   a1Temp_1;
  wire       [19:0]   a1Temp_2;
  wire       [19:0]   a1Temp_3;
  wire       [19:0]   a1Temp_4;
  wire       [19:0]   a1Temp_5;
  wire       [19:0]   a1Temp_6;
  wire       [19:0]   a1Temp_7;
  wire       [19:0]   a2Temp_0;
  wire       [19:0]   a2Temp_1;
  wire       [19:0]   a2Temp_2;
  wire       [19:0]   a2Temp_3;
  wire       [19:0]   a2Temp_4;
  wire       [19:0]   a2Temp_5;
  wire       [19:0]   a2Temp_6;
  wire       [19:0]   a2Temp_7;
  reg        [20:0]   _zz_S;
  reg        [20:0]   _zz_S_1;
  reg        [20:0]   _zz_S_2;
  reg        [20:0]   _zz_S_3;
  reg        [21:0]   _zz_S_4;
  reg        [21:0]   _zz_S_5;
  reg        [22:0]   _zz_S_6;
  reg        [20:0]   _zz_S_7;
  reg        [20:0]   _zz_S_8;
  reg        [20:0]   _zz_S_9;
  reg        [20:0]   _zz_S_10;
  reg        [21:0]   _zz_S_11;
  reg        [21:0]   _zz_S_12;
  reg        [22:0]   _zz_S_13;

  assign _zz__zz_S = {a2Temp_0[19],a2Temp_0};
  assign _zz__zz_S_1 = {a2Temp_1[19],a2Temp_1};
  assign _zz__zz_S_1_1 = {a2Temp_2[19],a2Temp_2};
  assign _zz__zz_S_1_2 = {a2Temp_3[19],a2Temp_3};
  assign _zz__zz_S_2 = {a2Temp_4[19],a2Temp_4};
  assign _zz__zz_S_2_1 = {a2Temp_5[19],a2Temp_5};
  assign _zz__zz_S_3 = {a2Temp_6[19],a2Temp_6};
  assign _zz__zz_S_3_1 = {a2Temp_7[19],a2Temp_7};
  assign _zz__zz_S_4 = {_zz_S[20],_zz_S};
  assign _zz__zz_S_4_1 = {_zz_S_1[20],_zz_S_1};
  assign _zz__zz_S_5 = {_zz_S_2[20],_zz_S_2};
  assign _zz__zz_S_5_1 = {_zz_S_3[20],_zz_S_3};
  assign _zz__zz_S_6 = {_zz_S_4[21],_zz_S_4};
  assign _zz__zz_S_6_1 = {_zz_S_5[21],_zz_S_5};
  assign _zz__zz_S_7 = {a1Temp_0[19],a1Temp_0};
  assign _zz__zz_S_7_1 = {a1Temp_1[19],a1Temp_1};
  assign _zz__zz_S_8 = {a1Temp_2[19],a1Temp_2};
  assign _zz__zz_S_8_1 = {a1Temp_3[19],a1Temp_3};
  assign _zz__zz_S_9 = {a1Temp_4[19],a1Temp_4};
  assign _zz__zz_S_9_1 = {a1Temp_5[19],a1Temp_5};
  assign _zz__zz_S_10 = {a1Temp_6[19],a1Temp_6};
  assign _zz__zz_S_10_1 = {a1Temp_7[19],a1Temp_7};
  assign _zz__zz_S_11 = {_zz_S_7[20],_zz_S_7};
  assign _zz__zz_S_11_1 = {_zz_S_8[20],_zz_S_8};
  assign _zz__zz_S_12 = {_zz_S_9[20],_zz_S_9};
  assign _zz__zz_S_12_1 = {_zz_S_10[20],_zz_S_10};
  assign _zz__zz_S_13 = {_zz_S_11[21],_zz_S_11};
  assign _zz__zz_S_13_1 = {_zz_S_12[21],_zz_S_12};
  assign a1Temp_0 = A_0[19 : 0];
  assign a2Temp_0 = A_0[39 : 20];
  assign a1Temp_1 = A_1[19 : 0];
  assign a2Temp_1 = A_1[39 : 20];
  assign a1Temp_2 = A_2[19 : 0];
  assign a2Temp_2 = A_2[39 : 20];
  assign a1Temp_3 = A_3[19 : 0];
  assign a2Temp_3 = A_3[39 : 20];
  assign a1Temp_4 = A_4[19 : 0];
  assign a2Temp_4 = A_4[39 : 20];
  assign a1Temp_5 = A_5[19 : 0];
  assign a2Temp_5 = A_5[39 : 20];
  assign a1Temp_6 = A_6[19 : 0];
  assign a2Temp_6 = A_6[39 : 20];
  assign a1Temp_7 = A_7[19 : 0];
  assign a2Temp_7 = A_7[39 : 20];
  assign S = {_zz_S_6,_zz_S_13};
  always @(posedge clk) begin
    _zz_S <= ($signed(_zz__zz_S) + $signed(_zz__zz_S_1));
    _zz_S_1 <= ($signed(_zz__zz_S_1_1) + $signed(_zz__zz_S_1_2));
    _zz_S_2 <= ($signed(_zz__zz_S_2) + $signed(_zz__zz_S_2_1));
    _zz_S_3 <= ($signed(_zz__zz_S_3) + $signed(_zz__zz_S_3_1));
    _zz_S_4 <= ($signed(_zz__zz_S_4) + $signed(_zz__zz_S_4_1));
    _zz_S_5 <= ($signed(_zz__zz_S_5) + $signed(_zz__zz_S_5_1));
    _zz_S_6 <= ($signed(_zz__zz_S_6) + $signed(_zz__zz_S_6_1));
    _zz_S_7 <= ($signed(_zz__zz_S_7) + $signed(_zz__zz_S_7_1));
    _zz_S_8 <= ($signed(_zz__zz_S_8) + $signed(_zz__zz_S_8_1));
    _zz_S_9 <= ($signed(_zz__zz_S_9) + $signed(_zz__zz_S_9_1));
    _zz_S_10 <= ($signed(_zz__zz_S_10) + $signed(_zz__zz_S_10_1));
    _zz_S_11 <= ($signed(_zz__zz_S_11) + $signed(_zz__zz_S_11_1));
    _zz_S_12 <= ($signed(_zz__zz_S_12) + $signed(_zz__zz_S_12_1));
    _zz_S_13 <= ($signed(_zz__zz_S_13) + $signed(_zz__zz_S_13_1));
  end


endmodule

//xAddTimes replaced by xAddTimes

//xAddTimes replaced by xAddTimes

//xAddTimes replaced by xAddTimes

//xAddTimes replaced by xAddTimes

//xAddTimes replaced by xAddTimes

//xAddTimes replaced by xAddTimes

//xAddTimes replaced by xAddTimes

//xAddTimes replaced by xAddTimes

//xAddTimes replaced by xAddTimes

//xAddTimes replaced by xAddTimes

//xAddTimes replaced by xAddTimes

//xAddTimes replaced by xAddTimes

//xAddTimes replaced by xAddTimes

//xAddTimes replaced by xAddTimes

//xAddTimes replaced by xAddTimes

//xAddTimes replaced by xAddTimes

//xAddTimes replaced by xAddTimes

//xAddTimes replaced by xAddTimes

//xAddTimes replaced by xAddTimes

//xAddTimes replaced by xAddTimes

//xAddTimes replaced by xAddTimes

//xAddTimes replaced by xAddTimes

//xAddTimes replaced by xAddTimes

//xAddTimes replaced by xAddTimes

//xAddTimes replaced by xAddTimes

//xAddTimes replaced by xAddTimes

//xAddTimes replaced by xAddTimes

//xAddTimes replaced by xAddTimes

//xAddTimes replaced by xAddTimes

//xAddTimes replaced by xAddTimes

//xAddTimes replaced by xAddTimes

module xAddTimes (
  input      [31:0]   A_0,
  input      [31:0]   A_1,
  input      [31:0]   A_2,
  input      [31:0]   A_3,
  input      [31:0]   A_4,
  input      [31:0]   A_5,
  input      [31:0]   A_6,
  input      [31:0]   A_7,
  input      [31:0]   A_8,
  output     [39:0]   S,
  input               clk,
  input               reset
);

  wire       [16:0]   _zz__zz_S;
  wire       [16:0]   _zz__zz_S_1;
  wire       [16:0]   _zz__zz_S_1_1;
  wire       [16:0]   _zz__zz_S_1_2;
  wire       [16:0]   _zz__zz_S_2;
  wire       [16:0]   _zz__zz_S_2_1;
  wire       [16:0]   _zz__zz_S_3;
  wire       [16:0]   _zz__zz_S_3_1;
  wire       [17:0]   _zz__zz_S_4;
  wire       [17:0]   _zz__zz_S_4_1;
  wire       [17:0]   _zz__zz_S_5;
  wire       [17:0]   _zz__zz_S_5_1;
  wire       [18:0]   _zz__zz_S_6;
  wire       [18:0]   _zz__zz_S_6_1;
  wire       [19:0]   _zz__zz_S_7;
  wire       [19:0]   _zz__zz_S_7_1;
  wire       [16:0]   _zz__zz_S_7_2;
  wire       [16:0]   _zz__zz_S_8;
  wire       [16:0]   _zz__zz_S_8_1;
  wire       [16:0]   _zz__zz_S_9;
  wire       [16:0]   _zz__zz_S_9_1;
  wire       [16:0]   _zz__zz_S_10;
  wire       [16:0]   _zz__zz_S_10_1;
  wire       [16:0]   _zz__zz_S_11;
  wire       [16:0]   _zz__zz_S_11_1;
  wire       [17:0]   _zz__zz_S_12;
  wire       [17:0]   _zz__zz_S_12_1;
  wire       [17:0]   _zz__zz_S_13;
  wire       [17:0]   _zz__zz_S_13_1;
  wire       [18:0]   _zz__zz_S_14;
  wire       [18:0]   _zz__zz_S_14_1;
  wire       [19:0]   _zz__zz_S_15;
  wire       [19:0]   _zz__zz_S_15_1;
  wire       [16:0]   _zz__zz_S_15_2;
  wire       [15:0]   a1Temp_0;
  wire       [15:0]   a1Temp_1;
  wire       [15:0]   a1Temp_2;
  wire       [15:0]   a1Temp_3;
  wire       [15:0]   a1Temp_4;
  wire       [15:0]   a1Temp_5;
  wire       [15:0]   a1Temp_6;
  wire       [15:0]   a1Temp_7;
  wire       [15:0]   a1Temp_8;
  wire       [15:0]   a2Temp_0;
  wire       [15:0]   a2Temp_1;
  wire       [15:0]   a2Temp_2;
  wire       [15:0]   a2Temp_3;
  wire       [15:0]   a2Temp_4;
  wire       [15:0]   a2Temp_5;
  wire       [15:0]   a2Temp_6;
  wire       [15:0]   a2Temp_7;
  wire       [15:0]   a2Temp_8;
  reg        [16:0]   _zz_S;
  reg        [16:0]   _zz_S_1;
  reg        [16:0]   _zz_S_2;
  reg        [16:0]   _zz_S_3;
  reg        [15:0]   a2Temp_8_regNext;
  reg        [17:0]   _zz_S_4;
  reg        [17:0]   _zz_S_5;
  reg        [15:0]   a2Temp_8_regNext_regNext;
  reg        [18:0]   _zz_S_6;
  reg        [15:0]   a2Temp_8_regNext_regNext_regNext;
  reg        [19:0]   _zz_S_7;
  reg        [16:0]   _zz_S_8;
  reg        [16:0]   _zz_S_9;
  reg        [16:0]   _zz_S_10;
  reg        [16:0]   _zz_S_11;
  reg        [15:0]   a1Temp_8_regNext;
  reg        [17:0]   _zz_S_12;
  reg        [17:0]   _zz_S_13;
  reg        [15:0]   a1Temp_8_regNext_regNext;
  reg        [18:0]   _zz_S_14;
  reg        [15:0]   a1Temp_8_regNext_regNext_regNext;
  reg        [19:0]   _zz_S_15;

  assign _zz__zz_S = {a2Temp_0[15],a2Temp_0};
  assign _zz__zz_S_1 = {a2Temp_1[15],a2Temp_1};
  assign _zz__zz_S_1_1 = {a2Temp_2[15],a2Temp_2};
  assign _zz__zz_S_1_2 = {a2Temp_3[15],a2Temp_3};
  assign _zz__zz_S_2 = {a2Temp_4[15],a2Temp_4};
  assign _zz__zz_S_2_1 = {a2Temp_5[15],a2Temp_5};
  assign _zz__zz_S_3 = {a2Temp_6[15],a2Temp_6};
  assign _zz__zz_S_3_1 = {a2Temp_7[15],a2Temp_7};
  assign _zz__zz_S_4 = {_zz_S[16],_zz_S};
  assign _zz__zz_S_4_1 = {_zz_S_1[16],_zz_S_1};
  assign _zz__zz_S_5 = {_zz_S_2[16],_zz_S_2};
  assign _zz__zz_S_5_1 = {_zz_S_3[16],_zz_S_3};
  assign _zz__zz_S_6 = {_zz_S_4[17],_zz_S_4};
  assign _zz__zz_S_6_1 = {_zz_S_5[17],_zz_S_5};
  assign _zz__zz_S_7 = {_zz_S_6[18],_zz_S_6};
  assign _zz__zz_S_7_2 = {a2Temp_8_regNext_regNext_regNext[15],a2Temp_8_regNext_regNext_regNext};
  assign _zz__zz_S_7_1 = {{3{_zz__zz_S_7_2[16]}}, _zz__zz_S_7_2};
  assign _zz__zz_S_8 = {a1Temp_0[15],a1Temp_0};
  assign _zz__zz_S_8_1 = {a1Temp_1[15],a1Temp_1};
  assign _zz__zz_S_9 = {a1Temp_2[15],a1Temp_2};
  assign _zz__zz_S_9_1 = {a1Temp_3[15],a1Temp_3};
  assign _zz__zz_S_10 = {a1Temp_4[15],a1Temp_4};
  assign _zz__zz_S_10_1 = {a1Temp_5[15],a1Temp_5};
  assign _zz__zz_S_11 = {a1Temp_6[15],a1Temp_6};
  assign _zz__zz_S_11_1 = {a1Temp_7[15],a1Temp_7};
  assign _zz__zz_S_12 = {_zz_S_8[16],_zz_S_8};
  assign _zz__zz_S_12_1 = {_zz_S_9[16],_zz_S_9};
  assign _zz__zz_S_13 = {_zz_S_10[16],_zz_S_10};
  assign _zz__zz_S_13_1 = {_zz_S_11[16],_zz_S_11};
  assign _zz__zz_S_14 = {_zz_S_12[17],_zz_S_12};
  assign _zz__zz_S_14_1 = {_zz_S_13[17],_zz_S_13};
  assign _zz__zz_S_15 = {_zz_S_14[18],_zz_S_14};
  assign _zz__zz_S_15_2 = {a1Temp_8_regNext_regNext_regNext[15],a1Temp_8_regNext_regNext_regNext};
  assign _zz__zz_S_15_1 = {{3{_zz__zz_S_15_2[16]}}, _zz__zz_S_15_2};
  assign a1Temp_0 = A_0[15 : 0];
  assign a2Temp_0 = A_0[31 : 16];
  assign a1Temp_1 = A_1[15 : 0];
  assign a2Temp_1 = A_1[31 : 16];
  assign a1Temp_2 = A_2[15 : 0];
  assign a2Temp_2 = A_2[31 : 16];
  assign a1Temp_3 = A_3[15 : 0];
  assign a2Temp_3 = A_3[31 : 16];
  assign a1Temp_4 = A_4[15 : 0];
  assign a2Temp_4 = A_4[31 : 16];
  assign a1Temp_5 = A_5[15 : 0];
  assign a2Temp_5 = A_5[31 : 16];
  assign a1Temp_6 = A_6[15 : 0];
  assign a2Temp_6 = A_6[31 : 16];
  assign a1Temp_7 = A_7[15 : 0];
  assign a2Temp_7 = A_7[31 : 16];
  assign a1Temp_8 = A_8[15 : 0];
  assign a2Temp_8 = A_8[31 : 16];
  assign S = {_zz_S_7,_zz_S_15};
  always @(posedge clk) begin
    _zz_S <= ($signed(_zz__zz_S) + $signed(_zz__zz_S_1));
    _zz_S_1 <= ($signed(_zz__zz_S_1_1) + $signed(_zz__zz_S_1_2));
    _zz_S_2 <= ($signed(_zz__zz_S_2) + $signed(_zz__zz_S_2_1));
    _zz_S_3 <= ($signed(_zz__zz_S_3) + $signed(_zz__zz_S_3_1));
    a2Temp_8_regNext <= a2Temp_8;
    _zz_S_4 <= ($signed(_zz__zz_S_4) + $signed(_zz__zz_S_4_1));
    _zz_S_5 <= ($signed(_zz__zz_S_5) + $signed(_zz__zz_S_5_1));
    a2Temp_8_regNext_regNext <= a2Temp_8_regNext;
    _zz_S_6 <= ($signed(_zz__zz_S_6) + $signed(_zz__zz_S_6_1));
    a2Temp_8_regNext_regNext_regNext <= a2Temp_8_regNext_regNext;
    _zz_S_7 <= ($signed(_zz__zz_S_7) + $signed(_zz__zz_S_7_1));
    _zz_S_8 <= ($signed(_zz__zz_S_8) + $signed(_zz__zz_S_8_1));
    _zz_S_9 <= ($signed(_zz__zz_S_9) + $signed(_zz__zz_S_9_1));
    _zz_S_10 <= ($signed(_zz__zz_S_10) + $signed(_zz__zz_S_10_1));
    _zz_S_11 <= ($signed(_zz__zz_S_11) + $signed(_zz__zz_S_11_1));
    a1Temp_8_regNext <= a1Temp_8;
    _zz_S_12 <= ($signed(_zz__zz_S_12) + $signed(_zz__zz_S_12_1));
    _zz_S_13 <= ($signed(_zz__zz_S_13) + $signed(_zz__zz_S_13_1));
    a1Temp_8_regNext_regNext <= a1Temp_8_regNext;
    _zz_S_14 <= ($signed(_zz__zz_S_14) + $signed(_zz__zz_S_14_1));
    a1Temp_8_regNext_regNext_regNext <= a1Temp_8_regNext_regNext;
    _zz_S_15 <= ($signed(_zz__zz_S_15) + $signed(_zz__zz_S_15_1));
  end


endmodule

//WaXpmSyncFifo replaced by WaXpmSyncFifo

//WaXpmSyncFifo replaced by WaXpmSyncFifo

//WaXpmSyncFifo replaced by WaXpmSyncFifo

//WaXpmSyncFifo replaced by WaXpmSyncFifo

//WaXpmSyncFifo replaced by WaXpmSyncFifo

//WaXpmSyncFifo replaced by WaXpmSyncFifo

//WaXpmSyncFifo replaced by WaXpmSyncFifo

//WaXpmSyncFifo replaced by WaXpmSyncFifo

module WaXpmSyncFifo (
  input      [11:0]   sCount,
  input      [11:0]   mCount,
  output reg          sReady,
  output reg          mReady,
  input               reset,
  input               clk,
  input               dataIn_valid,
  input      [63:0]   dataIn_payload,
  input               rd_en,
  output     [63:0]   dout
);

  wire                fifo_full;
  wire                fifo_empty;
  wire       [63:0]   fifo_dout;
  wire       [11:0]   fifo_wr_data_count;
  wire       [11:0]   fifo_rd_data_count;
  wire                fifo_data_valid;
  wire                fifo_rd_rst_busy;
  wire                fifo_wr_rst_busy;
  wire       [11:0]   _zz_when_WaFifo_l64;
  wire                when_WaFifo_l64;
  wire                when_WaFifo_l69;

  assign _zz_when_WaFifo_l64 = (fifo_wr_data_count + sCount);
  FifoSync fifo (
    .full          (fifo_full               ), //o
    .wr_en         (dataIn_valid            ), //i
    .din           (dataIn_payload[63:0]    ), //i
    .empty         (fifo_empty              ), //o
    .dout          (fifo_dout[63:0]         ), //o
    .rd_en         (rd_en                   ), //i
    .wr_data_count (fifo_wr_data_count[11:0]), //o
    .rd_data_count (fifo_rd_data_count[11:0]), //o
    .data_valid    (fifo_data_valid         ), //o
    .rd_rst_busy   (fifo_rd_rst_busy        ), //o
    .wr_rst_busy   (fifo_wr_rst_busy        ), //o
    .reset         (reset                   ), //i
    .clk           (clk                     )  //i
  );
  assign dout = fifo_dout;
  assign when_WaFifo_l64 = (_zz_when_WaFifo_l64 < 12'h7f6);
  always @(*) begin
    if(when_WaFifo_l64) begin
      sReady = 1'b1;
    end else begin
      sReady = 1'b0;
    end
  end

  assign when_WaFifo_l69 = (mCount <= fifo_rd_data_count);
  always @(*) begin
    if(when_WaFifo_l69) begin
      mReady = 1'b1;
    end else begin
      mReady = 1'b0;
    end
  end


endmodule

module LoadWeight (
  input               start,
  input               sData_valid,
  output reg          sData_ready,
  input      [63:0]   sData_payload,
  input      [12:0]   weightNum,
  input      [8:0]    quanNum,
  input      [9:0]    weightRead_0_addr,
  output     [511:0]  weightRead_0_data,
  input      [9:0]    weightRead_1_addr,
  output     [511:0]  weightRead_1_data,
  input      [9:0]    weightRead_2_addr,
  output     [511:0]  weightRead_2_data,
  input      [9:0]    weightRead_3_addr,
  output     [511:0]  weightRead_3_data,
  input      [9:0]    weightRead_4_addr,
  output     [511:0]  weightRead_4_data,
  input      [9:0]    weightRead_5_addr,
  output     [511:0]  weightRead_5_data,
  input      [9:0]    weightRead_6_addr,
  output     [511:0]  weightRead_6_data,
  input      [9:0]    weightRead_7_addr,
  output     [511:0]  weightRead_7_data,
  input      [9:0]    weightRead_8_addr,
  output     [511:0]  weightRead_8_data,
  input      [6:0]    biasRead_addr,
  output     [255:0]  biasRead_data,
  input      [6:0]    scaleRead_addr,
  output     [255:0]  scaleRead_data,
  input      [6:0]    shiftRead_addr,
  output     [255:0]  shiftRead_data,
  output reg          copyWeightDone,
  input      [1:0]    convType,
  input      [11:0]   channelIn,
  input      [11:0]   channelOut,
  input               clk,
  input               reset
);
  localparam LoadWeightEnum_IDLE = 6'd1;
  localparam LoadWeightEnum_INIT = 6'd2;
  localparam LoadWeightEnum_COPY_WEIGHT = 6'd4;
  localparam LoadWeightEnum_COPY_BIAS = 6'd8;
  localparam LoadWeightEnum_COPY_SCALE = 6'd16;
  localparam LoadWeightEnum_COPY_SHIFT = 6'd32;

  wire       [12:0]   weightRam_0_addra;
  wire       [9:0]    weightRam_0_addrb;
  wire       [63:0]   weightRam_0_dina;
  wire       [0:0]    weightRam_0_wea;
  wire       [12:0]   weightRam_1_addra;
  wire       [9:0]    weightRam_1_addrb;
  wire       [63:0]   weightRam_1_dina;
  wire       [0:0]    weightRam_1_wea;
  wire       [12:0]   weightRam_2_addra;
  wire       [9:0]    weightRam_2_addrb;
  wire       [63:0]   weightRam_2_dina;
  wire       [0:0]    weightRam_2_wea;
  wire       [12:0]   weightRam_3_addra;
  wire       [9:0]    weightRam_3_addrb;
  wire       [63:0]   weightRam_3_dina;
  wire       [0:0]    weightRam_3_wea;
  wire       [12:0]   weightRam_4_addra;
  wire       [9:0]    weightRam_4_addrb;
  wire       [63:0]   weightRam_4_dina;
  wire       [0:0]    weightRam_4_wea;
  wire       [12:0]   weightRam_5_addra;
  wire       [9:0]    weightRam_5_addrb;
  wire       [63:0]   weightRam_5_dina;
  wire       [0:0]    weightRam_5_wea;
  wire       [12:0]   weightRam_6_addra;
  wire       [9:0]    weightRam_6_addrb;
  wire       [63:0]   weightRam_6_dina;
  wire       [0:0]    weightRam_6_wea;
  wire       [12:0]   weightRam_7_addra;
  wire       [9:0]    weightRam_7_addrb;
  wire       [63:0]   weightRam_7_dina;
  wire       [0:0]    weightRam_7_wea;
  wire       [12:0]   weightRam_8_addra;
  wire       [9:0]    weightRam_8_addrb;
  wire       [63:0]   weightRam_8_dina;
  wire       [0:0]    weightRam_8_wea;
  wire       [8:0]    copyBias_ram_addra;
  wire       [6:0]    copyBias_ram_addrb;
  wire       [63:0]   copyBias_ram_dina;
  wire       [0:0]    copyBias_ram_wea;
  wire       [8:0]    copyScale_ram_addra;
  wire       [6:0]    copyScale_ram_addrb;
  wire       [63:0]   copyScale_ram_dina;
  wire       [0:0]    copyScale_ram_wea;
  wire       [8:0]    copyShift_ram_addra;
  wire       [6:0]    copyShift_ram_addrb;
  wire       [63:0]   copyShift_ram_dina;
  wire       [0:0]    copyShift_ram_wea;
  wire       [511:0]  weightRam_0_doutb;
  wire       [511:0]  weightRam_1_doutb;
  wire       [511:0]  weightRam_2_doutb;
  wire       [511:0]  weightRam_3_doutb;
  wire       [511:0]  weightRam_4_doutb;
  wire       [511:0]  weightRam_5_doutb;
  wire       [511:0]  weightRam_6_doutb;
  wire       [511:0]  weightRam_7_doutb;
  wire       [511:0]  weightRam_8_doutb;
  wire       [255:0]  copyBias_ram_doutb;
  wire       [255:0]  copyScale_ram_doutb;
  wire       [255:0]  copyShift_ram_doutb;
  wire       [12:0]   _zz_when_WaCounter_l12_1;
  wire       [8:0]    _zz_when_WaCounter_l12_3;
  wire       [11:0]   _zz_when_WaCounter_l12_6;
  wire       [12:0]   _zz_when_Weight_l191;
  wire       [12:0]   _zz_when_Weight_l191_1;
  wire       [12:0]   _zz_when_Weight_l191_2;
  wire       [12:0]   _zz_when_Weight_l191_3;
  wire       [12:0]   _zz_when_Weight_l191_4;
  wire       [12:0]   _zz_when_Weight_l191_5;
  wire       [12:0]   _zz_when_Weight_l191_6;
  wire       [12:0]   _zz_when_Weight_l191_7;
  wire       [12:0]   _zz_when_Weight_l191_8;
  wire       [8:0]    _zz_when_WaCounter_l12_7;
  wire       [8:0]    _zz_when_WaCounter_l12_8;
  wire       [8:0]    _zz_when_WaCounter_l12_9;
  wire       [8:0]    channelInTimes;
  wire                fsm_initEnd;
  reg                 fsm_copyWeightEnd;
  wire                fsm_copyBiasEnd;
  wire                fsm_copyScaleEnd;
  wire                fsm_copyShiftEnd;
  reg        [5:0]    fsm_currentState;
  reg        [5:0]    fsm_nextState;
  wire                when_WaCounter_l17;
  reg        [2:0]    init_count;
  reg                 init_valid;
  wire                when_WaCounter_l12;
  wire                sData_fire;
  wire                when_WaCounter_l17_1;
  reg        [12:0]   copyWeightCnt_count;
  reg                 copyWeightCnt_valid;
  wire                when_WaCounter_l12_1;
  reg        [3:0]    copyWeightTimes_count;
  reg                 copyWeightTimes_valid;
  wire                when_WaCounter_l12_2;
  wire                sData_fire_1;
  wire                when_WaCounter_l17_2;
  reg        [8:0]    channelInCnt_count;
  reg                 channelInCnt_valid;
  wire                when_WaCounter_l12_3;
  wire                sData_fire_2;
  wire                when_WaCounter_l17_3;
  reg        [2:0]    computeChannelOut_count;
  reg                 computeChannelOut_valid;
  wire                when_WaCounter_l12_4;
  reg        [2:0]    times_count;
  reg                 times_valid;
  wire                when_WaCounter_l12_5;
  reg        [11:0]   channelOutCnt_count;
  reg                 channelOutCnt_valid;
  wire                when_WaCounter_l12_6;
  wire                when_Weight_l119;
  wire                when_Weight_l126;
  wire                when_Weight_l128;
  wire                when_Weight_l133;
  reg                 weav_0;
  reg                 weav_1;
  reg                 weav_2;
  reg                 weav_3;
  reg                 weav_4;
  reg                 weav_5;
  reg                 weav_6;
  reg                 weav_7;
  reg                 weav_8;
  wire                sData_fire_3;
  wire                when_Weight_l141;
  wire                when_Weight_l142;
  wire                when_Weight_l161;
  reg        [12:0]   addr_0;
  reg        [12:0]   addr_1;
  reg        [12:0]   addr_2;
  reg        [12:0]   addr_3;
  reg        [12:0]   addr_4;
  reg        [12:0]   addr_5;
  reg        [12:0]   addr_6;
  reg        [12:0]   addr_7;
  reg        [12:0]   addr_8;
  wire                when_Weight_l191;
  wire                when_Weight_l191_1;
  wire                when_Weight_l191_2;
  wire                when_Weight_l191_3;
  wire                when_Weight_l191_4;
  wire                when_Weight_l191_5;
  wire                when_Weight_l191_6;
  wire                when_Weight_l191_7;
  wire                when_Weight_l191_8;
  wire                sData_fire_4;
  wire                when_WaCounter_l17_4;
  wire                sData_fire_5;
  reg        [8:0]    copyBias_copyCnt_count;
  reg                 copyBias_copyCnt_valid;
  wire                when_WaCounter_l12_7;
  wire                sData_fire_6;
  wire                when_WaCounter_l17_5;
  wire                sData_fire_7;
  reg        [8:0]    copyScale_copyCnt_count;
  reg                 copyScale_copyCnt_valid;
  wire                when_WaCounter_l12_8;
  wire                sData_fire_8;
  wire                when_WaCounter_l17_6;
  wire                sData_fire_9;
  reg        [8:0]    copyShift_copyCnt_count;
  reg                 copyShift_copyCnt_valid;
  wire                when_WaCounter_l12_9;
  wire                when_WaUtil_l29;
  `ifndef SYNTHESIS
  reg [87:0] fsm_currentState_string;
  reg [87:0] fsm_nextState_string;
  `endif


  assign _zz_when_WaCounter_l12_1 = (weightNum - 13'h0001);
  assign _zz_when_WaCounter_l12_3 = (channelInTimes - 9'h001);
  assign _zz_when_WaCounter_l12_6 = (channelOut - 12'h001);
  assign _zz_when_Weight_l191 = (weightNum - 13'h0001);
  assign _zz_when_Weight_l191_1 = (weightNum - 13'h0001);
  assign _zz_when_Weight_l191_2 = (weightNum - 13'h0001);
  assign _zz_when_Weight_l191_3 = (weightNum - 13'h0001);
  assign _zz_when_Weight_l191_4 = (weightNum - 13'h0001);
  assign _zz_when_Weight_l191_5 = (weightNum - 13'h0001);
  assign _zz_when_Weight_l191_6 = (weightNum - 13'h0001);
  assign _zz_when_Weight_l191_7 = (weightNum - 13'h0001);
  assign _zz_when_Weight_l191_8 = (weightNum - 13'h0001);
  assign _zz_when_WaCounter_l12_7 = (quanNum - 9'h001);
  assign _zz_when_WaCounter_l12_8 = (quanNum - 9'h001);
  assign _zz_when_WaCounter_l12_9 = (quanNum - 9'h001);
  sdpram weightRam_0 (
    .doutb (weightRam_0_doutb[511:0]), //o
    .addra (weightRam_0_addra[12:0] ), //i
    .addrb (weightRam_0_addrb[9:0]  ), //i
    .dina  (weightRam_0_dina[63:0]  ), //i
    .ena   (1'b1                    ), //i
    .enb   (1'b1                    ), //i
    .wea   (weightRam_0_wea         ), //i
    .clk   (clk                     )  //i
  );
  sdpram weightRam_1 (
    .doutb (weightRam_1_doutb[511:0]), //o
    .addra (weightRam_1_addra[12:0] ), //i
    .addrb (weightRam_1_addrb[9:0]  ), //i
    .dina  (weightRam_1_dina[63:0]  ), //i
    .ena   (1'b1                    ), //i
    .enb   (1'b1                    ), //i
    .wea   (weightRam_1_wea         ), //i
    .clk   (clk                     )  //i
  );
  sdpram weightRam_2 (
    .doutb (weightRam_2_doutb[511:0]), //o
    .addra (weightRam_2_addra[12:0] ), //i
    .addrb (weightRam_2_addrb[9:0]  ), //i
    .dina  (weightRam_2_dina[63:0]  ), //i
    .ena   (1'b1                    ), //i
    .enb   (1'b1                    ), //i
    .wea   (weightRam_2_wea         ), //i
    .clk   (clk                     )  //i
  );
  sdpram weightRam_3 (
    .doutb (weightRam_3_doutb[511:0]), //o
    .addra (weightRam_3_addra[12:0] ), //i
    .addrb (weightRam_3_addrb[9:0]  ), //i
    .dina  (weightRam_3_dina[63:0]  ), //i
    .ena   (1'b1                    ), //i
    .enb   (1'b1                    ), //i
    .wea   (weightRam_3_wea         ), //i
    .clk   (clk                     )  //i
  );
  sdpram weightRam_4 (
    .doutb (weightRam_4_doutb[511:0]), //o
    .addra (weightRam_4_addra[12:0] ), //i
    .addrb (weightRam_4_addrb[9:0]  ), //i
    .dina  (weightRam_4_dina[63:0]  ), //i
    .ena   (1'b1                    ), //i
    .enb   (1'b1                    ), //i
    .wea   (weightRam_4_wea         ), //i
    .clk   (clk                     )  //i
  );
  sdpram weightRam_5 (
    .doutb (weightRam_5_doutb[511:0]), //o
    .addra (weightRam_5_addra[12:0] ), //i
    .addrb (weightRam_5_addrb[9:0]  ), //i
    .dina  (weightRam_5_dina[63:0]  ), //i
    .ena   (1'b1                    ), //i
    .enb   (1'b1                    ), //i
    .wea   (weightRam_5_wea         ), //i
    .clk   (clk                     )  //i
  );
  sdpram weightRam_6 (
    .doutb (weightRam_6_doutb[511:0]), //o
    .addra (weightRam_6_addra[12:0] ), //i
    .addrb (weightRam_6_addrb[9:0]  ), //i
    .dina  (weightRam_6_dina[63:0]  ), //i
    .ena   (1'b1                    ), //i
    .enb   (1'b1                    ), //i
    .wea   (weightRam_6_wea         ), //i
    .clk   (clk                     )  //i
  );
  sdpram weightRam_7 (
    .doutb (weightRam_7_doutb[511:0]), //o
    .addra (weightRam_7_addra[12:0] ), //i
    .addrb (weightRam_7_addrb[9:0]  ), //i
    .dina  (weightRam_7_dina[63:0]  ), //i
    .ena   (1'b1                    ), //i
    .enb   (1'b1                    ), //i
    .wea   (weightRam_7_wea         ), //i
    .clk   (clk                     )  //i
  );
  sdpram weightRam_8 (
    .doutb (weightRam_8_doutb[511:0]), //o
    .addra (weightRam_8_addra[12:0] ), //i
    .addrb (weightRam_8_addrb[9:0]  ), //i
    .dina  (weightRam_8_dina[63:0]  ), //i
    .ena   (1'b1                    ), //i
    .enb   (1'b1                    ), //i
    .wea   (weightRam_8_wea         ), //i
    .clk   (clk                     )  //i
  );
  sdpram_9 copyBias_ram (
    .doutb (copyBias_ram_doutb[255:0]), //o
    .addra (copyBias_ram_addra[8:0]  ), //i
    .addrb (copyBias_ram_addrb[6:0]  ), //i
    .dina  (copyBias_ram_dina[63:0]  ), //i
    .ena   (1'b1                     ), //i
    .enb   (1'b1                     ), //i
    .wea   (copyBias_ram_wea         ), //i
    .clk   (clk                      )  //i
  );
  sdpram_9 copyScale_ram (
    .doutb (copyScale_ram_doutb[255:0]), //o
    .addra (copyScale_ram_addra[8:0]  ), //i
    .addrb (copyScale_ram_addrb[6:0]  ), //i
    .dina  (copyScale_ram_dina[63:0]  ), //i
    .ena   (1'b1                      ), //i
    .enb   (1'b1                      ), //i
    .wea   (copyScale_ram_wea         ), //i
    .clk   (clk                       )  //i
  );
  sdpram_9 copyShift_ram (
    .doutb (copyShift_ram_doutb[255:0]), //o
    .addra (copyShift_ram_addra[8:0]  ), //i
    .addrb (copyShift_ram_addrb[6:0]  ), //i
    .dina  (copyShift_ram_dina[63:0]  ), //i
    .ena   (1'b1                      ), //i
    .enb   (1'b1                      ), //i
    .wea   (copyShift_ram_wea         ), //i
    .clk   (clk                       )  //i
  );
  `ifndef SYNTHESIS
  always @(*) begin
    case(fsm_currentState)
      LoadWeightEnum_IDLE : fsm_currentState_string = "IDLE       ";
      LoadWeightEnum_INIT : fsm_currentState_string = "INIT       ";
      LoadWeightEnum_COPY_WEIGHT : fsm_currentState_string = "COPY_WEIGHT";
      LoadWeightEnum_COPY_BIAS : fsm_currentState_string = "COPY_BIAS  ";
      LoadWeightEnum_COPY_SCALE : fsm_currentState_string = "COPY_SCALE ";
      LoadWeightEnum_COPY_SHIFT : fsm_currentState_string = "COPY_SHIFT ";
      default : fsm_currentState_string = "???????????";
    endcase
  end
  always @(*) begin
    case(fsm_nextState)
      LoadWeightEnum_IDLE : fsm_nextState_string = "IDLE       ";
      LoadWeightEnum_INIT : fsm_nextState_string = "INIT       ";
      LoadWeightEnum_COPY_WEIGHT : fsm_nextState_string = "COPY_WEIGHT";
      LoadWeightEnum_COPY_BIAS : fsm_nextState_string = "COPY_BIAS  ";
      LoadWeightEnum_COPY_SCALE : fsm_nextState_string = "COPY_SCALE ";
      LoadWeightEnum_COPY_SHIFT : fsm_nextState_string = "COPY_SHIFT ";
      default : fsm_nextState_string = "???????????";
    endcase
  end
  `endif

  assign channelInTimes = (channelIn >>> 3);
  always @(*) begin
    (* parallel_case *)
    case(1) // synthesis parallel_case
      (((fsm_currentState) & LoadWeightEnum_IDLE) == LoadWeightEnum_IDLE) : begin
        if(start) begin
          fsm_nextState = LoadWeightEnum_INIT;
        end else begin
          fsm_nextState = LoadWeightEnum_IDLE;
        end
      end
      (((fsm_currentState) & LoadWeightEnum_INIT) == LoadWeightEnum_INIT) : begin
        if(fsm_initEnd) begin
          fsm_nextState = LoadWeightEnum_COPY_WEIGHT;
        end else begin
          fsm_nextState = LoadWeightEnum_INIT;
        end
      end
      (((fsm_currentState) & LoadWeightEnum_COPY_WEIGHT) == LoadWeightEnum_COPY_WEIGHT) : begin
        if(fsm_copyWeightEnd) begin
          fsm_nextState = LoadWeightEnum_COPY_BIAS;
        end else begin
          fsm_nextState = LoadWeightEnum_COPY_WEIGHT;
        end
      end
      (((fsm_currentState) & LoadWeightEnum_COPY_BIAS) == LoadWeightEnum_COPY_BIAS) : begin
        if(fsm_copyBiasEnd) begin
          fsm_nextState = LoadWeightEnum_COPY_SCALE;
        end else begin
          fsm_nextState = LoadWeightEnum_COPY_BIAS;
        end
      end
      (((fsm_currentState) & LoadWeightEnum_COPY_SCALE) == LoadWeightEnum_COPY_SCALE) : begin
        if(fsm_copyScaleEnd) begin
          fsm_nextState = LoadWeightEnum_COPY_SHIFT;
        end else begin
          fsm_nextState = LoadWeightEnum_COPY_SCALE;
        end
      end
      default : begin
        if(fsm_copyShiftEnd) begin
          fsm_nextState = LoadWeightEnum_IDLE;
        end else begin
          fsm_nextState = LoadWeightEnum_COPY_SHIFT;
        end
      end
    endcase
  end

  assign when_WaCounter_l17 = ((fsm_currentState & LoadWeightEnum_INIT) != 6'b000000);
  assign when_WaCounter_l12 = (init_count == 3'b101);
  always @(*) begin
    if(when_WaCounter_l12) begin
      init_valid = 1'b1;
    end else begin
      init_valid = 1'b0;
    end
  end

  assign fsm_initEnd = init_valid;
  assign sData_fire = (sData_valid && sData_ready);
  assign when_WaCounter_l17_1 = (((fsm_currentState & LoadWeightEnum_COPY_WEIGHT) != 6'b000000) && sData_fire);
  assign when_WaCounter_l12_1 = (copyWeightCnt_count == _zz_when_WaCounter_l12_1);
  always @(*) begin
    if(when_WaCounter_l12_1) begin
      copyWeightCnt_valid = 1'b1;
    end else begin
      copyWeightCnt_valid = 1'b0;
    end
    if(when_Weight_l119) begin
      copyWeightCnt_valid = 1'b0;
    end
  end

  assign when_WaCounter_l12_2 = (copyWeightTimes_count == 4'b1000);
  always @(*) begin
    if(when_WaCounter_l12_2) begin
      copyWeightTimes_valid = 1'b1;
    end else begin
      copyWeightTimes_valid = 1'b0;
    end
    if(when_Weight_l119) begin
      copyWeightTimes_valid = 1'b0;
    end
  end

  assign sData_fire_1 = (sData_valid && sData_ready);
  assign when_WaCounter_l17_2 = (((fsm_currentState & LoadWeightEnum_COPY_WEIGHT) != 6'b000000) && sData_fire_1);
  assign when_WaCounter_l12_3 = (channelInCnt_count == _zz_when_WaCounter_l12_3);
  always @(*) begin
    if(when_WaCounter_l12_3) begin
      channelInCnt_valid = 1'b1;
    end else begin
      channelInCnt_valid = 1'b0;
    end
    if(when_Weight_l119) begin
      channelInCnt_valid = 1'b0;
    end
  end

  assign sData_fire_2 = (sData_valid && sData_ready);
  assign when_WaCounter_l17_3 = (((fsm_currentState & LoadWeightEnum_COPY_WEIGHT) != 6'b000000) && sData_fire_2);
  assign when_WaCounter_l12_4 = (computeChannelOut_count == 3'b111);
  always @(*) begin
    if(when_WaCounter_l12_4) begin
      computeChannelOut_valid = 1'b1;
    end else begin
      computeChannelOut_valid = 1'b0;
    end
  end

  assign when_WaCounter_l12_5 = (times_count == 3'b111);
  always @(*) begin
    if(when_WaCounter_l12_5) begin
      times_valid = 1'b1;
    end else begin
      times_valid = 1'b0;
    end
  end

  assign when_WaCounter_l12_6 = (channelOutCnt_count == _zz_when_WaCounter_l12_6);
  always @(*) begin
    if(when_WaCounter_l12_6) begin
      channelOutCnt_valid = 1'b1;
    end else begin
      channelOutCnt_valid = 1'b0;
    end
    if(when_Weight_l119) begin
      channelOutCnt_valid = 1'b0;
    end
  end

  assign when_Weight_l119 = ((fsm_currentState & LoadWeightEnum_IDLE) != 6'b000000);
  assign when_Weight_l126 = (convType == 2'b00);
  always @(*) begin
    if(when_Weight_l126) begin
      fsm_copyWeightEnd = (copyWeightCnt_valid && copyWeightTimes_valid);
    end else begin
      if(when_Weight_l128) begin
        fsm_copyWeightEnd = (channelInCnt_valid && channelOutCnt_valid);
      end else begin
        fsm_copyWeightEnd = 1'b0;
      end
    end
  end

  assign when_Weight_l128 = (convType == 2'b01);
  assign when_Weight_l133 = (((((fsm_currentState & LoadWeightEnum_COPY_WEIGHT) != 6'b000000) || ((fsm_currentState & LoadWeightEnum_COPY_SHIFT) != 6'b000000)) || ((fsm_currentState & LoadWeightEnum_COPY_BIAS) != 6'b000000)) || ((fsm_currentState & LoadWeightEnum_COPY_SCALE) != 6'b000000));
  always @(*) begin
    if(when_Weight_l133) begin
      sData_ready = 1'b1;
    end else begin
      sData_ready = 1'b0;
    end
  end

  assign sData_fire_3 = (sData_valid && sData_ready);
  assign when_Weight_l141 = (sData_fire_3 && ((fsm_currentState & LoadWeightEnum_COPY_WEIGHT) != 6'b000000));
  assign when_Weight_l142 = (convType == 2'b00);
  always @(*) begin
    if(when_Weight_l141) begin
      if(when_Weight_l142) begin
        case(copyWeightTimes_count)
          4'b0000 : begin
            weav_0 = 1'b1;
          end
          4'b0001 : begin
            weav_0 = 1'b0;
          end
          4'b0010 : begin
            weav_0 = 1'b0;
          end
          4'b0011 : begin
            weav_0 = 1'b0;
          end
          4'b0100 : begin
            weav_0 = 1'b0;
          end
          4'b0101 : begin
            weav_0 = 1'b0;
          end
          4'b0110 : begin
            weav_0 = 1'b0;
          end
          4'b0111 : begin
            weav_0 = 1'b0;
          end
          4'b1000 : begin
            weav_0 = 1'b0;
          end
          default : begin
            weav_0 = 1'b0;
          end
        endcase
      end else begin
        if(when_Weight_l161) begin
          case(times_count)
            3'b000 : begin
              weav_0 = 1'b1;
            end
            3'b001 : begin
              weav_0 = 1'b0;
            end
            3'b010 : begin
              weav_0 = 1'b0;
            end
            3'b011 : begin
              weav_0 = 1'b0;
            end
            3'b100 : begin
              weav_0 = 1'b0;
            end
            3'b101 : begin
              weav_0 = 1'b0;
            end
            3'b110 : begin
              weav_0 = 1'b0;
            end
            default : begin
              weav_0 = 1'b0;
            end
          endcase
        end else begin
          weav_0 = 1'b0;
        end
      end
    end else begin
      weav_0 = 1'b0;
    end
  end

  always @(*) begin
    if(when_Weight_l141) begin
      if(when_Weight_l142) begin
        case(copyWeightTimes_count)
          4'b0000 : begin
            weav_1 = 1'b0;
          end
          4'b0001 : begin
            weav_1 = 1'b1;
          end
          4'b0010 : begin
            weav_1 = 1'b0;
          end
          4'b0011 : begin
            weav_1 = 1'b0;
          end
          4'b0100 : begin
            weav_1 = 1'b0;
          end
          4'b0101 : begin
            weav_1 = 1'b0;
          end
          4'b0110 : begin
            weav_1 = 1'b0;
          end
          4'b0111 : begin
            weav_1 = 1'b0;
          end
          4'b1000 : begin
            weav_1 = 1'b0;
          end
          default : begin
            weav_1 = 1'b0;
          end
        endcase
      end else begin
        if(when_Weight_l161) begin
          case(times_count)
            3'b000 : begin
              weav_1 = 1'b0;
            end
            3'b001 : begin
              weav_1 = 1'b1;
            end
            3'b010 : begin
              weav_1 = 1'b0;
            end
            3'b011 : begin
              weav_1 = 1'b0;
            end
            3'b100 : begin
              weav_1 = 1'b0;
            end
            3'b101 : begin
              weav_1 = 1'b0;
            end
            3'b110 : begin
              weav_1 = 1'b0;
            end
            default : begin
              weav_1 = 1'b0;
            end
          endcase
        end else begin
          weav_1 = 1'b0;
        end
      end
    end else begin
      weav_1 = 1'b0;
    end
  end

  always @(*) begin
    if(when_Weight_l141) begin
      if(when_Weight_l142) begin
        case(copyWeightTimes_count)
          4'b0000 : begin
            weav_2 = 1'b0;
          end
          4'b0001 : begin
            weav_2 = 1'b0;
          end
          4'b0010 : begin
            weav_2 = 1'b1;
          end
          4'b0011 : begin
            weav_2 = 1'b0;
          end
          4'b0100 : begin
            weav_2 = 1'b0;
          end
          4'b0101 : begin
            weav_2 = 1'b0;
          end
          4'b0110 : begin
            weav_2 = 1'b0;
          end
          4'b0111 : begin
            weav_2 = 1'b0;
          end
          4'b1000 : begin
            weav_2 = 1'b0;
          end
          default : begin
            weav_2 = 1'b0;
          end
        endcase
      end else begin
        if(when_Weight_l161) begin
          case(times_count)
            3'b000 : begin
              weav_2 = 1'b0;
            end
            3'b001 : begin
              weav_2 = 1'b0;
            end
            3'b010 : begin
              weav_2 = 1'b1;
            end
            3'b011 : begin
              weav_2 = 1'b0;
            end
            3'b100 : begin
              weav_2 = 1'b0;
            end
            3'b101 : begin
              weav_2 = 1'b0;
            end
            3'b110 : begin
              weav_2 = 1'b0;
            end
            default : begin
              weav_2 = 1'b0;
            end
          endcase
        end else begin
          weav_2 = 1'b0;
        end
      end
    end else begin
      weav_2 = 1'b0;
    end
  end

  always @(*) begin
    if(when_Weight_l141) begin
      if(when_Weight_l142) begin
        case(copyWeightTimes_count)
          4'b0000 : begin
            weav_3 = 1'b0;
          end
          4'b0001 : begin
            weav_3 = 1'b0;
          end
          4'b0010 : begin
            weav_3 = 1'b0;
          end
          4'b0011 : begin
            weav_3 = 1'b1;
          end
          4'b0100 : begin
            weav_3 = 1'b0;
          end
          4'b0101 : begin
            weav_3 = 1'b0;
          end
          4'b0110 : begin
            weav_3 = 1'b0;
          end
          4'b0111 : begin
            weav_3 = 1'b0;
          end
          4'b1000 : begin
            weav_3 = 1'b0;
          end
          default : begin
            weav_3 = 1'b0;
          end
        endcase
      end else begin
        if(when_Weight_l161) begin
          case(times_count)
            3'b000 : begin
              weav_3 = 1'b0;
            end
            3'b001 : begin
              weav_3 = 1'b0;
            end
            3'b010 : begin
              weav_3 = 1'b0;
            end
            3'b011 : begin
              weav_3 = 1'b1;
            end
            3'b100 : begin
              weav_3 = 1'b0;
            end
            3'b101 : begin
              weav_3 = 1'b0;
            end
            3'b110 : begin
              weav_3 = 1'b0;
            end
            default : begin
              weav_3 = 1'b0;
            end
          endcase
        end else begin
          weav_3 = 1'b0;
        end
      end
    end else begin
      weav_3 = 1'b0;
    end
  end

  always @(*) begin
    if(when_Weight_l141) begin
      if(when_Weight_l142) begin
        case(copyWeightTimes_count)
          4'b0000 : begin
            weav_4 = 1'b0;
          end
          4'b0001 : begin
            weav_4 = 1'b0;
          end
          4'b0010 : begin
            weav_4 = 1'b0;
          end
          4'b0011 : begin
            weav_4 = 1'b0;
          end
          4'b0100 : begin
            weav_4 = 1'b1;
          end
          4'b0101 : begin
            weav_4 = 1'b0;
          end
          4'b0110 : begin
            weav_4 = 1'b0;
          end
          4'b0111 : begin
            weav_4 = 1'b0;
          end
          4'b1000 : begin
            weav_4 = 1'b0;
          end
          default : begin
            weav_4 = 1'b0;
          end
        endcase
      end else begin
        if(when_Weight_l161) begin
          case(times_count)
            3'b000 : begin
              weav_4 = 1'b0;
            end
            3'b001 : begin
              weav_4 = 1'b0;
            end
            3'b010 : begin
              weav_4 = 1'b0;
            end
            3'b011 : begin
              weav_4 = 1'b0;
            end
            3'b100 : begin
              weav_4 = 1'b1;
            end
            3'b101 : begin
              weav_4 = 1'b0;
            end
            3'b110 : begin
              weav_4 = 1'b0;
            end
            default : begin
              weav_4 = 1'b0;
            end
          endcase
        end else begin
          weav_4 = 1'b0;
        end
      end
    end else begin
      weav_4 = 1'b0;
    end
  end

  always @(*) begin
    if(when_Weight_l141) begin
      if(when_Weight_l142) begin
        case(copyWeightTimes_count)
          4'b0000 : begin
            weav_5 = 1'b0;
          end
          4'b0001 : begin
            weav_5 = 1'b0;
          end
          4'b0010 : begin
            weav_5 = 1'b0;
          end
          4'b0011 : begin
            weav_5 = 1'b0;
          end
          4'b0100 : begin
            weav_5 = 1'b0;
          end
          4'b0101 : begin
            weav_5 = 1'b1;
          end
          4'b0110 : begin
            weav_5 = 1'b0;
          end
          4'b0111 : begin
            weav_5 = 1'b0;
          end
          4'b1000 : begin
            weav_5 = 1'b0;
          end
          default : begin
            weav_5 = 1'b0;
          end
        endcase
      end else begin
        if(when_Weight_l161) begin
          case(times_count)
            3'b000 : begin
              weav_5 = 1'b0;
            end
            3'b001 : begin
              weav_5 = 1'b0;
            end
            3'b010 : begin
              weav_5 = 1'b0;
            end
            3'b011 : begin
              weav_5 = 1'b0;
            end
            3'b100 : begin
              weav_5 = 1'b0;
            end
            3'b101 : begin
              weav_5 = 1'b1;
            end
            3'b110 : begin
              weav_5 = 1'b0;
            end
            default : begin
              weav_5 = 1'b0;
            end
          endcase
        end else begin
          weav_5 = 1'b0;
        end
      end
    end else begin
      weav_5 = 1'b0;
    end
  end

  always @(*) begin
    if(when_Weight_l141) begin
      if(when_Weight_l142) begin
        case(copyWeightTimes_count)
          4'b0000 : begin
            weav_6 = 1'b0;
          end
          4'b0001 : begin
            weav_6 = 1'b0;
          end
          4'b0010 : begin
            weav_6 = 1'b0;
          end
          4'b0011 : begin
            weav_6 = 1'b0;
          end
          4'b0100 : begin
            weav_6 = 1'b0;
          end
          4'b0101 : begin
            weav_6 = 1'b0;
          end
          4'b0110 : begin
            weav_6 = 1'b1;
          end
          4'b0111 : begin
            weav_6 = 1'b0;
          end
          4'b1000 : begin
            weav_6 = 1'b0;
          end
          default : begin
            weav_6 = 1'b0;
          end
        endcase
      end else begin
        if(when_Weight_l161) begin
          case(times_count)
            3'b000 : begin
              weav_6 = 1'b0;
            end
            3'b001 : begin
              weav_6 = 1'b0;
            end
            3'b010 : begin
              weav_6 = 1'b0;
            end
            3'b011 : begin
              weav_6 = 1'b0;
            end
            3'b100 : begin
              weav_6 = 1'b0;
            end
            3'b101 : begin
              weav_6 = 1'b0;
            end
            3'b110 : begin
              weav_6 = 1'b1;
            end
            default : begin
              weav_6 = 1'b0;
            end
          endcase
        end else begin
          weav_6 = 1'b0;
        end
      end
    end else begin
      weav_6 = 1'b0;
    end
  end

  always @(*) begin
    if(when_Weight_l141) begin
      if(when_Weight_l142) begin
        case(copyWeightTimes_count)
          4'b0000 : begin
            weav_7 = 1'b0;
          end
          4'b0001 : begin
            weav_7 = 1'b0;
          end
          4'b0010 : begin
            weav_7 = 1'b0;
          end
          4'b0011 : begin
            weav_7 = 1'b0;
          end
          4'b0100 : begin
            weav_7 = 1'b0;
          end
          4'b0101 : begin
            weav_7 = 1'b0;
          end
          4'b0110 : begin
            weav_7 = 1'b0;
          end
          4'b0111 : begin
            weav_7 = 1'b1;
          end
          4'b1000 : begin
            weav_7 = 1'b0;
          end
          default : begin
            weav_7 = 1'b0;
          end
        endcase
      end else begin
        if(when_Weight_l161) begin
          case(times_count)
            3'b000 : begin
              weav_7 = 1'b0;
            end
            3'b001 : begin
              weav_7 = 1'b0;
            end
            3'b010 : begin
              weav_7 = 1'b0;
            end
            3'b011 : begin
              weav_7 = 1'b0;
            end
            3'b100 : begin
              weav_7 = 1'b0;
            end
            3'b101 : begin
              weav_7 = 1'b0;
            end
            3'b110 : begin
              weav_7 = 1'b0;
            end
            default : begin
              weav_7 = 1'b1;
            end
          endcase
        end else begin
          weav_7 = 1'b0;
        end
      end
    end else begin
      weav_7 = 1'b0;
    end
  end

  always @(*) begin
    if(when_Weight_l141) begin
      if(when_Weight_l142) begin
        case(copyWeightTimes_count)
          4'b0000 : begin
            weav_8 = 1'b0;
          end
          4'b0001 : begin
            weav_8 = 1'b0;
          end
          4'b0010 : begin
            weav_8 = 1'b0;
          end
          4'b0011 : begin
            weav_8 = 1'b0;
          end
          4'b0100 : begin
            weav_8 = 1'b0;
          end
          4'b0101 : begin
            weav_8 = 1'b0;
          end
          4'b0110 : begin
            weav_8 = 1'b0;
          end
          4'b0111 : begin
            weav_8 = 1'b0;
          end
          4'b1000 : begin
            weav_8 = 1'b1;
          end
          default : begin
            weav_8 = 1'b0;
          end
        endcase
      end else begin
        if(when_Weight_l161) begin
          weav_8 = 1'b0;
        end else begin
          weav_8 = 1'b0;
        end
      end
    end else begin
      weav_8 = 1'b0;
    end
  end

  assign when_Weight_l161 = (convType == 2'b01);
  assign when_Weight_l191 = (addr_0 == _zz_when_Weight_l191);
  assign when_Weight_l191_1 = (addr_1 == _zz_when_Weight_l191_1);
  assign when_Weight_l191_2 = (addr_2 == _zz_when_Weight_l191_2);
  assign when_Weight_l191_3 = (addr_3 == _zz_when_Weight_l191_3);
  assign when_Weight_l191_4 = (addr_4 == _zz_when_Weight_l191_4);
  assign when_Weight_l191_5 = (addr_5 == _zz_when_Weight_l191_5);
  assign when_Weight_l191_6 = (addr_6 == _zz_when_Weight_l191_6);
  assign when_Weight_l191_7 = (addr_7 == _zz_when_Weight_l191_7);
  assign when_Weight_l191_8 = (addr_8 == _zz_when_Weight_l191_8);
  assign weightRam_0_wea = weav_0;
  assign weightRam_0_addra = addr_0;
  assign weightRam_0_addrb = weightRead_0_addr;
  assign weightRam_0_dina = sData_payload;
  assign weightRead_0_data = weightRam_0_doutb;
  assign weightRam_1_wea = weav_1;
  assign weightRam_1_addra = addr_1;
  assign weightRam_1_addrb = weightRead_1_addr;
  assign weightRam_1_dina = sData_payload;
  assign weightRead_1_data = weightRam_1_doutb;
  assign weightRam_2_wea = weav_2;
  assign weightRam_2_addra = addr_2;
  assign weightRam_2_addrb = weightRead_2_addr;
  assign weightRam_2_dina = sData_payload;
  assign weightRead_2_data = weightRam_2_doutb;
  assign weightRam_3_wea = weav_3;
  assign weightRam_3_addra = addr_3;
  assign weightRam_3_addrb = weightRead_3_addr;
  assign weightRam_3_dina = sData_payload;
  assign weightRead_3_data = weightRam_3_doutb;
  assign weightRam_4_wea = weav_4;
  assign weightRam_4_addra = addr_4;
  assign weightRam_4_addrb = weightRead_4_addr;
  assign weightRam_4_dina = sData_payload;
  assign weightRead_4_data = weightRam_4_doutb;
  assign weightRam_5_wea = weav_5;
  assign weightRam_5_addra = addr_5;
  assign weightRam_5_addrb = weightRead_5_addr;
  assign weightRam_5_dina = sData_payload;
  assign weightRead_5_data = weightRam_5_doutb;
  assign weightRam_6_wea = weav_6;
  assign weightRam_6_addra = addr_6;
  assign weightRam_6_addrb = weightRead_6_addr;
  assign weightRam_6_dina = sData_payload;
  assign weightRead_6_data = weightRam_6_doutb;
  assign weightRam_7_wea = weav_7;
  assign weightRam_7_addra = addr_7;
  assign weightRam_7_addrb = weightRead_7_addr;
  assign weightRam_7_dina = sData_payload;
  assign weightRead_7_data = weightRam_7_doutb;
  assign weightRam_8_wea = weav_8;
  assign weightRam_8_addra = addr_8;
  assign weightRam_8_addrb = weightRead_8_addr;
  assign weightRam_8_dina = sData_payload;
  assign weightRead_8_data = weightRam_8_doutb;
  assign sData_fire_4 = (sData_valid && sData_ready);
  assign when_WaCounter_l17_4 = (((fsm_currentState & LoadWeightEnum_COPY_BIAS) != 6'b000000) && sData_fire_4);
  assign sData_fire_5 = (sData_valid && sData_ready);
  assign when_WaCounter_l12_7 = (copyBias_copyCnt_count == _zz_when_WaCounter_l12_7);
  always @(*) begin
    if(when_WaCounter_l12_7) begin
      copyBias_copyCnt_valid = 1'b1;
    end else begin
      copyBias_copyCnt_valid = 1'b0;
    end
  end

  assign copyBias_ram_wea = (((fsm_currentState & LoadWeightEnum_COPY_BIAS) != 6'b000000) && sData_fire_5);
  assign copyBias_ram_dina = sData_payload;
  assign copyBias_ram_addra = copyBias_copyCnt_count;
  assign copyBias_ram_addrb = biasRead_addr;
  assign biasRead_data = copyBias_ram_doutb;
  assign fsm_copyBiasEnd = copyBias_copyCnt_valid;
  assign sData_fire_6 = (sData_valid && sData_ready);
  assign when_WaCounter_l17_5 = (((fsm_currentState & LoadWeightEnum_COPY_SCALE) != 6'b000000) && sData_fire_6);
  assign sData_fire_7 = (sData_valid && sData_ready);
  assign when_WaCounter_l12_8 = (copyScale_copyCnt_count == _zz_when_WaCounter_l12_8);
  always @(*) begin
    if(when_WaCounter_l12_8) begin
      copyScale_copyCnt_valid = 1'b1;
    end else begin
      copyScale_copyCnt_valid = 1'b0;
    end
  end

  assign copyScale_ram_wea = (((fsm_currentState & LoadWeightEnum_COPY_SCALE) != 6'b000000) && sData_fire_7);
  assign copyScale_ram_dina = sData_payload;
  assign copyScale_ram_addra = copyScale_copyCnt_count;
  assign copyScale_ram_addrb = scaleRead_addr;
  assign scaleRead_data = copyScale_ram_doutb;
  assign fsm_copyScaleEnd = copyScale_copyCnt_valid;
  assign sData_fire_8 = (sData_valid && sData_ready);
  assign when_WaCounter_l17_6 = (((fsm_currentState & LoadWeightEnum_COPY_SHIFT) != 6'b000000) && sData_fire_8);
  assign sData_fire_9 = (sData_valid && sData_ready);
  assign when_WaCounter_l12_9 = (copyShift_copyCnt_count == _zz_when_WaCounter_l12_9);
  always @(*) begin
    if(when_WaCounter_l12_9) begin
      copyShift_copyCnt_valid = 1'b1;
    end else begin
      copyShift_copyCnt_valid = 1'b0;
    end
  end

  assign copyShift_ram_wea = (((fsm_currentState & LoadWeightEnum_COPY_SHIFT) != 6'b000000) && sData_fire_9);
  assign copyShift_ram_dina = sData_payload;
  assign copyShift_ram_addra = copyShift_copyCnt_count;
  assign copyShift_ram_addrb = shiftRead_addr;
  assign shiftRead_data = copyShift_ram_doutb;
  assign fsm_copyShiftEnd = copyShift_copyCnt_valid;
  assign when_WaUtil_l29 = (((fsm_currentState & LoadWeightEnum_COPY_SHIFT) != 6'b000000) && ((fsm_nextState & LoadWeightEnum_IDLE) != 6'b000000));
  always @(*) begin
    if(when_WaUtil_l29) begin
      copyWeightDone = 1'b1;
    end else begin
      copyWeightDone = 1'b0;
    end
  end

  always @(posedge clk or posedge reset) begin
    if(reset) begin
      fsm_currentState <= LoadWeightEnum_IDLE;
      init_count <= 3'b000;
      copyWeightCnt_count <= 13'h0;
      copyWeightTimes_count <= 4'b0000;
      channelInCnt_count <= 9'h0;
      computeChannelOut_count <= 3'b000;
      times_count <= 3'b000;
      channelOutCnt_count <= 12'h0;
      addr_0 <= 13'h0;
      addr_1 <= 13'h0;
      addr_2 <= 13'h0;
      addr_3 <= 13'h0;
      addr_4 <= 13'h0;
      addr_5 <= 13'h0;
      addr_6 <= 13'h0;
      addr_7 <= 13'h0;
      addr_8 <= 13'h0;
      copyBias_copyCnt_count <= 9'h0;
      copyScale_copyCnt_count <= 9'h0;
      copyShift_copyCnt_count <= 9'h0;
    end else begin
      fsm_currentState <= fsm_nextState;
      if(when_WaCounter_l17) begin
        init_count <= (init_count + 3'b001);
        if(init_valid) begin
          init_count <= 3'b000;
        end
      end
      if(when_WaCounter_l17_1) begin
        copyWeightCnt_count <= (copyWeightCnt_count + 13'h0001);
        if(copyWeightCnt_valid) begin
          copyWeightCnt_count <= 13'h0;
        end
      end
      if(copyWeightCnt_valid) begin
        copyWeightTimes_count <= (copyWeightTimes_count + 4'b0001);
        if(copyWeightTimes_valid) begin
          copyWeightTimes_count <= 4'b0000;
        end
      end
      if(when_WaCounter_l17_2) begin
        channelInCnt_count <= (channelInCnt_count + 9'h001);
        if(channelInCnt_valid) begin
          channelInCnt_count <= 9'h0;
        end
      end
      if(when_WaCounter_l17_3) begin
        computeChannelOut_count <= (computeChannelOut_count + 3'b001);
        if(computeChannelOut_valid) begin
          computeChannelOut_count <= 3'b000;
        end
      end
      if(computeChannelOut_valid) begin
        times_count <= (times_count + 3'b001);
        if(times_valid) begin
          times_count <= 3'b000;
        end
      end
      if(channelInCnt_valid) begin
        channelOutCnt_count <= (channelOutCnt_count + 12'h001);
        if(channelOutCnt_valid) begin
          channelOutCnt_count <= 12'h0;
        end
      end
      if(when_Weight_l119) begin
        copyWeightCnt_count <= 13'h0;
        copyWeightTimes_count <= 4'b0000;
        channelInCnt_count <= 9'h0;
        channelOutCnt_count <= 12'h0;
      end
      if(weav_0) begin
        if(when_Weight_l191) begin
          addr_0 <= 13'h0;
        end else begin
          addr_0 <= (addr_0 + 13'h0001);
        end
      end
      if(weav_1) begin
        if(when_Weight_l191_1) begin
          addr_1 <= 13'h0;
        end else begin
          addr_1 <= (addr_1 + 13'h0001);
        end
      end
      if(weav_2) begin
        if(when_Weight_l191_2) begin
          addr_2 <= 13'h0;
        end else begin
          addr_2 <= (addr_2 + 13'h0001);
        end
      end
      if(weav_3) begin
        if(when_Weight_l191_3) begin
          addr_3 <= 13'h0;
        end else begin
          addr_3 <= (addr_3 + 13'h0001);
        end
      end
      if(weav_4) begin
        if(when_Weight_l191_4) begin
          addr_4 <= 13'h0;
        end else begin
          addr_4 <= (addr_4 + 13'h0001);
        end
      end
      if(weav_5) begin
        if(when_Weight_l191_5) begin
          addr_5 <= 13'h0;
        end else begin
          addr_5 <= (addr_5 + 13'h0001);
        end
      end
      if(weav_6) begin
        if(when_Weight_l191_6) begin
          addr_6 <= 13'h0;
        end else begin
          addr_6 <= (addr_6 + 13'h0001);
        end
      end
      if(weav_7) begin
        if(when_Weight_l191_7) begin
          addr_7 <= 13'h0;
        end else begin
          addr_7 <= (addr_7 + 13'h0001);
        end
      end
      if(weav_8) begin
        if(when_Weight_l191_8) begin
          addr_8 <= 13'h0;
        end else begin
          addr_8 <= (addr_8 + 13'h0001);
        end
      end
      if(when_WaCounter_l17_4) begin
        copyBias_copyCnt_count <= (copyBias_copyCnt_count + 9'h001);
        if(copyBias_copyCnt_valid) begin
          copyBias_copyCnt_count <= 9'h0;
        end
      end
      if(when_WaCounter_l17_5) begin
        copyScale_copyCnt_count <= (copyScale_copyCnt_count + 9'h001);
        if(copyScale_copyCnt_valid) begin
          copyScale_copyCnt_count <= 9'h0;
        end
      end
      if(when_WaCounter_l17_6) begin
        copyShift_copyCnt_count <= (copyShift_copyCnt_count + 9'h001);
        if(copyShift_copyCnt_valid) begin
          copyShift_copyCnt_count <= 9'h0;
        end
      end
    end
  end


endmodule

module ConvComputeCtrl (
  input               start,
  output reg          mDataValid,
  input               mDataReady,
  output              normValid,
  output              normPreValid,
  output reg          normEnd,
  input               sDataReady,
  input      [8:0]    rowNumIn,
  input      [8:0]    colNumIn,
  input      [11:0]   channelIn,
  input      [11:0]   channelOut,
  output     [5:0]    featureMemReadAddr,
  output     [5:0]    featureMemWriteAddr,
  output reg          featureMemWriteReady,
  output     [9:0]    weightReadAddr_0,
  output     [9:0]    weightReadAddr_1,
  output     [9:0]    weightReadAddr_2,
  output     [9:0]    weightReadAddr_3,
  output     [9:0]    weightReadAddr_4,
  output     [9:0]    weightReadAddr_5,
  output     [9:0]    weightReadAddr_6,
  output     [9:0]    weightReadAddr_7,
  output     [9:0]    weightReadAddr_8,
  output     [6:0]    biasReadAddr,
  output     [6:0]    scaleReadAddr,
  output     [6:0]    shiftReadAddr,
  input               activationEn,
  output     [10:0]   sCount,
  output     [10:0]   mCount,
  input      [1:0]    convType,
  input               clk,
  input               reset
);
  localparam ConvComputeCtrlEnum_IDLE = 6'd1;
  localparam ConvComputeCtrlEnum_INIT = 6'd2;
  localparam ConvComputeCtrlEnum_DATA_READY = 6'd4;
  localparam ConvComputeCtrlEnum_FIFO_READY = 6'd8;
  localparam ConvComputeCtrlEnum_COMPUTE = 6'd16;
  localparam ConvComputeCtrlEnum_END_1 = 6'd32;

  wire       [8:0]    _zz_temp;
  wire       [5:0]    _zz_temp_1;
  wire       [11:0]   _zz_when_WaCounter_l12_1;
  wire       [11:0]   _zz_when_WaCounter_l12_2;
  wire       [8:0]    _zz_when_WaCounter_l12_2_1;
  wire       [8:0]    _zz_when_WaCounter_l12_3;
  wire       [8:0]    _zz_when_WaCounter_l12_4;
  wire       [8:0]    _zz_when_WaCounter_l12_5;
  wire       [8:0]    _zz_when_WaCounter_l12_5_1;
  wire                convComputeCtrlFsm_start;
  wire                convComputeCtrlFsm_dataReady;
  wire                convComputeCtrlFsm_fifoReady;
  reg                 convComputeCtrlFsm_initEnd;
  reg                 convComputeCtrlFsm_computeEnd;
  reg                 convComputeCtrlFsm_endEnd;
  reg        [5:0]    convComputeCtrlFsm_currentState;
  reg        [5:0]    convComputeCtrlFsm_nextState;
  wire                when_WaCounter_l17;
  reg        [2:0]    initCnt_count;
  reg                 initCnt_valid;
  wire                when_WaCounter_l12;
  reg        [11:0]   temp;
  wire                when_ConvComputeCtrl_l114;
  reg        [11:0]   channelInTimes;
  reg        [8:0]    channelOutTimes;
  wire                when_WaCounter_l17_1;
  reg        [11:0]   channelInCnt_count;
  reg                 channelInCnt_valid;
  wire                when_WaCounter_l12_1;
  wire                when_WaCounter_l17_2;
  reg        [11:0]   channelOutCnt_count;
  reg                 channelOutCnt_valid;
  wire                when_WaCounter_l12_2;
  wire                when_WaCounter_l17_3;
  reg        [8:0]    columnCnt_count;
  reg                 columnCnt_valid;
  wire                when_WaCounter_l12_3;
  wire                when_WaCounter_l17_4;
  reg        [8:0]    rowCnt_count;
  reg                 rowCnt_valid;
  wire                when_WaCounter_l12_4;
  wire                when_ConvComputeCtrl_l126;
  wire                when_WaUtil_l29;
  wire                when_WaUtil_l29_1;
  wire                when_WaUtil_l29_2;
  (* max_fanout = "50" *) reg        [5:0]    featureMemWriteAddr_1;
  wire                when_ConvComputeCtrl_l139;
  reg        [5:0]    featureMemReadAddrTemp;
  wire                when_ConvComputeCtrl_l148;
  reg        [5:0]    featureMemReadAddrTemp_delay_1;
  reg        [5:0]    featureMemReadAddrTemp_delay_2;
  reg        [9:0]    weightReadAddr;
  wire                when_ConvComputeCtrl_l149;
  wire                when_ConvComputeCtrl_l148_1;
  reg        [9:0]    weightReadAddrTemp;
  reg                 channelTimesAdd;
  wire                when_WaUtil_l29_3;
  reg                 channelTimesAdd_delay_1;
  reg                 channelTimesAdd_delay_2;
  reg                 channelTimesAdd_delay_3;
  reg                 channelTimesAdd_delay_4;
  reg                 channelTimesAdd_delay_5;
  reg                 channelTimesAdd_delay_6;
  reg                 channelTimesAdd_delay_7;
  reg                 channelTimesAdd_delay_8;
  reg                 channelTimesAdd_delay_9;
  reg                 channelTimesAdd_delay_10;
  reg                 channelTimesAdd_delay_11;
  reg                 channelTimesAdd_delay_12;
  reg                 channelTimesAdd_delay_13;
  reg                 channelTimesAdd_delay_14;
  reg                 channelTimesAdd_delay_15;
  reg                 channelTimesAdd_delay_16;
  reg                 channelTimesAdd_delay_17;
  reg                 channelTimesAdd_delay_18;
  reg                 normValidTemp;
  wire                when_WaUtil_l29_4;
  wire                normValidTempQ_0;
  reg                 normValidTempQ_1;
  reg                 normValidTempQ_2;
  reg                 normValidTempQ_3;
  reg                 normValidTempQ_4;
  reg                 normValidTempQ_5;
  reg                 normValidTempQ_6;
  reg                 normValidTempQ_7;
  reg                 normValidTempQ_8;
  reg                 normValidTempQ_9;
  reg                 normValidTempQ_10;
  reg                 normValidTempQ_11;
  reg                 normValidTempQ_12;
  reg                 normValidTempQ_13;
  reg                 normValidTempQ_14;
  reg                 normValidTempQ_15;
  reg                 normValidTempQ_16;
  reg                 normValidTempQ_17;
  reg                 normValidTempQ_18;
  reg                 normValidTempQ_19;
  reg                 normValidTempQ_20;
  reg                 normValidTempQ_21;
  reg                 normValidTempQ_22;
  reg                 normValidTempQ_23;
  reg                 normValidTempQ_24;
  reg                 normValidTempQ_25;
  reg                 normValidTempQ_26;
  reg                 normValidTempQ_27;
  reg                 normValidTempQ_28;
  reg                 normValidTempQ_29;
  reg                 normValidTempQ_30;
  reg                 normValidTempQ_31;
  reg                 normValidTempQ_32;
  reg                 normValidTempQ_33;
  reg        [20:0]   _zz_sCount;
  reg        [6:0]    biasAddrCnt_count;
  reg                 biasAddrCnt_valid;
  wire                when_WaCounter_l12_5;
  wire       [6:0]    quanDelayTemp_0;
  reg        [6:0]    quanDelayTemp_1;
  reg        [6:0]    quanDelayTemp_2;
  reg        [6:0]    quanDelayTemp_3;
  reg        [6:0]    quanDelayTemp_4;
  `ifndef SYNTHESIS
  reg [79:0] convComputeCtrlFsm_currentState_string;
  reg [79:0] convComputeCtrlFsm_nextState_string;
  `endif


  assign _zz_temp = (channelIn >>> 3);
  assign _zz_temp_1 = (channelIn >>> 6);
  assign _zz_when_WaCounter_l12_1 = (channelInTimes - 12'h001);
  assign _zz_when_WaCounter_l12_2_1 = (channelOutTimes - 9'h001);
  assign _zz_when_WaCounter_l12_2 = {3'd0, _zz_when_WaCounter_l12_2_1};
  assign _zz_when_WaCounter_l12_3 = (colNumIn - 9'h001);
  assign _zz_when_WaCounter_l12_4 = (rowNumIn - 9'h001);
  assign _zz_when_WaCounter_l12_5 = {2'd0, biasAddrCnt_count};
  assign _zz_when_WaCounter_l12_5_1 = (channelOutTimes - 9'h001);
  `ifndef SYNTHESIS
  always @(*) begin
    case(convComputeCtrlFsm_currentState)
      ConvComputeCtrlEnum_IDLE : convComputeCtrlFsm_currentState_string = "IDLE      ";
      ConvComputeCtrlEnum_INIT : convComputeCtrlFsm_currentState_string = "INIT      ";
      ConvComputeCtrlEnum_DATA_READY : convComputeCtrlFsm_currentState_string = "DATA_READY";
      ConvComputeCtrlEnum_FIFO_READY : convComputeCtrlFsm_currentState_string = "FIFO_READY";
      ConvComputeCtrlEnum_COMPUTE : convComputeCtrlFsm_currentState_string = "COMPUTE   ";
      ConvComputeCtrlEnum_END_1 : convComputeCtrlFsm_currentState_string = "END_1     ";
      default : convComputeCtrlFsm_currentState_string = "??????????";
    endcase
  end
  always @(*) begin
    case(convComputeCtrlFsm_nextState)
      ConvComputeCtrlEnum_IDLE : convComputeCtrlFsm_nextState_string = "IDLE      ";
      ConvComputeCtrlEnum_INIT : convComputeCtrlFsm_nextState_string = "INIT      ";
      ConvComputeCtrlEnum_DATA_READY : convComputeCtrlFsm_nextState_string = "DATA_READY";
      ConvComputeCtrlEnum_FIFO_READY : convComputeCtrlFsm_nextState_string = "FIFO_READY";
      ConvComputeCtrlEnum_COMPUTE : convComputeCtrlFsm_nextState_string = "COMPUTE   ";
      ConvComputeCtrlEnum_END_1 : convComputeCtrlFsm_nextState_string = "END_1     ";
      default : convComputeCtrlFsm_nextState_string = "??????????";
    endcase
  end
  `endif

  always @(*) begin
    (* parallel_case *)
    case(1) // synthesis parallel_case
      (((convComputeCtrlFsm_currentState) & ConvComputeCtrlEnum_IDLE) == ConvComputeCtrlEnum_IDLE) : begin
        if(convComputeCtrlFsm_start) begin
          convComputeCtrlFsm_nextState = ConvComputeCtrlEnum_INIT;
        end else begin
          convComputeCtrlFsm_nextState = ConvComputeCtrlEnum_IDLE;
        end
      end
      (((convComputeCtrlFsm_currentState) & ConvComputeCtrlEnum_INIT) == ConvComputeCtrlEnum_INIT) : begin
        if(convComputeCtrlFsm_initEnd) begin
          convComputeCtrlFsm_nextState = ConvComputeCtrlEnum_DATA_READY;
        end else begin
          convComputeCtrlFsm_nextState = ConvComputeCtrlEnum_INIT;
        end
      end
      (((convComputeCtrlFsm_currentState) & ConvComputeCtrlEnum_DATA_READY) == ConvComputeCtrlEnum_DATA_READY) : begin
        if(convComputeCtrlFsm_dataReady) begin
          convComputeCtrlFsm_nextState = ConvComputeCtrlEnum_FIFO_READY;
        end else begin
          convComputeCtrlFsm_nextState = ConvComputeCtrlEnum_DATA_READY;
        end
      end
      (((convComputeCtrlFsm_currentState) & ConvComputeCtrlEnum_FIFO_READY) == ConvComputeCtrlEnum_FIFO_READY) : begin
        if(convComputeCtrlFsm_fifoReady) begin
          convComputeCtrlFsm_nextState = ConvComputeCtrlEnum_COMPUTE;
        end else begin
          convComputeCtrlFsm_nextState = ConvComputeCtrlEnum_FIFO_READY;
        end
      end
      (((convComputeCtrlFsm_currentState) & ConvComputeCtrlEnum_COMPUTE) == ConvComputeCtrlEnum_COMPUTE) : begin
        if(convComputeCtrlFsm_computeEnd) begin
          convComputeCtrlFsm_nextState = ConvComputeCtrlEnum_END_1;
        end else begin
          convComputeCtrlFsm_nextState = ConvComputeCtrlEnum_COMPUTE;
        end
      end
      default : begin
        if(convComputeCtrlFsm_endEnd) begin
          convComputeCtrlFsm_nextState = ConvComputeCtrlEnum_IDLE;
        end else begin
          convComputeCtrlFsm_nextState = ConvComputeCtrlEnum_DATA_READY;
        end
      end
    endcase
  end

  assign convComputeCtrlFsm_start = start;
  assign convComputeCtrlFsm_dataReady = sDataReady;
  assign convComputeCtrlFsm_fifoReady = mDataReady;
  assign when_WaCounter_l17 = ((convComputeCtrlFsm_currentState & ConvComputeCtrlEnum_INIT) != 6'b000000);
  assign when_WaCounter_l12 = (initCnt_count == 3'b111);
  always @(*) begin
    if(when_WaCounter_l12) begin
      initCnt_valid = 1'b1;
    end else begin
      initCnt_valid = 1'b0;
    end
  end

  assign when_ConvComputeCtrl_l114 = (convType == 2'b00);
  always @(*) begin
    if(when_ConvComputeCtrl_l114) begin
      temp = {3'd0, _zz_temp};
    end else begin
      temp = {6'd0, _zz_temp_1};
    end
  end

  assign when_WaCounter_l17_1 = ((convComputeCtrlFsm_currentState & ConvComputeCtrlEnum_COMPUTE) != 6'b000000);
  assign when_WaCounter_l12_1 = (channelInCnt_count == _zz_when_WaCounter_l12_1);
  always @(*) begin
    if(when_WaCounter_l12_1) begin
      channelInCnt_valid = 1'b1;
    end else begin
      channelInCnt_valid = 1'b0;
    end
    if(when_ConvComputeCtrl_l126) begin
      channelInCnt_valid = 1'b0;
    end
  end

  assign when_WaCounter_l17_2 = (((convComputeCtrlFsm_currentState & ConvComputeCtrlEnum_COMPUTE) != 6'b000000) && channelInCnt_valid);
  assign when_WaCounter_l12_2 = (channelOutCnt_count == _zz_when_WaCounter_l12_2);
  always @(*) begin
    if(when_WaCounter_l12_2) begin
      channelOutCnt_valid = 1'b1;
    end else begin
      channelOutCnt_valid = 1'b0;
    end
    if(when_ConvComputeCtrl_l126) begin
      channelOutCnt_valid = 1'b0;
    end
  end

  assign when_WaCounter_l17_3 = (channelInCnt_valid && channelOutCnt_valid);
  assign when_WaCounter_l12_3 = (columnCnt_count == _zz_when_WaCounter_l12_3);
  always @(*) begin
    if(when_WaCounter_l12_3) begin
      columnCnt_valid = 1'b1;
    end else begin
      columnCnt_valid = 1'b0;
    end
    if(when_ConvComputeCtrl_l126) begin
      columnCnt_valid = 1'b0;
    end
  end

  assign when_WaCounter_l17_4 = ((convComputeCtrlFsm_currentState & ConvComputeCtrlEnum_END_1) != 6'b000000);
  assign when_WaCounter_l12_4 = (rowCnt_count == _zz_when_WaCounter_l12_4);
  always @(*) begin
    if(when_WaCounter_l12_4) begin
      rowCnt_valid = 1'b1;
    end else begin
      rowCnt_valid = 1'b0;
    end
  end

  assign when_ConvComputeCtrl_l126 = ((convComputeCtrlFsm_currentState & ConvComputeCtrlEnum_IDLE) != 6'b000000);
  assign when_WaUtil_l29 = ((channelInCnt_valid && channelOutCnt_valid) && columnCnt_valid);
  always @(*) begin
    if(when_WaUtil_l29) begin
      convComputeCtrlFsm_computeEnd = 1'b1;
    end else begin
      convComputeCtrlFsm_computeEnd = 1'b0;
    end
  end

  always @(*) begin
    if(rowCnt_valid) begin
      convComputeCtrlFsm_endEnd = 1'b1;
    end else begin
      convComputeCtrlFsm_endEnd = 1'b0;
    end
  end

  assign when_WaUtil_l29_1 = (((convComputeCtrlFsm_currentState & ConvComputeCtrlEnum_END_1) != 6'b000000) && ((convComputeCtrlFsm_nextState & ConvComputeCtrlEnum_IDLE) != 6'b000000));
  always @(*) begin
    if(when_WaUtil_l29_1) begin
      normEnd = 1'b1;
    end else begin
      normEnd = 1'b0;
    end
  end

  always @(*) begin
    if(initCnt_valid) begin
      convComputeCtrlFsm_initEnd = 1'b1;
    end else begin
      convComputeCtrlFsm_initEnd = 1'b0;
    end
  end

  assign when_WaUtil_l29_2 = (((convComputeCtrlFsm_currentState & ConvComputeCtrlEnum_COMPUTE) != 6'b000000) && (channelOutCnt_count == 12'h0));
  assign featureMemWriteAddr = featureMemWriteAddr_1;
  assign when_ConvComputeCtrl_l139 = ((channelOutCnt_count == 12'h0) && (channelInCnt_count == 12'h0));
  assign when_ConvComputeCtrl_l148 = ((convComputeCtrlFsm_currentState & ConvComputeCtrlEnum_COMPUTE) != 6'b000000);
  assign featureMemReadAddr = featureMemReadAddrTemp_delay_2;
  assign when_ConvComputeCtrl_l149 = (channelInCnt_valid && channelOutCnt_valid);
  assign when_ConvComputeCtrl_l148_1 = ((convComputeCtrlFsm_currentState & ConvComputeCtrlEnum_COMPUTE) != 6'b000000);
  assign weightReadAddr_0 = weightReadAddrTemp;
  assign weightReadAddr_1 = weightReadAddrTemp;
  assign weightReadAddr_2 = weightReadAddrTemp;
  assign weightReadAddr_3 = weightReadAddrTemp;
  assign weightReadAddr_4 = weightReadAddrTemp;
  assign weightReadAddr_5 = weightReadAddrTemp;
  assign weightReadAddr_6 = weightReadAddrTemp;
  assign weightReadAddr_7 = weightReadAddrTemp;
  assign weightReadAddr_8 = weightReadAddrTemp;
  assign when_WaUtil_l29_3 = (((convComputeCtrlFsm_currentState & ConvComputeCtrlEnum_COMPUTE) != 6'b000000) && (channelInCnt_count == 12'h0));
  assign normPreValid = channelTimesAdd_delay_18;
  assign when_WaUtil_l29_4 = (((convComputeCtrlFsm_currentState & ConvComputeCtrlEnum_COMPUTE) != 6'b000000) && channelInCnt_valid);
  assign normValidTempQ_0 = normValidTemp;
  assign normValid = normValidTempQ_19;
  assign sCount = _zz_sCount[10:0];
  assign mCount = sCount;
  assign when_WaCounter_l12_5 = (_zz_when_WaCounter_l12_5 == _zz_when_WaCounter_l12_5_1);
  always @(*) begin
    if(when_WaCounter_l12_5) begin
      biasAddrCnt_valid = 1'b1;
    end else begin
      biasAddrCnt_valid = 1'b0;
    end
  end

  assign biasReadAddr = biasAddrCnt_count;
  assign quanDelayTemp_0 = biasReadAddr;
  assign scaleReadAddr = biasAddrCnt_count;
  assign shiftReadAddr = biasAddrCnt_count;
  always @(*) begin
    if(activationEn) begin
      mDataValid = normValidTempQ_33;
    end else begin
      mDataValid = normValidTempQ_24;
    end
  end

  always @(posedge clk or posedge reset) begin
    if(reset) begin
      featureMemWriteReady <= 1'b0;
      convComputeCtrlFsm_currentState <= ConvComputeCtrlEnum_IDLE;
      initCnt_count <= 3'b000;
      channelInCnt_count <= 12'h0;
      channelOutCnt_count <= 12'h0;
      columnCnt_count <= 9'h0;
      rowCnt_count <= 9'h0;
      featureMemWriteAddr_1 <= 6'h0;
      featureMemReadAddrTemp <= 6'h0;
      channelTimesAdd <= 1'b0;
      normValidTemp <= 1'b0;
      biasAddrCnt_count <= 7'h0;
    end else begin
      convComputeCtrlFsm_currentState <= convComputeCtrlFsm_nextState;
      if(when_WaCounter_l17) begin
        initCnt_count <= (initCnt_count + 3'b001);
        if(initCnt_valid) begin
          initCnt_count <= 3'b000;
        end
      end
      if(when_WaCounter_l17_1) begin
        channelInCnt_count <= (channelInCnt_count + 12'h001);
        if(channelInCnt_valid) begin
          channelInCnt_count <= 12'h0;
        end
      end
      if(when_WaCounter_l17_2) begin
        channelOutCnt_count <= (channelOutCnt_count + 12'h001);
        if(channelOutCnt_valid) begin
          channelOutCnt_count <= 12'h0;
        end
      end
      if(when_WaCounter_l17_3) begin
        columnCnt_count <= (columnCnt_count + 9'h001);
        if(columnCnt_valid) begin
          columnCnt_count <= 9'h0;
        end
      end
      if(when_WaCounter_l17_4) begin
        rowCnt_count <= (rowCnt_count + 9'h001);
        if(rowCnt_valid) begin
          rowCnt_count <= 9'h0;
        end
      end
      if(when_ConvComputeCtrl_l126) begin
        channelInCnt_count <= 12'h0;
        channelOutCnt_count <= 12'h0;
        columnCnt_count <= 9'h0;
      end
      if(when_WaUtil_l29_2) begin
        featureMemWriteReady <= 1'b1;
      end else begin
        featureMemWriteReady <= 1'b0;
      end
      if(when_ConvComputeCtrl_l139) begin
        featureMemWriteAddr_1 <= 6'h0;
      end else begin
        if(featureMemWriteReady) begin
          featureMemWriteAddr_1 <= (featureMemWriteAddr_1 + 6'h01);
        end else begin
          featureMemWriteAddr_1 <= 6'h0;
        end
      end
      if(when_ConvComputeCtrl_l148) begin
        if(channelInCnt_valid) begin
          featureMemReadAddrTemp <= 6'h0;
        end else begin
          featureMemReadAddrTemp <= (featureMemReadAddrTemp + 6'h01);
        end
      end else begin
        featureMemReadAddrTemp <= 6'h0;
      end
      if(when_WaUtil_l29_3) begin
        channelTimesAdd <= 1'b1;
      end else begin
        channelTimesAdd <= 1'b0;
      end
      if(when_WaUtil_l29_4) begin
        normValidTemp <= 1'b1;
      end else begin
        normValidTemp <= 1'b0;
      end
      if(normValidTempQ_18) begin
        biasAddrCnt_count <= (biasAddrCnt_count + 7'h01);
        if(biasAddrCnt_valid) begin
          biasAddrCnt_count <= 7'h0;
        end
      end
    end
  end

  always @(posedge clk) begin
    channelInTimes <= temp;
    channelOutTimes <= (channelOut >>> 3);
    featureMemReadAddrTemp_delay_1 <= featureMemReadAddrTemp;
    featureMemReadAddrTemp_delay_2 <= featureMemReadAddrTemp_delay_1;
    if(when_ConvComputeCtrl_l148_1) begin
      if(when_ConvComputeCtrl_l149) begin
        weightReadAddr <= 10'h0;
      end else begin
        weightReadAddr <= (weightReadAddr + 10'h001);
      end
    end else begin
      weightReadAddr <= 10'h0;
    end
    weightReadAddrTemp <= weightReadAddr;
    channelTimesAdd_delay_1 <= channelTimesAdd;
    channelTimesAdd_delay_2 <= channelTimesAdd_delay_1;
    channelTimesAdd_delay_3 <= channelTimesAdd_delay_2;
    channelTimesAdd_delay_4 <= channelTimesAdd_delay_3;
    channelTimesAdd_delay_5 <= channelTimesAdd_delay_4;
    channelTimesAdd_delay_6 <= channelTimesAdd_delay_5;
    channelTimesAdd_delay_7 <= channelTimesAdd_delay_6;
    channelTimesAdd_delay_8 <= channelTimesAdd_delay_7;
    channelTimesAdd_delay_9 <= channelTimesAdd_delay_8;
    channelTimesAdd_delay_10 <= channelTimesAdd_delay_9;
    channelTimesAdd_delay_11 <= channelTimesAdd_delay_10;
    channelTimesAdd_delay_12 <= channelTimesAdd_delay_11;
    channelTimesAdd_delay_13 <= channelTimesAdd_delay_12;
    channelTimesAdd_delay_14 <= channelTimesAdd_delay_13;
    channelTimesAdd_delay_15 <= channelTimesAdd_delay_14;
    channelTimesAdd_delay_16 <= channelTimesAdd_delay_15;
    channelTimesAdd_delay_17 <= channelTimesAdd_delay_16;
    channelTimesAdd_delay_18 <= channelTimesAdd_delay_17;
    normValidTempQ_1 <= normValidTempQ_0;
    normValidTempQ_2 <= normValidTempQ_1;
    normValidTempQ_3 <= normValidTempQ_2;
    normValidTempQ_4 <= normValidTempQ_3;
    normValidTempQ_5 <= normValidTempQ_4;
    normValidTempQ_6 <= normValidTempQ_5;
    normValidTempQ_7 <= normValidTempQ_6;
    normValidTempQ_8 <= normValidTempQ_7;
    normValidTempQ_9 <= normValidTempQ_8;
    normValidTempQ_10 <= normValidTempQ_9;
    normValidTempQ_11 <= normValidTempQ_10;
    normValidTempQ_12 <= normValidTempQ_11;
    normValidTempQ_13 <= normValidTempQ_12;
    normValidTempQ_14 <= normValidTempQ_13;
    normValidTempQ_15 <= normValidTempQ_14;
    normValidTempQ_16 <= normValidTempQ_15;
    normValidTempQ_17 <= normValidTempQ_16;
    normValidTempQ_18 <= normValidTempQ_17;
    normValidTempQ_19 <= normValidTempQ_18;
    normValidTempQ_20 <= normValidTempQ_19;
    normValidTempQ_21 <= normValidTempQ_20;
    normValidTempQ_22 <= normValidTempQ_21;
    normValidTempQ_23 <= normValidTempQ_22;
    normValidTempQ_24 <= normValidTempQ_23;
    normValidTempQ_25 <= normValidTempQ_24;
    normValidTempQ_26 <= normValidTempQ_25;
    normValidTempQ_27 <= normValidTempQ_26;
    normValidTempQ_28 <= normValidTempQ_27;
    normValidTempQ_29 <= normValidTempQ_28;
    normValidTempQ_30 <= normValidTempQ_29;
    normValidTempQ_31 <= normValidTempQ_30;
    normValidTempQ_32 <= normValidTempQ_31;
    normValidTempQ_33 <= normValidTempQ_32;
    _zz_sCount <= (colNumIn * channelInTimes);
    quanDelayTemp_1 <= quanDelayTemp_0;
    quanDelayTemp_2 <= quanDelayTemp_1;
    quanDelayTemp_3 <= quanDelayTemp_2;
    quanDelayTemp_4 <= quanDelayTemp_3;
  end


endmodule

module DataGenerate (
  input               sData_valid,
  output reg          sData_ready,
  input      [63:0]   sData_payload,
  input               start,
  input               enPadding,
  input      [11:0]   channelIn,
  input      [8:0]    rowNumIn,
  input      [8:0]    colNumIn,
  input      [7:0]    zeroDara,
  input      [0:0]    zeroNum,
  output reg          mData_mData_0_valid,
  output reg [63:0]   mData_mData_0_payload,
  output reg          mData_mData_1_valid,
  output reg [63:0]   mData_mData_1_payload,
  output reg          mData_mData_2_valid,
  output reg [63:0]   mData_mData_2_payload,
  output reg          mData_mData_3_valid,
  output reg [63:0]   mData_mData_3_payload,
  output reg          mData_mData_4_valid,
  output reg [63:0]   mData_mData_4_payload,
  output reg          mData_mData_5_valid,
  output reg [63:0]   mData_mData_5_payload,
  output reg          mData_mData_6_valid,
  output reg [63:0]   mData_mData_6_payload,
  output reg          mData_mData_7_valid,
  output reg [63:0]   mData_mData_7_payload,
  output reg          mData_mData_8_valid,
  output reg [63:0]   mData_mData_8_payload,
  input               mData_ready,
  input      [1:0]    convType,
  input               reset,
  input               clk
);

  reg                 padding_1_sData_valid;
  reg        [63:0]   padding_1_sData_payload;
  reg                 padding_1_start;
  reg                 featureGenerate_1_mData_ready;
  reg                 featureWidthConvert_1_sData_valid;
  reg        [63:0]   featureWidthConvert_1_sData_payload;
  reg                 featureWidthConvert_1_mData_ready;
  reg                 featureWidthConvert_1_start;
  wire                padding_1_sData_ready;
  wire                padding_1_mData_valid;
  wire       [63:0]   padding_1_mData_payload;
  wire       [8:0]    padding_1_rowNumOut;
  wire       [8:0]    padding_1_colNumOut;
  wire                padding_1_last;
  wire                featureGenerate_1_sData_ready;
  wire                featureGenerate_1_mData_mData_0_valid;
  wire       [63:0]   featureGenerate_1_mData_mData_0_payload;
  wire                featureGenerate_1_mData_mData_1_valid;
  wire       [63:0]   featureGenerate_1_mData_mData_1_payload;
  wire                featureGenerate_1_mData_mData_2_valid;
  wire       [63:0]   featureGenerate_1_mData_mData_2_payload;
  wire                featureGenerate_1_mData_mData_3_valid;
  wire       [63:0]   featureGenerate_1_mData_mData_3_payload;
  wire                featureGenerate_1_mData_mData_4_valid;
  wire       [63:0]   featureGenerate_1_mData_mData_4_payload;
  wire                featureGenerate_1_mData_mData_5_valid;
  wire       [63:0]   featureGenerate_1_mData_mData_5_payload;
  wire                featureGenerate_1_mData_mData_6_valid;
  wire       [63:0]   featureGenerate_1_mData_mData_6_payload;
  wire                featureGenerate_1_mData_mData_7_valid;
  wire       [63:0]   featureGenerate_1_mData_mData_7_payload;
  wire                featureGenerate_1_mData_mData_8_valid;
  wire       [63:0]   featureGenerate_1_mData_mData_8_payload;
  wire                featureWidthConvert_1_sData_ready;
  wire                featureWidthConvert_1_mData_mData_0_valid;
  wire       [63:0]   featureWidthConvert_1_mData_mData_0_payload;
  wire                featureWidthConvert_1_mData_mData_1_valid;
  wire       [63:0]   featureWidthConvert_1_mData_mData_1_payload;
  wire                featureWidthConvert_1_mData_mData_2_valid;
  wire       [63:0]   featureWidthConvert_1_mData_mData_2_payload;
  wire                featureWidthConvert_1_mData_mData_3_valid;
  wire       [63:0]   featureWidthConvert_1_mData_mData_3_payload;
  wire                featureWidthConvert_1_mData_mData_4_valid;
  wire       [63:0]   featureWidthConvert_1_mData_mData_4_payload;
  wire                featureWidthConvert_1_mData_mData_5_valid;
  wire       [63:0]   featureWidthConvert_1_mData_mData_5_payload;
  wire                featureWidthConvert_1_mData_mData_6_valid;
  wire       [63:0]   featureWidthConvert_1_mData_mData_6_payload;
  wire                featureWidthConvert_1_mData_mData_7_valid;
  wire       [63:0]   featureWidthConvert_1_mData_mData_7_payload;
  wire                featureWidthConvert_1_mData_mData_8_valid;
  wire       [63:0]   featureWidthConvert_1_mData_mData_8_payload;
  wire                when_DataGenerate_l44;

  Padding padding_1 (
    .sData_valid   (padding_1_sData_valid        ), //i
    .sData_ready   (padding_1_sData_ready        ), //o
    .sData_payload (padding_1_sData_payload[63:0]), //i
    .mData_valid   (padding_1_mData_valid        ), //o
    .mData_ready   (featureGenerate_1_sData_ready), //i
    .mData_payload (padding_1_mData_payload[63:0]), //o
    .enPadding     (enPadding                    ), //i
    .channelIn     (channelIn[11:0]              ), //i
    .start         (padding_1_start              ), //i
    .rowNumIn      (rowNumIn[8:0]                ), //i
    .rowNumOut     (padding_1_rowNumOut[8:0]     ), //o
    .colNumIn      (colNumIn[8:0]                ), //i
    .colNumOut     (padding_1_colNumOut[8:0]     ), //o
    .zeroDara      (zeroDara[7:0]                ), //i
    .zeroNum       (zeroNum                      ), //i
    .last          (padding_1_last               ), //o
    .clk           (clk                          ), //i
    .reset         (reset                        )  //i
  );
  FeatureGenerate featureGenerate_1 (
    .sData_valid           (padding_1_mData_valid                        ), //i
    .sData_ready           (featureGenerate_1_sData_ready                ), //o
    .sData_payload         (padding_1_mData_payload[63:0]                ), //i
    .mData_mData_0_valid   (featureGenerate_1_mData_mData_0_valid        ), //o
    .mData_mData_0_payload (featureGenerate_1_mData_mData_0_payload[63:0]), //o
    .mData_mData_1_valid   (featureGenerate_1_mData_mData_1_valid        ), //o
    .mData_mData_1_payload (featureGenerate_1_mData_mData_1_payload[63:0]), //o
    .mData_mData_2_valid   (featureGenerate_1_mData_mData_2_valid        ), //o
    .mData_mData_2_payload (featureGenerate_1_mData_mData_2_payload[63:0]), //o
    .mData_mData_3_valid   (featureGenerate_1_mData_mData_3_valid        ), //o
    .mData_mData_3_payload (featureGenerate_1_mData_mData_3_payload[63:0]), //o
    .mData_mData_4_valid   (featureGenerate_1_mData_mData_4_valid        ), //o
    .mData_mData_4_payload (featureGenerate_1_mData_mData_4_payload[63:0]), //o
    .mData_mData_5_valid   (featureGenerate_1_mData_mData_5_valid        ), //o
    .mData_mData_5_payload (featureGenerate_1_mData_mData_5_payload[63:0]), //o
    .mData_mData_6_valid   (featureGenerate_1_mData_mData_6_valid        ), //o
    .mData_mData_6_payload (featureGenerate_1_mData_mData_6_payload[63:0]), //o
    .mData_mData_7_valid   (featureGenerate_1_mData_mData_7_valid        ), //o
    .mData_mData_7_payload (featureGenerate_1_mData_mData_7_payload[63:0]), //o
    .mData_mData_8_valid   (featureGenerate_1_mData_mData_8_valid        ), //o
    .mData_mData_8_payload (featureGenerate_1_mData_mData_8_payload[63:0]), //o
    .mData_ready           (featureGenerate_1_mData_ready                ), //i
    .rowNumIn              (padding_1_rowNumOut[8:0]                     ), //i
    .colNumIn              (padding_1_colNumOut[8:0]                     ), //i
    .start                 (padding_1_start                              ), //i
    .channelIn             (channelIn[11:0]                              ), //i
    .clk                   (clk                                          ), //i
    .reset                 (reset                                        )  //i
  );
  FeatureWidthConvert featureWidthConvert_1 (
    .sData_valid           (featureWidthConvert_1_sData_valid                ), //i
    .sData_ready           (featureWidthConvert_1_sData_ready                ), //o
    .sData_payload         (featureWidthConvert_1_sData_payload[63:0]        ), //i
    .mData_mData_0_valid   (featureWidthConvert_1_mData_mData_0_valid        ), //o
    .mData_mData_0_payload (featureWidthConvert_1_mData_mData_0_payload[63:0]), //o
    .mData_mData_1_valid   (featureWidthConvert_1_mData_mData_1_valid        ), //o
    .mData_mData_1_payload (featureWidthConvert_1_mData_mData_1_payload[63:0]), //o
    .mData_mData_2_valid   (featureWidthConvert_1_mData_mData_2_valid        ), //o
    .mData_mData_2_payload (featureWidthConvert_1_mData_mData_2_payload[63:0]), //o
    .mData_mData_3_valid   (featureWidthConvert_1_mData_mData_3_valid        ), //o
    .mData_mData_3_payload (featureWidthConvert_1_mData_mData_3_payload[63:0]), //o
    .mData_mData_4_valid   (featureWidthConvert_1_mData_mData_4_valid        ), //o
    .mData_mData_4_payload (featureWidthConvert_1_mData_mData_4_payload[63:0]), //o
    .mData_mData_5_valid   (featureWidthConvert_1_mData_mData_5_valid        ), //o
    .mData_mData_5_payload (featureWidthConvert_1_mData_mData_5_payload[63:0]), //o
    .mData_mData_6_valid   (featureWidthConvert_1_mData_mData_6_valid        ), //o
    .mData_mData_6_payload (featureWidthConvert_1_mData_mData_6_payload[63:0]), //o
    .mData_mData_7_valid   (featureWidthConvert_1_mData_mData_7_valid        ), //o
    .mData_mData_7_payload (featureWidthConvert_1_mData_mData_7_payload[63:0]), //o
    .mData_mData_8_valid   (featureWidthConvert_1_mData_mData_8_valid        ), //o
    .mData_mData_8_payload (featureWidthConvert_1_mData_mData_8_payload[63:0]), //o
    .mData_ready           (featureWidthConvert_1_mData_ready                ), //i
    .rowNumIn              (rowNumIn[8:0]                                    ), //i
    .colNumIn              (colNumIn[8:0]                                    ), //i
    .start                 (featureWidthConvert_1_start                      ), //i
    .channelIn             (channelIn[11:0]                                  ), //i
    .reset                 (reset                                            ), //i
    .clk                   (clk                                              )  //i
  );
  assign when_DataGenerate_l44 = (convType == 2'b00);
  always @(*) begin
    if(when_DataGenerate_l44) begin
      padding_1_sData_valid = sData_valid;
    end else begin
      padding_1_sData_valid = 1'b0;
    end
  end

  always @(*) begin
    if(when_DataGenerate_l44) begin
      sData_ready = padding_1_sData_ready;
    end else begin
      sData_ready = featureWidthConvert_1_sData_ready;
    end
  end

  always @(*) begin
    if(when_DataGenerate_l44) begin
      padding_1_sData_payload = sData_payload;
    end else begin
      padding_1_sData_payload = 64'h0;
    end
  end

  always @(*) begin
    if(when_DataGenerate_l44) begin
      padding_1_start = start;
    end else begin
      padding_1_start = 1'b0;
    end
  end

  always @(*) begin
    if(when_DataGenerate_l44) begin
      mData_mData_0_valid = featureGenerate_1_mData_mData_0_valid;
    end else begin
      mData_mData_0_valid = featureWidthConvert_1_mData_mData_0_valid;
    end
  end

  always @(*) begin
    if(when_DataGenerate_l44) begin
      mData_mData_0_payload = featureGenerate_1_mData_mData_0_payload;
    end else begin
      mData_mData_0_payload = featureWidthConvert_1_mData_mData_0_payload;
    end
  end

  always @(*) begin
    if(when_DataGenerate_l44) begin
      mData_mData_1_valid = featureGenerate_1_mData_mData_1_valid;
    end else begin
      mData_mData_1_valid = featureWidthConvert_1_mData_mData_1_valid;
    end
  end

  always @(*) begin
    if(when_DataGenerate_l44) begin
      mData_mData_1_payload = featureGenerate_1_mData_mData_1_payload;
    end else begin
      mData_mData_1_payload = featureWidthConvert_1_mData_mData_1_payload;
    end
  end

  always @(*) begin
    if(when_DataGenerate_l44) begin
      mData_mData_2_valid = featureGenerate_1_mData_mData_2_valid;
    end else begin
      mData_mData_2_valid = featureWidthConvert_1_mData_mData_2_valid;
    end
  end

  always @(*) begin
    if(when_DataGenerate_l44) begin
      mData_mData_2_payload = featureGenerate_1_mData_mData_2_payload;
    end else begin
      mData_mData_2_payload = featureWidthConvert_1_mData_mData_2_payload;
    end
  end

  always @(*) begin
    if(when_DataGenerate_l44) begin
      mData_mData_3_valid = featureGenerate_1_mData_mData_3_valid;
    end else begin
      mData_mData_3_valid = featureWidthConvert_1_mData_mData_3_valid;
    end
  end

  always @(*) begin
    if(when_DataGenerate_l44) begin
      mData_mData_3_payload = featureGenerate_1_mData_mData_3_payload;
    end else begin
      mData_mData_3_payload = featureWidthConvert_1_mData_mData_3_payload;
    end
  end

  always @(*) begin
    if(when_DataGenerate_l44) begin
      mData_mData_4_valid = featureGenerate_1_mData_mData_4_valid;
    end else begin
      mData_mData_4_valid = featureWidthConvert_1_mData_mData_4_valid;
    end
  end

  always @(*) begin
    if(when_DataGenerate_l44) begin
      mData_mData_4_payload = featureGenerate_1_mData_mData_4_payload;
    end else begin
      mData_mData_4_payload = featureWidthConvert_1_mData_mData_4_payload;
    end
  end

  always @(*) begin
    if(when_DataGenerate_l44) begin
      mData_mData_5_valid = featureGenerate_1_mData_mData_5_valid;
    end else begin
      mData_mData_5_valid = featureWidthConvert_1_mData_mData_5_valid;
    end
  end

  always @(*) begin
    if(when_DataGenerate_l44) begin
      mData_mData_5_payload = featureGenerate_1_mData_mData_5_payload;
    end else begin
      mData_mData_5_payload = featureWidthConvert_1_mData_mData_5_payload;
    end
  end

  always @(*) begin
    if(when_DataGenerate_l44) begin
      mData_mData_6_valid = featureGenerate_1_mData_mData_6_valid;
    end else begin
      mData_mData_6_valid = featureWidthConvert_1_mData_mData_6_valid;
    end
  end

  always @(*) begin
    if(when_DataGenerate_l44) begin
      mData_mData_6_payload = featureGenerate_1_mData_mData_6_payload;
    end else begin
      mData_mData_6_payload = featureWidthConvert_1_mData_mData_6_payload;
    end
  end

  always @(*) begin
    if(when_DataGenerate_l44) begin
      mData_mData_7_valid = featureGenerate_1_mData_mData_7_valid;
    end else begin
      mData_mData_7_valid = featureWidthConvert_1_mData_mData_7_valid;
    end
  end

  always @(*) begin
    if(when_DataGenerate_l44) begin
      mData_mData_7_payload = featureGenerate_1_mData_mData_7_payload;
    end else begin
      mData_mData_7_payload = featureWidthConvert_1_mData_mData_7_payload;
    end
  end

  always @(*) begin
    if(when_DataGenerate_l44) begin
      mData_mData_8_valid = featureGenerate_1_mData_mData_8_valid;
    end else begin
      mData_mData_8_valid = featureWidthConvert_1_mData_mData_8_valid;
    end
  end

  always @(*) begin
    if(when_DataGenerate_l44) begin
      mData_mData_8_payload = featureGenerate_1_mData_mData_8_payload;
    end else begin
      mData_mData_8_payload = featureWidthConvert_1_mData_mData_8_payload;
    end
  end

  always @(*) begin
    if(when_DataGenerate_l44) begin
      featureGenerate_1_mData_ready = mData_ready;
    end else begin
      featureGenerate_1_mData_ready = 1'b0;
    end
  end

  always @(*) begin
    if(when_DataGenerate_l44) begin
      featureWidthConvert_1_sData_valid = 1'b0;
    end else begin
      featureWidthConvert_1_sData_valid = sData_valid;
    end
  end

  always @(*) begin
    if(when_DataGenerate_l44) begin
      featureWidthConvert_1_sData_payload = 64'h0;
    end else begin
      featureWidthConvert_1_sData_payload = sData_payload;
    end
  end

  always @(*) begin
    if(when_DataGenerate_l44) begin
      featureWidthConvert_1_mData_ready = 1'b0;
    end else begin
      featureWidthConvert_1_mData_ready = mData_ready;
    end
  end

  always @(*) begin
    if(when_DataGenerate_l44) begin
      featureWidthConvert_1_start = 1'b0;
    end else begin
      featureWidthConvert_1_start = start;
    end
  end


endmodule

module StreamFifo (
  input               io_push_valid,
  output              io_push_ready,
  input      [63:0]   io_push_payload,
  output              io_pop_valid,
  input               io_pop_ready,
  output     [63:0]   io_pop_payload,
  input               io_flush,
  output     [12:0]   io_occupancy,
  output     [12:0]   io_availability,
  input               clk,
  input               reset
);

  reg        [63:0]   _zz_logic_ram_port0;
  wire       [11:0]   _zz_logic_pushPtr_valueNext;
  wire       [0:0]    _zz_logic_pushPtr_valueNext_1;
  wire       [11:0]   _zz_logic_popPtr_valueNext;
  wire       [0:0]    _zz_logic_popPtr_valueNext_1;
  wire                _zz_logic_ram_port;
  wire                _zz_io_pop_payload;
  wire       [63:0]   _zz_logic_ram_port_1;
  wire       [11:0]   _zz_io_availability;
  reg                 _zz_1;
  reg                 logic_pushPtr_willIncrement;
  reg                 logic_pushPtr_willClear;
  reg        [11:0]   logic_pushPtr_valueNext;
  reg        [11:0]   logic_pushPtr_value;
  wire                logic_pushPtr_willOverflowIfInc;
  wire                logic_pushPtr_willOverflow;
  reg                 logic_popPtr_willIncrement;
  reg                 logic_popPtr_willClear;
  reg        [11:0]   logic_popPtr_valueNext;
  reg        [11:0]   logic_popPtr_value;
  wire                logic_popPtr_willOverflowIfInc;
  wire                logic_popPtr_willOverflow;
  wire                logic_ptrMatch;
  reg                 logic_risingOccupancy;
  wire                logic_pushing;
  wire                logic_popping;
  wire                logic_empty;
  wire                logic_full;
  reg                 _zz_io_pop_valid;
  wire                when_Stream_l1021;
  wire       [11:0]   logic_ptrDif;
  reg [63:0] logic_ram [0:4095];

  assign _zz_logic_pushPtr_valueNext_1 = logic_pushPtr_willIncrement;
  assign _zz_logic_pushPtr_valueNext = {11'd0, _zz_logic_pushPtr_valueNext_1};
  assign _zz_logic_popPtr_valueNext_1 = logic_popPtr_willIncrement;
  assign _zz_logic_popPtr_valueNext = {11'd0, _zz_logic_popPtr_valueNext_1};
  assign _zz_io_availability = (logic_popPtr_value - logic_pushPtr_value);
  assign _zz_io_pop_payload = 1'b1;
  assign _zz_logic_ram_port_1 = io_push_payload;
  always @(posedge clk) begin
    if(_zz_io_pop_payload) begin
      _zz_logic_ram_port0 <= logic_ram[logic_popPtr_valueNext];
    end
  end

  always @(posedge clk) begin
    if(_zz_1) begin
      logic_ram[logic_pushPtr_value] <= _zz_logic_ram_port_1;
    end
  end

  always @(*) begin
    _zz_1 = 1'b0;
    if(logic_pushing) begin
      _zz_1 = 1'b1;
    end
  end

  always @(*) begin
    logic_pushPtr_willIncrement = 1'b0;
    if(logic_pushing) begin
      logic_pushPtr_willIncrement = 1'b1;
    end
  end

  always @(*) begin
    logic_pushPtr_willClear = 1'b0;
    if(io_flush) begin
      logic_pushPtr_willClear = 1'b1;
    end
  end

  assign logic_pushPtr_willOverflowIfInc = (logic_pushPtr_value == 12'hfff);
  assign logic_pushPtr_willOverflow = (logic_pushPtr_willOverflowIfInc && logic_pushPtr_willIncrement);
  always @(*) begin
    logic_pushPtr_valueNext = (logic_pushPtr_value + _zz_logic_pushPtr_valueNext);
    if(logic_pushPtr_willClear) begin
      logic_pushPtr_valueNext = 12'h0;
    end
  end

  always @(*) begin
    logic_popPtr_willIncrement = 1'b0;
    if(logic_popping) begin
      logic_popPtr_willIncrement = 1'b1;
    end
  end

  always @(*) begin
    logic_popPtr_willClear = 1'b0;
    if(io_flush) begin
      logic_popPtr_willClear = 1'b1;
    end
  end

  assign logic_popPtr_willOverflowIfInc = (logic_popPtr_value == 12'hfff);
  assign logic_popPtr_willOverflow = (logic_popPtr_willOverflowIfInc && logic_popPtr_willIncrement);
  always @(*) begin
    logic_popPtr_valueNext = (logic_popPtr_value + _zz_logic_popPtr_valueNext);
    if(logic_popPtr_willClear) begin
      logic_popPtr_valueNext = 12'h0;
    end
  end

  assign logic_ptrMatch = (logic_pushPtr_value == logic_popPtr_value);
  assign logic_pushing = (io_push_valid && io_push_ready);
  assign logic_popping = (io_pop_valid && io_pop_ready);
  assign logic_empty = (logic_ptrMatch && (! logic_risingOccupancy));
  assign logic_full = (logic_ptrMatch && logic_risingOccupancy);
  assign io_push_ready = (! logic_full);
  assign io_pop_valid = ((! logic_empty) && (! (_zz_io_pop_valid && (! logic_full))));
  assign io_pop_payload = _zz_logic_ram_port0;
  assign when_Stream_l1021 = (logic_pushing != logic_popping);
  assign logic_ptrDif = (logic_pushPtr_value - logic_popPtr_value);
  assign io_occupancy = {(logic_risingOccupancy && logic_ptrMatch),logic_ptrDif};
  assign io_availability = {((! logic_risingOccupancy) && logic_ptrMatch),_zz_io_availability};
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      logic_pushPtr_value <= 12'h0;
      logic_popPtr_value <= 12'h0;
      logic_risingOccupancy <= 1'b0;
      _zz_io_pop_valid <= 1'b0;
    end else begin
      logic_pushPtr_value <= logic_pushPtr_valueNext;
      logic_popPtr_value <= logic_popPtr_valueNext;
      _zz_io_pop_valid <= (logic_popPtr_valueNext == logic_pushPtr_value);
      if(when_Stream_l1021) begin
        logic_risingOccupancy <= logic_pushing;
      end
      if(io_flush) begin
        logic_risingOccupancy <= 1'b0;
      end
    end
  end


endmodule

module LeakyRelu (
  input      [7:0]    dataIn_0,
  input      [7:0]    dataIn_1,
  input      [7:0]    dataIn_2,
  input      [7:0]    dataIn_3,
  input      [7:0]    dataIn_4,
  input      [7:0]    dataIn_5,
  input      [7:0]    dataIn_6,
  input      [7:0]    dataIn_7,
  input      [7:0]    quanZero,
  output     [7:0]    dataOut_0,
  output     [7:0]    dataOut_1,
  output     [7:0]    dataOut_2,
  output     [7:0]    dataOut_3,
  output     [7:0]    dataOut_4,
  output     [7:0]    dataOut_5,
  output     [7:0]    dataOut_6,
  output     [7:0]    dataOut_7,
  input               clk,
  input               reset
);

  wire       [15:0]   addSub_A;
  wire       [15:0]   addSub_2_A;
  wire       [15:0]   addSub_4_A;
  wire       [15:0]   addSub_6_A;
  wire       [15:0]   addSub_8_A;
  wire       [15:0]   addSub_10_A;
  wire       [15:0]   addSub_12_A;
  wire       [15:0]   addSub_14_A;
  wire       [15:0]   addSub_S;
  wire       [31:0]   mul_P;
  wire       [15:0]   addSub_1_S;
  wire       [15:0]   addSub_2_S;
  wire       [31:0]   mul_1_P;
  wire       [15:0]   addSub_3_S;
  wire       [15:0]   addSub_4_S;
  wire       [31:0]   mul_2_P;
  wire       [15:0]   addSub_5_S;
  wire       [15:0]   addSub_6_S;
  wire       [31:0]   mul_3_P;
  wire       [15:0]   addSub_7_S;
  wire       [15:0]   addSub_8_S;
  wire       [31:0]   mul_4_P;
  wire       [15:0]   addSub_9_S;
  wire       [15:0]   addSub_10_S;
  wire       [31:0]   mul_5_P;
  wire       [15:0]   addSub_11_S;
  wire       [15:0]   addSub_12_S;
  wire       [31:0]   mul_6_P;
  wire       [15:0]   addSub_13_S;
  wire       [15:0]   addSub_14_S;
  wire       [31:0]   mul_7_P;
  wire       [15:0]   addSub_15_S;
  wire       [16:0]   _zz_when_LeakyRelu_l73_8;
  wire       [14:0]   _zz__zz_A;
  wire       [14:0]   _zz__zz_A_1;
  wire       [14:0]   _zz__zz_A_2;
  wire       [14:0]   _zz__zz_A_3;
  wire       [15:0]   _zz__zz_dataOut_0;
  wire       [15:0]   _zz_when_LeakyRelu_l107;
  wire       [16:0]   _zz_when_LeakyRelu_l73_1_1;
  wire       [14:0]   _zz__zz_A_1_1;
  wire       [14:0]   _zz__zz_A_1_2;
  wire       [14:0]   _zz__zz_A_1_3;
  wire       [14:0]   _zz__zz_A_1_4;
  wire       [15:0]   _zz__zz_dataOut_1;
  wire       [15:0]   _zz_when_LeakyRelu_l107_1;
  wire       [16:0]   _zz_when_LeakyRelu_l73_2_1;
  wire       [14:0]   _zz__zz_A_2_1;
  wire       [14:0]   _zz__zz_A_2_2;
  wire       [14:0]   _zz__zz_A_2_3;
  wire       [14:0]   _zz__zz_A_2_4;
  wire       [15:0]   _zz__zz_dataOut_2;
  wire       [15:0]   _zz_when_LeakyRelu_l107_2;
  wire       [16:0]   _zz_when_LeakyRelu_l73_3_1;
  wire       [14:0]   _zz__zz_A_3_1;
  wire       [14:0]   _zz__zz_A_3_2;
  wire       [14:0]   _zz__zz_A_3_3;
  wire       [14:0]   _zz__zz_A_3_4;
  wire       [15:0]   _zz__zz_dataOut_3;
  wire       [15:0]   _zz_when_LeakyRelu_l107_3;
  wire       [16:0]   _zz_when_LeakyRelu_l73_4_1;
  wire       [14:0]   _zz__zz_A_4;
  wire       [14:0]   _zz__zz_A_4_1;
  wire       [14:0]   _zz__zz_A_4_2;
  wire       [14:0]   _zz__zz_A_4_3;
  wire       [15:0]   _zz__zz_dataOut_4;
  wire       [15:0]   _zz_when_LeakyRelu_l107_4;
  wire       [16:0]   _zz_when_LeakyRelu_l73_5_1;
  wire       [14:0]   _zz__zz_A_5;
  wire       [14:0]   _zz__zz_A_5_1;
  wire       [14:0]   _zz__zz_A_5_2;
  wire       [14:0]   _zz__zz_A_5_3;
  wire       [15:0]   _zz__zz_dataOut_5;
  wire       [15:0]   _zz_when_LeakyRelu_l107_5;
  wire       [16:0]   _zz_when_LeakyRelu_l73_6_1;
  wire       [14:0]   _zz__zz_A_6;
  wire       [14:0]   _zz__zz_A_6_1;
  wire       [14:0]   _zz__zz_A_6_2;
  wire       [14:0]   _zz__zz_A_6_3;
  wire       [15:0]   _zz__zz_dataOut_6;
  wire       [15:0]   _zz_when_LeakyRelu_l107_6;
  wire       [16:0]   _zz_when_LeakyRelu_l73_7_1;
  wire       [14:0]   _zz__zz_A_7;
  wire       [14:0]   _zz__zz_A_7_1;
  wire       [14:0]   _zz__zz_A_7_2;
  wire       [14:0]   _zz__zz_A_7_3;
  wire       [15:0]   _zz__zz_dataOut_7;
  wire       [15:0]   _zz_when_LeakyRelu_l107_7;
  wire       [15:0]   leaky;
  wire       [16:0]   midLow;
  reg        [7:0]    _zz_dataOut_0;
  reg        [15:0]   _zz_A;
  wire       [15:0]   _zz_when_LeakyRelu_l70;
  wire       [31:0]   _zz_when_LeakyRelu_l73;
  reg        [15:0]   _zz_when_LeakyRelu_l70_1;
  reg        [15:0]   _zz_when_LeakyRelu_l70_2;
  reg        [15:0]   _zz_when_LeakyRelu_l70_3;
  wire                when_LeakyRelu_l70;
  wire                when_LeakyRelu_l73;
  wire       [15:0]   _zz_dataOut_0_1;
  wire                when_LeakyRelu_l105;
  wire                when_LeakyRelu_l107;
  reg        [7:0]    _zz_dataOut_1;
  reg        [15:0]   _zz_A_1;
  wire       [15:0]   _zz_when_LeakyRelu_l70_4;
  wire       [31:0]   _zz_when_LeakyRelu_l73_1;
  reg        [15:0]   _zz_when_LeakyRelu_l70_5;
  reg        [15:0]   _zz_when_LeakyRelu_l70_6;
  reg        [15:0]   _zz_when_LeakyRelu_l70_7;
  wire                when_LeakyRelu_l70_1;
  wire                when_LeakyRelu_l73_1;
  wire       [15:0]   _zz_dataOut_1_1;
  wire                when_LeakyRelu_l105_1;
  wire                when_LeakyRelu_l107_1;
  reg        [7:0]    _zz_dataOut_2;
  reg        [15:0]   _zz_A_2;
  wire       [15:0]   _zz_when_LeakyRelu_l70_8;
  wire       [31:0]   _zz_when_LeakyRelu_l73_2;
  reg        [15:0]   _zz_when_LeakyRelu_l70_9;
  reg        [15:0]   _zz_when_LeakyRelu_l70_10;
  reg        [15:0]   _zz_when_LeakyRelu_l70_11;
  wire                when_LeakyRelu_l70_2;
  wire                when_LeakyRelu_l73_2;
  wire       [15:0]   _zz_dataOut_2_1;
  wire                when_LeakyRelu_l105_2;
  wire                when_LeakyRelu_l107_2;
  reg        [7:0]    _zz_dataOut_3;
  reg        [15:0]   _zz_A_3;
  wire       [15:0]   _zz_when_LeakyRelu_l70_12;
  wire       [31:0]   _zz_when_LeakyRelu_l73_3;
  reg        [15:0]   _zz_when_LeakyRelu_l70_13;
  reg        [15:0]   _zz_when_LeakyRelu_l70_14;
  reg        [15:0]   _zz_when_LeakyRelu_l70_15;
  wire                when_LeakyRelu_l70_3;
  wire                when_LeakyRelu_l73_3;
  wire       [15:0]   _zz_dataOut_3_1;
  wire                when_LeakyRelu_l105_3;
  wire                when_LeakyRelu_l107_3;
  reg        [7:0]    _zz_dataOut_4;
  reg        [15:0]   _zz_A_4;
  wire       [15:0]   _zz_when_LeakyRelu_l70_16;
  wire       [31:0]   _zz_when_LeakyRelu_l73_4;
  reg        [15:0]   _zz_when_LeakyRelu_l70_17;
  reg        [15:0]   _zz_when_LeakyRelu_l70_18;
  reg        [15:0]   _zz_when_LeakyRelu_l70_19;
  wire                when_LeakyRelu_l70_4;
  wire                when_LeakyRelu_l73_4;
  wire       [15:0]   _zz_dataOut_4_1;
  wire                when_LeakyRelu_l105_4;
  wire                when_LeakyRelu_l107_4;
  reg        [7:0]    _zz_dataOut_5;
  reg        [15:0]   _zz_A_5;
  wire       [15:0]   _zz_when_LeakyRelu_l70_20;
  wire       [31:0]   _zz_when_LeakyRelu_l73_5;
  reg        [15:0]   _zz_when_LeakyRelu_l70_21;
  reg        [15:0]   _zz_when_LeakyRelu_l70_22;
  reg        [15:0]   _zz_when_LeakyRelu_l70_23;
  wire                when_LeakyRelu_l70_5;
  wire                when_LeakyRelu_l73_5;
  wire       [15:0]   _zz_dataOut_5_1;
  wire                when_LeakyRelu_l105_5;
  wire                when_LeakyRelu_l107_5;
  reg        [7:0]    _zz_dataOut_6;
  reg        [15:0]   _zz_A_6;
  wire       [15:0]   _zz_when_LeakyRelu_l70_24;
  wire       [31:0]   _zz_when_LeakyRelu_l73_6;
  reg        [15:0]   _zz_when_LeakyRelu_l70_25;
  reg        [15:0]   _zz_when_LeakyRelu_l70_26;
  reg        [15:0]   _zz_when_LeakyRelu_l70_27;
  wire                when_LeakyRelu_l70_6;
  wire                when_LeakyRelu_l73_6;
  wire       [15:0]   _zz_dataOut_6_1;
  wire                when_LeakyRelu_l105_6;
  wire                when_LeakyRelu_l107_6;
  reg        [7:0]    _zz_dataOut_7;
  reg        [15:0]   _zz_A_7;
  wire       [15:0]   _zz_when_LeakyRelu_l70_28;
  wire       [31:0]   _zz_when_LeakyRelu_l73_7;
  reg        [15:0]   _zz_when_LeakyRelu_l70_29;
  reg        [15:0]   _zz_when_LeakyRelu_l70_30;
  reg        [15:0]   _zz_when_LeakyRelu_l70_31;
  wire                when_LeakyRelu_l70_7;
  wire                when_LeakyRelu_l73_7;
  wire       [15:0]   _zz_dataOut_7_1;
  wire                when_LeakyRelu_l105_7;
  wire                when_LeakyRelu_l107_7;

  assign _zz_when_LeakyRelu_l73_8 = _zz_when_LeakyRelu_l73[16 : 0];
  assign _zz__zz_A = (_zz_when_LeakyRelu_l73 >>> 17);
  assign _zz__zz_A_1 = ($signed(_zz__zz_A_2) + $signed(_zz__zz_A_3));
  assign _zz__zz_A_2 = (_zz_when_LeakyRelu_l73 >>> 17);
  assign _zz__zz_A_3 = 15'h0001;
  assign _zz__zz_dataOut_0 = _zz_dataOut_0_1;
  assign _zz_when_LeakyRelu_l107 = 16'h00ff;
  assign _zz_when_LeakyRelu_l73_1_1 = _zz_when_LeakyRelu_l73_1[16 : 0];
  assign _zz__zz_A_1_1 = (_zz_when_LeakyRelu_l73_1 >>> 17);
  assign _zz__zz_A_1_2 = ($signed(_zz__zz_A_1_3) + $signed(_zz__zz_A_1_4));
  assign _zz__zz_A_1_3 = (_zz_when_LeakyRelu_l73_1 >>> 17);
  assign _zz__zz_A_1_4 = 15'h0001;
  assign _zz__zz_dataOut_1 = _zz_dataOut_1_1;
  assign _zz_when_LeakyRelu_l107_1 = 16'h00ff;
  assign _zz_when_LeakyRelu_l73_2_1 = _zz_when_LeakyRelu_l73_2[16 : 0];
  assign _zz__zz_A_2_1 = (_zz_when_LeakyRelu_l73_2 >>> 17);
  assign _zz__zz_A_2_2 = ($signed(_zz__zz_A_2_3) + $signed(_zz__zz_A_2_4));
  assign _zz__zz_A_2_3 = (_zz_when_LeakyRelu_l73_2 >>> 17);
  assign _zz__zz_A_2_4 = 15'h0001;
  assign _zz__zz_dataOut_2 = _zz_dataOut_2_1;
  assign _zz_when_LeakyRelu_l107_2 = 16'h00ff;
  assign _zz_when_LeakyRelu_l73_3_1 = _zz_when_LeakyRelu_l73_3[16 : 0];
  assign _zz__zz_A_3_1 = (_zz_when_LeakyRelu_l73_3 >>> 17);
  assign _zz__zz_A_3_2 = ($signed(_zz__zz_A_3_3) + $signed(_zz__zz_A_3_4));
  assign _zz__zz_A_3_3 = (_zz_when_LeakyRelu_l73_3 >>> 17);
  assign _zz__zz_A_3_4 = 15'h0001;
  assign _zz__zz_dataOut_3 = _zz_dataOut_3_1;
  assign _zz_when_LeakyRelu_l107_3 = 16'h00ff;
  assign _zz_when_LeakyRelu_l73_4_1 = _zz_when_LeakyRelu_l73_4[16 : 0];
  assign _zz__zz_A_4 = (_zz_when_LeakyRelu_l73_4 >>> 17);
  assign _zz__zz_A_4_1 = ($signed(_zz__zz_A_4_2) + $signed(_zz__zz_A_4_3));
  assign _zz__zz_A_4_2 = (_zz_when_LeakyRelu_l73_4 >>> 17);
  assign _zz__zz_A_4_3 = 15'h0001;
  assign _zz__zz_dataOut_4 = _zz_dataOut_4_1;
  assign _zz_when_LeakyRelu_l107_4 = 16'h00ff;
  assign _zz_when_LeakyRelu_l73_5_1 = _zz_when_LeakyRelu_l73_5[16 : 0];
  assign _zz__zz_A_5 = (_zz_when_LeakyRelu_l73_5 >>> 17);
  assign _zz__zz_A_5_1 = ($signed(_zz__zz_A_5_2) + $signed(_zz__zz_A_5_3));
  assign _zz__zz_A_5_2 = (_zz_when_LeakyRelu_l73_5 >>> 17);
  assign _zz__zz_A_5_3 = 15'h0001;
  assign _zz__zz_dataOut_5 = _zz_dataOut_5_1;
  assign _zz_when_LeakyRelu_l107_5 = 16'h00ff;
  assign _zz_when_LeakyRelu_l73_6_1 = _zz_when_LeakyRelu_l73_6[16 : 0];
  assign _zz__zz_A_6 = (_zz_when_LeakyRelu_l73_6 >>> 17);
  assign _zz__zz_A_6_1 = ($signed(_zz__zz_A_6_2) + $signed(_zz__zz_A_6_3));
  assign _zz__zz_A_6_2 = (_zz_when_LeakyRelu_l73_6 >>> 17);
  assign _zz__zz_A_6_3 = 15'h0001;
  assign _zz__zz_dataOut_6 = _zz_dataOut_6_1;
  assign _zz_when_LeakyRelu_l107_6 = 16'h00ff;
  assign _zz_when_LeakyRelu_l73_7_1 = _zz_when_LeakyRelu_l73_7[16 : 0];
  assign _zz__zz_A_7 = (_zz_when_LeakyRelu_l73_7 >>> 17);
  assign _zz__zz_A_7_1 = ($signed(_zz__zz_A_7_2) + $signed(_zz__zz_A_7_3));
  assign _zz__zz_A_7_2 = (_zz_when_LeakyRelu_l73_7 >>> 17);
  assign _zz__zz_A_7_3 = 15'h0001;
  assign _zz__zz_dataOut_7 = _zz_dataOut_7_1;
  assign _zz_when_LeakyRelu_l107_7 = 16'h00ff;
  leakySubZ3 addSub (
    .A   (addSub_A[15:0]), //i
    .B   (quanZero[7:0] ), //i
    .S   (addSub_S[15:0]), //o
    .CLK (clk           )  //i
  );
  leakyReluMul mul (
    .A   (_zz_when_LeakyRelu_l70[15:0]), //i
    .B   (leaky[15:0]                 ), //i
    .P   (mul_P[31:0]                 ), //o
    .CLK (clk                         )  //i
  );
  leakyAddZ3 addSub_1 (
    .A   (_zz_A[15:0]     ), //i
    .B   (quanZero[7:0]   ), //i
    .S   (addSub_1_S[15:0]), //o
    .CLK (clk             )  //i
  );
  leakySubZ3 addSub_2 (
    .A   (addSub_2_A[15:0]), //i
    .B   (quanZero[7:0]   ), //i
    .S   (addSub_2_S[15:0]), //o
    .CLK (clk             )  //i
  );
  leakyReluMul mul_1 (
    .A   (_zz_when_LeakyRelu_l70_4[15:0]), //i
    .B   (leaky[15:0]                   ), //i
    .P   (mul_1_P[31:0]                 ), //o
    .CLK (clk                           )  //i
  );
  leakyAddZ3 addSub_3 (
    .A   (_zz_A_1[15:0]   ), //i
    .B   (quanZero[7:0]   ), //i
    .S   (addSub_3_S[15:0]), //o
    .CLK (clk             )  //i
  );
  leakySubZ3 addSub_4 (
    .A   (addSub_4_A[15:0]), //i
    .B   (quanZero[7:0]   ), //i
    .S   (addSub_4_S[15:0]), //o
    .CLK (clk             )  //i
  );
  leakyReluMul mul_2 (
    .A   (_zz_when_LeakyRelu_l70_8[15:0]), //i
    .B   (leaky[15:0]                   ), //i
    .P   (mul_2_P[31:0]                 ), //o
    .CLK (clk                           )  //i
  );
  leakyAddZ3 addSub_5 (
    .A   (_zz_A_2[15:0]   ), //i
    .B   (quanZero[7:0]   ), //i
    .S   (addSub_5_S[15:0]), //o
    .CLK (clk             )  //i
  );
  leakySubZ3 addSub_6 (
    .A   (addSub_6_A[15:0]), //i
    .B   (quanZero[7:0]   ), //i
    .S   (addSub_6_S[15:0]), //o
    .CLK (clk             )  //i
  );
  leakyReluMul mul_3 (
    .A   (_zz_when_LeakyRelu_l70_12[15:0]), //i
    .B   (leaky[15:0]                    ), //i
    .P   (mul_3_P[31:0]                  ), //o
    .CLK (clk                            )  //i
  );
  leakyAddZ3 addSub_7 (
    .A   (_zz_A_3[15:0]   ), //i
    .B   (quanZero[7:0]   ), //i
    .S   (addSub_7_S[15:0]), //o
    .CLK (clk             )  //i
  );
  leakySubZ3 addSub_8 (
    .A   (addSub_8_A[15:0]), //i
    .B   (quanZero[7:0]   ), //i
    .S   (addSub_8_S[15:0]), //o
    .CLK (clk             )  //i
  );
  leakyReluMul mul_4 (
    .A   (_zz_when_LeakyRelu_l70_16[15:0]), //i
    .B   (leaky[15:0]                    ), //i
    .P   (mul_4_P[31:0]                  ), //o
    .CLK (clk                            )  //i
  );
  leakyAddZ3 addSub_9 (
    .A   (_zz_A_4[15:0]   ), //i
    .B   (quanZero[7:0]   ), //i
    .S   (addSub_9_S[15:0]), //o
    .CLK (clk             )  //i
  );
  leakySubZ3 addSub_10 (
    .A   (addSub_10_A[15:0]), //i
    .B   (quanZero[7:0]    ), //i
    .S   (addSub_10_S[15:0]), //o
    .CLK (clk              )  //i
  );
  leakyReluMul mul_5 (
    .A   (_zz_when_LeakyRelu_l70_20[15:0]), //i
    .B   (leaky[15:0]                    ), //i
    .P   (mul_5_P[31:0]                  ), //o
    .CLK (clk                            )  //i
  );
  leakyAddZ3 addSub_11 (
    .A   (_zz_A_5[15:0]    ), //i
    .B   (quanZero[7:0]    ), //i
    .S   (addSub_11_S[15:0]), //o
    .CLK (clk              )  //i
  );
  leakySubZ3 addSub_12 (
    .A   (addSub_12_A[15:0]), //i
    .B   (quanZero[7:0]    ), //i
    .S   (addSub_12_S[15:0]), //o
    .CLK (clk              )  //i
  );
  leakyReluMul mul_6 (
    .A   (_zz_when_LeakyRelu_l70_24[15:0]), //i
    .B   (leaky[15:0]                    ), //i
    .P   (mul_6_P[31:0]                  ), //o
    .CLK (clk                            )  //i
  );
  leakyAddZ3 addSub_13 (
    .A   (_zz_A_6[15:0]    ), //i
    .B   (quanZero[7:0]    ), //i
    .S   (addSub_13_S[15:0]), //o
    .CLK (clk              )  //i
  );
  leakySubZ3 addSub_14 (
    .A   (addSub_14_A[15:0]), //i
    .B   (quanZero[7:0]    ), //i
    .S   (addSub_14_S[15:0]), //o
    .CLK (clk              )  //i
  );
  leakyReluMul mul_7 (
    .A   (_zz_when_LeakyRelu_l70_28[15:0]), //i
    .B   (leaky[15:0]                    ), //i
    .P   (mul_7_P[31:0]                  ), //o
    .CLK (clk                            )  //i
  );
  leakyAddZ3 addSub_15 (
    .A   (_zz_A_7[15:0]    ), //i
    .B   (quanZero[7:0]    ), //i
    .S   (addSub_15_S[15:0]), //o
    .CLK (clk              )  //i
  );
  assign leaky = 16'h3333;
  assign midLow = 17'h10000;
  assign addSub_A = {8'h0,dataIn_0};
  assign _zz_when_LeakyRelu_l70 = addSub_S;
  assign _zz_when_LeakyRelu_l73 = mul_P;
  assign when_LeakyRelu_l70 = (! _zz_when_LeakyRelu_l70_3[15]);
  assign when_LeakyRelu_l73 = (_zz_when_LeakyRelu_l73_8 < midLow);
  assign _zz_dataOut_0_1 = addSub_1_S;
  assign when_LeakyRelu_l105 = _zz_dataOut_0_1[15];
  assign when_LeakyRelu_l107 = ($signed(_zz_when_LeakyRelu_l107) < $signed(_zz_dataOut_0_1));
  assign dataOut_0 = _zz_dataOut_0;
  assign addSub_2_A = {8'h0,dataIn_1};
  assign _zz_when_LeakyRelu_l70_4 = addSub_2_S;
  assign _zz_when_LeakyRelu_l73_1 = mul_1_P;
  assign when_LeakyRelu_l70_1 = (! _zz_when_LeakyRelu_l70_7[15]);
  assign when_LeakyRelu_l73_1 = (_zz_when_LeakyRelu_l73_1_1 < midLow);
  assign _zz_dataOut_1_1 = addSub_3_S;
  assign when_LeakyRelu_l105_1 = _zz_dataOut_1_1[15];
  assign when_LeakyRelu_l107_1 = ($signed(_zz_when_LeakyRelu_l107_1) < $signed(_zz_dataOut_1_1));
  assign dataOut_1 = _zz_dataOut_1;
  assign addSub_4_A = {8'h0,dataIn_2};
  assign _zz_when_LeakyRelu_l70_8 = addSub_4_S;
  assign _zz_when_LeakyRelu_l73_2 = mul_2_P;
  assign when_LeakyRelu_l70_2 = (! _zz_when_LeakyRelu_l70_11[15]);
  assign when_LeakyRelu_l73_2 = (_zz_when_LeakyRelu_l73_2_1 < midLow);
  assign _zz_dataOut_2_1 = addSub_5_S;
  assign when_LeakyRelu_l105_2 = _zz_dataOut_2_1[15];
  assign when_LeakyRelu_l107_2 = ($signed(_zz_when_LeakyRelu_l107_2) < $signed(_zz_dataOut_2_1));
  assign dataOut_2 = _zz_dataOut_2;
  assign addSub_6_A = {8'h0,dataIn_3};
  assign _zz_when_LeakyRelu_l70_12 = addSub_6_S;
  assign _zz_when_LeakyRelu_l73_3 = mul_3_P;
  assign when_LeakyRelu_l70_3 = (! _zz_when_LeakyRelu_l70_15[15]);
  assign when_LeakyRelu_l73_3 = (_zz_when_LeakyRelu_l73_3_1 < midLow);
  assign _zz_dataOut_3_1 = addSub_7_S;
  assign when_LeakyRelu_l105_3 = _zz_dataOut_3_1[15];
  assign when_LeakyRelu_l107_3 = ($signed(_zz_when_LeakyRelu_l107_3) < $signed(_zz_dataOut_3_1));
  assign dataOut_3 = _zz_dataOut_3;
  assign addSub_8_A = {8'h0,dataIn_4};
  assign _zz_when_LeakyRelu_l70_16 = addSub_8_S;
  assign _zz_when_LeakyRelu_l73_4 = mul_4_P;
  assign when_LeakyRelu_l70_4 = (! _zz_when_LeakyRelu_l70_19[15]);
  assign when_LeakyRelu_l73_4 = (_zz_when_LeakyRelu_l73_4_1 < midLow);
  assign _zz_dataOut_4_1 = addSub_9_S;
  assign when_LeakyRelu_l105_4 = _zz_dataOut_4_1[15];
  assign when_LeakyRelu_l107_4 = ($signed(_zz_when_LeakyRelu_l107_4) < $signed(_zz_dataOut_4_1));
  assign dataOut_4 = _zz_dataOut_4;
  assign addSub_10_A = {8'h0,dataIn_5};
  assign _zz_when_LeakyRelu_l70_20 = addSub_10_S;
  assign _zz_when_LeakyRelu_l73_5 = mul_5_P;
  assign when_LeakyRelu_l70_5 = (! _zz_when_LeakyRelu_l70_23[15]);
  assign when_LeakyRelu_l73_5 = (_zz_when_LeakyRelu_l73_5_1 < midLow);
  assign _zz_dataOut_5_1 = addSub_11_S;
  assign when_LeakyRelu_l105_5 = _zz_dataOut_5_1[15];
  assign when_LeakyRelu_l107_5 = ($signed(_zz_when_LeakyRelu_l107_5) < $signed(_zz_dataOut_5_1));
  assign dataOut_5 = _zz_dataOut_5;
  assign addSub_12_A = {8'h0,dataIn_6};
  assign _zz_when_LeakyRelu_l70_24 = addSub_12_S;
  assign _zz_when_LeakyRelu_l73_6 = mul_6_P;
  assign when_LeakyRelu_l70_6 = (! _zz_when_LeakyRelu_l70_27[15]);
  assign when_LeakyRelu_l73_6 = (_zz_when_LeakyRelu_l73_6_1 < midLow);
  assign _zz_dataOut_6_1 = addSub_13_S;
  assign when_LeakyRelu_l105_6 = _zz_dataOut_6_1[15];
  assign when_LeakyRelu_l107_6 = ($signed(_zz_when_LeakyRelu_l107_6) < $signed(_zz_dataOut_6_1));
  assign dataOut_6 = _zz_dataOut_6;
  assign addSub_14_A = {8'h0,dataIn_7};
  assign _zz_when_LeakyRelu_l70_28 = addSub_14_S;
  assign _zz_when_LeakyRelu_l73_7 = mul_7_P;
  assign when_LeakyRelu_l70_7 = (! _zz_when_LeakyRelu_l70_31[15]);
  assign when_LeakyRelu_l73_7 = (_zz_when_LeakyRelu_l73_7_1 < midLow);
  assign _zz_dataOut_7_1 = addSub_15_S;
  assign when_LeakyRelu_l105_7 = _zz_dataOut_7_1[15];
  assign when_LeakyRelu_l107_7 = ($signed(_zz_when_LeakyRelu_l107_7) < $signed(_zz_dataOut_7_1));
  assign dataOut_7 = _zz_dataOut_7;
  always @(posedge clk) begin
    _zz_when_LeakyRelu_l70_1 <= _zz_when_LeakyRelu_l70;
    _zz_when_LeakyRelu_l70_2 <= _zz_when_LeakyRelu_l70_1;
    _zz_when_LeakyRelu_l70_3 <= _zz_when_LeakyRelu_l70_2;
    if(when_LeakyRelu_l70) begin
      _zz_A <= _zz_when_LeakyRelu_l70_3;
    end else begin
      if(when_LeakyRelu_l73) begin
        _zz_A <= {{1{_zz__zz_A[14]}}, _zz__zz_A};
      end else begin
        _zz_A <= {{1{_zz__zz_A_1[14]}}, _zz__zz_A_1};
      end
    end
    if(when_LeakyRelu_l105) begin
      _zz_dataOut_0 <= 8'h0;
    end else begin
      if(when_LeakyRelu_l107) begin
        _zz_dataOut_0 <= 8'hff;
      end else begin
        _zz_dataOut_0 <= _zz__zz_dataOut_0[7:0];
      end
    end
    _zz_when_LeakyRelu_l70_5 <= _zz_when_LeakyRelu_l70_4;
    _zz_when_LeakyRelu_l70_6 <= _zz_when_LeakyRelu_l70_5;
    _zz_when_LeakyRelu_l70_7 <= _zz_when_LeakyRelu_l70_6;
    if(when_LeakyRelu_l70_1) begin
      _zz_A_1 <= _zz_when_LeakyRelu_l70_7;
    end else begin
      if(when_LeakyRelu_l73_1) begin
        _zz_A_1 <= {{1{_zz__zz_A_1_1[14]}}, _zz__zz_A_1_1};
      end else begin
        _zz_A_1 <= {{1{_zz__zz_A_1_2[14]}}, _zz__zz_A_1_2};
      end
    end
    if(when_LeakyRelu_l105_1) begin
      _zz_dataOut_1 <= 8'h0;
    end else begin
      if(when_LeakyRelu_l107_1) begin
        _zz_dataOut_1 <= 8'hff;
      end else begin
        _zz_dataOut_1 <= _zz__zz_dataOut_1[7:0];
      end
    end
    _zz_when_LeakyRelu_l70_9 <= _zz_when_LeakyRelu_l70_8;
    _zz_when_LeakyRelu_l70_10 <= _zz_when_LeakyRelu_l70_9;
    _zz_when_LeakyRelu_l70_11 <= _zz_when_LeakyRelu_l70_10;
    if(when_LeakyRelu_l70_2) begin
      _zz_A_2 <= _zz_when_LeakyRelu_l70_11;
    end else begin
      if(when_LeakyRelu_l73_2) begin
        _zz_A_2 <= {{1{_zz__zz_A_2_1[14]}}, _zz__zz_A_2_1};
      end else begin
        _zz_A_2 <= {{1{_zz__zz_A_2_2[14]}}, _zz__zz_A_2_2};
      end
    end
    if(when_LeakyRelu_l105_2) begin
      _zz_dataOut_2 <= 8'h0;
    end else begin
      if(when_LeakyRelu_l107_2) begin
        _zz_dataOut_2 <= 8'hff;
      end else begin
        _zz_dataOut_2 <= _zz__zz_dataOut_2[7:0];
      end
    end
    _zz_when_LeakyRelu_l70_13 <= _zz_when_LeakyRelu_l70_12;
    _zz_when_LeakyRelu_l70_14 <= _zz_when_LeakyRelu_l70_13;
    _zz_when_LeakyRelu_l70_15 <= _zz_when_LeakyRelu_l70_14;
    if(when_LeakyRelu_l70_3) begin
      _zz_A_3 <= _zz_when_LeakyRelu_l70_15;
    end else begin
      if(when_LeakyRelu_l73_3) begin
        _zz_A_3 <= {{1{_zz__zz_A_3_1[14]}}, _zz__zz_A_3_1};
      end else begin
        _zz_A_3 <= {{1{_zz__zz_A_3_2[14]}}, _zz__zz_A_3_2};
      end
    end
    if(when_LeakyRelu_l105_3) begin
      _zz_dataOut_3 <= 8'h0;
    end else begin
      if(when_LeakyRelu_l107_3) begin
        _zz_dataOut_3 <= 8'hff;
      end else begin
        _zz_dataOut_3 <= _zz__zz_dataOut_3[7:0];
      end
    end
    _zz_when_LeakyRelu_l70_17 <= _zz_when_LeakyRelu_l70_16;
    _zz_when_LeakyRelu_l70_18 <= _zz_when_LeakyRelu_l70_17;
    _zz_when_LeakyRelu_l70_19 <= _zz_when_LeakyRelu_l70_18;
    if(when_LeakyRelu_l70_4) begin
      _zz_A_4 <= _zz_when_LeakyRelu_l70_19;
    end else begin
      if(when_LeakyRelu_l73_4) begin
        _zz_A_4 <= {{1{_zz__zz_A_4[14]}}, _zz__zz_A_4};
      end else begin
        _zz_A_4 <= {{1{_zz__zz_A_4_1[14]}}, _zz__zz_A_4_1};
      end
    end
    if(when_LeakyRelu_l105_4) begin
      _zz_dataOut_4 <= 8'h0;
    end else begin
      if(when_LeakyRelu_l107_4) begin
        _zz_dataOut_4 <= 8'hff;
      end else begin
        _zz_dataOut_4 <= _zz__zz_dataOut_4[7:0];
      end
    end
    _zz_when_LeakyRelu_l70_21 <= _zz_when_LeakyRelu_l70_20;
    _zz_when_LeakyRelu_l70_22 <= _zz_when_LeakyRelu_l70_21;
    _zz_when_LeakyRelu_l70_23 <= _zz_when_LeakyRelu_l70_22;
    if(when_LeakyRelu_l70_5) begin
      _zz_A_5 <= _zz_when_LeakyRelu_l70_23;
    end else begin
      if(when_LeakyRelu_l73_5) begin
        _zz_A_5 <= {{1{_zz__zz_A_5[14]}}, _zz__zz_A_5};
      end else begin
        _zz_A_5 <= {{1{_zz__zz_A_5_1[14]}}, _zz__zz_A_5_1};
      end
    end
    if(when_LeakyRelu_l105_5) begin
      _zz_dataOut_5 <= 8'h0;
    end else begin
      if(when_LeakyRelu_l107_5) begin
        _zz_dataOut_5 <= 8'hff;
      end else begin
        _zz_dataOut_5 <= _zz__zz_dataOut_5[7:0];
      end
    end
    _zz_when_LeakyRelu_l70_25 <= _zz_when_LeakyRelu_l70_24;
    _zz_when_LeakyRelu_l70_26 <= _zz_when_LeakyRelu_l70_25;
    _zz_when_LeakyRelu_l70_27 <= _zz_when_LeakyRelu_l70_26;
    if(when_LeakyRelu_l70_6) begin
      _zz_A_6 <= _zz_when_LeakyRelu_l70_27;
    end else begin
      if(when_LeakyRelu_l73_6) begin
        _zz_A_6 <= {{1{_zz__zz_A_6[14]}}, _zz__zz_A_6};
      end else begin
        _zz_A_6 <= {{1{_zz__zz_A_6_1[14]}}, _zz__zz_A_6_1};
      end
    end
    if(when_LeakyRelu_l105_6) begin
      _zz_dataOut_6 <= 8'h0;
    end else begin
      if(when_LeakyRelu_l107_6) begin
        _zz_dataOut_6 <= 8'hff;
      end else begin
        _zz_dataOut_6 <= _zz__zz_dataOut_6[7:0];
      end
    end
    _zz_when_LeakyRelu_l70_29 <= _zz_when_LeakyRelu_l70_28;
    _zz_when_LeakyRelu_l70_30 <= _zz_when_LeakyRelu_l70_29;
    _zz_when_LeakyRelu_l70_31 <= _zz_when_LeakyRelu_l70_30;
    if(when_LeakyRelu_l70_7) begin
      _zz_A_7 <= _zz_when_LeakyRelu_l70_31;
    end else begin
      if(when_LeakyRelu_l73_7) begin
        _zz_A_7 <= {{1{_zz__zz_A_7[14]}}, _zz__zz_A_7};
      end else begin
        _zz_A_7 <= {{1{_zz__zz_A_7_1[14]}}, _zz__zz_A_7_1};
      end
    end
    if(when_LeakyRelu_l105_7) begin
      _zz_dataOut_7 <= 8'h0;
    end else begin
      if(when_LeakyRelu_l107_7) begin
        _zz_dataOut_7 <= 8'hff;
      end else begin
        _zz_dataOut_7 <= _zz__zz_dataOut_7[7:0];
      end
    end
  end


endmodule

module Zero (
  input      [15:0]   dataIn_0,
  input      [15:0]   dataIn_1,
  input      [15:0]   dataIn_2,
  input      [15:0]   dataIn_3,
  input      [15:0]   dataIn_4,
  input      [15:0]   dataIn_5,
  input      [15:0]   dataIn_6,
  input      [15:0]   dataIn_7,
  input      [7:0]    quan_1,
  output     [7:0]    dataOut_0,
  output     [7:0]    dataOut_1,
  output     [7:0]    dataOut_2,
  output     [7:0]    dataOut_3,
  output     [7:0]    dataOut_4,
  output     [7:0]    dataOut_5,
  output     [7:0]    dataOut_6,
  output     [7:0]    dataOut_7,
  input               clk,
  input               reset
);

  wire       [15:0]   addZero_0_S;
  wire       [15:0]   addZero_1_S;
  wire       [15:0]   addZero_2_S;
  wire       [15:0]   addZero_3_S;
  wire       [15:0]   addZero_4_S;
  wire       [15:0]   addZero_5_S;
  wire       [15:0]   addZero_6_S;
  wire       [15:0]   addZero_7_S;
  wire       [15:0]   _zz_normalData_0;
  wire       [15:0]   _zz_when_Quan_l155;
  wire       [15:0]   _zz_normalData_1;
  wire       [15:0]   _zz_when_Quan_l155_1;
  wire       [15:0]   _zz_normalData_2;
  wire       [15:0]   _zz_when_Quan_l155_2;
  wire       [15:0]   _zz_normalData_3;
  wire       [15:0]   _zz_when_Quan_l155_3;
  wire       [15:0]   _zz_normalData_4;
  wire       [15:0]   _zz_when_Quan_l155_4;
  wire       [15:0]   _zz_normalData_5;
  wire       [15:0]   _zz_when_Quan_l155_5;
  wire       [15:0]   _zz_normalData_6;
  wire       [15:0]   _zz_when_Quan_l155_6;
  wire       [15:0]   _zz_normalData_7;
  wire       [15:0]   _zz_when_Quan_l155_7;
  wire       [15:0]   addZeroTemp_0;
  wire       [15:0]   addZeroTemp_1;
  wire       [15:0]   addZeroTemp_2;
  wire       [15:0]   addZeroTemp_3;
  wire       [15:0]   addZeroTemp_4;
  wire       [15:0]   addZeroTemp_5;
  wire       [15:0]   addZeroTemp_6;
  wire       [15:0]   addZeroTemp_7;
  reg        [7:0]    normalData_0;
  reg        [7:0]    normalData_1;
  reg        [7:0]    normalData_2;
  reg        [7:0]    normalData_3;
  reg        [7:0]    normalData_4;
  reg        [7:0]    normalData_5;
  reg        [7:0]    normalData_6;
  reg        [7:0]    normalData_7;
  wire                when_Quan_l153;
  wire                when_Quan_l155;
  wire                when_Quan_l153_1;
  wire                when_Quan_l155_1;
  wire                when_Quan_l153_2;
  wire                when_Quan_l155_2;
  wire                when_Quan_l153_3;
  wire                when_Quan_l155_3;
  wire                when_Quan_l153_4;
  wire                when_Quan_l155_4;
  wire                when_Quan_l153_5;
  wire                when_Quan_l155_5;
  wire                when_Quan_l153_6;
  wire                when_Quan_l155_6;
  wire                when_Quan_l153_7;
  wire                when_Quan_l155_7;

  assign _zz_normalData_0 = addZeroTemp_0;
  assign _zz_when_Quan_l155 = 16'h00ff;
  assign _zz_normalData_1 = addZeroTemp_1;
  assign _zz_when_Quan_l155_1 = 16'h00ff;
  assign _zz_normalData_2 = addZeroTemp_2;
  assign _zz_when_Quan_l155_2 = 16'h00ff;
  assign _zz_normalData_3 = addZeroTemp_3;
  assign _zz_when_Quan_l155_3 = 16'h00ff;
  assign _zz_normalData_4 = addZeroTemp_4;
  assign _zz_when_Quan_l155_4 = 16'h00ff;
  assign _zz_normalData_5 = addZeroTemp_5;
  assign _zz_when_Quan_l155_5 = 16'h00ff;
  assign _zz_normalData_6 = addZeroTemp_6;
  assign _zz_when_Quan_l155_6 = 16'h00ff;
  assign _zz_normalData_7 = addZeroTemp_7;
  assign _zz_when_Quan_l155_7 = 16'h00ff;
  AddZero addZero_0 (
    .A   (dataIn_0[15:0]   ), //i
    .B   (quan_1[7:0]      ), //i
    .S   (addZero_0_S[15:0]), //o
    .CLK (clk              )  //i
  );
  AddZero addZero_1 (
    .A   (dataIn_1[15:0]   ), //i
    .B   (quan_1[7:0]      ), //i
    .S   (addZero_1_S[15:0]), //o
    .CLK (clk              )  //i
  );
  AddZero addZero_2 (
    .A   (dataIn_2[15:0]   ), //i
    .B   (quan_1[7:0]      ), //i
    .S   (addZero_2_S[15:0]), //o
    .CLK (clk              )  //i
  );
  AddZero addZero_3 (
    .A   (dataIn_3[15:0]   ), //i
    .B   (quan_1[7:0]      ), //i
    .S   (addZero_3_S[15:0]), //o
    .CLK (clk              )  //i
  );
  AddZero addZero_4 (
    .A   (dataIn_4[15:0]   ), //i
    .B   (quan_1[7:0]      ), //i
    .S   (addZero_4_S[15:0]), //o
    .CLK (clk              )  //i
  );
  AddZero addZero_5 (
    .A   (dataIn_5[15:0]   ), //i
    .B   (quan_1[7:0]      ), //i
    .S   (addZero_5_S[15:0]), //o
    .CLK (clk              )  //i
  );
  AddZero addZero_6 (
    .A   (dataIn_6[15:0]   ), //i
    .B   (quan_1[7:0]      ), //i
    .S   (addZero_6_S[15:0]), //o
    .CLK (clk              )  //i
  );
  AddZero addZero_7 (
    .A   (dataIn_7[15:0]   ), //i
    .B   (quan_1[7:0]      ), //i
    .S   (addZero_7_S[15:0]), //o
    .CLK (clk              )  //i
  );
  assign addZeroTemp_0 = addZero_0_S;
  assign addZeroTemp_1 = addZero_1_S;
  assign addZeroTemp_2 = addZero_2_S;
  assign addZeroTemp_3 = addZero_3_S;
  assign addZeroTemp_4 = addZero_4_S;
  assign addZeroTemp_5 = addZero_5_S;
  assign addZeroTemp_6 = addZero_6_S;
  assign addZeroTemp_7 = addZero_7_S;
  assign dataOut_0 = normalData_0;
  assign dataOut_1 = normalData_1;
  assign dataOut_2 = normalData_2;
  assign dataOut_3 = normalData_3;
  assign dataOut_4 = normalData_4;
  assign dataOut_5 = normalData_5;
  assign dataOut_6 = normalData_6;
  assign dataOut_7 = normalData_7;
  assign when_Quan_l153 = addZeroTemp_0[15];
  assign when_Quan_l155 = ($signed(_zz_when_Quan_l155) < $signed(addZeroTemp_0));
  assign when_Quan_l153_1 = addZeroTemp_1[15];
  assign when_Quan_l155_1 = ($signed(_zz_when_Quan_l155_1) < $signed(addZeroTemp_1));
  assign when_Quan_l153_2 = addZeroTemp_2[15];
  assign when_Quan_l155_2 = ($signed(_zz_when_Quan_l155_2) < $signed(addZeroTemp_2));
  assign when_Quan_l153_3 = addZeroTemp_3[15];
  assign when_Quan_l155_3 = ($signed(_zz_when_Quan_l155_3) < $signed(addZeroTemp_3));
  assign when_Quan_l153_4 = addZeroTemp_4[15];
  assign when_Quan_l155_4 = ($signed(_zz_when_Quan_l155_4) < $signed(addZeroTemp_4));
  assign when_Quan_l153_5 = addZeroTemp_5[15];
  assign when_Quan_l155_5 = ($signed(_zz_when_Quan_l155_5) < $signed(addZeroTemp_5));
  assign when_Quan_l153_6 = addZeroTemp_6[15];
  assign when_Quan_l155_6 = ($signed(_zz_when_Quan_l155_6) < $signed(addZeroTemp_6));
  assign when_Quan_l153_7 = addZeroTemp_7[15];
  assign when_Quan_l155_7 = ($signed(_zz_when_Quan_l155_7) < $signed(addZeroTemp_7));
  always @(posedge clk) begin
    if(when_Quan_l153) begin
      normalData_0 <= 8'h0;
    end else begin
      if(when_Quan_l155) begin
        normalData_0 <= 8'hff;
      end else begin
        normalData_0 <= _zz_normalData_0[7:0];
      end
    end
    if(when_Quan_l153_1) begin
      normalData_1 <= 8'h0;
    end else begin
      if(when_Quan_l155_1) begin
        normalData_1 <= 8'hff;
      end else begin
        normalData_1 <= _zz_normalData_1[7:0];
      end
    end
    if(when_Quan_l153_2) begin
      normalData_2 <= 8'h0;
    end else begin
      if(when_Quan_l155_2) begin
        normalData_2 <= 8'hff;
      end else begin
        normalData_2 <= _zz_normalData_2[7:0];
      end
    end
    if(when_Quan_l153_3) begin
      normalData_3 <= 8'h0;
    end else begin
      if(when_Quan_l155_3) begin
        normalData_3 <= 8'hff;
      end else begin
        normalData_3 <= _zz_normalData_3[7:0];
      end
    end
    if(when_Quan_l153_4) begin
      normalData_4 <= 8'h0;
    end else begin
      if(when_Quan_l155_4) begin
        normalData_4 <= 8'hff;
      end else begin
        normalData_4 <= _zz_normalData_4[7:0];
      end
    end
    if(when_Quan_l153_5) begin
      normalData_5 <= 8'h0;
    end else begin
      if(when_Quan_l155_5) begin
        normalData_5 <= 8'hff;
      end else begin
        normalData_5 <= _zz_normalData_5[7:0];
      end
    end
    if(when_Quan_l153_6) begin
      normalData_6 <= 8'h0;
    end else begin
      if(when_Quan_l155_6) begin
        normalData_6 <= 8'hff;
      end else begin
        normalData_6 <= _zz_normalData_6[7:0];
      end
    end
    if(when_Quan_l153_7) begin
      normalData_7 <= 8'h0;
    end else begin
      if(when_Quan_l155_7) begin
        normalData_7 <= 8'hff;
      end else begin
        normalData_7 <= _zz_normalData_7[7:0];
      end
    end
  end


endmodule

module Shift (
  input      [31:0]   shift_dataIn_0,
  input      [31:0]   shift_dataIn_1,
  input      [31:0]   shift_dataIn_2,
  input      [31:0]   shift_dataIn_3,
  input      [31:0]   shift_dataIn_4,
  input      [31:0]   shift_dataIn_5,
  input      [31:0]   shift_dataIn_6,
  input      [31:0]   shift_dataIn_7,
  input      [31:0]   shift_quan_0,
  input      [31:0]   shift_quan_1,
  input      [31:0]   shift_quan_2,
  input      [31:0]   shift_quan_3,
  input      [31:0]   shift_quan_4,
  input      [31:0]   shift_quan_5,
  input      [31:0]   shift_quan_6,
  input      [31:0]   shift_quan_7,
  output     [15:0]   shift_dataOut_0,
  output     [15:0]   shift_dataOut_1,
  output     [15:0]   shift_dataOut_2,
  output     [15:0]   shift_dataOut_3,
  output     [15:0]   shift_dataOut_4,
  output     [15:0]   shift_dataOut_5,
  output     [15:0]   shift_dataOut_6,
  output     [15:0]   shift_dataOut_7,
  input               clk,
  input               reset
);

  wire       [15:0]   _zz__zz_shift_dataOut_0_1;
  wire       [0:0]    _zz__zz_shift_dataOut_0_1_1;
  wire       [14:0]   _zz__zz_shift_dataOut_0_1_2;
  wire       [15:0]   _zz__zz_shift_dataOut_0_1_3;
  wire       [0:0]    _zz__zz_shift_dataOut_0_1_4;
  wire       [14:0]   _zz__zz_shift_dataOut_0_1_5;
  wire       [15:0]   _zz__zz_shift_dataOut_1_1;
  wire       [0:0]    _zz__zz_shift_dataOut_1_1_1;
  wire       [14:0]   _zz__zz_shift_dataOut_1_1_2;
  wire       [15:0]   _zz__zz_shift_dataOut_1_1_3;
  wire       [0:0]    _zz__zz_shift_dataOut_1_1_4;
  wire       [14:0]   _zz__zz_shift_dataOut_1_1_5;
  wire       [15:0]   _zz__zz_shift_dataOut_2_1;
  wire       [0:0]    _zz__zz_shift_dataOut_2_1_1;
  wire       [14:0]   _zz__zz_shift_dataOut_2_1_2;
  wire       [15:0]   _zz__zz_shift_dataOut_2_1_3;
  wire       [0:0]    _zz__zz_shift_dataOut_2_1_4;
  wire       [14:0]   _zz__zz_shift_dataOut_2_1_5;
  wire       [15:0]   _zz__zz_shift_dataOut_3_1;
  wire       [0:0]    _zz__zz_shift_dataOut_3_1_1;
  wire       [14:0]   _zz__zz_shift_dataOut_3_1_2;
  wire       [15:0]   _zz__zz_shift_dataOut_3_1_3;
  wire       [0:0]    _zz__zz_shift_dataOut_3_1_4;
  wire       [14:0]   _zz__zz_shift_dataOut_3_1_5;
  wire       [15:0]   _zz__zz_shift_dataOut_4_1;
  wire       [0:0]    _zz__zz_shift_dataOut_4_1_1;
  wire       [14:0]   _zz__zz_shift_dataOut_4_1_2;
  wire       [15:0]   _zz__zz_shift_dataOut_4_1_3;
  wire       [0:0]    _zz__zz_shift_dataOut_4_1_4;
  wire       [14:0]   _zz__zz_shift_dataOut_4_1_5;
  wire       [15:0]   _zz__zz_shift_dataOut_5_1;
  wire       [0:0]    _zz__zz_shift_dataOut_5_1_1;
  wire       [14:0]   _zz__zz_shift_dataOut_5_1_2;
  wire       [15:0]   _zz__zz_shift_dataOut_5_1_3;
  wire       [0:0]    _zz__zz_shift_dataOut_5_1_4;
  wire       [14:0]   _zz__zz_shift_dataOut_5_1_5;
  wire       [15:0]   _zz__zz_shift_dataOut_6_1;
  wire       [0:0]    _zz__zz_shift_dataOut_6_1_1;
  wire       [14:0]   _zz__zz_shift_dataOut_6_1_2;
  wire       [15:0]   _zz__zz_shift_dataOut_6_1_3;
  wire       [0:0]    _zz__zz_shift_dataOut_6_1_4;
  wire       [14:0]   _zz__zz_shift_dataOut_6_1_5;
  wire       [15:0]   _zz__zz_shift_dataOut_7_1;
  wire       [0:0]    _zz__zz_shift_dataOut_7_1_1;
  wire       [14:0]   _zz__zz_shift_dataOut_7_1_2;
  wire       [15:0]   _zz__zz_shift_dataOut_7_1_3;
  wire       [0:0]    _zz__zz_shift_dataOut_7_1_4;
  wire       [14:0]   _zz__zz_shift_dataOut_7_1_5;
  wire       [31:0]   _zz_shift_dataOut_0;
  reg        [15:0]   _zz_shift_dataOut_0_1;
  wire                when_Quan_l112;
  wire       [31:0]   _zz_shift_dataOut_1;
  reg        [15:0]   _zz_shift_dataOut_1_1;
  wire                when_Quan_l112_1;
  wire       [31:0]   _zz_shift_dataOut_2;
  reg        [15:0]   _zz_shift_dataOut_2_1;
  wire                when_Quan_l112_2;
  wire       [31:0]   _zz_shift_dataOut_3;
  reg        [15:0]   _zz_shift_dataOut_3_1;
  wire                when_Quan_l112_3;
  wire       [31:0]   _zz_shift_dataOut_4;
  reg        [15:0]   _zz_shift_dataOut_4_1;
  wire                when_Quan_l112_4;
  wire       [31:0]   _zz_shift_dataOut_5;
  reg        [15:0]   _zz_shift_dataOut_5_1;
  wire                when_Quan_l112_5;
  wire       [31:0]   _zz_shift_dataOut_6;
  reg        [15:0]   _zz_shift_dataOut_6_1;
  wire                when_Quan_l112_6;
  wire       [31:0]   _zz_shift_dataOut_7;
  reg        [15:0]   _zz_shift_dataOut_7_1;
  wire                when_Quan_l112_7;

  assign _zz__zz_shift_dataOut_0_1 = {_zz__zz_shift_dataOut_0_1_1,_zz__zz_shift_dataOut_0_1_2};
  assign _zz__zz_shift_dataOut_0_1_1 = _zz_shift_dataOut_0[31];
  assign _zz__zz_shift_dataOut_0_1_2 = _zz_shift_dataOut_0[15 : 1];
  assign _zz__zz_shift_dataOut_0_1_3 = 16'h0001;
  assign _zz__zz_shift_dataOut_0_1_4 = _zz_shift_dataOut_0[31];
  assign _zz__zz_shift_dataOut_0_1_5 = _zz_shift_dataOut_0[15 : 1];
  assign _zz__zz_shift_dataOut_1_1 = {_zz__zz_shift_dataOut_1_1_1,_zz__zz_shift_dataOut_1_1_2};
  assign _zz__zz_shift_dataOut_1_1_1 = _zz_shift_dataOut_1[31];
  assign _zz__zz_shift_dataOut_1_1_2 = _zz_shift_dataOut_1[15 : 1];
  assign _zz__zz_shift_dataOut_1_1_3 = 16'h0001;
  assign _zz__zz_shift_dataOut_1_1_4 = _zz_shift_dataOut_1[31];
  assign _zz__zz_shift_dataOut_1_1_5 = _zz_shift_dataOut_1[15 : 1];
  assign _zz__zz_shift_dataOut_2_1 = {_zz__zz_shift_dataOut_2_1_1,_zz__zz_shift_dataOut_2_1_2};
  assign _zz__zz_shift_dataOut_2_1_1 = _zz_shift_dataOut_2[31];
  assign _zz__zz_shift_dataOut_2_1_2 = _zz_shift_dataOut_2[15 : 1];
  assign _zz__zz_shift_dataOut_2_1_3 = 16'h0001;
  assign _zz__zz_shift_dataOut_2_1_4 = _zz_shift_dataOut_2[31];
  assign _zz__zz_shift_dataOut_2_1_5 = _zz_shift_dataOut_2[15 : 1];
  assign _zz__zz_shift_dataOut_3_1 = {_zz__zz_shift_dataOut_3_1_1,_zz__zz_shift_dataOut_3_1_2};
  assign _zz__zz_shift_dataOut_3_1_1 = _zz_shift_dataOut_3[31];
  assign _zz__zz_shift_dataOut_3_1_2 = _zz_shift_dataOut_3[15 : 1];
  assign _zz__zz_shift_dataOut_3_1_3 = 16'h0001;
  assign _zz__zz_shift_dataOut_3_1_4 = _zz_shift_dataOut_3[31];
  assign _zz__zz_shift_dataOut_3_1_5 = _zz_shift_dataOut_3[15 : 1];
  assign _zz__zz_shift_dataOut_4_1 = {_zz__zz_shift_dataOut_4_1_1,_zz__zz_shift_dataOut_4_1_2};
  assign _zz__zz_shift_dataOut_4_1_1 = _zz_shift_dataOut_4[31];
  assign _zz__zz_shift_dataOut_4_1_2 = _zz_shift_dataOut_4[15 : 1];
  assign _zz__zz_shift_dataOut_4_1_3 = 16'h0001;
  assign _zz__zz_shift_dataOut_4_1_4 = _zz_shift_dataOut_4[31];
  assign _zz__zz_shift_dataOut_4_1_5 = _zz_shift_dataOut_4[15 : 1];
  assign _zz__zz_shift_dataOut_5_1 = {_zz__zz_shift_dataOut_5_1_1,_zz__zz_shift_dataOut_5_1_2};
  assign _zz__zz_shift_dataOut_5_1_1 = _zz_shift_dataOut_5[31];
  assign _zz__zz_shift_dataOut_5_1_2 = _zz_shift_dataOut_5[15 : 1];
  assign _zz__zz_shift_dataOut_5_1_3 = 16'h0001;
  assign _zz__zz_shift_dataOut_5_1_4 = _zz_shift_dataOut_5[31];
  assign _zz__zz_shift_dataOut_5_1_5 = _zz_shift_dataOut_5[15 : 1];
  assign _zz__zz_shift_dataOut_6_1 = {_zz__zz_shift_dataOut_6_1_1,_zz__zz_shift_dataOut_6_1_2};
  assign _zz__zz_shift_dataOut_6_1_1 = _zz_shift_dataOut_6[31];
  assign _zz__zz_shift_dataOut_6_1_2 = _zz_shift_dataOut_6[15 : 1];
  assign _zz__zz_shift_dataOut_6_1_3 = 16'h0001;
  assign _zz__zz_shift_dataOut_6_1_4 = _zz_shift_dataOut_6[31];
  assign _zz__zz_shift_dataOut_6_1_5 = _zz_shift_dataOut_6[15 : 1];
  assign _zz__zz_shift_dataOut_7_1 = {_zz__zz_shift_dataOut_7_1_1,_zz__zz_shift_dataOut_7_1_2};
  assign _zz__zz_shift_dataOut_7_1_1 = _zz_shift_dataOut_7[31];
  assign _zz__zz_shift_dataOut_7_1_2 = _zz_shift_dataOut_7[15 : 1];
  assign _zz__zz_shift_dataOut_7_1_3 = 16'h0001;
  assign _zz__zz_shift_dataOut_7_1_4 = _zz_shift_dataOut_7[31];
  assign _zz__zz_shift_dataOut_7_1_5 = _zz_shift_dataOut_7[15 : 1];
  assign _zz_shift_dataOut_0 = ($signed(shift_dataIn_0) >>> shift_quan_0);
  assign when_Quan_l112 = _zz_shift_dataOut_0[0];
  assign shift_dataOut_0 = _zz_shift_dataOut_0_1;
  assign _zz_shift_dataOut_1 = ($signed(shift_dataIn_1) >>> shift_quan_1);
  assign when_Quan_l112_1 = _zz_shift_dataOut_1[0];
  assign shift_dataOut_1 = _zz_shift_dataOut_1_1;
  assign _zz_shift_dataOut_2 = ($signed(shift_dataIn_2) >>> shift_quan_2);
  assign when_Quan_l112_2 = _zz_shift_dataOut_2[0];
  assign shift_dataOut_2 = _zz_shift_dataOut_2_1;
  assign _zz_shift_dataOut_3 = ($signed(shift_dataIn_3) >>> shift_quan_3);
  assign when_Quan_l112_3 = _zz_shift_dataOut_3[0];
  assign shift_dataOut_3 = _zz_shift_dataOut_3_1;
  assign _zz_shift_dataOut_4 = ($signed(shift_dataIn_4) >>> shift_quan_4);
  assign when_Quan_l112_4 = _zz_shift_dataOut_4[0];
  assign shift_dataOut_4 = _zz_shift_dataOut_4_1;
  assign _zz_shift_dataOut_5 = ($signed(shift_dataIn_5) >>> shift_quan_5);
  assign when_Quan_l112_5 = _zz_shift_dataOut_5[0];
  assign shift_dataOut_5 = _zz_shift_dataOut_5_1;
  assign _zz_shift_dataOut_6 = ($signed(shift_dataIn_6) >>> shift_quan_6);
  assign when_Quan_l112_6 = _zz_shift_dataOut_6[0];
  assign shift_dataOut_6 = _zz_shift_dataOut_6_1;
  assign _zz_shift_dataOut_7 = ($signed(shift_dataIn_7) >>> shift_quan_7);
  assign when_Quan_l112_7 = _zz_shift_dataOut_7[0];
  assign shift_dataOut_7 = _zz_shift_dataOut_7_1;
  always @(posedge clk) begin
    if(when_Quan_l112) begin
      _zz_shift_dataOut_0_1 <= ($signed(_zz__zz_shift_dataOut_0_1) + $signed(_zz__zz_shift_dataOut_0_1_3));
    end else begin
      _zz_shift_dataOut_0_1 <= {_zz__zz_shift_dataOut_0_1_4,_zz__zz_shift_dataOut_0_1_5};
    end
    if(when_Quan_l112_1) begin
      _zz_shift_dataOut_1_1 <= ($signed(_zz__zz_shift_dataOut_1_1) + $signed(_zz__zz_shift_dataOut_1_1_3));
    end else begin
      _zz_shift_dataOut_1_1 <= {_zz__zz_shift_dataOut_1_1_4,_zz__zz_shift_dataOut_1_1_5};
    end
    if(when_Quan_l112_2) begin
      _zz_shift_dataOut_2_1 <= ($signed(_zz__zz_shift_dataOut_2_1) + $signed(_zz__zz_shift_dataOut_2_1_3));
    end else begin
      _zz_shift_dataOut_2_1 <= {_zz__zz_shift_dataOut_2_1_4,_zz__zz_shift_dataOut_2_1_5};
    end
    if(when_Quan_l112_3) begin
      _zz_shift_dataOut_3_1 <= ($signed(_zz__zz_shift_dataOut_3_1) + $signed(_zz__zz_shift_dataOut_3_1_3));
    end else begin
      _zz_shift_dataOut_3_1 <= {_zz__zz_shift_dataOut_3_1_4,_zz__zz_shift_dataOut_3_1_5};
    end
    if(when_Quan_l112_4) begin
      _zz_shift_dataOut_4_1 <= ($signed(_zz__zz_shift_dataOut_4_1) + $signed(_zz__zz_shift_dataOut_4_1_3));
    end else begin
      _zz_shift_dataOut_4_1 <= {_zz__zz_shift_dataOut_4_1_4,_zz__zz_shift_dataOut_4_1_5};
    end
    if(when_Quan_l112_5) begin
      _zz_shift_dataOut_5_1 <= ($signed(_zz__zz_shift_dataOut_5_1) + $signed(_zz__zz_shift_dataOut_5_1_3));
    end else begin
      _zz_shift_dataOut_5_1 <= {_zz__zz_shift_dataOut_5_1_4,_zz__zz_shift_dataOut_5_1_5};
    end
    if(when_Quan_l112_6) begin
      _zz_shift_dataOut_6_1 <= ($signed(_zz__zz_shift_dataOut_6_1) + $signed(_zz__zz_shift_dataOut_6_1_3));
    end else begin
      _zz_shift_dataOut_6_1 <= {_zz__zz_shift_dataOut_6_1_4,_zz__zz_shift_dataOut_6_1_5};
    end
    if(when_Quan_l112_7) begin
      _zz_shift_dataOut_7_1 <= ($signed(_zz__zz_shift_dataOut_7_1) + $signed(_zz__zz_shift_dataOut_7_1_3));
    end else begin
      _zz_shift_dataOut_7_1 <= {_zz__zz_shift_dataOut_7_1_4,_zz__zz_shift_dataOut_7_1_5};
    end
  end


endmodule

module Scale (
  input      [31:0]   Scale_dataIn_0,
  input      [31:0]   Scale_dataIn_1,
  input      [31:0]   Scale_dataIn_2,
  input      [31:0]   Scale_dataIn_3,
  input      [31:0]   Scale_dataIn_4,
  input      [31:0]   Scale_dataIn_5,
  input      [31:0]   Scale_dataIn_6,
  input      [31:0]   Scale_dataIn_7,
  input      [31:0]   Scale_quan_0,
  input      [31:0]   Scale_quan_1,
  input      [31:0]   Scale_quan_2,
  input      [31:0]   Scale_quan_3,
  input      [31:0]   Scale_quan_4,
  input      [31:0]   Scale_quan_5,
  input      [31:0]   Scale_quan_6,
  input      [31:0]   Scale_quan_7,
  output     [31:0]   Scale_dataOut_0,
  output     [31:0]   Scale_dataOut_1,
  output     [31:0]   Scale_dataOut_2,
  output     [31:0]   Scale_dataOut_3,
  output     [31:0]   Scale_dataOut_4,
  output     [31:0]   Scale_dataOut_5,
  output     [31:0]   Scale_dataOut_6,
  output     [31:0]   Scale_dataOut_7,
  input               clk
);

  wire       [31:0]   mul_P;
  wire       [31:0]   mul_1_P;
  wire       [31:0]   mul_2_P;
  wire       [31:0]   mul_3_P;
  wire       [31:0]   mul_4_P;
  wire       [31:0]   mul_5_P;
  wire       [31:0]   mul_6_P;
  wire       [31:0]   mul_7_P;
  wire       [31:0]   scaleMulOut_0;
  wire       [31:0]   scaleMulOut_1;
  wire       [31:0]   scaleMulOut_2;
  wire       [31:0]   scaleMulOut_3;
  wire       [31:0]   scaleMulOut_4;
  wire       [31:0]   scaleMulOut_5;
  wire       [31:0]   scaleMulOut_6;
  wire       [31:0]   scaleMulOut_7;

  scaleMul mul (
    .A   (Scale_dataIn_0[31:0]), //i
    .B   (Scale_quan_0[31:0]  ), //i
    .P   (mul_P[31:0]         ), //o
    .CLK (clk                 )  //i
  );
  scaleMul mul_1 (
    .A   (Scale_dataIn_1[31:0]), //i
    .B   (Scale_quan_1[31:0]  ), //i
    .P   (mul_1_P[31:0]       ), //o
    .CLK (clk                 )  //i
  );
  scaleMul mul_2 (
    .A   (Scale_dataIn_2[31:0]), //i
    .B   (Scale_quan_2[31:0]  ), //i
    .P   (mul_2_P[31:0]       ), //o
    .CLK (clk                 )  //i
  );
  scaleMul mul_3 (
    .A   (Scale_dataIn_3[31:0]), //i
    .B   (Scale_quan_3[31:0]  ), //i
    .P   (mul_3_P[31:0]       ), //o
    .CLK (clk                 )  //i
  );
  scaleMul mul_4 (
    .A   (Scale_dataIn_4[31:0]), //i
    .B   (Scale_quan_4[31:0]  ), //i
    .P   (mul_4_P[31:0]       ), //o
    .CLK (clk                 )  //i
  );
  scaleMul mul_5 (
    .A   (Scale_dataIn_5[31:0]), //i
    .B   (Scale_quan_5[31:0]  ), //i
    .P   (mul_5_P[31:0]       ), //o
    .CLK (clk                 )  //i
  );
  scaleMul mul_6 (
    .A   (Scale_dataIn_6[31:0]), //i
    .B   (Scale_quan_6[31:0]  ), //i
    .P   (mul_6_P[31:0]       ), //o
    .CLK (clk                 )  //i
  );
  scaleMul mul_7 (
    .A   (Scale_dataIn_7[31:0]), //i
    .B   (Scale_quan_7[31:0]  ), //i
    .P   (mul_7_P[31:0]       ), //o
    .CLK (clk                 )  //i
  );
  assign scaleMulOut_0 = mul_P;
  assign scaleMulOut_1 = mul_1_P;
  assign scaleMulOut_2 = mul_2_P;
  assign scaleMulOut_3 = mul_3_P;
  assign scaleMulOut_4 = mul_4_P;
  assign scaleMulOut_5 = mul_5_P;
  assign scaleMulOut_6 = mul_6_P;
  assign scaleMulOut_7 = mul_7_P;
  assign Scale_dataOut_0 = scaleMulOut_0;
  assign Scale_dataOut_1 = scaleMulOut_1;
  assign Scale_dataOut_2 = scaleMulOut_2;
  assign Scale_dataOut_3 = scaleMulOut_3;
  assign Scale_dataOut_4 = scaleMulOut_4;
  assign Scale_dataOut_5 = scaleMulOut_5;
  assign Scale_dataOut_6 = scaleMulOut_6;
  assign Scale_dataOut_7 = scaleMulOut_7;

endmodule

module Bias (
  input      [31:0]   Bias_dataIn_0,
  input      [31:0]   Bias_dataIn_1,
  input      [31:0]   Bias_dataIn_2,
  input      [31:0]   Bias_dataIn_3,
  input      [31:0]   Bias_dataIn_4,
  input      [31:0]   Bias_dataIn_5,
  input      [31:0]   Bias_dataIn_6,
  input      [31:0]   Bias_dataIn_7,
  input      [31:0]   Bias_quan_0,
  input      [31:0]   Bias_quan_1,
  input      [31:0]   Bias_quan_2,
  input      [31:0]   Bias_quan_3,
  input      [31:0]   Bias_quan_4,
  input      [31:0]   Bias_quan_5,
  input      [31:0]   Bias_quan_6,
  input      [31:0]   Bias_quan_7,
  output     [31:0]   Bias_dataOut_0,
  output     [31:0]   Bias_dataOut_1,
  output     [31:0]   Bias_dataOut_2,
  output     [31:0]   Bias_dataOut_3,
  output     [31:0]   Bias_dataOut_4,
  output     [31:0]   Bias_dataOut_5,
  output     [31:0]   Bias_dataOut_6,
  output     [31:0]   Bias_dataOut_7,
  input               clk
);

  wire       [31:0]   addSub_S;
  wire       [31:0]   addSub_1_S;
  wire       [31:0]   addSub_2_S;
  wire       [31:0]   addSub_3_S;
  wire       [31:0]   addSub_4_S;
  wire       [31:0]   addSub_5_S;
  wire       [31:0]   addSub_6_S;
  wire       [31:0]   addSub_7_S;

  biasAdd addSub (
    .A   (Bias_dataIn_0[31:0]), //i
    .B   (Bias_quan_0[31:0]  ), //i
    .S   (addSub_S[31:0]     ), //o
    .CLK (clk                )  //i
  );
  biasAdd addSub_1 (
    .A   (Bias_dataIn_1[31:0]), //i
    .B   (Bias_quan_1[31:0]  ), //i
    .S   (addSub_1_S[31:0]   ), //o
    .CLK (clk                )  //i
  );
  biasAdd addSub_2 (
    .A   (Bias_dataIn_2[31:0]), //i
    .B   (Bias_quan_2[31:0]  ), //i
    .S   (addSub_2_S[31:0]   ), //o
    .CLK (clk                )  //i
  );
  biasAdd addSub_3 (
    .A   (Bias_dataIn_3[31:0]), //i
    .B   (Bias_quan_3[31:0]  ), //i
    .S   (addSub_3_S[31:0]   ), //o
    .CLK (clk                )  //i
  );
  biasAdd addSub_4 (
    .A   (Bias_dataIn_4[31:0]), //i
    .B   (Bias_quan_4[31:0]  ), //i
    .S   (addSub_4_S[31:0]   ), //o
    .CLK (clk                )  //i
  );
  biasAdd addSub_5 (
    .A   (Bias_dataIn_5[31:0]), //i
    .B   (Bias_quan_5[31:0]  ), //i
    .S   (addSub_5_S[31:0]   ), //o
    .CLK (clk                )  //i
  );
  biasAdd addSub_6 (
    .A   (Bias_dataIn_6[31:0]), //i
    .B   (Bias_quan_6[31:0]  ), //i
    .S   (addSub_6_S[31:0]   ), //o
    .CLK (clk                )  //i
  );
  biasAdd addSub_7 (
    .A   (Bias_dataIn_7[31:0]), //i
    .B   (Bias_quan_7[31:0]  ), //i
    .S   (addSub_7_S[31:0]   ), //o
    .CLK (clk                )  //i
  );
  assign Bias_dataOut_0 = addSub_S;
  assign Bias_dataOut_1 = addSub_1_S;
  assign Bias_dataOut_2 = addSub_2_S;
  assign Bias_dataOut_3 = addSub_3_S;
  assign Bias_dataOut_4 = addSub_4_S;
  assign Bias_dataOut_5 = addSub_5_S;
  assign Bias_dataOut_6 = addSub_6_S;
  assign Bias_dataOut_7 = addSub_7_S;

endmodule

//FifoSync replaced by FifoSync

//FifoSync replaced by FifoSync

//FifoSync replaced by FifoSync

//FifoSync replaced by FifoSync

//FifoSync replaced by FifoSync

//FifoSync replaced by FifoSync

//FifoSync replaced by FifoSync

//FifoSync replaced by FifoSync

module FifoSync (
  output              full,
  input               wr_en,
  input      [63:0]   din,
  output              empty,
  output     [63:0]   dout,
  input               rd_en,
  output     [11:0]   wr_data_count,
  output     [11:0]   rd_data_count,
  output              data_valid,
  output              rd_rst_busy,
  output              wr_rst_busy,
  input               reset,
  input               clk
);

  wire                xpm_fifo_sync_1_almost_empty;
  wire                xpm_fifo_sync_1_almost_full;
  wire                xpm_fifo_sync_1_data_valid;
  wire                xpm_fifo_sync_1_dbiterr;
  wire       [63:0]   xpm_fifo_sync_1_dout;
  wire                xpm_fifo_sync_1_empty;
  wire                xpm_fifo_sync_1_full;
  wire                xpm_fifo_sync_1_overflow;
  wire                xpm_fifo_sync_1_prog_empty;
  wire                xpm_fifo_sync_1_prog_full;
  wire       [11:0]   xpm_fifo_sync_1_rd_data_count;
  wire                xpm_fifo_sync_1_rd_rst_busy;
  wire                xpm_fifo_sync_1_sbiterr;
  wire                xpm_fifo_sync_1_underflow;
  wire                xpm_fifo_sync_1_wr_ack;
  wire       [11:0]   xpm_fifo_sync_1_wr_data_count;
  wire                xpm_fifo_sync_1_wr_rst_busy;
  wire                almost_empty;
  wire                almost_full;
  wire                dbiterr;
  wire                overflow;
  wire                prog_empty;
  wire                prog_full;
  wire                sbiterr;
  wire                underflow;
  wire                wr_ack;
  wire                injectdbiterr;
  wire                injectsbiterr;
  wire                sleep;

  xpm_fifo_sync #(
    .CASCADE_HEIGHT(0),
    .DOUT_RESET_VALUE(0),
    .ECC_MODE("no_ecc"),
    .FIFO_MEMORY_TYPE("block"),
    .FIFO_READ_LATENCY(0),
    .FIFO_WRITE_DEPTH(2048),
    .FULL_RESET_VALUE(0),
    .PROG_EMPTY_THRESH(5),
    .PROG_FULL_THRESH(2043),
    .RD_DATA_COUNT_WIDTH(12),
    .READ_DATA_WIDTH(64),
    .READ_MODE("fwft"),
    .SIM_ASSERT_CHK(0),
    .USE_ADV_FEATURES("0707"),
    .WAKEUP_TIME(0),
    .WRITE_DATA_WIDTH(64),
    .WR_DATA_COUNT_WIDTH(12)
  ) xpm_fifo_sync_1 (
    .almost_empty  (xpm_fifo_sync_1_almost_empty       ), //o
    .almost_full   (xpm_fifo_sync_1_almost_full        ), //o
    .data_valid    (xpm_fifo_sync_1_data_valid         ), //o
    .dbiterr       (xpm_fifo_sync_1_dbiterr            ), //o
    .dout          (xpm_fifo_sync_1_dout[63:0]         ), //o
    .empty         (xpm_fifo_sync_1_empty              ), //o
    .full          (xpm_fifo_sync_1_full               ), //o
    .overflow      (xpm_fifo_sync_1_overflow           ), //o
    .prog_empty    (xpm_fifo_sync_1_prog_empty         ), //o
    .prog_full     (xpm_fifo_sync_1_prog_full          ), //o
    .rd_data_count (xpm_fifo_sync_1_rd_data_count[11:0]), //o
    .rd_rst_busy   (xpm_fifo_sync_1_rd_rst_busy        ), //o
    .sbiterr       (xpm_fifo_sync_1_sbiterr            ), //o
    .underflow     (xpm_fifo_sync_1_underflow          ), //o
    .wr_ack        (xpm_fifo_sync_1_wr_ack             ), //o
    .wr_data_count (xpm_fifo_sync_1_wr_data_count[11:0]), //o
    .wr_rst_busy   (xpm_fifo_sync_1_wr_rst_busy        ), //o
    .din           (din[63:0]                          ), //i
    .injectdbiterr (injectdbiterr                      ), //i
    .injectsbiterr (injectsbiterr                      ), //i
    .rd_en         (rd_en                              ), //i
    .rst           (reset                              ), //i
    .sleep         (sleep                              ), //i
    .wr_clk        (clk                                ), //i
    .wr_en         (wr_en                              )  //i
  );
  assign injectdbiterr = 1'b0;
  assign injectsbiterr = 1'b0;
  assign sleep = 1'b0;
  assign almost_empty = xpm_fifo_sync_1_almost_empty;
  assign almost_full = xpm_fifo_sync_1_almost_full;
  assign data_valid = xpm_fifo_sync_1_data_valid;
  assign dbiterr = xpm_fifo_sync_1_dbiterr;
  assign dout = xpm_fifo_sync_1_dout;
  assign empty = xpm_fifo_sync_1_empty;
  assign full = xpm_fifo_sync_1_full;
  assign overflow = xpm_fifo_sync_1_overflow;
  assign prog_empty = xpm_fifo_sync_1_prog_empty;
  assign prog_full = xpm_fifo_sync_1_prog_full;
  assign rd_data_count = xpm_fifo_sync_1_rd_data_count;
  assign rd_rst_busy = xpm_fifo_sync_1_rd_rst_busy;
  assign sbiterr = xpm_fifo_sync_1_sbiterr;
  assign underflow = xpm_fifo_sync_1_underflow;
  assign wr_ack = xpm_fifo_sync_1_wr_ack;
  assign wr_data_count = xpm_fifo_sync_1_wr_data_count;
  assign wr_rst_busy = xpm_fifo_sync_1_wr_rst_busy;

endmodule

//sdpram_9 replaced by sdpram_9

//sdpram_9 replaced by sdpram_9

module sdpram_9 (
  output     [255:0]  doutb,
  input      [8:0]    addra,
  input      [6:0]    addrb,
  input      [63:0]   dina,
  input               ena,
  input               enb,
  input      [0:0]    wea,
  input               clk
);

  wire                temp_dbiterrb;
  wire       [255:0]  temp_doutb;
  wire                temp_sbiterrb;
  wire                dbiterrb;
  wire                sbiterrb;
  wire                injectdbiterra;
  wire                injectsbiterra;
  wire                regceb;
  wire                rstb;
  wire                sleep;

  xpm_memory_sdpram #(
    .ADDR_WIDTH_A(9),
    .ADDR_WIDTH_B(7),
    .AUTO_SLEEP_TIME(0),
    .BYTE_WRITE_WIDTH_A(64),
    .CASCADE_HEIGHT(0),
    .CLOCKING_MODE("common_clock"),
    .ECC_MODE("no_ecc"),
    .MEMORY_INIT_FILE("none"),
    .MEMORY_INIT_PARAM("0"),
    .MEMORY_OPTIMIZATION("true"),
    .MEMORY_PRIMITIVE("block"),
    .MEMORY_SIZE(32768),
    .MESSAGE_CONTROL(0),
    .READ_DATA_WIDTH_B(256),
    .READ_LATENCY_B(1),
    .READ_RESET_VALUE_B("0"),
    .RST_MODE_A("SYNC"),
    .RST_MODE_B("SYNC"),
    .SIM_ASSERT_CHK(0),
    .USE_EMBEDDED_CONSTRAINT(0),
    .USE_MEM_INIT(1),
    .WAKEUP_TIME("disable_sleep"),
    .WRITE_DATA_WIDTH_A(64),
    .WRITE_MODE_B("read_first"),
    .USE_MEM_INIT_MMI(0),
    .WRITE_PROTECT(1)
  ) temp (
    .dbiterrb       (temp_dbiterrb    ), //o
    .doutb          (temp_doutb[255:0]), //o
    .sbiterrb       (temp_sbiterrb    ), //o
    .addra          (addra[8:0]       ), //i
    .addrb          (addrb[6:0]       ), //i
    .clka           (clk              ), //i
    .clkb           (clk              ), //i
    .dina           (dina[63:0]       ), //i
    .ena            (ena              ), //i
    .enb            (enb              ), //i
    .injectdbiterra (injectdbiterra   ), //i
    .injectsbiterra (injectsbiterra   ), //i
    .regceb         (regceb           ), //i
    .rstb           (rstb             ), //i
    .sleep          (sleep            ), //i
    .wea            (wea              )  //i
  );
  assign injectdbiterra = 1'b0;
  assign injectsbiterra = 1'b0;
  assign regceb = 1'b1;
  assign rstb = 1'b0;
  assign sleep = 1'b0;
  assign dbiterrb = temp_dbiterrb;
  assign doutb = temp_doutb;
  assign sbiterrb = temp_sbiterrb;

endmodule

//sdpram replaced by sdpram

//sdpram replaced by sdpram

//sdpram replaced by sdpram

//sdpram replaced by sdpram

//sdpram replaced by sdpram

//sdpram replaced by sdpram

//sdpram replaced by sdpram

//sdpram replaced by sdpram

module sdpram (
  output     [511:0]  doutb,
  input      [12:0]   addra,
  input      [9:0]    addrb,
  input      [63:0]   dina,
  input               ena,
  input               enb,
  input      [0:0]    wea,
  input               clk
);

  wire                temp_dbiterrb;
  wire       [511:0]  temp_doutb;
  wire                temp_sbiterrb;
  wire                dbiterrb;
  wire                sbiterrb;
  wire                injectdbiterra;
  wire                injectsbiterra;
  wire                regceb;
  wire                rstb;
  wire                sleep;

  xpm_memory_sdpram #(
    .ADDR_WIDTH_A(13),
    .ADDR_WIDTH_B(10),
    .AUTO_SLEEP_TIME(0),
    .BYTE_WRITE_WIDTH_A(64),
    .CASCADE_HEIGHT(0),
    .CLOCKING_MODE("common_clock"),
    .ECC_MODE("no_ecc"),
    .MEMORY_INIT_FILE("none"),
    .MEMORY_INIT_PARAM("0"),
    .MEMORY_OPTIMIZATION("true"),
    .MEMORY_PRIMITIVE("block"),
    .MEMORY_SIZE(524288),
    .MESSAGE_CONTROL(0),
    .READ_DATA_WIDTH_B(512),
    .READ_LATENCY_B(1),
    .READ_RESET_VALUE_B("0"),
    .RST_MODE_A("SYNC"),
    .RST_MODE_B("SYNC"),
    .SIM_ASSERT_CHK(0),
    .USE_EMBEDDED_CONSTRAINT(0),
    .USE_MEM_INIT(1),
    .WAKEUP_TIME("disable_sleep"),
    .WRITE_DATA_WIDTH_A(64),
    .WRITE_MODE_B("read_first"),
    .USE_MEM_INIT_MMI(0),
    .WRITE_PROTECT(1)
  ) temp (
    .dbiterrb       (temp_dbiterrb    ), //o
    .doutb          (temp_doutb[511:0]), //o
    .sbiterrb       (temp_sbiterrb    ), //o
    .addra          (addra[12:0]      ), //i
    .addrb          (addrb[9:0]       ), //i
    .clka           (clk              ), //i
    .clkb           (clk              ), //i
    .dina           (dina[63:0]       ), //i
    .ena            (ena              ), //i
    .enb            (enb              ), //i
    .injectdbiterra (injectdbiterra   ), //i
    .injectsbiterra (injectsbiterra   ), //i
    .regceb         (regceb           ), //i
    .rstb           (rstb             ), //i
    .sleep          (sleep            ), //i
    .wea            (wea              )  //i
  );
  assign injectdbiterra = 1'b0;
  assign injectsbiterra = 1'b0;
  assign regceb = 1'b1;
  assign rstb = 1'b0;
  assign sleep = 1'b0;
  assign dbiterrb = temp_dbiterrb;
  assign doutb = temp_doutb;
  assign sbiterrb = temp_sbiterrb;

endmodule

module FeatureWidthConvert (
  input               sData_valid,
  output              sData_ready,
  input      [63:0]   sData_payload,
  output              mData_mData_0_valid,
  output     [63:0]   mData_mData_0_payload,
  output              mData_mData_1_valid,
  output     [63:0]   mData_mData_1_payload,
  output              mData_mData_2_valid,
  output     [63:0]   mData_mData_2_payload,
  output              mData_mData_3_valid,
  output     [63:0]   mData_mData_3_payload,
  output              mData_mData_4_valid,
  output     [63:0]   mData_mData_4_payload,
  output              mData_mData_5_valid,
  output     [63:0]   mData_mData_5_payload,
  output              mData_mData_6_valid,
  output     [63:0]   mData_mData_6_payload,
  output              mData_mData_7_valid,
  output     [63:0]   mData_mData_7_payload,
  output              mData_mData_8_valid,
  output     [63:0]   mData_mData_8_payload,
  input               mData_ready,
  input      [8:0]    rowNumIn,
  input      [8:0]    colNumIn,
  input               start,
  input      [11:0]   channelIn,
  input               reset,
  input               clk
);
  localparam FeatureWidthConvertEnum_IDLE = 5'd1;
  localparam FeatureWidthConvertEnum_INIT = 5'd2;
  localparam FeatureWidthConvertEnum_FIFO_READY = 5'd4;
  localparam FeatureWidthConvertEnum_SEND = 5'd8;
  localparam FeatureWidthConvertEnum_END_1 = 5'd16;

  reg                 dataCvt_m_axis_tready;
  wire                dataCvt_aresetn;
  wire                dataCvt_s_axis_tready;
  wire                dataCvt_m_axis_tvalid;
  wire       [511:0]  dataCvt_m_axis_tdata;
  wire       [11:0]   _zz_when_WaCounter_l12_1;
  wire       [5:0]    _zz_when_WaCounter_l12_1_1;
  wire       [8:0]    _zz_when_WaCounter_l12_2;
  wire       [8:0]    _zz_when_WaCounter_l12_3;
  wire                fsm_initEnd;
  wire                fsm_fifoReady;
  wire                fsm_sendEnd;
  wire                fsm_last;
  reg        [4:0]    fsm_currentState;
  reg        [4:0]    fsm_nextState;
  wire                when_WaCounter_l17;
  reg        [2:0]    initCnt_count;
  reg                 initCnt_valid;
  wire                when_WaCounter_l12;
  reg        [5:0]    channelInTimes;
  wire                dataCvt_mData_fire;
  reg        [11:0]   channelCnt_count;
  reg                 channelCnt_valid;
  wire                when_WaCounter_l12_1;
  reg        [8:0]    columnCnt_count;
  reg                 columnCnt_valid;
  wire                when_WaCounter_l12_2;
  wire                when_WaCounter_l17_1;
  reg        [8:0]    rowCnt_count;
  reg                 rowCnt_valid;
  wire                when_WaCounter_l12_3;
  wire                dataCvt_mData_fire_1;
  wire                dataCvt_mData_fire_2;
  wire                dataCvt_mData_fire_3;
  wire                dataCvt_mData_fire_4;
  wire                dataCvt_mData_fire_5;
  wire                dataCvt_mData_fire_6;
  wire                dataCvt_mData_fire_7;
  wire                dataCvt_mData_fire_8;
  wire                dataCvt_mData_fire_9;
  wire                when_FeatureWidthConvert_l102;
  `ifndef SYNTHESIS
  reg [79:0] fsm_currentState_string;
  reg [79:0] fsm_nextState_string;
  `endif


  assign _zz_when_WaCounter_l12_1_1 = (channelInTimes - 6'h01);
  assign _zz_when_WaCounter_l12_1 = {6'd0, _zz_when_WaCounter_l12_1_1};
  assign _zz_when_WaCounter_l12_2 = (colNumIn - 9'h001);
  assign _zz_when_WaCounter_l12_3 = (rowNumIn - 9'h001);
  conv11DataCvt dataCvt (
    .s_axis_tvalid (sData_valid                ), //i
    .s_axis_tready (dataCvt_s_axis_tready      ), //o
    .s_axis_tdata  (sData_payload[63:0]        ), //i
    .m_axis_tvalid (dataCvt_m_axis_tvalid      ), //o
    .m_axis_tready (dataCvt_m_axis_tready      ), //i
    .m_axis_tdata  (dataCvt_m_axis_tdata[511:0]), //o
    .aclk          (clk                        ), //i
    .aresetn       (dataCvt_aresetn            )  //i
  );
  `ifndef SYNTHESIS
  always @(*) begin
    case(fsm_currentState)
      FeatureWidthConvertEnum_IDLE : fsm_currentState_string = "IDLE      ";
      FeatureWidthConvertEnum_INIT : fsm_currentState_string = "INIT      ";
      FeatureWidthConvertEnum_FIFO_READY : fsm_currentState_string = "FIFO_READY";
      FeatureWidthConvertEnum_SEND : fsm_currentState_string = "SEND      ";
      FeatureWidthConvertEnum_END_1 : fsm_currentState_string = "END_1     ";
      default : fsm_currentState_string = "??????????";
    endcase
  end
  always @(*) begin
    case(fsm_nextState)
      FeatureWidthConvertEnum_IDLE : fsm_nextState_string = "IDLE      ";
      FeatureWidthConvertEnum_INIT : fsm_nextState_string = "INIT      ";
      FeatureWidthConvertEnum_FIFO_READY : fsm_nextState_string = "FIFO_READY";
      FeatureWidthConvertEnum_SEND : fsm_nextState_string = "SEND      ";
      FeatureWidthConvertEnum_END_1 : fsm_nextState_string = "END_1     ";
      default : fsm_nextState_string = "??????????";
    endcase
  end
  `endif

  always @(*) begin
    (* parallel_case *)
    case(1) // synthesis parallel_case
      (((fsm_currentState) & FeatureWidthConvertEnum_IDLE) == FeatureWidthConvertEnum_IDLE) : begin
        if(start) begin
          fsm_nextState = FeatureWidthConvertEnum_INIT;
        end else begin
          fsm_nextState = FeatureWidthConvertEnum_IDLE;
        end
      end
      (((fsm_currentState) & FeatureWidthConvertEnum_INIT) == FeatureWidthConvertEnum_INIT) : begin
        if(fsm_initEnd) begin
          fsm_nextState = FeatureWidthConvertEnum_FIFO_READY;
        end else begin
          fsm_nextState = FeatureWidthConvertEnum_INIT;
        end
      end
      (((fsm_currentState) & FeatureWidthConvertEnum_FIFO_READY) == FeatureWidthConvertEnum_FIFO_READY) : begin
        if(fsm_fifoReady) begin
          fsm_nextState = FeatureWidthConvertEnum_SEND;
        end else begin
          fsm_nextState = FeatureWidthConvertEnum_FIFO_READY;
        end
      end
      (((fsm_currentState) & FeatureWidthConvertEnum_SEND) == FeatureWidthConvertEnum_SEND) : begin
        if(fsm_sendEnd) begin
          fsm_nextState = FeatureWidthConvertEnum_END_1;
        end else begin
          fsm_nextState = FeatureWidthConvertEnum_SEND;
        end
      end
      default : begin
        if(fsm_last) begin
          fsm_nextState = FeatureWidthConvertEnum_IDLE;
        end else begin
          fsm_nextState = FeatureWidthConvertEnum_FIFO_READY;
        end
      end
    endcase
  end

  assign when_WaCounter_l17 = ((fsm_currentState & FeatureWidthConvertEnum_INIT) != 5'b00000);
  assign when_WaCounter_l12 = (initCnt_count == 3'b111);
  always @(*) begin
    if(when_WaCounter_l12) begin
      initCnt_valid = 1'b1;
    end else begin
      initCnt_valid = 1'b0;
    end
  end

  assign fsm_initEnd = initCnt_valid;
  assign dataCvt_aresetn = (! reset);
  assign dataCvt_mData_fire = (dataCvt_m_axis_tvalid && dataCvt_m_axis_tready);
  assign when_WaCounter_l12_1 = (channelCnt_count == _zz_when_WaCounter_l12_1);
  always @(*) begin
    if(when_WaCounter_l12_1) begin
      channelCnt_valid = 1'b1;
    end else begin
      channelCnt_valid = 1'b0;
    end
  end

  assign when_WaCounter_l12_2 = (columnCnt_count == _zz_when_WaCounter_l12_2);
  always @(*) begin
    if(when_WaCounter_l12_2) begin
      columnCnt_valid = 1'b1;
    end else begin
      columnCnt_valid = 1'b0;
    end
  end

  assign when_WaCounter_l17_1 = ((fsm_currentState & FeatureWidthConvertEnum_END_1) != 5'b00000);
  assign when_WaCounter_l12_3 = (rowCnt_count == _zz_when_WaCounter_l12_3);
  always @(*) begin
    if(when_WaCounter_l12_3) begin
      rowCnt_valid = 1'b1;
    end else begin
      rowCnt_valid = 1'b0;
    end
  end

  assign fsm_fifoReady = mData_ready;
  assign fsm_sendEnd = (channelCnt_valid && columnCnt_valid);
  assign fsm_last = ((channelCnt_valid && columnCnt_valid) && rowCnt_valid);
  assign sData_ready = dataCvt_s_axis_tready;
  assign mData_mData_0_payload = dataCvt_m_axis_tdata[63 : 0];
  assign dataCvt_mData_fire_1 = (dataCvt_m_axis_tvalid && dataCvt_m_axis_tready);
  assign mData_mData_0_valid = dataCvt_mData_fire_1;
  assign mData_mData_1_payload = dataCvt_m_axis_tdata[127 : 64];
  assign dataCvt_mData_fire_2 = (dataCvt_m_axis_tvalid && dataCvt_m_axis_tready);
  assign mData_mData_1_valid = dataCvt_mData_fire_2;
  assign mData_mData_2_payload = dataCvt_m_axis_tdata[191 : 128];
  assign dataCvt_mData_fire_3 = (dataCvt_m_axis_tvalid && dataCvt_m_axis_tready);
  assign mData_mData_2_valid = dataCvt_mData_fire_3;
  assign mData_mData_3_payload = dataCvt_m_axis_tdata[255 : 192];
  assign dataCvt_mData_fire_4 = (dataCvt_m_axis_tvalid && dataCvt_m_axis_tready);
  assign mData_mData_3_valid = dataCvt_mData_fire_4;
  assign mData_mData_4_payload = dataCvt_m_axis_tdata[319 : 256];
  assign dataCvt_mData_fire_5 = (dataCvt_m_axis_tvalid && dataCvt_m_axis_tready);
  assign mData_mData_4_valid = dataCvt_mData_fire_5;
  assign mData_mData_5_payload = dataCvt_m_axis_tdata[383 : 320];
  assign dataCvt_mData_fire_6 = (dataCvt_m_axis_tvalid && dataCvt_m_axis_tready);
  assign mData_mData_5_valid = dataCvt_mData_fire_6;
  assign mData_mData_6_payload = dataCvt_m_axis_tdata[447 : 384];
  assign dataCvt_mData_fire_7 = (dataCvt_m_axis_tvalid && dataCvt_m_axis_tready);
  assign mData_mData_6_valid = dataCvt_mData_fire_7;
  assign mData_mData_7_payload = dataCvt_m_axis_tdata[511 : 448];
  assign dataCvt_mData_fire_8 = (dataCvt_m_axis_tvalid && dataCvt_m_axis_tready);
  assign mData_mData_7_valid = dataCvt_mData_fire_8;
  assign mData_mData_8_payload = 64'h0;
  assign dataCvt_mData_fire_9 = (dataCvt_m_axis_tvalid && dataCvt_m_axis_tready);
  assign mData_mData_8_valid = dataCvt_mData_fire_9;
  assign when_FeatureWidthConvert_l102 = ((fsm_currentState & FeatureWidthConvertEnum_SEND) != 5'b00000);
  always @(*) begin
    if(when_FeatureWidthConvert_l102) begin
      dataCvt_m_axis_tready = 1'b1;
    end else begin
      dataCvt_m_axis_tready = 1'b0;
    end
  end

  always @(posedge clk or posedge reset) begin
    if(reset) begin
      fsm_currentState <= FeatureWidthConvertEnum_IDLE;
      initCnt_count <= 3'b000;
      channelCnt_count <= 12'h0;
      columnCnt_count <= 9'h0;
      rowCnt_count <= 9'h0;
    end else begin
      fsm_currentState <= fsm_nextState;
      if(when_WaCounter_l17) begin
        initCnt_count <= (initCnt_count + 3'b001);
        if(initCnt_valid) begin
          initCnt_count <= 3'b000;
        end
      end
      if(dataCvt_mData_fire) begin
        channelCnt_count <= (channelCnt_count + 12'h001);
        if(channelCnt_valid) begin
          channelCnt_count <= 12'h0;
        end
      end
      if(channelCnt_valid) begin
        columnCnt_count <= (columnCnt_count + 9'h001);
        if(columnCnt_valid) begin
          columnCnt_count <= 9'h0;
        end
      end
      if(when_WaCounter_l17_1) begin
        rowCnt_count <= (rowCnt_count + 9'h001);
        if(rowCnt_valid) begin
          rowCnt_count <= 9'h0;
        end
      end
    end
  end

  always @(posedge clk) begin
    channelInTimes <= (channelIn >>> 6);
  end


endmodule

module FeatureGenerate (
  input               sData_valid,
  output reg          sData_ready,
  input      [63:0]   sData_payload,
  output              mData_mData_0_valid,
  output     [63:0]   mData_mData_0_payload,
  output              mData_mData_1_valid,
  output     [63:0]   mData_mData_1_payload,
  output              mData_mData_2_valid,
  output     [63:0]   mData_mData_2_payload,
  output              mData_mData_3_valid,
  output     [63:0]   mData_mData_3_payload,
  output              mData_mData_4_valid,
  output     [63:0]   mData_mData_4_payload,
  output              mData_mData_5_valid,
  output     [63:0]   mData_mData_5_payload,
  output              mData_mData_6_valid,
  output     [63:0]   mData_mData_6_payload,
  output              mData_mData_7_valid,
  output     [63:0]   mData_mData_7_payload,
  output              mData_mData_8_valid,
  output     [63:0]   mData_mData_8_payload,
  input               mData_ready,
  input      [8:0]    rowNumIn,
  input      [8:0]    colNumIn,
  input               start,
  input      [11:0]   channelIn,
  input               clk,
  input               reset
);
  localparam FeatureGenerateEnum_IDLE = 6'd1;
  localparam FeatureGenerateEnum_INIT = 6'd2;
  localparam FeatureGenerateEnum_WAIT_1 = 6'd4;
  localparam FeatureGenerateEnum_FIFO_READY = 6'd8;
  localparam FeatureGenerateEnum_WR = 6'd16;
  localparam FeatureGenerateEnum_END_1 = 6'd32;

  reg        [63:0]   _zz_mem_0_port1;
  reg        [63:0]   _zz_mem_1_port1;
  wire       [17:0]   _zz_when_FeatureGenerate_l108;
  wire       [17:0]   _zz_when_FeatureGenerate_l108_1;
  wire       [63:0]   _zz_mem_0_port;
  wire                _zz_mem_0_port_1;
  wire                _zz_rdData_0;
  wire       [63:0]   _zz_mem_1_port;
  wire                _zz_mem_1_port_1;
  wire                _zz_rdData_1;
  wire       [11:0]   _zz_when_WaCounter_l12_1;
  wire       [8:0]    _zz_when_WaCounter_l12_1_1;
  wire       [8:0]    _zz_when_WaCounter_l12_2;
  wire       [8:0]    _zz_when_WaCounter_l12_3;
  wire       [8:0]    _zz_when_FeatureGenerate_l155;
  wire       [8:0]    _zz_when_FeatureGenerate_l164;
  reg        [8:0]    channelTimes;
  reg        [17:0]   totalCnt;
  wire                fsm_initEnd;
  wire                fsm_waitEnd;
  wire                fsm_wrEnd;
  wire                fsm_endEnd;
  wire                fsm_wait2;
  wire                fsm_fifoReady;
  reg        [5:0]    fsm_currentState;
  reg        [5:0]    fsm_nextState;
  reg        [10:0]   rdAddr;
  wire       [63:0]   wrData_0;
  wire       [63:0]   wrData_1;
  wire       [63:0]   rdData_0;
  wire       [63:0]   rdData_1;
  reg        [10:0]   wrAddr;
  wire                sData_fire;
  wire                when_FeatureGenerate_l108;
  reg        [63:0]   sData_payload_regNext;
  wire                sData_fire_1;
  reg                 sData_fire_1_regNext;
  wire                sData_fire_2;
  reg                 sData_fire_2_regNext;
  wire                when_WaCounter_l17;
  reg        [2:0]    initCount_count;
  reg                 initCount_valid;
  wire                when_WaCounter_l12;
  wire                sData_fire_3;
  reg        [11:0]   channelCnt_count;
  reg                 channelCnt_valid;
  wire                when_WaCounter_l12_1;
  reg        [8:0]    columnCnt_count;
  reg                 columnCnt_valid;
  wire                when_WaCounter_l12_2;
  wire                when_WaCounter_l17_1;
  reg        [8:0]    rowCnt_count;
  reg                 rowCnt_valid;
  wire                when_WaCounter_l12_3;
  wire                when_FeatureGenerate_l136;
  reg                 valid_0;
  reg                 valid_1;
  reg                 valid_2;
  reg                 valid_3;
  reg                 valid_4;
  reg                 valid_5;
  reg                 valid_6;
  reg                 valid_7;
  reg                 valid_8;
  reg                 valid_0_delay_1;
  reg                 valid_0_delay_2;
  reg                 valid_0_delay_3;
  reg                 valid_3_delay_1;
  reg                 valid_3_delay_2;
  reg                 valid_3_delay_3;
  reg                 valid_6_delay_1;
  reg                 valid_6_delay_2;
  reg                 valid_6_delay_3;
  reg                 valid_1_delay_1;
  reg                 valid_1_delay_2;
  reg                 valid_4_delay_1;
  reg                 valid_4_delay_2;
  reg                 valid_7_delay_1;
  reg                 valid_7_delay_2;
  reg                 valid_2_delay_1;
  reg                 valid_5_delay_1;
  reg                 valid_8_delay_1;
  wire                when_FeatureGenerate_l154;
  wire                when_FeatureGenerate_l155;
  wire                when_FeatureGenerate_l164;
  wire                when_FeatureGenerate_l173;
  reg        [63:0]   mData_mData_1_payload_regNext;
  reg        [63:0]   mData_mData_2_payload_regNext;
  reg        [63:0]   rdData_1_regNext;
  reg        [63:0]   mData_mData_4_payload_regNext;
  reg        [63:0]   mData_mData_5_payload_regNext;
  reg        [63:0]   rdData_0_regNext;
  reg        [63:0]   mData_mData_7_payload_regNext;
  reg        [63:0]   mData_mData_8_payload_regNext;
  reg        [63:0]   sData_payload_regNext_1;
  reg        [63:0]   sData_payload_regNext_1_regNext;
  `ifndef SYNTHESIS
  reg [79:0] fsm_currentState_string;
  reg [79:0] fsm_nextState_string;
  `endif

  reg [63:0] mem_0 [0:2047];
  reg [63:0] mem_1 [0:2047];

  assign _zz_when_FeatureGenerate_l108 = {7'd0, rdAddr};
  assign _zz_when_FeatureGenerate_l108_1 = (totalCnt - 18'h00001);
  assign _zz_when_WaCounter_l12_1_1 = (channelTimes - 9'h001);
  assign _zz_when_WaCounter_l12_1 = {3'd0, _zz_when_WaCounter_l12_1_1};
  assign _zz_when_WaCounter_l12_2 = (colNumIn - 9'h001);
  assign _zz_when_WaCounter_l12_3 = (rowNumIn - 9'h001);
  assign _zz_when_FeatureGenerate_l155 = (colNumIn - 9'h002);
  assign _zz_when_FeatureGenerate_l164 = (colNumIn - 9'h001);
  assign _zz_mem_0_port = wrData_0;
  assign _zz_rdData_0 = 1'b1;
  assign _zz_mem_1_port = wrData_1;
  assign _zz_rdData_1 = 1'b1;
  always @(posedge clk) begin
    if(sData_fire_1_regNext) begin
      mem_0[wrAddr] <= _zz_mem_0_port;
    end
  end

  always @(posedge clk) begin
    if(_zz_rdData_0) begin
      _zz_mem_0_port1 <= mem_0[rdAddr];
    end
  end

  always @(posedge clk) begin
    if(sData_fire_2_regNext) begin
      mem_1[wrAddr] <= _zz_mem_1_port;
    end
  end

  always @(posedge clk) begin
    if(_zz_rdData_1) begin
      _zz_mem_1_port1 <= mem_1[rdAddr];
    end
  end

  `ifndef SYNTHESIS
  always @(*) begin
    case(fsm_currentState)
      FeatureGenerateEnum_IDLE : fsm_currentState_string = "IDLE      ";
      FeatureGenerateEnum_INIT : fsm_currentState_string = "INIT      ";
      FeatureGenerateEnum_WAIT_1 : fsm_currentState_string = "WAIT_1    ";
      FeatureGenerateEnum_FIFO_READY : fsm_currentState_string = "FIFO_READY";
      FeatureGenerateEnum_WR : fsm_currentState_string = "WR        ";
      FeatureGenerateEnum_END_1 : fsm_currentState_string = "END_1     ";
      default : fsm_currentState_string = "??????????";
    endcase
  end
  always @(*) begin
    case(fsm_nextState)
      FeatureGenerateEnum_IDLE : fsm_nextState_string = "IDLE      ";
      FeatureGenerateEnum_INIT : fsm_nextState_string = "INIT      ";
      FeatureGenerateEnum_WAIT_1 : fsm_nextState_string = "WAIT_1    ";
      FeatureGenerateEnum_FIFO_READY : fsm_nextState_string = "FIFO_READY";
      FeatureGenerateEnum_WR : fsm_nextState_string = "WR        ";
      FeatureGenerateEnum_END_1 : fsm_nextState_string = "END_1     ";
      default : fsm_nextState_string = "??????????";
    endcase
  end
  `endif

  always @(*) begin
    (* parallel_case *)
    case(1) // synthesis parallel_case
      (((fsm_currentState) & FeatureGenerateEnum_IDLE) == FeatureGenerateEnum_IDLE) : begin
        if(start) begin
          fsm_nextState = FeatureGenerateEnum_INIT;
        end else begin
          fsm_nextState = FeatureGenerateEnum_IDLE;
        end
      end
      (((fsm_currentState) & FeatureGenerateEnum_INIT) == FeatureGenerateEnum_INIT) : begin
        if(fsm_initEnd) begin
          fsm_nextState = FeatureGenerateEnum_WAIT_1;
        end else begin
          fsm_nextState = FeatureGenerateEnum_INIT;
        end
      end
      (((fsm_currentState) & FeatureGenerateEnum_WAIT_1) == FeatureGenerateEnum_WAIT_1) : begin
        if(fsm_waitEnd) begin
          fsm_nextState = FeatureGenerateEnum_END_1;
        end else begin
          fsm_nextState = FeatureGenerateEnum_WAIT_1;
        end
      end
      (((fsm_currentState) & FeatureGenerateEnum_FIFO_READY) == FeatureGenerateEnum_FIFO_READY) : begin
        if(fsm_fifoReady) begin
          fsm_nextState = FeatureGenerateEnum_WR;
        end else begin
          fsm_nextState = FeatureGenerateEnum_FIFO_READY;
        end
      end
      (((fsm_currentState) & FeatureGenerateEnum_WR) == FeatureGenerateEnum_WR) : begin
        if(fsm_wrEnd) begin
          fsm_nextState = FeatureGenerateEnum_END_1;
        end else begin
          fsm_nextState = FeatureGenerateEnum_WR;
        end
      end
      default : begin
        if(fsm_wait2) begin
          fsm_nextState = FeatureGenerateEnum_WAIT_1;
        end else begin
          if(fsm_endEnd) begin
            fsm_nextState = FeatureGenerateEnum_IDLE;
          end else begin
            fsm_nextState = FeatureGenerateEnum_FIFO_READY;
          end
        end
      end
    endcase
  end

  assign fsm_fifoReady = mData_ready;
  assign sData_fire = (sData_valid && sData_ready);
  assign when_FeatureGenerate_l108 = (_zz_when_FeatureGenerate_l108 == _zz_when_FeatureGenerate_l108_1);
  assign wrData_0 = sData_payload_regNext;
  assign wrData_1 = rdData_0;
  assign sData_fire_1 = (sData_valid && sData_ready);
  assign rdData_0 = _zz_mem_0_port1;
  assign sData_fire_2 = (sData_valid && sData_ready);
  assign rdData_1 = _zz_mem_1_port1;
  assign when_WaCounter_l17 = ((fsm_currentState & FeatureGenerateEnum_INIT) != 6'b000000);
  assign when_WaCounter_l12 = (initCount_count == 3'b101);
  always @(*) begin
    if(when_WaCounter_l12) begin
      initCount_valid = 1'b1;
    end else begin
      initCount_valid = 1'b0;
    end
  end

  assign fsm_initEnd = initCount_valid;
  assign sData_fire_3 = (sData_valid && sData_ready);
  assign when_WaCounter_l12_1 = (channelCnt_count == _zz_when_WaCounter_l12_1);
  always @(*) begin
    if(when_WaCounter_l12_1) begin
      channelCnt_valid = 1'b1;
    end else begin
      channelCnt_valid = 1'b0;
    end
  end

  assign when_WaCounter_l12_2 = (columnCnt_count == _zz_when_WaCounter_l12_2);
  always @(*) begin
    if(when_WaCounter_l12_2) begin
      columnCnt_valid = 1'b1;
    end else begin
      columnCnt_valid = 1'b0;
    end
  end

  assign when_WaCounter_l17_1 = ((fsm_currentState & FeatureGenerateEnum_END_1) != 6'b000000);
  assign when_WaCounter_l12_3 = (rowCnt_count == _zz_when_WaCounter_l12_3);
  always @(*) begin
    if(when_WaCounter_l12_3) begin
      rowCnt_valid = 1'b1;
    end else begin
      rowCnt_valid = 1'b0;
    end
  end

  assign fsm_waitEnd = (channelCnt_valid && columnCnt_valid);
  assign fsm_wrEnd = (channelCnt_valid && columnCnt_valid);
  assign fsm_endEnd = ((rowCnt_valid && channelCnt_valid) && columnCnt_valid);
  assign fsm_wait2 = (rowCnt_count < 9'h001);
  assign when_FeatureGenerate_l136 = (((fsm_currentState & FeatureGenerateEnum_WAIT_1) != 6'b000000) || ((fsm_currentState & FeatureGenerateEnum_WR) != 6'b000000));
  always @(*) begin
    if(when_FeatureGenerate_l136) begin
      sData_ready = 1'b1;
    end else begin
      sData_ready = 1'b0;
    end
  end

  assign mData_mData_0_valid = valid_0_delay_3;
  assign mData_mData_3_valid = valid_3_delay_3;
  assign mData_mData_6_valid = valid_6_delay_3;
  assign mData_mData_1_valid = valid_1_delay_2;
  assign mData_mData_4_valid = valid_4_delay_2;
  assign mData_mData_7_valid = valid_7_delay_2;
  assign mData_mData_2_valid = valid_2_delay_1;
  assign mData_mData_5_valid = valid_5_delay_1;
  assign mData_mData_8_valid = valid_8_delay_1;
  assign when_FeatureGenerate_l154 = ((fsm_currentState & FeatureGenerateEnum_WR) != 6'b000000);
  assign when_FeatureGenerate_l155 = (columnCnt_count < _zz_when_FeatureGenerate_l155);
  assign when_FeatureGenerate_l164 = ((9'h0 < columnCnt_count) && (columnCnt_count < _zz_when_FeatureGenerate_l164));
  assign when_FeatureGenerate_l173 = ((9'h001 < columnCnt_count) && (columnCnt_count < colNumIn));
  assign mData_mData_0_payload = mData_mData_1_payload_regNext;
  assign mData_mData_1_payload = mData_mData_2_payload_regNext;
  assign mData_mData_2_payload = rdData_1_regNext;
  assign mData_mData_3_payload = mData_mData_4_payload_regNext;
  assign mData_mData_4_payload = mData_mData_5_payload_regNext;
  assign mData_mData_5_payload = rdData_0_regNext;
  assign mData_mData_6_payload = mData_mData_7_payload_regNext;
  assign mData_mData_7_payload = mData_mData_8_payload_regNext;
  assign mData_mData_8_payload = sData_payload_regNext_1_regNext;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      channelTimes <= 9'h0;
      fsm_currentState <= FeatureGenerateEnum_IDLE;
      rdAddr <= 11'h0;
      initCount_count <= 3'b000;
      channelCnt_count <= 12'h0;
      columnCnt_count <= 9'h0;
      rowCnt_count <= 9'h0;
      valid_0 <= 1'b0;
      valid_1 <= 1'b0;
      valid_2 <= 1'b0;
      valid_3 <= 1'b0;
      valid_4 <= 1'b0;
      valid_5 <= 1'b0;
      valid_6 <= 1'b0;
      valid_7 <= 1'b0;
      valid_8 <= 1'b0;
    end else begin
      channelTimes <= (channelIn >>> 3);
      fsm_currentState <= fsm_nextState;
      if(sData_fire) begin
        if(when_FeatureGenerate_l108) begin
          rdAddr <= 11'h0;
        end else begin
          rdAddr <= (rdAddr + 11'h001);
        end
      end
      if(when_WaCounter_l17) begin
        initCount_count <= (initCount_count + 3'b001);
        if(initCount_valid) begin
          initCount_count <= 3'b000;
        end
      end
      if(sData_fire_3) begin
        channelCnt_count <= (channelCnt_count + 12'h001);
        if(channelCnt_valid) begin
          channelCnt_count <= 12'h0;
        end
      end
      if(channelCnt_valid) begin
        columnCnt_count <= (columnCnt_count + 9'h001);
        if(columnCnt_valid) begin
          columnCnt_count <= 9'h0;
        end
      end
      if(when_WaCounter_l17_1) begin
        rowCnt_count <= (rowCnt_count + 9'h001);
        if(rowCnt_valid) begin
          rowCnt_count <= 9'h0;
        end
      end
      if(when_FeatureGenerate_l154) begin
        if(when_FeatureGenerate_l155) begin
          valid_0 <= 1'b1;
          valid_3 <= 1'b1;
          valid_6 <= 1'b1;
        end else begin
          valid_0 <= 1'b0;
          valid_3 <= 1'b0;
          valid_6 <= 1'b0;
        end
        if(when_FeatureGenerate_l164) begin
          valid_1 <= 1'b1;
          valid_4 <= 1'b1;
          valid_7 <= 1'b1;
        end else begin
          valid_1 <= 1'b0;
          valid_4 <= 1'b0;
          valid_7 <= 1'b0;
        end
        if(when_FeatureGenerate_l173) begin
          valid_2 <= 1'b1;
          valid_5 <= 1'b1;
          valid_8 <= 1'b1;
        end else begin
          valid_2 <= 1'b0;
          valid_5 <= 1'b0;
          valid_8 <= 1'b0;
        end
      end else begin
        valid_0 <= 1'b0;
        valid_1 <= 1'b0;
        valid_2 <= 1'b0;
        valid_3 <= 1'b0;
        valid_4 <= 1'b0;
        valid_5 <= 1'b0;
        valid_6 <= 1'b0;
        valid_7 <= 1'b0;
        valid_8 <= 1'b0;
      end
    end
  end

  always @(posedge clk) begin
    totalCnt <= (channelTimes * colNumIn);
    wrAddr <= rdAddr;
    sData_payload_regNext <= sData_payload;
    sData_fire_1_regNext <= sData_fire_1;
    sData_fire_2_regNext <= sData_fire_2;
    valid_0_delay_1 <= valid_0;
    valid_0_delay_2 <= valid_0_delay_1;
    valid_0_delay_3 <= valid_0_delay_2;
    valid_3_delay_1 <= valid_3;
    valid_3_delay_2 <= valid_3_delay_1;
    valid_3_delay_3 <= valid_3_delay_2;
    valid_6_delay_1 <= valid_6;
    valid_6_delay_2 <= valid_6_delay_1;
    valid_6_delay_3 <= valid_6_delay_2;
    valid_1_delay_1 <= valid_1;
    valid_1_delay_2 <= valid_1_delay_1;
    valid_4_delay_1 <= valid_4;
    valid_4_delay_2 <= valid_4_delay_1;
    valid_7_delay_1 <= valid_7;
    valid_7_delay_2 <= valid_7_delay_1;
    valid_2_delay_1 <= valid_2;
    valid_5_delay_1 <= valid_5;
    valid_8_delay_1 <= valid_8;
    mData_mData_1_payload_regNext <= mData_mData_1_payload;
    mData_mData_2_payload_regNext <= mData_mData_2_payload;
    rdData_1_regNext <= rdData_1;
    mData_mData_4_payload_regNext <= mData_mData_4_payload;
    mData_mData_5_payload_regNext <= mData_mData_5_payload;
    rdData_0_regNext <= rdData_0;
    mData_mData_7_payload_regNext <= mData_mData_7_payload;
    mData_mData_8_payload_regNext <= mData_mData_8_payload;
    sData_payload_regNext_1 <= sData_payload;
    sData_payload_regNext_1_regNext <= sData_payload_regNext_1;
  end


endmodule

module Padding (
  input               sData_valid,
  output              sData_ready,
  input      [63:0]   sData_payload,
  output              mData_valid /* verilator public */ ,
  input               mData_ready /* verilator public */ ,
  output     [63:0]   mData_payload /* verilator public */ ,
  input               enPadding,
  input      [11:0]   channelIn,
  input               start,
  input      [8:0]    rowNumIn,
  output reg [8:0]    rowNumOut,
  input      [8:0]    colNumIn,
  output reg [8:0]    colNumOut,
  input      [7:0]    zeroDara,
  input      [0:0]    zeroNum,
  output reg          last,
  input               clk,
  input               reset
);
  localparam PaddingEnum_IDLE = 7'd1;
  localparam PaddingEnum_INIT = 7'd2;
  localparam PaddingEnum_UPDOWN = 7'd4;
  localparam PaddingEnum_LEFT = 7'd8;
  localparam PaddingEnum_CENTER = 7'd16;
  localparam PaddingEnum_RIGHT = 7'd32;
  localparam PaddingEnum_END_1 = 7'd64;

  reg                 fifo_push_valid;
  reg        [63:0]   fifo_push_payload;
  wire                fifo_push_ready;
  wire                fifo_pop_valid;
  wire       [63:0]   fifo_pop_payload;
  wire       [2:0]    fifo_occupancy;
  wire       [2:0]    fifo_availability;
  wire                fifo_almost_full;
  wire       [8:0]    _zz_rowNumOut;
  wire       [1:0]    _zz_rowNumOut_1;
  wire       [8:0]    _zz_colNumOut;
  wire       [1:0]    _zz_colNumOut_1;
  wire       [11:0]   _zz_when_WaCounter_l12_1;
  wire       [8:0]    _zz_when_WaCounter_l12_1_1;
  wire       [8:0]    _zz_when_WaCounter_l12_2;
  wire       [8:0]    _zz_when_WaCounter_l12_3;
  wire       [8:0]    _zz_when_Padding_l144_1;
  wire       [0:0]    _zz_when_Padding_l144_1_1;
  wire       [8:0]    _zz_when_Padding_l144_2;
  wire       [8:0]    _zz_when_Padding_l144_3;
  wire       [8:0]    _zz_when_Padding_l144_4;
  wire       [8:0]    _zz_when_Padding_l144_4_1;
  wire       [8:0]    _zz_when_Padding_l144_4_2;
  wire       [8:0]    _zz_when_Padding_l144_5;
  wire       [8:0]    _zz_when_Padding_l144_5_1;
  wire       [8:0]    _zz_when_Padding_l144_5_2;
  wire       [8:0]    _zz_when_Padding_l144_6;
  wire       [8:0]    _zz_when_Padding_l144_6_1;
  wire       [8:0]    _zz_when_Padding_l144_6_2;
  wire       [8:0]    _zz_when_Padding_l144_6_3;
  reg        [8:0]    channelTimes;
  wire                fsm_initEnd;
  reg                 fsm_leftEnd;
  reg                 fsm_rightEnd;
  reg                 fsm_upDownEnd;
  reg                 fsm_centerEnd;
  reg                 fsm_endEnd;
  wire                fsm_enPadding;
  reg                 fsm_enUpDown;
  reg        [6:0]    fsm_currentState;
  reg        [6:0]    fsm_nextState;
  reg                 initEn;
  wire                when_Padding_l151;
  wire                when_Padding_l151_1;
  reg        [4:0]    initCount_count;
  reg                 initCount_valid;
  wire                when_WaCounter_l12;
  wire                when_Padding_l153;
  reg                 zeroValid;
  wire                when_Padding_l160;
  wire       [7:0]    _zz_push_payload;
  wire                fifo_push_fire;
  reg        [11:0]   channelCnt_count;
  reg                 channelCnt_valid;
  wire                when_WaCounter_l12_1;
  wire                when_Padding_l169;
  wire                fifo_push_fire_1;
  wire                when_WaCounter_l17;
  reg        [8:0]    colCnt_count;
  reg                 colCnt_valid;
  wire                when_WaCounter_l12_2;
  wire                when_Padding_l173;
  wire                when_WaCounter_l17_1;
  reg        [8:0]    rowCnt_count;
  reg                 rowCnt_valid;
  wire                when_WaCounter_l12_3;
  wire                when_Padding_l177;
  wire                when_Padding_l144;
  wire                fifo_push_fire_2;
  wire                when_Padding_l144_1;
  wire                fifo_push_fire_3;
  wire                when_Padding_l144_2;
  wire                when_Padding_l144_3;
  wire                fifo_push_fire_4;
  wire                when_Padding_l144_4;
  wire                fifo_push_fire_5;
  wire                when_Padding_l144_5;
  wire                when_Padding_l144_6;
  wire                when_Padding_l144_7;
  `ifndef SYNTHESIS
  reg [47:0] fsm_currentState_string;
  reg [47:0] fsm_nextState_string;
  `endif


  assign _zz_rowNumOut_1 = ({1'd0,zeroNum} <<< 1);
  assign _zz_rowNumOut = {7'd0, _zz_rowNumOut_1};
  assign _zz_colNumOut_1 = ({1'd0,zeroNum} <<< 1);
  assign _zz_colNumOut = {7'd0, _zz_colNumOut_1};
  assign _zz_when_WaCounter_l12_1_1 = (channelTimes - 9'h001);
  assign _zz_when_WaCounter_l12_1 = {3'd0, _zz_when_WaCounter_l12_1_1};
  assign _zz_when_WaCounter_l12_2 = (colNumOut - 9'h001);
  assign _zz_when_WaCounter_l12_3 = (rowNumOut - 9'h001);
  assign _zz_when_Padding_l144_1_1 = (zeroNum - 1'b1);
  assign _zz_when_Padding_l144_1 = {8'd0, _zz_when_Padding_l144_1_1};
  assign _zz_when_Padding_l144_2 = (colNumOut - 9'h001);
  assign _zz_when_Padding_l144_3 = (rowNumOut - 9'h001);
  assign _zz_when_Padding_l144_4 = (_zz_when_Padding_l144_4_1 - 9'h001);
  assign _zz_when_Padding_l144_4_1 = (colNumOut - _zz_when_Padding_l144_4_2);
  assign _zz_when_Padding_l144_4_2 = {8'd0, zeroNum};
  assign _zz_when_Padding_l144_5 = (_zz_when_Padding_l144_5_1 - 9'h001);
  assign _zz_when_Padding_l144_5_1 = (colNumOut - _zz_when_Padding_l144_5_2);
  assign _zz_when_Padding_l144_5_2 = {8'd0, zeroNum};
  assign _zz_when_Padding_l144_6 = {8'd0, zeroNum};
  assign _zz_when_Padding_l144_6_1 = (_zz_when_Padding_l144_6_2 - 9'h001);
  assign _zz_when_Padding_l144_6_2 = (rowNumOut - _zz_when_Padding_l144_6_3);
  assign _zz_when_Padding_l144_6_3 = {8'd0, zeroNum};
  WaStreamFifo fifo (
    .push_valid   (fifo_push_valid        ), //i
    .push_ready   (fifo_push_ready        ), //o
    .push_payload (fifo_push_payload[63:0]), //i
    .pop_valid    (fifo_pop_valid         ), //o
    .pop_ready    (mData_ready            ), //i
    .pop_payload  (fifo_pop_payload[63:0] ), //o
    .flush        (1'b0                   ), //i
    .occupancy    (fifo_occupancy[2:0]    ), //o
    .availability (fifo_availability[2:0] ), //o
    .almost_full  (fifo_almost_full       ), //o
    .clk          (clk                    ), //i
    .reset        (reset                  )  //i
  );
  `ifndef SYNTHESIS
  always @(*) begin
    case(fsm_currentState)
      PaddingEnum_IDLE : fsm_currentState_string = "IDLE  ";
      PaddingEnum_INIT : fsm_currentState_string = "INIT  ";
      PaddingEnum_UPDOWN : fsm_currentState_string = "UPDOWN";
      PaddingEnum_LEFT : fsm_currentState_string = "LEFT  ";
      PaddingEnum_CENTER : fsm_currentState_string = "CENTER";
      PaddingEnum_RIGHT : fsm_currentState_string = "RIGHT ";
      PaddingEnum_END_1 : fsm_currentState_string = "END_1 ";
      default : fsm_currentState_string = "??????";
    endcase
  end
  always @(*) begin
    case(fsm_nextState)
      PaddingEnum_IDLE : fsm_nextState_string = "IDLE  ";
      PaddingEnum_INIT : fsm_nextState_string = "INIT  ";
      PaddingEnum_UPDOWN : fsm_nextState_string = "UPDOWN";
      PaddingEnum_LEFT : fsm_nextState_string = "LEFT  ";
      PaddingEnum_CENTER : fsm_nextState_string = "CENTER";
      PaddingEnum_RIGHT : fsm_nextState_string = "RIGHT ";
      PaddingEnum_END_1 : fsm_nextState_string = "END_1 ";
      default : fsm_nextState_string = "??????";
    endcase
  end
  `endif

  always @(*) begin
    if(enPadding) begin
      rowNumOut = (_zz_rowNumOut + rowNumIn);
    end else begin
      rowNumOut = rowNumIn;
    end
  end

  always @(*) begin
    if(enPadding) begin
      colNumOut = (_zz_colNumOut + colNumIn);
    end else begin
      colNumOut = colNumIn;
    end
  end

  assign mData_valid = fifo_pop_valid;
  assign mData_payload = fifo_pop_payload;
  always @(*) begin
    (* parallel_case *)
    case(1) // synthesis parallel_case
      (((fsm_currentState) & PaddingEnum_IDLE) == PaddingEnum_IDLE) : begin
        if(start) begin
          fsm_nextState = PaddingEnum_INIT;
        end else begin
          fsm_nextState = PaddingEnum_IDLE;
        end
      end
      (((fsm_currentState) & PaddingEnum_INIT) == PaddingEnum_INIT) : begin
        if(fsm_initEnd) begin
          if(fsm_enPadding) begin
            fsm_nextState = PaddingEnum_LEFT;
          end else begin
            fsm_nextState = PaddingEnum_CENTER;
          end
        end else begin
          fsm_nextState = PaddingEnum_INIT;
        end
      end
      (((fsm_currentState) & PaddingEnum_UPDOWN) == PaddingEnum_UPDOWN) : begin
        if(fsm_upDownEnd) begin
          fsm_nextState = PaddingEnum_RIGHT;
        end else begin
          fsm_nextState = PaddingEnum_UPDOWN;
        end
      end
      (((fsm_currentState) & PaddingEnum_LEFT) == PaddingEnum_LEFT) : begin
        if(fsm_leftEnd) begin
          if(fsm_enUpDown) begin
            fsm_nextState = PaddingEnum_UPDOWN;
          end else begin
            fsm_nextState = PaddingEnum_CENTER;
          end
        end else begin
          fsm_nextState = PaddingEnum_LEFT;
        end
      end
      (((fsm_currentState) & PaddingEnum_CENTER) == PaddingEnum_CENTER) : begin
        if(fsm_centerEnd) begin
          if(fsm_enPadding) begin
            fsm_nextState = PaddingEnum_RIGHT;
          end else begin
            fsm_nextState = PaddingEnum_END_1;
          end
        end else begin
          fsm_nextState = PaddingEnum_CENTER;
        end
      end
      (((fsm_currentState) & PaddingEnum_RIGHT) == PaddingEnum_RIGHT) : begin
        if(fsm_rightEnd) begin
          fsm_nextState = PaddingEnum_END_1;
        end else begin
          fsm_nextState = PaddingEnum_RIGHT;
        end
      end
      default : begin
        if(fsm_endEnd) begin
          fsm_nextState = PaddingEnum_IDLE;
        end else begin
          if(fsm_enPadding) begin
            fsm_nextState = PaddingEnum_LEFT;
          end else begin
            fsm_nextState = PaddingEnum_CENTER;
          end
        end
      end
    endcase
  end

  assign fsm_enPadding = enPadding;
  assign sData_ready = (fifo_push_ready && ((fsm_currentState & PaddingEnum_CENTER) != 7'b0000000));
  assign when_Padding_l151 = ((fsm_currentState & PaddingEnum_INIT) != 7'b0000000);
  assign when_Padding_l151_1 = ((fsm_nextState & PaddingEnum_INIT) == 7'b0000000);
  assign when_WaCounter_l12 = (initCount_count == 5'h08);
  always @(*) begin
    if(when_WaCounter_l12) begin
      initCount_valid = 1'b1;
    end else begin
      initCount_valid = 1'b0;
    end
    if(when_Padding_l153) begin
      initCount_valid = 1'b0;
    end
  end

  assign when_Padding_l153 = ((fsm_currentState & PaddingEnum_IDLE) != 7'b0000000);
  assign fsm_initEnd = initCount_valid;
  assign when_Padding_l160 = ((fsm_currentState & PaddingEnum_CENTER) != 7'b0000000);
  always @(*) begin
    if(when_Padding_l160) begin
      fifo_push_valid = sData_valid;
    end else begin
      fifo_push_valid = zeroValid;
    end
  end

  always @(*) begin
    if(when_Padding_l160) begin
      fifo_push_payload = sData_payload;
    end else begin
      fifo_push_payload[7 : 0] = _zz_push_payload;
      fifo_push_payload[15 : 8] = _zz_push_payload;
      fifo_push_payload[23 : 16] = _zz_push_payload;
      fifo_push_payload[31 : 24] = _zz_push_payload;
      fifo_push_payload[39 : 32] = _zz_push_payload;
      fifo_push_payload[47 : 40] = _zz_push_payload;
      fifo_push_payload[55 : 48] = _zz_push_payload;
      fifo_push_payload[63 : 56] = _zz_push_payload;
    end
  end

  assign _zz_push_payload = zeroDara;
  assign fifo_push_fire = (fifo_push_valid && fifo_push_ready);
  assign when_WaCounter_l12_1 = (channelCnt_count == _zz_when_WaCounter_l12_1);
  always @(*) begin
    if(when_WaCounter_l12_1) begin
      channelCnt_valid = 1'b1;
    end else begin
      channelCnt_valid = 1'b0;
    end
    if(when_Padding_l169) begin
      channelCnt_valid = 1'b0;
    end
  end

  assign when_Padding_l169 = ((fsm_currentState & PaddingEnum_IDLE) != 7'b0000000);
  assign fifo_push_fire_1 = (fifo_push_valid && fifo_push_ready);
  assign when_WaCounter_l17 = (channelCnt_valid && fifo_push_fire_1);
  assign when_WaCounter_l12_2 = (colCnt_count == _zz_when_WaCounter_l12_2);
  always @(*) begin
    if(when_WaCounter_l12_2) begin
      colCnt_valid = 1'b1;
    end else begin
      colCnt_valid = 1'b0;
    end
    if(when_Padding_l173) begin
      colCnt_valid = 1'b0;
    end
  end

  assign when_Padding_l173 = ((fsm_currentState & PaddingEnum_IDLE) != 7'b0000000);
  assign when_WaCounter_l17_1 = ((fsm_nextState & PaddingEnum_END_1) != 7'b0000000);
  assign when_WaCounter_l12_3 = (rowCnt_count == _zz_when_WaCounter_l12_3);
  always @(*) begin
    if(when_WaCounter_l12_3) begin
      rowCnt_valid = 1'b1;
    end else begin
      rowCnt_valid = 1'b0;
    end
    if(when_Padding_l177) begin
      rowCnt_valid = 1'b0;
    end
  end

  assign when_Padding_l177 = ((fsm_currentState & PaddingEnum_IDLE) != 7'b0000000);
  assign when_Padding_l144 = ((((fsm_currentState & PaddingEnum_LEFT) != 7'b0000000) || ((fsm_currentState & PaddingEnum_RIGHT) != 7'b0000000)) || ((fsm_currentState & PaddingEnum_UPDOWN) != 7'b0000000));
  always @(*) begin
    if(when_Padding_l144) begin
      zeroValid = 1'b1;
    end else begin
      zeroValid = 1'b0;
    end
  end

  assign fifo_push_fire_2 = (fifo_push_valid && fifo_push_ready);
  assign when_Padding_l144_1 = (((colCnt_count == _zz_when_Padding_l144_1) && channelCnt_valid) && fifo_push_fire_2);
  always @(*) begin
    if(when_Padding_l144_1) begin
      fsm_leftEnd = 1'b1;
    end else begin
      fsm_leftEnd = 1'b0;
    end
  end

  assign fifo_push_fire_3 = (fifo_push_valid && fifo_push_ready);
  assign when_Padding_l144_2 = (((colCnt_count == _zz_when_Padding_l144_2) && channelCnt_valid) && fifo_push_fire_3);
  always @(*) begin
    if(when_Padding_l144_2) begin
      fsm_rightEnd = 1'b1;
    end else begin
      fsm_rightEnd = 1'b0;
    end
  end

  assign when_Padding_l144_3 = (rowCnt_count == _zz_when_Padding_l144_3);
  assign fifo_push_fire_4 = (fifo_push_valid && fifo_push_ready);
  assign when_Padding_l144_4 = (((colCnt_count == _zz_when_Padding_l144_4) && channelCnt_valid) && fifo_push_fire_4);
  always @(*) begin
    if(when_Padding_l144_4) begin
      fsm_upDownEnd = 1'b1;
    end else begin
      fsm_upDownEnd = 1'b0;
    end
  end

  assign fifo_push_fire_5 = (fifo_push_valid && fifo_push_ready);
  assign when_Padding_l144_5 = (((colCnt_count == _zz_when_Padding_l144_5) && channelCnt_valid) && fifo_push_fire_5);
  always @(*) begin
    if(when_Padding_l144_5) begin
      fsm_centerEnd = 1'b1;
    end else begin
      fsm_centerEnd = 1'b0;
    end
  end

  assign when_Padding_l144_6 = ((rowCnt_count < _zz_when_Padding_l144_6) || (_zz_when_Padding_l144_6_1 < rowCnt_count));
  always @(*) begin
    if(when_Padding_l144_6) begin
      fsm_enUpDown = 1'b1;
    end else begin
      fsm_enUpDown = 1'b0;
    end
  end

  assign when_Padding_l144_7 = (((fsm_currentState & PaddingEnum_END_1) != 7'b0000000) && ((fsm_nextState & PaddingEnum_IDLE) != 7'b0000000));
  always @(*) begin
    if(when_Padding_l144_7) begin
      last = 1'b1;
    end else begin
      last = 1'b0;
    end
  end

  always @(posedge clk or posedge reset) begin
    if(reset) begin
      channelTimes <= 9'h0;
      fsm_currentState <= PaddingEnum_IDLE;
      initEn <= 1'b0;
      initCount_count <= 5'h0;
      channelCnt_count <= 12'h0;
      colCnt_count <= 9'h0;
      rowCnt_count <= 9'h0;
    end else begin
      channelTimes <= (channelIn >>> 3);
      fsm_currentState <= fsm_nextState;
      if(when_Padding_l151) begin
        initEn <= 1'b1;
      end
      if(when_Padding_l151_1) begin
        initEn <= 1'b0;
      end
      if(initEn) begin
        initCount_count <= (initCount_count + 5'h01);
        if(initCount_valid) begin
          initCount_count <= 5'h0;
        end
      end
      if(when_Padding_l153) begin
        initCount_count <= 5'h0;
      end
      if(fifo_push_fire) begin
        channelCnt_count <= (channelCnt_count + 12'h001);
        if(channelCnt_valid) begin
          channelCnt_count <= 12'h0;
        end
      end
      if(when_Padding_l169) begin
        channelCnt_count <= 12'h0;
      end
      if(when_WaCounter_l17) begin
        colCnt_count <= (colCnt_count + 9'h001);
        if(colCnt_valid) begin
          colCnt_count <= 9'h0;
        end
      end
      if(when_Padding_l173) begin
        colCnt_count <= 9'h0;
      end
      if(when_WaCounter_l17_1) begin
        rowCnt_count <= (rowCnt_count + 9'h001);
        if(rowCnt_valid) begin
          rowCnt_count <= 9'h0;
        end
      end
      if(when_Padding_l177) begin
        rowCnt_count <= 9'h0;
      end
    end
  end

  always @(posedge clk) begin
    if(when_Padding_l144_3) begin
      fsm_endEnd <= 1'b1;
    end else begin
      fsm_endEnd <= 1'b0;
    end
  end


endmodule

module WaStreamFifo (
  input               push_valid,
  output              push_ready,
  input      [63:0]   push_payload,
  output              pop_valid,
  input               pop_ready,
  output     [63:0]   pop_payload,
  input               flush,
  output reg [2:0]    occupancy,
  output reg [2:0]    availability,
  output reg          almost_full,
  input               clk,
  input               reset
);

  reg        [63:0]   _zz_logic_ram_port0;
  wire       [2:0]    _zz_logic_pushPtr_valueNext;
  wire       [0:0]    _zz_logic_pushPtr_valueNext_1;
  wire       [2:0]    _zz_logic_popPtr_valueNext;
  wire       [0:0]    _zz_logic_popPtr_valueNext_1;
  wire                _zz_logic_ram_port;
  wire                _zz_pop_payload;
  wire       [63:0]   _zz_logic_ram_port_1;
  wire       [2:0]    _zz_occupancy;
  wire       [2:0]    _zz_availability;
  wire       [2:0]    _zz_availability_1;
  wire       [2:0]    _zz_availability_2;
  reg                 _zz_1;
  reg                 logic_pushPtr_willIncrement;
  reg                 logic_pushPtr_willClear;
  reg        [2:0]    logic_pushPtr_valueNext;
  reg        [2:0]    logic_pushPtr_value;
  wire                logic_pushPtr_willOverflowIfInc;
  wire                logic_pushPtr_willOverflow;
  reg                 logic_popPtr_willIncrement;
  reg                 logic_popPtr_willClear;
  reg        [2:0]    logic_popPtr_valueNext;
  reg        [2:0]    logic_popPtr_value;
  wire                logic_popPtr_willOverflowIfInc;
  wire                logic_popPtr_willOverflow;
  wire                logic_ptrMatch;
  reg                 logic_risingOccupancy;
  wire                logic_pushing;
  wire                logic_popping;
  wire                logic_empty;
  wire                logic_full;
  reg                 _zz_pop_valid;
  wire                when_Stream_l1021;
  wire       [2:0]    logic_ptrDif;
  wire                when_WaFifo_l23;
  reg [63:0] logic_ram [0:4];

  assign _zz_logic_pushPtr_valueNext_1 = logic_pushPtr_willIncrement;
  assign _zz_logic_pushPtr_valueNext = {2'd0, _zz_logic_pushPtr_valueNext_1};
  assign _zz_logic_popPtr_valueNext_1 = logic_popPtr_willIncrement;
  assign _zz_logic_popPtr_valueNext = {2'd0, _zz_logic_popPtr_valueNext_1};
  assign _zz_occupancy = (3'b101 + logic_ptrDif);
  assign _zz_availability = (3'b101 + _zz_availability_1);
  assign _zz_availability_1 = (logic_popPtr_value - logic_pushPtr_value);
  assign _zz_availability_2 = (logic_popPtr_value - logic_pushPtr_value);
  assign _zz_pop_payload = 1'b1;
  assign _zz_logic_ram_port_1 = push_payload;
  always @(posedge clk) begin
    if(_zz_pop_payload) begin
      _zz_logic_ram_port0 <= logic_ram[logic_popPtr_valueNext];
    end
  end

  always @(posedge clk) begin
    if(_zz_1) begin
      logic_ram[logic_pushPtr_value] <= _zz_logic_ram_port_1;
    end
  end

  always @(*) begin
    _zz_1 = 1'b0;
    if(logic_pushing) begin
      _zz_1 = 1'b1;
    end
  end

  always @(*) begin
    logic_pushPtr_willIncrement = 1'b0;
    if(logic_pushing) begin
      logic_pushPtr_willIncrement = 1'b1;
    end
  end

  always @(*) begin
    logic_pushPtr_willClear = 1'b0;
    if(flush) begin
      logic_pushPtr_willClear = 1'b1;
    end
  end

  assign logic_pushPtr_willOverflowIfInc = (logic_pushPtr_value == 3'b100);
  assign logic_pushPtr_willOverflow = (logic_pushPtr_willOverflowIfInc && logic_pushPtr_willIncrement);
  always @(*) begin
    if(logic_pushPtr_willOverflow) begin
      logic_pushPtr_valueNext = 3'b000;
    end else begin
      logic_pushPtr_valueNext = (logic_pushPtr_value + _zz_logic_pushPtr_valueNext);
    end
    if(logic_pushPtr_willClear) begin
      logic_pushPtr_valueNext = 3'b000;
    end
  end

  always @(*) begin
    logic_popPtr_willIncrement = 1'b0;
    if(logic_popping) begin
      logic_popPtr_willIncrement = 1'b1;
    end
  end

  always @(*) begin
    logic_popPtr_willClear = 1'b0;
    if(flush) begin
      logic_popPtr_willClear = 1'b1;
    end
  end

  assign logic_popPtr_willOverflowIfInc = (logic_popPtr_value == 3'b100);
  assign logic_popPtr_willOverflow = (logic_popPtr_willOverflowIfInc && logic_popPtr_willIncrement);
  always @(*) begin
    if(logic_popPtr_willOverflow) begin
      logic_popPtr_valueNext = 3'b000;
    end else begin
      logic_popPtr_valueNext = (logic_popPtr_value + _zz_logic_popPtr_valueNext);
    end
    if(logic_popPtr_willClear) begin
      logic_popPtr_valueNext = 3'b000;
    end
  end

  assign logic_ptrMatch = (logic_pushPtr_value == logic_popPtr_value);
  assign logic_pushing = (push_valid && push_ready);
  assign logic_popping = (pop_valid && pop_ready);
  assign logic_empty = (logic_ptrMatch && (! logic_risingOccupancy));
  assign logic_full = (logic_ptrMatch && logic_risingOccupancy);
  assign push_ready = (! logic_full);
  assign pop_valid = ((! logic_empty) && (! (_zz_pop_valid && (! logic_full))));
  assign pop_payload = _zz_logic_ram_port0;
  assign when_Stream_l1021 = (logic_pushing != logic_popping);
  assign logic_ptrDif = (logic_pushPtr_value - logic_popPtr_value);
  always @(*) begin
    if(logic_ptrMatch) begin
      occupancy = (logic_risingOccupancy ? 3'b101 : 3'b000);
    end else begin
      occupancy = ((logic_popPtr_value < logic_pushPtr_value) ? logic_ptrDif : _zz_occupancy);
    end
  end

  always @(*) begin
    if(logic_ptrMatch) begin
      availability = (logic_risingOccupancy ? 3'b000 : 3'b101);
    end else begin
      availability = ((logic_popPtr_value < logic_pushPtr_value) ? _zz_availability : _zz_availability_2);
    end
  end

  assign when_WaFifo_l23 = (availability <= 3'b001);
  always @(*) begin
    if(when_WaFifo_l23) begin
      almost_full = 1'b1;
    end else begin
      almost_full = 1'b0;
    end
  end

  always @(posedge clk or posedge reset) begin
    if(reset) begin
      logic_pushPtr_value <= 3'b000;
      logic_popPtr_value <= 3'b000;
      logic_risingOccupancy <= 1'b0;
      _zz_pop_valid <= 1'b0;
    end else begin
      logic_pushPtr_value <= logic_pushPtr_valueNext;
      logic_popPtr_value <= logic_popPtr_valueNext;
      _zz_pop_valid <= (logic_popPtr_valueNext == logic_pushPtr_value);
      if(when_Stream_l1021) begin
        logic_risingOccupancy <= logic_pushing;
      end
      if(flush) begin
        logic_risingOccupancy <= 1'b0;
      end
    end
  end


endmodule

module DSP (
              input             [7:0] a       ,
              input             [7:0] d       ,
              input             [7:0] a1      ,
              input             [7:0] d1      ,
              input             [7:0] b       ,
              output            [63:0] p      ,
              input             CLK           ,
              input             CLK_2X        ,
              input             RST_2X


          );

          wire  signed       [7:0]   ain;
    assign ain = $signed(a);
    wire  signed       [24:0]  din;
    wire  signed       [7:0]   ain1;
    assign ain1 = $signed(a1);
    wire  signed       [24:0]  din1;
    assign din1 =  $signed({d1,16'd0});

    wire [33:0] pout;
    wire [15:0] pout1;
    wire [15:0] pout2;
    reg  [31:0] dsp2x_out;
    assign pout1 = pout[15:0];
    assign pout2 = pout[31:16];
    always@(*)begin
        if(pout1[15])begin
            dsp2x_out[15:0] = pout1;
            dsp2x_out[31:16] = pout2+1;
        end else begin
            dsp2x_out[15:0] = pout1;
            dsp2x_out[31:16] = pout2;
        end
    end
    assign din =  $signed({d,16'd0});
    reg dataIn ;
    reg dataInq ;
    reg dataInqq ;
    reg dataInqqq ;
    always@(posedge CLK_2X)begin
        if(RST_2X)begin
            dataIn <= 1'b0;
            dataInq <= dataIn;
            dataInqq <= dataInq;
            dataInqqq <= dataInqq;
        end else begin
            dataIn <= !dataIn;
            dataInq <= dataIn;
            dataInqq <= dataInq;
            dataInqqq <= dataInqq;
        end
    end
    reg [63:0] dsp_out;
    reg out_valid;
    always@(posedge CLK_2X)begin
        if(dataInqqq)begin
            dsp_out[63:32] <= dsp2x_out;
            out_valid <= 1'b1;
        end else begin
            dsp_out[31:0] <= dsp2x_out;
            out_valid <= 1'b0;
        end
    end
    wire out_validq;
    xpm_cdc_single #(
    .DEST_SYNC_FF(4), // DECIMAL; range: 2-10
    .INIT_SYNC_FF(0), // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
    .SIM_ASSERT_CHK(0), // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
    .SRC_INPUT_REG(1) // DECIMAL; 0=do not register input, 1=register input
    )
    dsp2x_s (
        .dest_out(out_validq), // 1-bit output: src_in synchronized to the destination clock domain. This output is
        // registered.

        .dest_clk(CLK), // 1-bit input: Clock signal for the destination clock domain.
        .src_clk(CLK_2X), // 1-bit input: optional; required when SRC_INPUT_REG = 1
        .src_in(out_valid) // 1-bit input: Input signal to be synchronized to dest_clk domain.
    );

    wire [63:0] dsp2x_x_out;
    xpm_cdc_gray #(
    .DEST_SYNC_FF(4), // DECIMAL; range: 2-10
    .INIT_SYNC_FF(0), // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
    .REG_OUTPUT(0), // DECIMAL; 0=disable registered output, 1=enable registered output
    .SIM_ASSERT_CHK(0), // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
    .SIM_LOSSLESS_GRAY_CHK(0), // DECIMAL; 0=disable lossless check, 1=enable lossless check
    .WIDTH(32) // DECIMAL; range: 2-32
    )
    dsp2x_x (
        .dest_out_bin(dsp2x_x_out[31:0]), // WIDTH-bit output: Binary input bus (src_in_bin) synchronized to
        // destination clock domain. This output is combinatorial unless REG_OUTPUT
        // is set to 1.

        .dest_clk(CLK), // 1-bit input: Destination clock.
        .src_clk(CLK_2X), // 1-bit input: Source clock.
        .src_in_bin(dsp_out[31:0]) // WIDTH-bit input: Binary input bus that will be synchronized to the
        // destination clock domain.

    );

       xpm_cdc_gray #(
          .DEST_SYNC_FF(4),          // DECIMAL; range: 2-10
          .INIT_SYNC_FF(0),          // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
          .REG_OUTPUT(0),            // DECIMAL; 0=disable registered output, 1=enable registered output
          .SIM_ASSERT_CHK(0),        // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
          .SIM_LOSSLESS_GRAY_CHK(0), // DECIMAL; 0=disable lossless check, 1=enable lossless check
          .WIDTH(32)                  // DECIMAL; range: 2-32
       )
       dsp2x_x1 (
          .dest_out_bin(dsp2x_x_out[63:32]), // WIDTH-bit output: Binary input bus (src_in_bin) synchronized to
                                       // destination clock domain. This output is combinatorial unless REG_OUTPUT
                                       // is set to 1.

          .dest_clk(CLK),         // 1-bit input: Destination clock.
          .src_clk(CLK_2X),           // 1-bit input: Source clock.
          .src_in_bin(dsp_out[63:32])      // WIDTH-bit input: Binary input bus that will be synchronized to the
                                       // destination clock domain.

       );

    reg [31:0] pTemp;
    always@(posedge CLK)begin
//        if(out_validq)begin
//            pTemp = pTemp;
//        end else begin
            pTemp = dsp2x_x_out[31:0];
//        end
    end
    assign p = {dsp2x_x_out[63:32],pTemp};
    reg  signed       [7:0]   dsp_ain;
    reg  signed       [24:0]   dsp_din;
    reg  signed       [8:0]   dsp_bin;

    wire  signed       [7:0]   aout;
    wire  signed       [7:0]   bout;
    wire  signed       [24:0]  dout;
    xpm_cdc_gray #(
          .DEST_SYNC_FF(4),          // DECIMAL; range: 2-10
          .INIT_SYNC_FF(0),          // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
          .REG_OUTPUT(0),            // DECIMAL; 0=disable registered output, 1=enable registered output
          .SIM_ASSERT_CHK(0),        // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
          .SIM_LOSSLESS_GRAY_CHK(0), // DECIMAL; 0=disable lossless check, 1=enable lossless check
          .WIDTH(8)                  // DECIMAL; range: 2-32
       )
       cdc_ain (
          .dest_out_bin(aout), // WIDTH-bit output: Binary input bus (src_in_bin) synchronized to
                                       // destination clock domain. This output is combinatorial unless REG_OUTPUT
                                       // is set to 1.

          .dest_clk(CLK_2X),         // 1-bit input: Destination clock.
          .src_clk(CLK),           // 1-bit input: Source clock.
          .src_in_bin(ain)      // WIDTH-bit input: Binary input bus that will be synchronized to the
                                       // destination clock domain.

       );
    xpm_cdc_gray #(
          .DEST_SYNC_FF(4),          // DECIMAL; range: 2-10
          .INIT_SYNC_FF(0),          // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
          .REG_OUTPUT(0),            // DECIMAL; 0=disable registered output, 1=enable registered output
          .SIM_ASSERT_CHK(0),        // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
          .SIM_LOSSLESS_GRAY_CHK(0), // DECIMAL; 0=disable lossless check, 1=enable lossless check
          .WIDTH(8)                  // DECIMAL; range: 2-32
       )
       cdc_bin (
          .dest_out_bin(bout), // WIDTH-bit output: Binary input bus (src_in_bin) synchronized to
                                       // destination clock domain. This output is combinatorial unless REG_OUTPUT
                                       // is set to 1.

          .dest_clk(CLK_2X),         // 1-bit input: Destination clock.
          .src_clk(CLK),           // 1-bit input: Source clock.
          .src_in_bin(b)      // WIDTH-bit input: Binary input bus that will be synchronized to the
                                       // destination clock domain.

       );
  xpm_cdc_gray #(
          .DEST_SYNC_FF(4),          // DECIMAL; range: 2-10
          .INIT_SYNC_FF(0),          // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
          .REG_OUTPUT(0),            // DECIMAL; 0=disable registered output, 1=enable registered output
          .SIM_ASSERT_CHK(0),        // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
          .SIM_LOSSLESS_GRAY_CHK(0), // DECIMAL; 0=disable lossless check, 1=enable lossless check
          .WIDTH(25)                  // DECIMAL; range: 2-32
       )
       cdc_din (
          .dest_out_bin(dout), // WIDTH-bit output: Binary input bus (src_in_bin) synchronized to
                                       // destination clock domain. This output is combinatorial unless REG_OUTPUT
                                       // is set to 1.

          .dest_clk(CLK_2X),         // 1-bit input: Destination clock.
          .src_clk(CLK),           // 1-bit input: Source clock.
          .src_in_bin(din)      // WIDTH-bit input: Binary input bus that will be synchronized to the
                                       // destination clock domain.

       );
    wire  signed       [7:0]   aout1;
    wire  signed       [24:0]  dout1;
    xpm_cdc_gray #(
          .DEST_SYNC_FF(4),          // DECIMAL; range: 2-10
          .INIT_SYNC_FF(0),          // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
          .REG_OUTPUT(0),            // DECIMAL; 0=disable registered output, 1=enable registered output
          .SIM_ASSERT_CHK(0),        // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
          .SIM_LOSSLESS_GRAY_CHK(0), // DECIMAL; 0=disable lossless check, 1=enable lossless check
          .WIDTH(8)                  // DECIMAL; range: 2-32
       )
       cdc_ain1 (
          .dest_out_bin(aout1), // WIDTH-bit output: Binary input bus (src_in_bin) synchronized to
                                       // destination clock domain. This output is combinatorial unless REG_OUTPUT
                                       // is set to 1.

          .dest_clk(CLK_2X),         // 1-bit input: Destination clock.
          .src_clk(CLK),           // 1-bit input: Source clock.
          .src_in_bin(ain1)      // WIDTH-bit input: Binary input bus that will be synchronized to the
                                       // destination clock domain.

       );
  xpm_cdc_gray #(
          .DEST_SYNC_FF(4),          // DECIMAL; range: 2-10
          .INIT_SYNC_FF(0),          // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
          .REG_OUTPUT(0),            // DECIMAL; 0=disable registered output, 1=enable registered output
          .SIM_ASSERT_CHK(0),        // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
          .SIM_LOSSLESS_GRAY_CHK(0), // DECIMAL; 0=disable lossless check, 1=enable lossless check
          .WIDTH(25)                  // DECIMAL; range: 2-32
       )
       cdc_din1 (
          .dest_out_bin(dout1), // WIDTH-bit output: Binary input bus (src_in_bin) synchronized to
                                       // destination clock domain. This output is combinatorial unless REG_OUTPUT
                                       // is set to 1.

          .dest_clk(CLK_2X),         // 1-bit input: Destination clock.
          .src_clk(CLK),           // 1-bit input: Source clock.
          .src_in_bin(din1)      // WIDTH-bit input: Binary input bus that will be synchronized to the
                                       // destination clock domain.

       );
    always @(posedge CLK_2X)begin
        if(dataIn)begin
            dsp_ain <= aout;
            dsp_bin <= {1'b0,bout};
            dsp_din <= dout;
        end else begin
            dsp_ain <= aout1;
            dsp_bin <= {1'b0,bout};
            dsp_din <= dout1;
        end
    end 
          mulWeight mulWeight_inst (
            .CLK(CLK_2X), // input wire CLK
            .A(dsp_ain), // input wire [7 : 0] A
            .B(dsp_bin), // input wire [8 : 0] B
            .D(dsp_din), // input wire [24 : 0] D
            .P(pout) // output wire [33 : 0] P
          );

endmodule
      
