package wa.xip.memory.xpm

import spinal.core._


case class XPM_FIFO_SYNC_CONFIG(memoryType:String,readLatency:Int,readMode:String,writeDepth:Int,writeWidth:Int,readWidth:Int){
    val CASCADE_HEIGHT = 0
    val DOUT_RESET_VALUE = 0
    val ECC_MODE = "no_ecc"
    val FIFO_MEMORY_TYPE = memoryType
    val READ_MODE = readMode
    val FIFO_READ_LATENCY = if(readMode==FIFO_READ_MODE.fwft) 0 else readLatency
    val FIFO_WRITE_DEPTH = writeDepth
    val FULL_RESET_VALUE = 0
    val READ_DATA_WIDTH = readWidth
    val PROG_EMPTY_THRESH = 3 + (if(readMode==FIFO_READ_MODE.fwft) 1 else 0) * 2
//    println(FIFO_WRITE_DEPTH)
//    println(WRITE_DATA_WIDTH)
//    println(READ_DATA_WIDTH)
    val WRITE_DATA_WIDTH = writeWidth
    val FIFO_READ_DEPTH = FIFO_WRITE_DEPTH * WRITE_DATA_WIDTH / READ_DATA_WIDTH
    val PROG_FULL_THRESH =(FIFO_WRITE_DEPTH - 3) - ((if(readMode==FIFO_READ_MODE.fwft) 1 else 0) * 2 * (FIFO_WRITE_DEPTH / FIFO_READ_DEPTH))

    val WR_DATA_COUNT_WIDTH = log2Up(FIFO_WRITE_DEPTH) + 1

    val RD_DATA_COUNT_WIDTH = log2Up(FIFO_READ_DEPTH) + 1
    val SIM_ASSERT_CHK = 0
    val USE_ADV_FEATURES = "0707"
    val WAKEUP_TIME = 0

}

class xpm_fifo_sync(config: XPM_FIFO_SYNC_CONFIG) extends BlackBox{
    addGeneric("CASCADE_HEIGHT",config.CASCADE_HEIGHT)
    addGeneric("DOUT_RESET_VALUE",config.DOUT_RESET_VALUE)
    addGeneric("ECC_MODE",config.ECC_MODE)
    addGeneric("FIFO_MEMORY_TYPE",config.FIFO_MEMORY_TYPE)
    addGeneric("FIFO_READ_LATENCY",config.FIFO_READ_LATENCY)
    addGeneric("FIFO_WRITE_DEPTH",config.FIFO_WRITE_DEPTH)
    addGeneric("FULL_RESET_VALUE",config.FULL_RESET_VALUE)
    addGeneric("PROG_EMPTY_THRESH",config.PROG_EMPTY_THRESH)
    addGeneric("PROG_FULL_THRESH",config.PROG_FULL_THRESH)
    addGeneric("RD_DATA_COUNT_WIDTH",config.RD_DATA_COUNT_WIDTH)
    addGeneric("READ_DATA_WIDTH",config.READ_DATA_WIDTH)
    addGeneric("READ_MODE",config.READ_MODE)
    addGeneric("SIM_ASSERT_CHK",config.SIM_ASSERT_CHK)
    addGeneric("USE_ADV_FEATURES",config.USE_ADV_FEATURES)
    addGeneric("WAKEUP_TIME",config.WAKEUP_TIME)
    addGeneric("WRITE_DATA_WIDTH",config.WRITE_DATA_WIDTH)
    addGeneric("WR_DATA_COUNT_WIDTH",config.WR_DATA_COUNT_WIDTH)
    val io = new Bundle {
        val almost_empty = out Bool()
        val almost_full = out Bool()
        val data_valid = out Bool()
        val dbiterr = out Bool()
        val dout = out UInt (config.READ_DATA_WIDTH bits)
        val empty = out Bool()
        val full = out Bool()
        val overflow = out Bool()
        val prog_empty = out Bool()
        val prog_full = out Bool()
        val rd_data_count = out UInt  (config.RD_DATA_COUNT_WIDTH bits)
        val rd_rst_busy = out Bool()
        val sbiterr = out Bool()
        val underflow = out Bool()
        val wr_ack = out Bool()
        val wr_data_count = out UInt (config.WR_DATA_COUNT_WIDTH bits)
        val wr_rst_busy = out Bool()
        val din = in UInt (config.WRITE_DATA_WIDTH bits)
        val injectdbiterr = in Bool()
        val injectsbiterr = in Bool()
        val rd_en = in Bool()
        val rst = in Bool()
        val sleep = in Bool()
        val wr_clk = in Bool()
        val wr_en = in Bool()
    }
    noIoPrefix()
    mapClockDomain(clock = io.wr_clk, reset = io.rst)

}

case class FifoSync(config: XPM_FIFO_SYNC_CONFIG) extends Component {
    val io = new Bundle {
        val full = out Bool()
        val wr_en = in Bool()
        val din = in UInt  (config.WRITE_DATA_WIDTH bits)
        val empty = out Bool()
        val dout = out UInt (config.READ_DATA_WIDTH bits)
        val rd_en = in Bool()
        val wr_data_count = out UInt (config.WR_DATA_COUNT_WIDTH bits)
        val rd_data_count = out UInt (config.RD_DATA_COUNT_WIDTH bits)
        val data_valid = out Bool()
        val rd_rst_busy = out Bool()
        val wr_rst_busy = out Bool()
    }
    noIoPrefix()
    val almost_empty = Bool()
    val almost_full = Bool()
    val dbiterr = Bool()
    val overflow = Bool()
    val prog_empty = Bool()
    val prog_full = Bool()

    val sbiterr = Bool()
    val underflow = Bool()
    val wr_ack = Bool()

    val injectdbiterr = Bool()
    injectdbiterr := False
    val injectsbiterr = Bool()
    injectsbiterr := False
    val sleep=Bool()
    sleep:= False
    val temp = new xpm_fifo_sync(config).setName("xpm_fifo_sync")
    temp.io.almost_empty <> almost_empty
    temp.io.almost_full <> almost_full
    temp.io.data_valid <> io.data_valid
    temp.io.dbiterr <> dbiterr
    temp.io.dout <> io.dout
    temp.io.empty <> io.empty
    temp.io.full <> io.full
    temp.io.overflow <> overflow
    temp.io.prog_empty <> prog_empty
    temp.io.prog_full <> prog_full
    temp.io.rd_data_count <> io.rd_data_count
    temp.io.rd_rst_busy <> io.rd_rst_busy
    temp.io.sbiterr <> sbiterr
    temp.io.underflow <> underflow
    temp.io.wr_ack <> wr_ack
    temp.io.wr_data_count <> io.wr_data_count
    temp.io.wr_rst_busy <> io.wr_rst_busy
    temp.io.din <> io.din
    temp.io.injectdbiterr <> injectdbiterr
    temp.io.injectsbiterr <> injectsbiterr
    temp.io.rd_en <> io.rd_en
    temp.io.sleep <> sleep
    temp.io.wr_en <> io.wr_en

}
//object testXpm{
//    def main(args: Array[String]): Unit = {
//        SpinalVerilog(FifoSync(config = XPM_FIFO_SYNC_CONFIG(MEM_TYPE.auto,2,FIFO_READ_MODE.fwft,2048,16,16)))
//    }
//}