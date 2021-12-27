package wa

import spinal.core._
import spinal.lib._

object WaStreamMem {
    def apply[T <: Data](dataType: T, depth: Int) = new WaStreamMem(dataType, depth)
}

class WaStreamMem[T <: Data](dataType: HardType[T], depth: Int) extends Component {
    val readPort = WaStreamMemReadPort(dataType, depth)
    val writePort = WaStreamMemWritePort(dataType, depth)
    val readAddr = Stream(UInt(log2Up(depth) bits))
    readAddr.valid := readPort.addr.valid
    readPort.addr.ready := readAddr.ready
    val k = Mem(dataType, wordCount = depth)
    val z = k.streamReadSync(readAddr.translateWith(readPort.addr.payload))
    val readData: T = dataType()
    readData := z.payload
    readPort.data <> z.translateWith(readData)
    k.write(writePort.addr, writePort.data, writePort.en)

}

case class WaStreamMemReadPort[T <: Data](dataType: HardType[T], depth: Int) extends Bundle {
    val data = master Stream dataType
    val addr = slave Stream UInt(log2Up(depth) bits)
}

case class WaStreamMemWritePort[T <: Data](dataType: HardType[T], depth: Int) extends Bundle {
    val addr = in UInt (log2Up(depth) bits)
    val en = in Bool()
    val data = in(cloneOf(dataType))
}

case class WaStreamMemPort[T <: Data](dataType: HardType[T], depth: Int) extends Bundle {
    val read = WaStreamMemReadPort(dataType, depth)
    val write = WaStreamMemWritePort(dataType, depth)
}

class WaPingPongStreamMem[T <: Data](dataType: T, depth: Int, pingPongCount: Int) extends Component {
    require(pingPongCount > 0,"pingPongCount应该大于0")
    val s_w = if(pingPongCount == 1) 1 else (pingPongCount-1).toBinaryString.length

    val read = WaStreamMemReadPort(dataType, depth)
    val write = WaStreamMemWritePort(dataType, depth)
    val mem = List.fill(pingPongCount)(WaStreamMem(dataType, depth))
    val selectMemIndex = in Bits (s_w bits)
    switch(selectMemIndex) {
        (0 until pingPongCount).foreach { i =>
            is(i) {
                mem.indices.foreach { j =>
                    if (i == j) {
                        mem(j).readPort.addr <> read.addr
                        mem(j).readPort.data <> read.data
                        mem(j).writePort.data <> write.data
                        mem(j).writePort.addr <> write.addr
                        mem(j).writePort.en <> write.en
                    } else {
                        setDefault(mem(j))
                    }
                }
            }

        }
        if(scala.math.pow(2,log2Up(pingPongCount)).toInt!=pingPongCount || pingPongCount == 1){
            default {
                mem.indices.foreach { j =>
                    setDefault(mem(j))
                }
                read.data.valid := False
                read.data.payload.assignFromBits(B(0, dataType.getBitsWidth bits))
                read.addr.ready := False
            }
        }
    }

    def setDefault(t: WaStreamMem[T]) = {
        t.readPort.addr.valid := False
        t.readPort.addr.payload := 0
        t.readPort.data.ready := False
        t.writePort.data.assignFromBits(B(0, dataType.getBitsWidth bits))
        t.writePort.addr := 0
        t.writePort.en := False
    }
}
