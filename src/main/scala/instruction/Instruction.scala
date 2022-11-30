package instruction

import shape._
import config.Config._
import conv.compute.CONV_STATE
import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba4.axilite._
import spinal.lib.bus.misc.SizeMapping
import spinal.lib.bus.regif._
import spinal.lib.bus.regif.AccessType._

class Instruction(addr: Int, instructionType: List[String]) extends Component {
    val io = new Bundle {
        val regSData = slave(AxiLite4(log2Up(registerAddrSize), 32))
        val convInstruction = out Vec(Vec(Reg(Bits(32 bits)) init 0, CONV_STATE.Reg.length), ConvNum)
        val shapeInstruction = out Vec(Reg(Bits(32 bits)) init 0, shape.Instruction.Reg.length)
    }
    noIoPrefix()
    AxiLite4SpecRenamer(io.regSData)
    val bus = BusInterface(io.regSData, sizeMap = SizeMapping(addr, registerAddrSize))

    class GenConvInst extends Area {
        val convStateReg = bus.newReg(doc = "卷积状态指令")
        val convControlReg = bus.newReg(doc = "卷积控制指令")
        val convState = in Bits (4 bits)
        val t1 = convStateReg.field(Bits(4 bits), RO, doc = "卷积的状态")
        t1 := convState
        val convControl = convControlReg.field(Bits(4 bits), WO, doc = "卷积的控制指令").asOutput()
    }

    val convInst = Array.tabulate(ConvNum) { i => {
        def gen = {
            val c = new GenConvInst
            c
        }

        gen
    }
    }


    val shapeStateReg = bus.newReg(doc = "shape状态指令")
    val shapeControlReg = bus.newReg(doc = "shape控制指令")
    val shapeState = in Bits (4 bits)
    val t2 = shapeStateReg.field(Bits(4 bits), RO, doc = "shape的状态")
    t2 := shapeState
    val shapeControl = shapeControlReg.field(Bits(4 bits), WO, doc = "shape的控制指令").asOutput()

    var index = 0

    class GenConvPara(convInt: Int) extends Area {
        index = 0
        val convInstruction = CONV_STATE.Reg.foreach(in => {
            val reg = bus.newReg(doc = "Conv" + in._1)
            var h = 0
            var l = 0
            for (i <- 0 until in._2.productArity if i % 2 == 0) {
                val w = in._2.productElement(i + 1).toString.toInt
                l = h
                h = h + w
                val regFiled = reg.field(Bits(w bits), WO, doc = in._2.productElement(i).toString)
                io.convInstruction(convInt)(index)((h - 1) downto l) := regFiled
            }
            index = index + 1
        })
    }

    val convParaInst = Array.tabulate(ConvNum) { i => {
        def gen = {
            val c = new GenConvPara(i).convInstruction
            c
        }

        gen
    }
    }
    index = 0
    val shapeInstruction = shape.Instruction.Reg.foreach(in => {
        val reg = bus.newReg(doc = "Shape" + in._1)
        var h = 0
        var l = 0
        for (i <- 0 until in._2.productArity if i % 2 == 0) {
            val w = in._2.productElement(i + 1).toString.toInt
            l = h
            h = h + w
            val regFiled = reg.field(Bits(w bits), WO, doc = in._2.productElement(i).toString)
            io.shapeInstruction(index)((h - 1) downto l) := regFiled
        }
        index = index + 1
    })

    val s = instructionType
    val dma = Array.tabulate(s.length) { i => {
        def gen = {

            val writeAddrReg = bus.newReg(doc = "dma写地址")
            val writeAddr = writeAddrReg.field(32 bits, WO, doc = s(i) + i.toString + " dma写地址").setName(s(i) + i.toString + "writeAddr").asOutput()
            val writeLenReg = bus.newReg(doc = "dma写长度,以字节为单位")
            val writeLen = writeLenReg.field(32 bits, WO, doc = s(i) + i.toString + " dma写长度").setName(s(i) + i.toString + "writeLen").asOutput()
            var addr = List(writeAddr)
            var len = List(writeLen)
            val readAddrReg = bus.newReg(doc = "dma读地址")
            val readAddr = readAddrReg.field(32 bits, WO, doc = s(i) + i.toString + " dma读地址").setName(s(i) + i.toString + "readAddr").asOutput()
            val readLenReg = bus.newReg(doc = "dma读长度，以字节为单位")
            val readLen = readLenReg.field(32 bits, WO, doc = s(i) + i.toString + " dma读长度").setName(s(i) + i.toString + "readLen").asOutput()
            addr = addr.::(readAddr)
            len = len.::(readLen)
            if (i == s.length - 1) {
                val readAddrReg = bus.newReg(doc = "dma读地址")
                val readAddr = readAddrReg.field(32 bits, WO, doc = s(i) + i.toString + " dma读地址1").setName(s(i) + i.toString + "readAddr1").asOutput()
                val readLenReg = bus.newReg(doc = "dma读长度，以字节为单位")
                val readLen = readLenReg.field(32 bits, WO, doc = s(i) + i.toString + " dma读长度").setName(s(i) + i.toString + "readLen1").asOutput()
                addr = addr.::(readAddr)
                len = len.::(readLen)
            }
            addr = addr.reverse
            len = len.reverse
            List(addr, len)
        }

        gen
    }
    }

    val convCascade_ = bus.newReg(doc = "conv级联")
    val convCascade = convCascade_.field(log2Up(ConvNum) + 1 bits, WO).asOutput()
    bus.accept(HtmlGenerator("Reg", "Npu"))

}

//object Instruction extends App {
//    SpinalVerilog(new Instruction)
//}
