package xfifo

import spinal.core._

class xpm_fifo_sync(
                       DOUT_RESET_VALUE: String = "0", // String
                       ECC_MODE: String = "no_ecc", // String
                       FIFO_MEMORY_TYPE: String = "auto", // String
                       FIFO_READ_LATENCY: Int = 1, // DECIMAL
                       FIFO_WRITE_DEPTH: Int = 2048, // DECIMAL
                       FULL_RESET_VALUE: Int = 0, // DECIMAL
                       PROG_EMPTY_THRESH: Int = 10, // DECIMAL
                       PROG_FULL_THRESH: Int = 10, // DECIMAL
                       RD_DATA_COUNT_WIDTH: Int = 1, // DECIMAL
                       READ_DATA_WIDTH: Int = 32, // DECIMAL
                       READ_MODE: String = "std", // String
                       SIM_ASSERT_CHK: Int = 0, // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
                       USE_ADV_FEATURES: String = "0707", // String
                       WAKEUP_TIME: Int = 0, // DECIMAL
                       WRITE_DATA_WIDTH: Int = 32, // DECIMAL
                       WR_DATA_COUNT_WIDTH: Int = 1 // DECIMAL
                   ) extends BlackBox {
    addGeneric("DOUT_RESET_VALUE", DOUT_RESET_VALUE)
    addGeneric("ECC_MODE", ECC_MODE)
    addGeneric("FIFO_MEMORY_TYPE", FIFO_MEMORY_TYPE)
    addGeneric("FIFO_READ_LATENCY", FIFO_READ_LATENCY)
    addGeneric("FIFO_WRITE_DEPTH", FIFO_WRITE_DEPTH)
    addGeneric("FULL_RESET_VALUE", FULL_RESET_VALUE)
    addGeneric("PROG_EMPTY_THRESH", PROG_EMPTY_THRESH)
    addGeneric("PROG_FULL_THRESH", PROG_FULL_THRESH)
    addGeneric("RD_DATA_COUNT_WIDTH", RD_DATA_COUNT_WIDTH)
    addGeneric("READ_DATA_WIDTH", READ_DATA_WIDTH)
    addGeneric("READ_MODE", READ_MODE)
    addGeneric("SIM_ASSERT_CHK", SIM_ASSERT_CHK)
    addGeneric("USE_ADV_FEATURES", USE_ADV_FEATURES)
    addGeneric("WAKEUP_TIME", WAKEUP_TIME)
    addGeneric("WRITE_DATA_WIDTH", WRITE_DATA_WIDTH)
    addGeneric("WR_DATA_COUNT_WIDTH", WR_DATA_COUNT_WIDTH)
    val io = new Bundle {
        val almost_empty = out Bool()
        val almost_full = out Bool()
        val data_valid = out Bool()
        val dbiterr = out Bool()
        val dout = out Bits (READ_DATA_WIDTH bits)
        val empty = out Bool()
        val full = out Bool()
        val overflow = out Bool()
        val prog_empty = out Bool()
        val prog_full = out Bool()
        val rd_data_count = out Bits (RD_DATA_COUNT_WIDTH bits)
        val rd_rst_busy = out Bool()
        val sbiterr = out Bool()
        val underflow = out Bool()
        val wr_ack = out Bool()
        val wr_data_count = out Bits (WR_DATA_COUNT_WIDTH bits)
        val wr_rst_busy = out Bool()
        val din = in Bits (WRITE_DATA_WIDTH bits)
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

object xpm_fifo_sync {
    def apply(
                 DOUT_RESET_VALUE: String = "0", // String
                 ECC_MODE: String = "no_ecc", // String
                 FIFO_MEMORY_TYPE: String = "auto", // String
                 FIFO_READ_LATENCY: Int = 1, // DECIMAL
                 FIFO_WRITE_DEPTH: Int = 2048, // DECIMAL
                 FULL_RESET_VALUE: Int = 0, // DECIMAL
                 PROG_EMPTY_THRESH: Int = 10, // DECIMAL
                 PROG_FULL_THRESH: Int = 10, // DECIMAL
                 RD_DATA_COUNT_WIDTH: Int = 1, // DECIMAL
                 READ_DATA_WIDTH: Int = 32, // DECIMAL
                 READ_MODE: String = "std", // String
                 SIM_ASSERT_CHK: Int = 0, // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
                 USE_ADV_FEATURES: String = "0707", // String
                 WAKEUP_TIME: Int = 0, // DECIMAL
                 WRITE_DATA_WIDTH: Int = 32, // DECIMAL
                 WR_DATA_COUNT_WIDTH: Int = 1 // DECIMAL
             )(almost_empty: Bool, almost_full: Bool, data_valid: Bool, dbiterr: Bool, dout: Bits, empty: Bool, full: Bool, overflow: Bool, prog_empty: Bool,
               prog_full: Bool, rd_data_count: Bits, rd_rst_busy: Bool, sbiterr: Bool, underflow: Bool, wr_ack: Bool, wr_data_count: Bits, wr_rst_busy: Bool,
               din: Bits, injectdbiterr: Bool, injectsbiterr: Bool, rd_en: Bool,  sleep: Bool, wr_en: Bool): xpm_fifo_sync = {
        val temp = new xpm_fifo_sync(DOUT_RESET_VALUE, ECC_MODE, FIFO_MEMORY_TYPE, FIFO_READ_LATENCY, FIFO_WRITE_DEPTH, FULL_RESET_VALUE, PROG_EMPTY_THRESH,
            PROG_FULL_THRESH, RD_DATA_COUNT_WIDTH, READ_DATA_WIDTH, READ_MODE, SIM_ASSERT_CHK, USE_ADV_FEATURES, WAKEUP_TIME, WRITE_DATA_WIDTH, WR_DATA_COUNT_WIDTH)
        temp.io.almost_empty <> almost_empty
        temp.io.almost_full <> almost_full
        temp.io.data_valid <> data_valid
        temp.io.dbiterr <> dbiterr
        temp.io.dout <> dout
        temp.io.empty <> empty
        temp.io.full <> full
        temp.io.overflow <> overflow
        temp.io.prog_empty <> prog_empty
        temp.io.prog_full <> prog_full
        temp.io.rd_data_count <> rd_data_count
        temp.io.rd_rst_busy <> rd_rst_busy
        temp.io.sbiterr <> sbiterr
        temp.io.underflow <> underflow
        temp.io.wr_ack <> wr_ack
        temp.io.wr_data_count <> wr_data_count
        temp.io.wr_rst_busy <> wr_rst_busy
        temp.io.din <> din
        temp.io.injectdbiterr <> injectdbiterr
        temp.io.injectsbiterr <> injectsbiterr
        temp.io.rd_en <> rd_en
        temp.io.sleep <> sleep
        temp.io.wr_en <> wr_en

        temp
    }
}

class fifo_sync(
                   WRITE_WIDTH: Int,
                   WRITE_DEPTH: Int,
                   READ_WIDTH: Int,
                   READ_LATENCY: Int = 2,
                   MEMORY_TYPE: String = "auto",
                   READ_MODE: String = "fwft"
               ) extends Component {
    assert(MEMORY_TYPE == "auto" || MEMORY_TYPE == "block" || MEMORY_TYPE == "distributed" || MEMORY_TYPE == "ultra", "MEMORY_TYPE应为auto，block，distributed，ultra中的一种")
    assert(READ_MODE == "std" || READ_MODE == "fwft", "READ_MODE应为std或fwft")
    if (READ_MODE == "fwft") {
        assert(READ_LATENCY == 0, "If READ_MODE = \"fwft\", then the only applicable value is 0")
    }
    if(MEMORY_TYPE=="auto"){
        assert(WRITE_WIDTH == READ_WIDTH,"WRITE_DATA_WIDTH should be equal to READ_DATA_WIDTH if FIFO_MEMORY_TYPE is set to \"auto\".")
    }
    assert((WRITE_DEPTH & (WRITE_DEPTH - 1)) == 0, "Defines the FIFO Write Depth, must be power of two")
    var wr_ratio = false
    if (WRITE_WIDTH == READ_WIDTH) {
        wr_ratio = true
    } else if (WRITE_WIDTH > READ_WIDTH) {
        for (i <- 2 to 8 if (!wr_ratio) && (i % 2 == 0) && (READ_WIDTH * i == WRITE_WIDTH)) {
            wr_ratio = true
        }
    } else {
        for (i <- 2 to 8 if (!wr_ratio) && (i % 2 == 0) && (WRITE_WIDTH * i == READ_WIDTH)) {
            wr_ratio = true
        }
    }
    assert(wr_ratio, "Write and read width aspect ratio must be 1:1, 1:2, 1:4, 1:8, 8:1, 4:1 and 2:1 ")
    val WRITE_DATA_WIDTH: Int = WRITE_WIDTH // DECIMAL
    val READ_DATA_WIDTH: Int = READ_WIDTH // DECIMAL
    val FIFO_WRITE_DEPTH: Int = WRITE_DEPTH // DECIMAL
    val READ_MODE_VAL = if (READ_MODE == "fwft") 1 else 0
    val FIFO_READ_DEPTH = FIFO_WRITE_DEPTH * WRITE_DATA_WIDTH / READ_DATA_WIDTH
    val DOUT_RESET_VALUE: String = "0" // String
    val ECC_MODE: String = "no_ecc" // String
    val FIFO_MEMORY_TYPE: String = MEMORY_TYPE // String
    val FIFO_READ_LATENCY: Int = READ_LATENCY // DECIMAL

    val FULL_RESET_VALUE: Int = 0 // DECIMAL
    val PROG_EMPTY_THRESH: Int = 3 + (READ_MODE_VAL * 2) // DECIMAL
    val PROG_FULL_THRESH: Int = (FIFO_WRITE_DEPTH - 3) - (READ_MODE_VAL * 2 * (FIFO_WRITE_DEPTH / FIFO_READ_DEPTH)) // DECIMAL
    val RD_DATA_COUNT_WIDTH: Int = log2Up(FIFO_READ_DEPTH) + 1// DECIMAL

    val READ_MODE_A: String = READ_MODE // String
    val SIM_ASSERT_CHK: Int = 0 // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
    val USE_ADV_FEATURES: String = "1404" // String  使能wr_data_count，rd_data_count，data_valid
    val WAKEUP_TIME: Int = 0 // DECIMAL

    val WR_DATA_COUNT_WIDTH: Int = log2Up(FIFO_WRITE_DEPTH) + 1// DECIMAL

    val io = new Bundle {
        val full = out Bool()
        val wr_en = in Bool()
        val din = in Bits (WRITE_WIDTH bits)
        val empty = out Bool()
        val dout = out Bits (READ_WIDTH bits)
        val rd_en = in Bool()
        val wr_data_count = out Bits (WR_DATA_COUNT_WIDTH bits)
        val rd_data_count = out Bits (RD_DATA_COUNT_WIDTH bits)
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
    val temp = xpm_fifo_sync(DOUT_RESET_VALUE, ECC_MODE, FIFO_MEMORY_TYPE, FIFO_READ_LATENCY, FIFO_WRITE_DEPTH, FULL_RESET_VALUE, PROG_EMPTY_THRESH
        , PROG_FULL_THRESH, RD_DATA_COUNT_WIDTH, READ_DATA_WIDTH, READ_MODE_A, SIM_ASSERT_CHK, USE_ADV_FEATURES, WAKEUP_TIME, WRITE_DATA_WIDTH, WR_DATA_COUNT_WIDTH)(
        almost_empty, almost_full, io.data_valid, dbiterr, io.dout, io.empty, io.full, overflow, prog_empty, prog_full, io.rd_data_count,
        io.rd_rst_busy, sbiterr, underflow, wr_ack, io.wr_data_count, io.wr_rst_busy, io.din, injectdbiterr, injectsbiterr, io.rd_en, sleep, io.wr_en)
}


object fifo_sync {
    def main(args: Array[String]): Unit = {
        SpinalConfig(targetDirectory = "verilog/xfifo").generateVerilog( new fifo_sync(12, 1024, 3,0,"block","fwft"))
    }
}
