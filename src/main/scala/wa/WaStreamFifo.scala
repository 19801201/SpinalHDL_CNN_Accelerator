package wa

import spinal.core._
import spinal.lib.StreamFifo

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
