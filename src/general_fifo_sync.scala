import spinal.core._
import xfifo.fifo_sync

import scala.math.pow

class general_fifo_sync(
                           W_DATA_WIDTH: Int,
                           R_DATA_WIDTH: Int,
                           MEMORY_DEPTH: Int,
                           ROW_COL_DATA_COUNT_WIDTH: Int,
                           IS_FIRST: Boolean = false
                       ) extends Component {
    val fifo_w_width = W_DATA_WIDTH
    val fifo_r_width = R_DATA_WIDTH
    val fifo_depth = pow(2, log2Up(MEMORY_DEPTH)).toInt
    val fifo = new fifo_sync(fifo_w_width, fifo_depth, fifo_r_width, 0, "block", "fwft")
    val io = new Bundle {
        val data_in = in Bits (W_DATA_WIDTH bits)
        val wr_en = in Bool()
        val data_in_ready = out Bool()

        val data_out = out Bits (R_DATA_WIDTH bits)
        val rd_en = in Bool()
        val data_out_valid = out Bool()
        val m_data_count = in UInt (ROW_COL_DATA_COUNT_WIDTH bits)
        val s_data_count = in UInt (ROW_COL_DATA_COUNT_WIDTH bits)
        val data_valid = out Bool()
        val full = out Bool()
        val empty = out Bool()
    }
    noIoPrefix()
    io.data_valid := fifo.io.data_valid
    io.full := fifo.io.full
    io.empty := fifo.io.empty


    fifo.io.wr_en <> io.wr_en
    fifo.io.rd_en <> io.rd_en
    fifo.io.din <> io.data_in
    fifo.io.dout <> io.data_out
    //    when((!fifo.io.wr_rst_busy)  && (!fifo.io.full)) {
    //        io.data_in_ready := True
    //    } otherwise (
    //        io.data_in_ready := False
    //        )
    if (!IS_FIRST) {
        when((!fifo.io.wr_rst_busy) && (U(fifo.io.wr_data_count) + io.s_data_count < fifo_depth) && (!fifo.io.full)) {
            io.data_in_ready := True
        } otherwise (
            io.data_in_ready := False
            )
    } else {
        when((!fifo.io.wr_rst_busy) && (!fifo.io.full) && (U(fifo.io.wr_data_count) < fifo_depth - 10)) {
            io.data_in_ready := True
        } otherwise (
            io.data_in_ready := False
            )
    }
    when((!fifo.io.rd_rst_busy) && (U(fifo.io.rd_data_count) >= io.m_data_count)) {
        io.data_out_valid := True
    } otherwise (
        io.data_out_valid := False
        )



}
