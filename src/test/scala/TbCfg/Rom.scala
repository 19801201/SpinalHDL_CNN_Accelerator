package TbCfg

import spinal.core._

class Rom(dataWidth:Int,dataCount:Int,memPath:String) extends Component {
    val io = new Bundle {
        val addr = in UInt (log2Up(dataCount) bits)
        val data = out UInt  (dataWidth bits)
    }
    noIoPrefix()
    val instRom = Mem(UInt(dataWidth bits), dataCount)
    val source = new LoadRom
    val romData = source.loadRomData(memPath)
    val len = romData.length
    val seq = romData ++ Seq.fill(dataCount - len)(BigInt(0))
    instRom.initBigInt(seq,allowNegative = true)
    io.data := instRom.readAsync(io.addr)
}

object Rom extends App {
//    SpinalConfig(globalPrefix = "weight1").generateVerilog(new Rom(64,336,"simData/player1.coe").setName("weight1"))
    SpinalConfig(globalPrefix = "feature1").generateVerilog(new Rom(64,102400,"simData/dark2_CSP_Conv1(1).coe").setName("feature1"))
//    SpinalConfig(globalPrefix = "weight2").generateVerilog(new Rom(64,176,"simData/weight.coe").setName("weight2"))
    SpinalConfig(globalPrefix = "feature2").generateVerilog(new Rom(64,102400,"simData/dark2_CSP_m_Conv2.coe").setName("feature2"))
}
