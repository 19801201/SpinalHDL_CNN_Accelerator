import config.Config
import misc.TotalTcl
import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba4.axi._
import spinal.lib.bus.amba4.axilite._
import config.Config._
import conv.compute._
import conv.dataGenerate.dataWait
import shape._
import wa.dma.{DmaConfig, DmaRead, DmaWrite}

import java.io.File


class Npu(convConfig: ConvConfig, shapeConfig: ShapeConfig) extends Component {
    val firstLayerWidth = if (imageType.dataType == imageType.rgb) 4 * convConfig.DATA_WIDTH else 8

    val regSData = slave(AxiLite4(log2Up(registerAddrSize), 32))
    AxiLite4SpecRenamer(regSData)

    val conv = new Conv(convConfig)
    val shape = new Shape(shapeConfig)
    val register = new instruction.Instruction
    if (!Config.useXilinxDma) {

    } else {

        case class Cmd() extends Bundle {
            val cmd = out Bits (64 bits)
            val valid = out Bool()
            val introut = in Bool()
        }

        val io = new Bundle {
            val convSData = slave Stream UInt(convConfig.FEATURE_S_DATA_WIDTH bits) setName ("convSData")
            val convFirstLayerSData = slave Stream UInt(firstLayerWidth bits) setName ("convFirstLayerSData")
            val convMData = master Stream UInt(convConfig.FEATURE_M_DATA_WIDTH bits) setName ("convMData")
            val shapeSData = slave Stream UInt(shapeConfig.STREAM_DATA_WIDTH bits) setName ("shapeSData")
            val shapeSData1 = slave Stream UInt(shapeConfig.STREAM_DATA_WIDTH bits) setName ("shapeSData1")
            val shapeMData = master Stream UInt(shapeConfig.STREAM_DATA_WIDTH bits) setName ("shapeMData")

            val convSDataCmd = Cmd() setName ("convSDataCmd")
            val convFirstLayerSDataCmd = Cmd() setName ("convFirstLayerSDataCmd")
            val convMDataCmd = Cmd() setName ("convMDataCmd")
            val shapeSDataCmd = Cmd() setName ("shapeSDataCmd")             // dma read 0
            val shapeSData1Cmd = Cmd() setName ("shapeSData1Cmd")           // dma read 1
            val shapeMDataCmd = Cmd() setName ("shapeMDataCmd")             // dma write
            val convMLast = out Bool() setName ("convMLast")
            val shapeMLast = out Bool() setName ("shapeMLast")

            val w_addr  = out UInt (12 bits) setName ("bram_w_addr")
            val w_data  = out UInt (64 bits) setName ("bram_w_data")
            val w_en    = out Bool()    setName ("bram_w_en")
            val finish  = out Bool()    setName ("bram_finish")
        }
        noIoPrefix()

        conv.io.last <> io.convMLast
        shape.io.last <> io.shapeMLast

        io.convMDataCmd.cmd := register.dma(0)(0)(0) ## register.dma(0)(1)(0)
        io.convMDataCmd.valid := conv.io.dmaWriteValid
        io.convSDataCmd.cmd := register.dma(0)(0)(1) ## register.dma(0)(1)(1)
        io.convSDataCmd.valid := conv.io.dmaReadValid
        io.convFirstLayerSDataCmd.valid := conv.io.dmaFirstLayerReadValid

        io.convFirstLayerSDataCmd.cmd := register.dma(0)(0)(1) ## register.dma(0)(1)(1)
        
        io.shapeMDataCmd.valid := shape.io.dmaWriteValid
        io.shapeMDataCmd.cmd := register.dma(1)(0)(0) ## register.dma(1)(1)(0)
        io.shapeSDataCmd.valid := shape.io.dmaReadValid(0)
        io.shapeSDataCmd.cmd := register.dma(1)(0)(1) ## register.dma(1)(1)(1)
        io.shapeSData1Cmd.valid := shape.io.dmaReadValid(1)
        io.shapeSData1Cmd.cmd := register.dma(1)(0)(2) ## register.dma(1)(1)(2)

        io.convSData <> conv.io.sData
        io.convMData <> conv.io.mData
        io.convFirstLayerSData <> conv.io.sFeatureFirstLayerData

        io.shapeSData <> shape.io.sData(0)
        io.shapeSData1 <> shape.io.sData(1)
        io.shapeMData <> shape.io.mData

        shape.io.w_addr    <> io.w_addr
        shape.io.w_data    <> io.w_data
        shape.io.w_en      <> io.w_en
        shape.io.finish    <> io.finish

        conv.io.introut := io.convMDataCmd.introut
        shape.io.introut := io.shapeMDataCmd.introut

    }


    register.io.regSData <> regSData
    register.io.convInstruction <> conv.io.instruction
    register.io.quantInstruction <> conv.io.quant_instruction
    register.io.shapeInstruction <> shape.io.instruction
    register.convState <> conv.io.state
    register.convControl <> conv.io.control
    register.shapeState <> shape.io.state
    register.shapeControl <> shape.io.control


}

object Npu extends App {
    //    SpinalVerilog(new Npu(ConvConfig(8, 8, 8, 12, 8192, 512, 416, 2048, 1), ShapeConfig(8, 8, 416, 10, 1024)))
    //    TotalTcl(Config.filePath + File.separator + "tcl", Config.filePath).genTotalTcl
    val clockCfg = ClockDomainConfig(resetKind = SYNC, resetActiveLevel = HIGH)
    SpinalConfig(headerWithDate = true, oneFilePerComponent = true, inlineRom = true, nameWhenByFile = false, defaultConfigForClockDomains = clockCfg, targetDirectory = Config.filePath + File.separator + "rtl").generateVerilog(new Npu(ConvConfig(8, 16, 16, 12, 4096, 512, 640, 4096, 1), ShapeConfig(8, 8, 640, 12, 4096)))
    TotalTcl(Config.filePath + File.separator + "tcl", Config.filePath).genTotalTcl
}
