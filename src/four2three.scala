import spinal.core._
import spinal.lib._
import spinal.lib.fsm._
import xmemory.sdpram

class four2three(
                    S_DATA_WIDTH: Int,
                    M_DATA_WIDTH: Int,
                    CHANNEL_NUM_WIDTH: Int,
                    ROW_COL_DATA_COUNT_WIDTH: Int,
                    MEMORY_DEPTH: Int
                ) extends Component {
    val io = new Bundle {
        val Start = in Bool()
        val StartRow = out Bool() setAsReg() init False
        val Row_Num_After_Padding = in UInt (ROW_COL_DATA_COUNT_WIDTH bits)
        val S_DATA = slave Stream Bits(S_DATA_WIDTH bits)
        val M_DATA = out Bits (M_DATA_WIDTH bits) setAsReg() init 0
        val M_Ready = in Bool()
        val M_Valid = out Bool() setAsReg() init False
        val M_rd_en = in Bool()
        val M_Addr = in UInt (ROW_COL_DATA_COUNT_WIDTH bits)
        val Channel_In_Num_REG = in Bits (CHANNEL_NUM_WIDTH bits)
    }
    noIoPrefix()
    val Channel_Times = io.Channel_In_Num_REG.asUInt >> 3
    val count_mult = new mul(ROW_COL_DATA_COUNT_WIDTH, Channel_Times.getWidth, ROW_COL_DATA_COUNT_WIDTH, false)
    count_mult.io.A := io.Row_Num_After_Padding.asBits
    count_mult.io.B := Channel_Times.asBits


    val fifo = new general_fifo_sync(S_DATA_WIDTH, S_DATA_WIDTH, MEMORY_DEPTH, ROW_COL_DATA_COUNT_WIDTH)
    fifo.io.data_in <> io.S_DATA.payload
    fifo.io.wr_en <> io.S_DATA.valid
    fifo.io.data_in_ready <> io.S_DATA.ready
    fifo.io.m_data_count <> count_mult.io.P.asUInt
    fifo.io.s_data_count <> count_mult.io.P.asUInt

    val ram1 = new sdpram(S_DATA_WIDTH, MEMORY_DEPTH, S_DATA_WIDTH, MEMORY_DEPTH, "distributed", 0, clka = this.clockDomain, clkb = this.clockDomain)
    val ram2 = new sdpram(S_DATA_WIDTH, MEMORY_DEPTH, S_DATA_WIDTH, MEMORY_DEPTH, "distributed", 0, clka = this.clockDomain, clkb = this.clockDomain)
    val ram3 = new sdpram(S_DATA_WIDTH, MEMORY_DEPTH, S_DATA_WIDTH, MEMORY_DEPTH, "distributed", 0, clka = this.clockDomain, clkb = this.clockDomain)
    val ram4 = new sdpram(S_DATA_WIDTH, MEMORY_DEPTH, S_DATA_WIDTH, MEMORY_DEPTH, "distributed", 0, clka = this.clockDomain, clkb = this.clockDomain)
    ram1.io.addrb <> io.M_Addr.asBits.resized
    ram2.io.addrb <> io.M_Addr.asBits.resized
    ram3.io.addrb <> io.M_Addr.asBits.resized
    ram4.io.addrb <> io.M_Addr.asBits.resized

    val f2t_fsm = new StateMachine {
        val IDLE = new State() with EntryPoint
        val INIT = new State()
        val Judge_Fifo = new State()
        val Read = new State()
        val Judge_Compute = new State()
        val Start_Compute = new State()


        val wait_cnt = UInt(6 bits) setAsReg()
        when(isActive(INIT)) {
            wait_cnt := wait_cnt + 1
        } otherwise {
            wait_cnt := 0
        }
        val init_en = Bool()
        when(wait_cnt === 5) {
            init_en := True
        } otherwise {
            init_en := False
        }

        val Cnt_Cin = UInt(CHANNEL_NUM_WIDTH bits) setAsReg()
        val EN_Last_Cin = Bool()
        when(Cnt_Cin === Channel_Times - 1) {
            EN_Last_Cin := True
        } otherwise {
            EN_Last_Cin := False
        }
        when(isActive(Read)) {
            when(EN_Last_Cin) {
                Cnt_Cin := 0
            } otherwise {
                Cnt_Cin := Cnt_Cin + 1
            }
        } otherwise {
            Cnt_Cin := 0
        }

        val Cnt_Column = UInt(ROW_COL_DATA_COUNT_WIDTH bits) setAsReg()
        val EN_Read_State = Bool()
        when(Cnt_Column === io.Row_Num_After_Padding - 1) {
            EN_Read_State := True
        } otherwise {
            EN_Read_State := False
        }
        when(isActive(Read)) {
            when(EN_Last_Cin) {
                Cnt_Column := Cnt_Column + 1
            } otherwise {
                Cnt_Column := Cnt_Column
            }
        } otherwise {
            Cnt_Column := 0
        }
        val Cnt_ROW = UInt(ROW_COL_DATA_COUNT_WIDTH bits) setAsReg() init 0
        when(isEntering(Start_Compute)) {
            Cnt_ROW := Cnt_ROW + 1
        } elsewhen isActive(IDLE) {
            Cnt_ROW := 0
        } otherwise (Cnt_ROW := Cnt_ROW)
        val Last_Row = Bool()
        when(Cnt_ROW === io.Row_Num_After_Padding - 2) {
            Last_Row := True
        } otherwise (Last_Row := False)

        val Cnt_Ram = UInt(2 bits) setAsReg() init 0
        when(isEntering(Judge_Compute)) {
            Cnt_Ram := Cnt_Ram + 1
        } elsewhen isEntering(Start_Compute) {
            Cnt_Ram := Cnt_Ram - 1
        } otherwise (Cnt_Ram := Cnt_Ram)

        val En_Ram = UInt(2 bits) setAsReg() init 0
        when(isEntering(Judge_Compute)) {
            En_Ram := En_Ram + 1
        } otherwise (En_Ram := En_Ram)
        switch(En_Ram) {
            is(0) {
                ram1.io.ena := True
                ram2.io.ena := False
                ram3.io.ena := False
                ram4.io.ena := False
            }
            is(1) {
                ram1.io.ena := False
                ram2.io.ena := True
                ram3.io.ena := False
                ram4.io.ena := False
            }
            is(2) {
                ram1.io.ena := False
                ram2.io.ena := False
                ram3.io.ena := True
                ram4.io.ena := False
            }
            is(3) {
                ram1.io.ena := False
                ram2.io.ena := False
                ram3.io.ena := False
                ram4.io.ena := True
            }
        }
        val addrRam1 = UInt(ROW_COL_DATA_COUNT_WIDTH bits) setAsReg() init 0
        val addrRam2 = UInt(ROW_COL_DATA_COUNT_WIDTH bits) setAsReg() init 0
        val addrRam3 = UInt(ROW_COL_DATA_COUNT_WIDTH bits) setAsReg() init 0
        val addrRam4 = UInt(ROW_COL_DATA_COUNT_WIDTH bits) setAsReg() init 0
        ram1.io.addra := ram2addra(addrRam1).asBits.resized
        ram1.io.dina := fifo.io.data_out
        ram2.io.addra := ram2addra(addrRam2).asBits.resized
        ram2.io.dina := fifo.io.data_out
        ram3.io.addra := ram2addra(addrRam3).asBits.resized
        ram3.io.dina := fifo.io.data_out
        ram4.io.addra := ram2addra(addrRam4).asBits.resized
        ram4.io.dina := fifo.io.data_out
        when(isActive(Read)) {
            fifo.io.rd_en := True
            switch(En_Ram) {
                is(0) {
                    ram1.io.wea := True.asBits
                    ram2.io.wea := False.asBits
                    ram3.io.wea := False.asBits
                    ram4.io.wea := False.asBits
                }
                is(1) {
                    ram1.io.wea := False.asBits
                    ram2.io.wea := True.asBits
                    ram3.io.wea := False.asBits
                    ram4.io.wea := False.asBits
                }
                is(2) {
                    ram1.io.wea := False.asBits
                    ram2.io.wea := False.asBits
                    ram3.io.wea := True.asBits
                    ram4.io.wea := False.asBits
                }
                is(3) {
                    ram1.io.wea := False.asBits
                    ram2.io.wea := False.asBits
                    ram3.io.wea := False.asBits
                    ram4.io.wea := True.asBits
                }
            }
        } otherwise {
            ram1.io.wea := False.asBits
            ram2.io.wea := False.asBits
            ram3.io.wea := False.asBits
            ram4.io.wea := False.asBits
            fifo.io.rd_en := False
        }
        when(isEntering(Start_Compute)) {
            io.StartRow := True
        } otherwise {
            io.StartRow := False
        }
        val rd_ram_cnt = UInt(3 bits) setAsReg() init (0)
        when(rd_ram_cnt === 4 && io.M_Addr === (io.Row_Num_After_Padding * Channel_Times) - 1) {
            rd_ram_cnt := 0
        } elsewhen (isEntering(Start_Compute)) {
            rd_ram_cnt := rd_ram_cnt + 1
        } otherwise (
            rd_ram_cnt := rd_ram_cnt
            )


        switch(rd_ram_cnt) {
            is(1) {
                ram1.io.enb := io.M_rd_en
                ram2.io.enb := io.M_rd_en
                ram3.io.enb := io.M_rd_en
                ram4.io.enb := False
            }
            is(2) {
                ram1.io.enb := False
                ram2.io.enb := io.M_rd_en
                ram3.io.enb := io.M_rd_en
                ram4.io.enb := io.M_rd_en
            }
            is(3) {
                ram1.io.enb := io.M_rd_en
                ram2.io.enb := False
                ram3.io.enb := io.M_rd_en
                ram4.io.enb := io.M_rd_en
            }
            is(4) {
                ram1.io.enb := io.M_rd_en
                ram2.io.enb := io.M_rd_en
                ram3.io.enb := False
                ram4.io.enb := io.M_rd_en
            }
            default {
                ram1.io.enb := False
                ram2.io.enb := False
                ram3.io.enb := False
                ram4.io.enb := False
            }
        }
        when(io.M_rd_en) {
            io.M_Valid := True
            switch(rd_ram_cnt) {
                is(1) {
                    io.M_DATA := ram3.io.doutb ## ram2.io.doutb ## ram1.io.doutb
                }
                is(2) {
                    io.M_DATA := ram4.io.doutb ## ram3.io.doutb ## ram2.io.doutb
                }
                is(3) {
                    io.M_DATA := ram1.io.doutb ## ram4.io.doutb ## ram3.io.doutb
                }
                is(4) {
                    io.M_DATA := ram2.io.doutb ## ram1.io.doutb ## ram4.io.doutb
                }
                default {
                    io.M_DATA := 0
                }
            }
        } otherwise {
            io.M_Valid := False
            io.M_DATA := 0
        }
        IDLE
            .whenIsActive {
                when(io.Start) {
                    goto(INIT)
                } otherwise goto(IDLE)
            }
        INIT
            .whenIsActive {
                when(init_en) {
                    goto(Judge_Fifo)
                } otherwise goto(INIT)
            }
        Judge_Fifo
            .whenIsActive {
                when(fifo.io.data_out_valid) {
                    goto(Read)
                } otherwise goto(Judge_Fifo)
            }
        Read
            .whenIsActive {
                when(EN_Read_State && EN_Last_Cin) {
                    goto(Judge_Compute)
                } otherwise goto(Read)
            }
        Judge_Compute
            .whenIsActive {
                when(Cnt_Ram === 3) {
                    when(io.M_Ready) {
                        goto(Start_Compute)
                    } otherwise goto(Judge_Compute)

                } otherwise goto(Judge_Fifo)
            }
        Start_Compute
            .whenIsActive {
                when(Last_Row) {
                    when(io.M_Addr === io.Row_Num_After_Padding * Channel_Times - 1) {
                        goto(IDLE)
                    } otherwise goto(Start_Compute)

                } otherwise {
                    goto(Judge_Fifo)
                }
            }

        def ram2addra(addr: UInt): UInt = {
            when(isActive(Read)) {
                addr := addr + 1
            } otherwise {
                addr := 0
            }
            addr
        }

    }
}

object four2three {
    def main(args: Array[String]): Unit = {
        SpinalVerilog(new four2three(64, 64, 10, 12, 2048))
    }
}
