package wa.WaStream

import spinal.core._
import spinal.lib._

class WaStreamFifoPipe[T <: Data](dataType: T, depth: Int) extends Component {

    val io = new Bundle {
        val push = slave Stream (dataType)
        val pop = master Stream (dataType)
        val flush = in Bool() default (False)
        val occupancy = out UInt (log2Up(depth + 1) bits)
        val availability = out UInt (log2Up(depth + 1) bits)
    }
    noIoPrefix()
    val fifo = StreamFifo(dataType, depth)
    fifo.io.push <> io.push
    fifo.io.flush <> io.flush
    fifo.io.occupancy <> io.occupancy
    fifo.io.availability <> io.availability
    //    fifo.io.pop <> io.pop

    val dataReg = RegNext(fifo.io.pop.payload)
    val fireReg = RegNext(fifo.io.pop.fire, False)
    val validHold = Reg(Bool()) init False
    val dataHold = RegNextWhen(dataReg, fireReg & (!fifo.io.pop.ready))

    when(fifo.io.pop.ready) {
        validHold.clear()
    } elsewhen (fireReg & (!fifo.io.pop.ready)) {
        validHold.set()
    }
    io.pop.valid := validHold | fireReg
    io.pop.payload := Mux(validHold, dataHold, dataReg)
    fifo.io.pop.ready := io.pop.ready || (!io.pop.valid)

}

object WaStreamFifoPipe {
    def apply[T <: Data](dataType: T, depth: Int) = new WaStreamFifoPipe(dataType, depth)
}

