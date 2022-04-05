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
