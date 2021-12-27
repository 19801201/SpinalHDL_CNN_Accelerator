package xmemory

import spinal.core._

class xpm_memory_tdpram(
                           ADDR_WIDTH_A: Int = 6, // DECIMAL
                           ADDR_WIDTH_B: Int = 6, // DECIMAL
                           AUTO_SLEEP_TIME: Int = 0, // DECIMAL
                           BYTE_WRITE_WIDTH_A: Int = 32, // DECIMAL
                           BYTE_WRITE_WIDTH_B: Int = 32, // DECIMAL
                           CASCADE_HEIGHT: Int = 0, // DECIMAL
                           CLOCKING_MODE: String = "common_clock", // String
                           ECC_MODE: String = "no_ecc", // String
                           MEMORY_INIT_FILE: String = "none", // String
                           MEMORY_INIT_PARAM: String = "0", // String
                           MEMORY_OPTIMIZATION: String = "true", // String
                           MEMORY_PRIMITIVE: String = "auto", // String
                           MEMORY_SIZE: Int = 2048, // DECIMAL
                           MESSAGE_CONTROL: Int = 0, // DECIMAL
                           READ_DATA_WIDTH_A: Int = 32, // DECIMAL
                           READ_DATA_WIDTH_B: Int = 32, // DECIMAL
                           READ_LATENCY_A: Int = 2, // DECIMAL
                           READ_LATENCY_B: Int = 2, // DECIMAL
                           READ_RESET_VALUE_A: String = "0", // String
                           READ_RESET_VALUE_B: String = "0", // String
                           RST_MODE_A: String = "SYNC", // String
                           RST_MODE_B: String = "SYNC", // String
                           SIM_ASSERT_CHK: Int = 0, // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
                           USE_EMBEDDED_CONSTRAINT: Int = 0, // DECIMAL
                           USE_MEM_INIT: Int = 1, // DECIMAL
                           WAKEUP_TIME: String = "disable_sleep", // String
                           WRITE_DATA_WIDTH_A: Int = 32, // DECIMAL
                           WRITE_DATA_WIDTH_B: Int = 32, // DECIMAL
                           WRITE_MODE_A: String = "no_change", // String
                           WRITE_MODE_B: String = "no_change", // String
                           clka: ClockDomain,
                           clkb: ClockDomain
                       ) extends BlackBox {
    addGeneric("ADDR_WIDTH_A", ADDR_WIDTH_A)
    addGeneric("ADDR_WIDTH_B", ADDR_WIDTH_B)
    addGeneric("AUTO_SLEEP_TIME", AUTO_SLEEP_TIME)
    addGeneric("BYTE_WRITE_WIDTH_A", BYTE_WRITE_WIDTH_A)
    addGeneric("BYTE_WRITE_WIDTH_B", BYTE_WRITE_WIDTH_B)
    addGeneric("CASCADE_HEIGHT", CASCADE_HEIGHT)
    addGeneric("CLOCKING_MODE", CLOCKING_MODE)
    addGeneric("ECC_MODE", ECC_MODE)
    addGeneric("MEMORY_INIT_FILE", MEMORY_INIT_FILE)
    addGeneric("MEMORY_INIT_PARAM", MEMORY_INIT_PARAM)
    addGeneric("MEMORY_OPTIMIZATION", MEMORY_OPTIMIZATION)
    addGeneric("MEMORY_PRIMITIVE", MEMORY_PRIMITIVE)
    addGeneric("MEMORY_SIZE", MEMORY_SIZE)
    addGeneric("MESSAGE_CONTROL", MESSAGE_CONTROL)
    addGeneric("READ_DATA_WIDTH_A", READ_DATA_WIDTH_A)
    addGeneric("READ_DATA_WIDTH_B", READ_DATA_WIDTH_B)
    addGeneric("READ_LATENCY_A", READ_LATENCY_A)
    addGeneric("READ_LATENCY_B", READ_LATENCY_B)
    addGeneric("READ_RESET_VALUE_A", READ_RESET_VALUE_A)
    addGeneric("READ_RESET_VALUE_B", READ_RESET_VALUE_B)
    addGeneric("RST_MODE_A", RST_MODE_A)
    addGeneric("RST_MODE_B", RST_MODE_B)
    addGeneric("SIM_ASSERT_CHK", SIM_ASSERT_CHK)
    addGeneric("USE_EMBEDDED_CONSTRAINT", USE_EMBEDDED_CONSTRAINT)
    addGeneric("USE_MEM_INIT", USE_MEM_INIT)
    addGeneric("WAKEUP_TIME", WAKEUP_TIME)
    addGeneric("WRITE_DATA_WIDTH_A", WRITE_DATA_WIDTH_A)
    addGeneric("WRITE_DATA_WIDTH_B", WRITE_DATA_WIDTH_B)
    addGeneric("WRITE_MODE_A", WRITE_MODE_A)
    addGeneric("WRITE_MODE_B", WRITE_MODE_B)
    val io = new Bundle {
        val dbiterra = out Bool()
        val dbiterrb = out Bool()
        val douta = out Bits (READ_DATA_WIDTH_A bits)
        val doutb = out Bits (READ_DATA_WIDTH_B bits)
        val sbiterra = out Bool()
        val sbiterrb = out Bool()
        val addra = in Bits (ADDR_WIDTH_A bits)
        val addrb = in Bits (ADDR_WIDTH_B bits)
        val clka = in Bool()
        val clkb = in Bool()
        val dina = in Bits (WRITE_DATA_WIDTH_A bits)
        val dinb = in Bits (WRITE_DATA_WIDTH_B bits)
        val ena = in Bool()
        val enb = in Bool()
        val injectdbiterra = in Bool()
        val injectdbiterrb = in Bool()
        val injectsbiterra = in Bool()
        val injectsbiterrb = in Bool()
        val regcea = in Bool()
        val regceb = in Bool()
        val rsta = in Bool()
        val rstb = in Bool()
        val sleep = in Bool()
        val wea = in Bits (WRITE_DATA_WIDTH_A / BYTE_WRITE_WIDTH_A bits)
        val web = in Bits (WRITE_DATA_WIDTH_B / BYTE_WRITE_WIDTH_B bits)
    }
    mapClockDomain(clka, io.clka)
    mapClockDomain(clkb, io.clkb)
    noIoPrefix()
}

object xpm_memory_tdpram {
    def apply(
                 ADDR_WIDTH_A: Int = 6, // DECIMAL
                 ADDR_WIDTH_B: Int = 6, // DECIMAL
                 AUTO_SLEEP_TIME: Int = 0, // DECIMAL
                 BYTE_WRITE_WIDTH_A: Int = 32, // DECIMAL
                 BYTE_WRITE_WIDTH_B: Int = 32, // DECIMAL
                 CASCADE_HEIGHT: Int = 0, // DECIMAL
                 CLOCKING_MODE: String = "common_clock", // String
                 ECC_MODE: String = "no_ecc", // String
                 MEMORY_INIT_FILE: String = "none", // String
                 MEMORY_INIT_PARAM: String = "0", // String
                 MEMORY_OPTIMIZATION: String = "true", // String
                 MEMORY_PRIMITIVE: String = "auto", // String
                 MEMORY_SIZE: Int = 2048, // DECIMAL
                 MESSAGE_CONTROL: Int = 0, // DECIMAL
                 READ_DATA_WIDTH_A: Int = 32, // DECIMAL
                 READ_DATA_WIDTH_B: Int = 32, // DECIMAL
                 READ_LATENCY_A: Int = 2, // DECIMAL
                 READ_LATENCY_B: Int = 2, // DECIMAL
                 READ_RESET_VALUE_A: String = "0", // String
                 READ_RESET_VALUE_B: String = "0", // String
                 RST_MODE_A: String = "SYNC", // String
                 RST_MODE_B: String = "SYNC", // String
                 SIM_ASSERT_CHK: Int = 0, // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
                 USE_EMBEDDED_CONSTRAINT: Int = 0, // DECIMAL
                 USE_MEM_INIT: Int = 1, // DECIMAL
                 WAKEUP_TIME: String = "disable_sleep", // String
                 WRITE_DATA_WIDTH_A: Int = 32, // DECIMAL
                 WRITE_DATA_WIDTH_B: Int = 32, // DECIMAL
                 WRITE_MODE_A: String = "no_change", // String
                 WRITE_MODE_B: String = "no_change", // String
                 clka: ClockDomain,
                 clkb: ClockDomain
             )(dbiterra: Bool, dbiterrb: Bool, douta: Bits, doutb: Bits, sbiterra: Bool, sbiterrb: Bool, addra: Bits, addrb: Bits, dina: Bits, dinb: Bits, ena: Bool, enb: Bool
               , injectdbiterra: Bool, injectdbiterrb: Bool, injectsbiterra: Bool, injectsbiterrb: Bool, regcea: Bool, regceb: Bool, rsta: Bool, rstb: Bool, sleep: Bool,
               wea: Bits, web: Bits): xpm_memory_tdpram = {
        val temp = new xpm_memory_tdpram(ADDR_WIDTH_A, ADDR_WIDTH_B, AUTO_SLEEP_TIME, BYTE_WRITE_WIDTH_A, BYTE_WRITE_WIDTH_B, CASCADE_HEIGHT, CLOCKING_MODE, ECC_MODE, MEMORY_INIT_FILE,
            MEMORY_INIT_PARAM, MEMORY_OPTIMIZATION, MEMORY_PRIMITIVE, MEMORY_SIZE, MESSAGE_CONTROL, READ_DATA_WIDTH_A, READ_DATA_WIDTH_B, READ_LATENCY_A,
            READ_LATENCY_B, READ_RESET_VALUE_A, READ_RESET_VALUE_B, RST_MODE_A, RST_MODE_B, SIM_ASSERT_CHK, USE_EMBEDDED_CONSTRAINT,
            USE_MEM_INIT, WAKEUP_TIME, WRITE_DATA_WIDTH_A, WRITE_DATA_WIDTH_B, WRITE_MODE_A, WRITE_MODE_B, clka, clkb)


        temp.io.dbiterra <> dbiterra
        temp.io.dbiterrb <> dbiterrb
        temp.io.douta <> douta
        temp.io.doutb <> doutb
        temp.io.sbiterra <> sbiterra
        temp.io.sbiterrb <> sbiterrb
        temp.io.addra <> addra
        temp.io.addrb <> addrb
        temp.io.dina <> dina
        temp.io.dinb <> dinb
        temp.io.ena <> ena
        temp.io.enb <> enb
        temp.io.injectdbiterra <> injectdbiterra
        temp.io.injectdbiterrb <> injectdbiterrb
        temp.io.injectsbiterra <> injectsbiterra
        temp.io.injectsbiterrb <> injectsbiterrb
        temp.io.regcea <> regcea
        temp.io.regceb <> regceb
        temp.io.rsta <> rsta
        temp.io.rstb <> rstb
        temp.io.sleep <> sleep
        temp.io.wea <> wea
        temp.io.web <> web
        temp
    }
}

class tdpram(
                WIDTH_A: Int,
                DEPTH_A: Int,
                WIDTH_B: Int,
                DEPTH_B: Int,
                MEMORY_TYPE: String = "block",
                READ_LATENCY_A: Int = 2,
                READ_LATENCY_B: Int = 2,
                CLOCK_MODE: String = "common_clock"
            ) extends Component {
    private val size_a = WIDTH_A * DEPTH_A

    private val size_b = WIDTH_B * DEPTH_B
    private val msg = "DEPTH_A*WIDTH_A,DEPTH_B*WIDTH_B两者的乘积应相等"

    assert(size_a == size_b, msg)
    assert(MEMORY_TYPE == "auto" || MEMORY_TYPE == "block" || MEMORY_TYPE == "distributed" || MEMORY_TYPE == "ultra", "MEMORY_TYPE应为auto，block，distributed，ultra中的一种")
    if (MEMORY_TYPE == "block") {
        assert(READ_LATENCY_A >= 1, "使用BRAM时,READ_LATENCY_A至少为1")
        assert(READ_LATENCY_B >= 1, "使用BRAM时,READ_LATENCY_B至少为1")

    }
    assert(CLOCK_MODE == "common_clock" || CLOCK_MODE == "independent_clock", "CLOCK_MODE应为common_clock或independent_clock")
    val ADDR_WIDTH_A: Int = log2Up(DEPTH_A); // DECIMAL
    val ADDR_WIDTH_B: Int = log2Up(DEPTH_B); // DECIMAL
    val AUTO_SLEEP_TIME: Int = 0; // DECIMAL
    val BYTE_WRITE_WIDTH_A: Int = WIDTH_A; // DECIMAL
    val BYTE_WRITE_WIDTH_B: Int = WIDTH_B; // DECIMAL
    val CASCADE_HEIGHT: Int = 0; // DECIMAL
    val CLOCKING_MODE: String = CLOCK_MODE; // String
    val ECC_MODE: String = "no_ecc"; // String
    val MEMORY_INIT_FILE: String = "none"; // String
    val MEMORY_INIT_PARAM: String = "0"; // String
    val MEMORY_OPTIMIZATION: String = "true"; // String
    val MEMORY_PRIMITIVE: String = MEMORY_TYPE; // String
    val MEMORY_SIZE: Int = size_a; // DECIMAL
    val MESSAGE_CONTROL: Int = 0; // DECIMAL
    val READ_DATA_WIDTH_A: Int = WIDTH_A; // DECIMAL
    val READ_DATA_WIDTH_B: Int = WIDTH_B; // DECIMAL
    val LATENCY_A: Int = READ_LATENCY_A; // DECIMAL
    val LATENCY_B: Int = READ_LATENCY_B; // DECIMAL
    val READ_RESET_VALUE_A: String = "0"; // String
    val READ_RESET_VALUE_B: String = "0"; // String
    val RST_MODE_A: String = "SYNC"; // String
    val RST_MODE_B: String = "SYNC"; // String
    val SIM_ASSERT_CHK: Int = 0; // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
    val USE_EMBEDDED_CONSTRAINT: Int = 0; // DECIMAL
    val USE_MEM_INIT: Int = 1; // DECIMAL
    val WAKEUP_TIME: String = "disable_sleep"; // String
    val WRITE_DATA_WIDTH_A: Int = WIDTH_A; // DECIMAL
    val WRITE_DATA_WIDTH_B: Int = WIDTH_B; // DECIMAL
    val WRITE_MODE_A: String = "read_first"; // String
    val WRITE_MODE_B: String = "read_first"; // String


    val io = new Bundle {
        val addra = in Bits (log2Up(DEPTH_A )bits)
        val clka = in Bool()
        val dina = in Bits (WIDTH_A bits)
        val douta = out Bits (WIDTH_A bits)
        val ena = in Bool()
        val wea = in Bits (WRITE_DATA_WIDTH_A / BYTE_WRITE_WIDTH_A bits)
        val addrb = in Bits (log2Up(DEPTH_B)bits)
        val clkb = in Bool()
        val dinb = in Bits (WIDTH_B bits)
        val doutb = out Bits (WIDTH_B bits)
        val enb = in Bool()
        val web = in Bits (WRITE_DATA_WIDTH_B / BYTE_WRITE_WIDTH_B bits)

    }
    noIoPrefix()
    val clka = ClockDomain(
        clock = io.clka,
        config = ClockDomainConfig(
            clockEdge = RISING
        )
    )
    val clkb = ClockDomain(
        clock = io.clkb,
        config = ClockDomainConfig(
            clockEdge = RISING
        )
    )
    val dbiterra = Bool()
    val dbiterrb = Bool()
    val sbiterra = Bool()
    val sbiterrb= Bool()
    val injectdbiterra = Bool()
    injectdbiterra := False
    val injectdbiterrb = Bool()
    injectdbiterrb := False
    val injectsbiterra = Bool()
    injectsbiterra := False
    val injectsbiterrb = Bool()
    injectsbiterrb := False
    val regcea = Bool()
    regcea := True
    val regceb = Bool()
    regceb := True
    val rsta = Bool()
    rsta := False
    val rstb = Bool()
    rstb := False
    val sleep = Bool()
    sleep := False
    val temp = xpm_memory_tdpram(ADDR_WIDTH_A, ADDR_WIDTH_B, AUTO_SLEEP_TIME, BYTE_WRITE_WIDTH_A, BYTE_WRITE_WIDTH_B, CASCADE_HEIGHT, CLOCKING_MODE, ECC_MODE, MEMORY_INIT_FILE,
        MEMORY_INIT_PARAM, MEMORY_OPTIMIZATION, MEMORY_PRIMITIVE, MEMORY_SIZE, MESSAGE_CONTROL, READ_DATA_WIDTH_A, READ_DATA_WIDTH_B, LATENCY_A,
        LATENCY_B, READ_RESET_VALUE_A, READ_RESET_VALUE_B, RST_MODE_A, RST_MODE_B, SIM_ASSERT_CHK, USE_EMBEDDED_CONSTRAINT,
        USE_MEM_INIT, WAKEUP_TIME, WRITE_DATA_WIDTH_A, WRITE_DATA_WIDTH_B, WRITE_MODE_A, WRITE_MODE_B, clka, clkb)(dbiterra, dbiterrb, io.douta,
        io.doutb, sbiterra, sbiterrb, io.addra, io.addrb, io.dina, io.dinb, io.ena, io.enb, injectdbiterra, injectdbiterrb, injectsbiterra,
        injectsbiterrb, regcea, regceb, rsta, rstb, sleep, io.wea, io.web)
}

object tdpram {
    def main(args: Array[String]): Unit = {
        SpinalConfig(targetDirectory = "verilog").generateVerilog(new tdpram(32,512,16,1024,"block",2,2))
    }
}
