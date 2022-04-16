import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba4.axi._
import spinal.lib.bus.amba4.axilite._
import config.Config._
import conv.compute._
import shape._
import wa.dma.{DmaConfig, DmaRead, DmaWrite}


class Npu(convConfig: ConvConfig, shapeConfig: ShapeConfig) extends Component {
    val io = new Bundle {
        val convSData = master(Axi4(Axi4Config(log2Up(DDRSize), convConfig.FEATURE_S_DATA_WIDTH, useQos = false, useId = false, useRegion = false, useLock = false, wUserWidth = 0, awUserWidth = 0, bUserWidth = 0)))
        val convMData = master(Axi4(Axi4Config(log2Up(DDRSize), convConfig.FEATURE_M_DATA_WIDTH, useQos = false, useId = false, useRegion = false, useLock = false, wUserWidth = 0, awUserWidth = 0, bUserWidth = 0)))
        val shapeSData = master(Axi4(Axi4Config(log2Up(DDRSize), shapeConfig.STREAM_DATA_WIDTH, useQos = false, useId = false, useRegion = false, useLock = false, wUserWidth = 0, awUserWidth = 0, bUserWidth = 0)))
        val shapeSData1 = master(Axi4(Axi4Config(log2Up(DDRSize), shapeConfig.STREAM_DATA_WIDTH, useQos = false, useId = false, useRegion = false, useLock = false, wUserWidth = 0, awUserWidth = 0, bUserWidth = 0)))
        val shapeMData = master(Axi4(Axi4Config(log2Up(DDRSize), shapeConfig.STREAM_DATA_WIDTH, useQos = false, useId = false, useRegion = false, useLock = false, wUserWidth = 0, awUserWidth = 0, bUserWidth = 0)))
        val instruction = slave(AxiLite4(log2Up(registerAddrSize), 32))
    }
    noIoPrefix()
    Axi4SpecRenamer(io.convSData)
    Axi4SpecRenamer(io.convMData)
    Axi4SpecRenamer(io.shapeSData)
    Axi4SpecRenamer(io.shapeSData1)
    Axi4SpecRenamer(io.shapeMData)

    val convDmaWrite = new DmaWrite(DmaConfig(log2Up(DDRSize), convConfig.FEATURE_S_DATA_WIDTH, burstSize))
    val convDmaRead = new DmaRead(DmaConfig(log2Up(DDRSize), convConfig.FEATURE_M_DATA_WIDTH, burstSize))

    convDmaWrite.io.M_AXI_S2MM.toAxi4() <> io.convMData
    convDmaRead.io.M_AXI_MM2S.toAxi4() <> io.convSData

    val shapeDmaWrite = new DmaWrite(DmaConfig(log2Up(DDRSize), shapeConfig.STREAM_DATA_WIDTH, burstSize))
    val shapeDmaRead = new DmaRead(DmaConfig(log2Up(DDRSize), shapeConfig.STREAM_DATA_WIDTH, burstSize))
    val shapeDmaRead1 = new DmaRead(DmaConfig(log2Up(DDRSize), shapeConfig.STREAM_DATA_WIDTH, burstSize))
    shapeDmaWrite.io.M_AXI_S2MM.toAxi4() <> io.shapeMData
    shapeDmaRead.io.M_AXI_MM2S.toAxi4() <> io.shapeSData
    shapeDmaRead1.io.M_AXI_MM2S.toAxi4() <> io.shapeSData1


    val conv = new Conv(convConfig)
    conv.io.sData <> convDmaRead.io.M_AXIS_MM2S
    convDmaWrite.io.M_AXIS_S2MM <> conv.io.mData

    val shape = new Shape(shapeConfig)
    shape.io.sData(0) <> shapeDmaRead.io.M_AXIS_MM2S
    shape.io.sData(1) <> shapeDmaRead1.io.M_AXIS_MM2S
    shape.io.mData <> shapeDmaWrite.io.M_AXIS_S2MM
}

object Npu extends App {
    SpinalVerilog(new Npu(ConvConfig(8, 8, 8, 12, 8192, 512, 416, 2048, 1), ShapeConfig(8, 8, 640, 10, 1024)))
}
