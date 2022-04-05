package wa.xip.memory.xpm

import spinal.core._

class xpm_memory_sprom (
                           ADDR_WIDTH_A: Int = 6, // DECIMAL
                           AUTO_SLEEP_TIME: Int = 0, // DECIMAL
                           CASCADE_HEIGHT: Int = 0, // DECIMAL
                           ECC_MODE: String = "no_ecc", // String
                           MEMORY_INIT_FILE: String = "none", // String
                           MEMORY_INIT_PARAM: String = "", // String
                           MEMORY_OPTIMIZATION: String = "true", // String
                           MEMORY_PRIMITIVE: String = "auto", // String
                           MEMORY_SIZE: Int = 2048, // DECIMAL
                           MESSAGE_CONTROL: Int = 0, // DECIMAL
                           READ_DATA_WIDTH_A: Int = 32,
                           READ_LATENCY_A: Int = 2,
                           READ_RESET_VALUE_A: String = "0",
                           RST_MODE_A: String = "SYNC", // String
                           SIM_ASSERT_CHK: Int = 0, // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
                           USE_MEM_INIT: Int = 1, // DECIMAL
                           WAKEUP_TIME: String = "disable_sleep" // String
                       )extends BlackBox{
    addGeneric("ADDR_WIDTH_A", ADDR_WIDTH_A)
    addGeneric("AUTO_SLEEP_TIME", AUTO_SLEEP_TIME)
    addGeneric("CASCADE_HEIGHT", CASCADE_HEIGHT)
    addGeneric("ECC_MODE", ECC_MODE)
    addGeneric("MEMORY_INIT_FILE", MEMORY_INIT_FILE)
    addGeneric("MEMORY_INIT_PARAM", MEMORY_INIT_PARAM)
    addGeneric("MEMORY_OPTIMIZATION", MEMORY_OPTIMIZATION)
    addGeneric("MEMORY_PRIMITIVE", MEMORY_PRIMITIVE)
    addGeneric("MEMORY_SIZE", MEMORY_SIZE)
    addGeneric("MESSAGE_CONTROL", MESSAGE_CONTROL)
    addGeneric("READ_DATA_WIDTH_A", READ_DATA_WIDTH_A)
    addGeneric("READ_LATENCY_A", READ_LATENCY_A)
    addGeneric("READ_RESET_VALUE_A", READ_RESET_VALUE_A)
    addGeneric("RST_MODE_A", RST_MODE_A)
    addGeneric("SIM_ASSERT_CHK", SIM_ASSERT_CHK)
    addGeneric("USE_MEM_INIT", USE_MEM_INIT)
    addGeneric("WAKEUP_TIME", WAKEUP_TIME)
    val io = new Bundle {
        val dbiterra = out Bool()
        val douta = out Bits (READ_DATA_WIDTH_A bits)
        val sbiterra = out Bool()
        val addra = in UInt  (ADDR_WIDTH_A bits)
        val clka = in Bool()
        val ena = in Bool()
        val injectdbiterra = in Bool()
        val injectsbiterra = in Bool()
        val regcea = in Bool()
        val rsta = in Bool()
        val sleep = in Bool()
    }
    mapClockDomain(clock = io.clka)
    noIoPrefix()

}
object xpm_memory_sprom{
    def apply(
                 ADDR_WIDTH_A: Int = 6, // DECIMAL
                 AUTO_SLEEP_TIME: Int = 0, // DECIMAL
                 CASCADE_HEIGHT: Int = 0, // DECIMAL
                 ECC_MODE: String = "no_ecc", // String
                 MEMORY_INIT_FILE: String = "none", // String
                 MEMORY_INIT_PARAM: String = "", // String
                 MEMORY_OPTIMIZATION: String = "true", // String
                 MEMORY_PRIMITIVE: String = "auto", // String
                 MEMORY_SIZE: Int = 2048, // DECIMAL
                 MESSAGE_CONTROL: Int = 0, // DECIMAL
                 READ_DATA_WIDTH_A: Int = 32,
                 READ_LATENCY_A: Int = 2,
                 READ_RESET_VALUE_A: String = "0",
                 RST_MODE_A: String = "SYNC", // String
                 SIM_ASSERT_CHK: Int = 0, // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
                 USE_MEM_INIT: Int = 1, // DECIMAL
                 WAKEUP_TIME: String = "disable_sleep" // String
             )(dbiterra: Bool, douta: Bits, sbiterra: Bool, addra: UInt,  ena: Bool, injectdbiterra: Bool,
               injectsbiterra: Bool, regcea: Bool, rsta: Bool, sleep: Bool): xpm_memory_sprom ={
        val temp = new xpm_memory_sprom(ADDR_WIDTH_A, AUTO_SLEEP_TIME, CASCADE_HEIGHT, ECC_MODE, MEMORY_INIT_FILE,
            MEMORY_INIT_PARAM, MEMORY_OPTIMIZATION, MEMORY_PRIMITIVE, MEMORY_SIZE, MESSAGE_CONTROL, READ_DATA_WIDTH_A, READ_LATENCY_A, READ_RESET_VALUE_A,
            RST_MODE_A, SIM_ASSERT_CHK, USE_MEM_INIT, WAKEUP_TIME)
        temp.io.dbiterra <> dbiterra
        temp.io.douta <> douta
        temp.io.sbiterra <> sbiterra
        temp.io.addra <> addra
        temp.io.ena <> ena
        temp.io.injectdbiterra <> injectdbiterra
        temp.io.injectsbiterra <> injectsbiterra
        temp.io.regcea <> regcea
        temp.io.rsta <> rsta
        temp.io.sleep <> sleep
        temp

    }
}
class sprom(
               WIDTH: Int,
               DEPTH: Int,
               MEMORY_TYPE: String = "block",
               READ_LATENCY: Int = 2,
               MEMORY_FILE:String=""
           ) extends Component {
    assert(MEMORY_FILE != "","初始化文件路径不能为空")
    assert(MEMORY_TYPE == "auto" || MEMORY_TYPE == "block" || MEMORY_TYPE == "distributed" || MEMORY_TYPE == "ultra", "MEMORY_TYPE应为auto，block，distributed，ultra中的一种")
    if (MEMORY_TYPE == "block") {
        assert(READ_LATENCY >= 1, "使用BRAM时,READ_LATENCY至少为1")
    }

    val ADDR_WIDTH_A: Int = log2Up(DEPTH) // DECIMAL
    val AUTO_SLEEP_TIME: Int = 0 // DECIMAL
    val CASCADE_HEIGHT: Int = 0 // DECIMAL
    val ECC_MODE: String = "no_ecc" // String
    val MEMORY_INIT_FILE: String = MEMORY_FILE // String
    val MEMORY_INIT_PARAM: String = "" // String
    val MEMORY_OPTIMIZATION: String = "true" // String
    val MEMORY_PRIMITIVE: String = MEMORY_TYPE // String
    val MEMORY_SIZE: Int = WIDTH * DEPTH// DECIMAL
    val MESSAGE_CONTROL: Int = 0 // DECIMAL
    val READ_DATA_WIDTH_A: Int = WIDTH
    val READ_LATENCY_A: Int = READ_LATENCY
    val READ_RESET_VALUE_A: String = "0"
    val RST_MODE_A: String = "SYNC" // String
    val SIM_ASSERT_CHK: Int = 0 // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
    val USE_MEM_INIT: Int = 1 // DECIMAL
    val WAKEUP_TIME: String = "disable_sleep" // String

    val io = new Bundle{
        val addra = in UInt (log2Up(DEPTH )bits)
        val douta = out Bits(WIDTH bits)
        val ena = in Bool()
    }
    val dbiterra = Bool()
    val sbiterra = Bool()
    val injectdbiterra = Bool()
    injectdbiterra := False
    val injectsbiterra = Bool()
    injectsbiterra := False
    val regcea = Bool()
    regcea := True
    val rsta = Bool()
    rsta := False
    val sleep = Bool()
    sleep := False
    val temp = xpm_memory_sprom(ADDR_WIDTH_A,AUTO_SLEEP_TIME,CASCADE_HEIGHT,ECC_MODE,MEMORY_INIT_FILE,MEMORY_INIT_PARAM,
        MEMORY_OPTIMIZATION,MEMORY_PRIMITIVE,MEMORY_SIZE,MESSAGE_CONTROL,READ_DATA_WIDTH_A,READ_LATENCY_A,READ_RESET_VALUE_A
        ,RST_MODE_A,SIM_ASSERT_CHK,USE_MEM_INIT,WAKEUP_TIME)(dbiterra, io.douta, sbiterra, io.addra,  io.ena, injectdbiterra,
        injectsbiterra, regcea, rsta, sleep)
    noIoPrefix()
}
object sprom{
    def main(args: Array[String]): Unit = {
        SpinalConfig().generateVerilog(new sprom(64,2400,"distributed",0,"all_weight_new.mem"))
    }
}

