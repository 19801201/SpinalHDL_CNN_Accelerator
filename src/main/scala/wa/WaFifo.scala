package wa

import conv.dataGenerate.GenerateMatrixPort
import spinal.core._
import spinal.lib._
import wa.xip.memory.xpm.{FifoSync, XPM_FIFO_SYNC_CONFIG}

object WaStreamFifo {
    def apply[T <: Data](dataType: T, depth: Int) = new WaStreamFifo(dataType, depth)

    def apply[T <: Data](dataType: T, depth: Int, mCount: UInt, sCount: UInt, sReady: Bool, mReady: Bool): WaStreamFifo[T] = {
        val tt = new WaStreamFifo(dataType, depth, true)
        sCount <> tt.sCount
        mCount <> tt.mCount
        sReady <> tt.sReady
        mReady <> tt.mReady
        tt
    }
}

class WaStreamFifo[T <: Data](dataType: HardType[T], depth: Int, flag: Boolean = false) extends StreamFifo[T](dataType: HardType[T], depth: Int) {
    val almost_full = out Bool()
    when(io.availability <= 1) {
        almost_full.set()
    } otherwise {
        almost_full.clear()
    }
    noIoPrefix()
    val sCount = if (flag) in UInt (log2Up(depth) bits) else null
    val mCount = if (flag) in UInt (log2Up(depth) bits) else null
    val sReady = if (flag) out Bool() else null
    val mReady = if (flag) out Bool() else null
    if (flag) {
        when(io.availability >= sCount) {
            sReady := True
        } otherwise {
            sReady := False
        }
        when(io.availability >= mCount) {
            mReady := True
        } otherwise {
            mReady := False

        }
    }
}

case class WaXpmSyncFifo(config: XPM_FIFO_SYNC_CONFIG) extends Component {

    val sCount = in UInt (config.WR_DATA_COUNT_WIDTH bits)
    val mCount = in UInt (config.RD_DATA_COUNT_WIDTH bits)
    val sReady = out Bool()
    val mReady = out Bool()
    val fifo = FifoSync(config)
    val dataIn = slave Flow(UInt(config.WRITE_DATA_WIDTH bits))
    val rd_en = in Bool()
    rd_en <> fifo.io.rd_en
    val dout = out UInt (config.READ_DATA_WIDTH bits)
    dout <> fifo.io.dout
    // dataIn.ready <> ((!(fifo.io.full || fifo.io.wr_rst_busy)) && sReady)
    dataIn.fire <> fifo.io.wr_en
    dataIn.payload <> fifo.io.din

    when(fifo.io.wr_data_count + sCount < config.FIFO_WRITE_DEPTH - 10) {
        sReady.set()
    } otherwise {
        sReady.clear()
    }
    when(fifo.io.rd_data_count >= mCount) {
        mReady.set()
    } otherwise {
        mReady.clear()
    }

}
