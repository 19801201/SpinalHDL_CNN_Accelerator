package xmemory

import spinal.core._
import spinal.lib._

class xpm_memory_sdpram(
                           ADDR_WIDTH_A: Int = 6, // DECIMAL
                           ADDR_WIDTH_B: Int = 6, // DECIMAL
                           AUTO_SLEEP_TIME: Int = 0, // DECIMAL
                           BYTE_WRITE_WIDTH_A: Int = 32, // DECIMAL
                           CASCADE_HEIGHT: Int = 0, // DECIMAL
                           CLOCKING_MODE: String = "common_clock", // String
                           ECC_MODE: String = "no_ecc", // String
                           MEMORY_INIT_FILE: String = "none", // String
                           MEMORY_INIT_PARAM: String = "0", // String
                           MEMORY_OPTIMIZATION: String = "true", // String
                           MEMORY_PRIMITIVE: String = "auto", // String
                           MEMORY_SIZE: Int = 2048, // DECIMAL
                           MESSAGE_CONTROL: Int = 0, // DECIMAL
                           READ_DATA_WIDTH_B: Int = 32, // DECIMAL
                           READ_LATENCY_B: Int = 2, // DECIMAL
                           READ_RESET_VALUE_B: String = "0", // String
                           RST_MODE_A: String = "SYNC", // String
                           RST_MODE_B: String = "SYNC", // String
                           SIM_ASSERT_CHK: Int = 0, // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
                           USE_EMBEDDED_CONSTRAINT: Int = 0, // DECIMAL
                           USE_MEM_INIT: Int = 1, // DECIMAL
                           WAKEUP_TIME: String = "disable_sleep", // String
                           WRITE_DATA_WIDTH_A: Int = 32, // DECIMAL
                           WRITE_MODE_B: String = "no_change", // String
                           clka: ClockDomain,
                           clkb: ClockDomain
                       ) extends BlackBox {
    addGeneric("ADDR_WIDTH_A", ADDR_WIDTH_A)
    addGeneric("ADDR_WIDTH_B", ADDR_WIDTH_B)
    addGeneric("AUTO_SLEEP_TIME", AUTO_SLEEP_TIME)
    addGeneric("BYTE_WRITE_WIDTH_A", BYTE_WRITE_WIDTH_A)
    addGeneric("CASCADE_HEIGHT", CASCADE_HEIGHT)
    addGeneric("CLOCKING_MODE", CLOCKING_MODE)
    addGeneric("ECC_MODE", ECC_MODE)
    addGeneric("MEMORY_INIT_FILE", MEMORY_INIT_FILE)
    addGeneric("MEMORY_INIT_PARAM", MEMORY_INIT_PARAM)
    addGeneric("MEMORY_OPTIMIZATION", MEMORY_OPTIMIZATION)
    addGeneric("MEMORY_PRIMITIVE", MEMORY_PRIMITIVE)
    addGeneric("MEMORY_SIZE", MEMORY_SIZE)
    addGeneric("MESSAGE_CONTROL", MESSAGE_CONTROL)
    addGeneric("READ_DATA_WIDTH_B", READ_DATA_WIDTH_B)
    addGeneric("READ_LATENCY_B", READ_LATENCY_B)
    addGeneric("READ_RESET_VALUE_B", READ_RESET_VALUE_B)
    addGeneric("RST_MODE_A", RST_MODE_A)
    addGeneric("RST_MODE_B", RST_MODE_B)
    addGeneric("SIM_ASSERT_CHK", SIM_ASSERT_CHK)
    addGeneric("USE_EMBEDDED_CONSTRAINT", USE_EMBEDDED_CONSTRAINT)
    addGeneric("USE_MEM_INIT", USE_MEM_INIT)
    addGeneric("WAKEUP_TIME", WAKEUP_TIME)
    addGeneric("WRITE_DATA_WIDTH_A", WRITE_DATA_WIDTH_A)
    addGeneric("WRITE_MODE_B", WRITE_MODE_B)
    val io = new Bundle {
        val dbiterrb = out Bool()
        val doutb = out Bits (READ_DATA_WIDTH_B bits)
        val sbiterrb = out Bool()
        val addra = in Bits (ADDR_WIDTH_A bits)
        val addrb = in Bits (ADDR_WIDTH_B bits)
        val clka = in Bool()
        val clkb = in Bool()
        val dina = in Bits (WRITE_DATA_WIDTH_A bits)
        val ena = in Bool()
        val enb = in Bool()
        val injectdbiterra = in Bool()
        val injectsbiterra = in Bool()
        val regceb = in Bool()
        val rstb = in Bool()
        val sleep = in Bool()
        val wea = in Bits (WRITE_DATA_WIDTH_A / BYTE_WRITE_WIDTH_A bits)
    }
    mapClockDomain(clka, io.clka)
    mapClockDomain(clkb, io.clkb)
    noIoPrefix()
}


object xpm_memory_sdpram {
    def apply(ADDR_WIDTH_A: Int = 6,
              ADDR_WIDTH_B: Int = 6,
              AUTO_SLEEP_TIME: Int = 0, // DECIMAL
              BYTE_WRITE_WIDTH_A: Int = 32, // DECIMAL
              CASCADE_HEIGHT: Int = 0, // DECIMAL
              CLOCKING_MODE: String = "common_clock", // String
              ECC_MODE: String = "no_ecc", // String
              MEMORY_INIT_FILE: String = "none", // String
              MEMORY_INIT_PARAM: String = "0", // String
              MEMORY_OPTIMIZATION: String = "true", // String
              MEMORY_PRIMITIVE: String = "auto", // String
              MEMORY_SIZE: Int = 2048, // DECIMAL
              MESSAGE_CONTROL: Int = 0, // DECIMAL
              READ_DATA_WIDTH_B: Int = 32, // DECIMAL
              READ_LATENCY_B: Int = 2, // DECIMAL
              READ_RESET_VALUE_B: String = "0", // String
              RST_MODE_A: String = "SYNC", // String
              RST_MODE_B: String = "SYNC", // String
              SIM_ASSERT_CHK: Int = 0, // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
              USE_EMBEDDED_CONSTRAINT: Int = 0, // DECIMAL
              USE_MEM_INIT: Int = 1, // DECIMAL
              WAKEUP_TIME: String = "disable_sleep", // String
              WRITE_DATA_WIDTH_A: Int = 32, // DECIMAL
              WRITE_MODE_B: String = "no_change", // String
              clka: ClockDomain,
              clkb: ClockDomain
             )(dbiterrb: Bool, doutb: Bits, sbiterrb: Bool, addra: Bits, addrb: Bits, dina: Bits, ena: Bool, enb: Bool, injectdbiterra: Bool,
               injectsbiterra: Bool, regceb: Bool, rstb: Bool, sleep: Bool, wea: Bits): xpm_memory_sdpram = {
        val temp = new xpm_memory_sdpram(ADDR_WIDTH_A, ADDR_WIDTH_B, AUTO_SLEEP_TIME, BYTE_WRITE_WIDTH_A, CASCADE_HEIGHT, CLOCKING_MODE, ECC_MODE, MEMORY_INIT_FILE,
            MEMORY_INIT_PARAM, MEMORY_OPTIMIZATION, MEMORY_PRIMITIVE, MEMORY_SIZE, MESSAGE_CONTROL, READ_DATA_WIDTH_B, READ_LATENCY_B, READ_RESET_VALUE_B,
            RST_MODE_A, RST_MODE_B, SIM_ASSERT_CHK, USE_EMBEDDED_CONSTRAINT, USE_MEM_INIT, WAKEUP_TIME, WRITE_DATA_WIDTH_A, WRITE_MODE_B, clka, clkb)
        temp.io.dbiterrb <> dbiterrb
        temp.io.doutb <> doutb
        temp.io.sbiterrb <> sbiterrb
        temp.io.addra <> addra
        temp.io.addrb <> addrb
        temp.io.dina <> dina
        temp.io.ena <> ena
        temp.io.enb <> enb
        temp.io.injectdbiterra <> injectdbiterra
        temp.io.injectsbiterra <> injectsbiterra
        temp.io.regceb <> regceb
        temp.io.rstb <> rstb
        temp.io.sleep <> sleep
        temp.io.wea <> wea


        temp

    }
}

class sdpram(
                WRITE_WIDTH: Int,
                WRITE_DEPTH: Int,
                READ_WIDTH: Int,
                READ_DEPTH:Int,
                MEMORY_TYPE: String = "block",
                READ_LATENCY: Int = 2,
                CLOCK_MODE:String="common_clock",
                clka:ClockDomain,
                clkb:ClockDomain
            ) extends Component {
    assert(WRITE_DEPTH*WRITE_WIDTH == READ_DEPTH*READ_WIDTH,"读写空间大小不匹配，WRITE_DEPTH*WRITE_WIDTH和READ_DEPTH*READ_WIDTH大小应相等")
    val ADDR_WIDTH_A: Int = log2Up(WRITE_DEPTH)
    val ADDR_WIDTH_B: Int = log2Up(READ_DEPTH)

    assert(MEMORY_TYPE == "auto" || MEMORY_TYPE == "block" || MEMORY_TYPE == "distributed" || MEMORY_TYPE == "ultra", "MEMORY_TYPE应为auto，block，distributed，ultra中的一种")
    if (MEMORY_TYPE == "block") {
        assert(READ_LATENCY >= 1, "使用BRAM时,READ_LATENCY至少为1")
    }
    assert(CLOCK_MODE=="common_clock"||CLOCK_MODE=="independent_clock","CLOCK_MODE应为common_clock或independent_clock")
    val AUTO_SLEEP_TIME: Int = 0 // DECIMAL
    val BYTE_WRITE_WIDTH_A: Int = WRITE_WIDTH // DECIMAL
    val CASCADE_HEIGHT: Int = 0 // DECIMAL
    val CLOCKING_MODE: String = CLOCK_MODE // String
    val ECC_MODE: String = "no_ecc" // String
    val MEMORY_INIT_FILE: String = "none" // String
    val MEMORY_INIT_PARAM: String = "0" // String
    val MEMORY_OPTIMIZATION: String = "true" // String
    val MEMORY_PRIMITIVE: String = MEMORY_TYPE // String
    val MEMORY_SIZE: Int =  WRITE_DEPTH*WRITE_WIDTH// DECIMAL
    val MESSAGE_CONTROL: Int = 0 // DECIMAL
    val READ_DATA_WIDTH_B: Int = READ_WIDTH // DECIMAL
    val READ_LATENCY_B: Int = READ_LATENCY // DECIMAL
    val READ_RESET_VALUE_B: String = "0" // String
    val RST_MODE_A: String = "SYNC" // String
    val RST_MODE_B: String = "SYNC" // String
    val SIM_ASSERT_CHK: Int = 0 // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
    val USE_EMBEDDED_CONSTRAINT: Int = 0 // DECIMAL
    val USE_MEM_INIT: Int = 1 // DECIMAL
    val WAKEUP_TIME: String = "disable_sleep" // String
    val WRITE_DATA_WIDTH_A: Int = WRITE_WIDTH // DECIMAL
    val WRITE_MODE_B: String = "read_first" // String


    val dbiterrb = Bool()
    val sbiterrb = Bool()
    val injectdbiterra = Bool()
    injectdbiterra := False
    val injectsbiterra = Bool()
    injectsbiterra := False
    val regceb = Bool()
    regceb := True
    val rstb = Bool()
    rstb := False
    val sleep = Bool()
    sleep := False
    val io = new Bundle {

        val doutb = out Bits (READ_WIDTH bits)
        val addra = in Bits (log2Up(WRITE_DEPTH) bits)
        val addrb = in Bits (log2Up(READ_DEPTH) bits)
        val dina = in Bits (WRITE_WIDTH bits)
        val ena = in Bool()
        val enb = in Bool()
        val wea = in Bits (WRITE_DATA_WIDTH_A / BYTE_WRITE_WIDTH_A bits)
//        val clka = in Bool()
//        val clkb = in Bool()

    }
//    val clka = ClockDomain(
//        clock = io.clka,
//        config = ClockDomainConfig(
//            clockEdge = RISING
//        )
//    )
//    val clkb = ClockDomain(
//        clock = io.clkb,
//        config = ClockDomainConfig(
//            clockEdge = RISING
//        )
//    )
//    clka.clock.setName("clka")
//    clkb.clock.setName("clkb")
    val temp = xpm_memory_sdpram(ADDR_WIDTH_A, ADDR_WIDTH_B, AUTO_SLEEP_TIME, BYTE_WRITE_WIDTH_A, CASCADE_HEIGHT, CLOCKING_MODE, ECC_MODE, MEMORY_INIT_FILE,
        MEMORY_INIT_PARAM, MEMORY_OPTIMIZATION, MEMORY_PRIMITIVE, MEMORY_SIZE, MESSAGE_CONTROL, READ_DATA_WIDTH_B, READ_LATENCY_B, READ_RESET_VALUE_B,
        RST_MODE_A, RST_MODE_B, SIM_ASSERT_CHK, USE_EMBEDDED_CONSTRAINT, USE_MEM_INIT, WAKEUP_TIME, WRITE_DATA_WIDTH_A, WRITE_MODE_B, clka, clkb)(dbiterrb, io.doutb, sbiterrb, io.addra, io.addrb, io.dina, io.ena, io.enb, injectdbiterra, injectsbiterra,
        regceb, rstb, sleep, io.wea)

    noIoPrefix()
}

object sdpram {
    def main(args: Array[String]): Unit = {
        SpinalConfig(targetDirectory = "verilog").generateVerilog(new sdpram(64,409600,64,409600,"distributed",0,"common_clock",new ClockDomain(new Bool()),new ClockDomain(new Bool)))
    }
}
