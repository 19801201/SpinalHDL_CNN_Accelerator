import spinal.core._
import spinal.lib._
import spinal.lib.fsm._
import xmemory._

class image_four2three(
                    S_DATA_WIDTH: Int,
                    ROW_COL_DATA_COUNT_WIDTH: Int,
                    FEATURE_MAP_SIZE: Int
                ) extends Component {
    val io = new Bundle {
        val Start = in Bool()
        val StartRow = out Bool() setAsReg() init (False)
        val Row_Num_After_Padding = in UInt (ROW_COL_DATA_COUNT_WIDTH bits)
        val S_DATA = slave Stream Bits(S_DATA_WIDTH bits)
        val M_DATA = out Bits (S_DATA_WIDTH * 3 bits) setAsReg() init 0
        val M_Ready = in Bool()
        val M_Valid = out Bool() setAsReg() init False
        val M_rd_en = in Bool()
        val M_Addr = in UInt (ROW_COL_DATA_COUNT_WIDTH bits)
    }

    noIoPrefix()
    val four2three_fifo = new general_fifo_sync(S_DATA_WIDTH,S_DATA_WIDTH, FEATURE_MAP_SIZE,ROW_COL_DATA_COUNT_WIDTH)
    four2three_fifo.io.data_in <> io.S_DATA.payload
    four2three_fifo.io.data_in_ready <> io.S_DATA.ready
    four2three_fifo.io.wr_en <> io.S_DATA.valid
    four2three_fifo.io.m_data_count <> FEATURE_MAP_SIZE
    four2three_fifo.io.s_data_count <> FEATURE_MAP_SIZE
    val ram1 = new sdpram(S_DATA_WIDTH, FEATURE_MAP_SIZE, S_DATA_WIDTH, FEATURE_MAP_SIZE, "distributed", 0,clka = this.clockDomain,clkb = this.clockDomain)
    val ram2 = new sdpram(S_DATA_WIDTH, FEATURE_MAP_SIZE, S_DATA_WIDTH, FEATURE_MAP_SIZE, "distributed", 0,clka = this.clockDomain,clkb = this.clockDomain)
    val ram3 = new sdpram(S_DATA_WIDTH, FEATURE_MAP_SIZE, S_DATA_WIDTH, FEATURE_MAP_SIZE, "distributed", 0,clka = this.clockDomain,clkb = this.clockDomain)
    val ram4 = new sdpram(S_DATA_WIDTH, FEATURE_MAP_SIZE, S_DATA_WIDTH, FEATURE_MAP_SIZE, "distributed", 0,clka = this.clockDomain,clkb = this.clockDomain)
    ram1.io.addrb <> io.M_Addr.asBits.resized
    ram2.io.addrb <> io.M_Addr.asBits.resized
    ram3.io.addrb <> io.M_Addr.asBits.resized
    ram4.io.addrb <> io.M_Addr.asBits.resized
    val four2three_fsm = new StateMachine {
        val IDLE = new State() with EntryPoint
        val Judge_Fifo = new State()
        val Read = new State()
        val Judge_Compute = new State()
        val Start_Compute = new State()

        val End_Read = Bool()
        val Cnt_Column = UInt(ROW_COL_DATA_COUNT_WIDTH bits) setAsReg() init (0)
        when(isActive(Read)) {
            Cnt_Column := Cnt_Column + 1
        } otherwise (Cnt_Column := 0)
        when(Cnt_Column === io.Row_Num_After_Padding - 1) {
            End_Read := True
        } otherwise (End_Read := False)
        val Cnt_Ram = UInt(2 bits) setAsReg() init 0
        when(isEntering(Judge_Compute)) {
            Cnt_Ram := Cnt_Ram + 1
        } elsewhen isEntering(Start_Compute) {
            Cnt_Ram := Cnt_Ram - 1
        } otherwise (Cnt_Ram := Cnt_Ram)
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
            //            default{
            //                ram1.io.ena := False
            //                ram2.io.ena := False
            //                ram3.io.ena := False
            //                ram4.io.ena := False
            //            }
        }
        val addrRam1 = UInt(ROW_COL_DATA_COUNT_WIDTH bits) setAsReg() init 0
        val addrRam2 = UInt(ROW_COL_DATA_COUNT_WIDTH bits) setAsReg() init 0
        val addrRam3 = UInt(ROW_COL_DATA_COUNT_WIDTH bits) setAsReg() init 0
        val addrRam4 = UInt(ROW_COL_DATA_COUNT_WIDTH bits) setAsReg() init 0
        ram1.io.addra := ram2addra(addrRam1).asBits.resized
        ram1.io.dina := four2three_fifo.io.data_out
        ram2.io.addra := ram2addra(addrRam2).asBits.resized
        ram2.io.dina := four2three_fifo.io.data_out
        ram3.io.addra := ram2addra(addrRam3).asBits.resized
        ram3.io.dina := four2three_fifo.io.data_out
        ram4.io.addra := ram2addra(addrRam4).asBits.resized
        ram4.io.dina := four2three_fifo.io.data_out
        when(isActive(Read)) {
            four2three_fifo.io.rd_en := True
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
                //                default {
                //                    ram1.io.wea := False.asBits
                //                    ram2.io.wea := False.asBits
                //                    ram3.io.wea := False.asBits
                //                    ram4.io.wea := False.asBits
                //                }
            }
        } otherwise {
            ram1.io.wea := False.asBits
            ram2.io.wea := False.asBits
            ram3.io.wea := False.asBits
            ram4.io.wea := False.asBits
            four2three_fifo.io.rd_en := False
        }
        when(isEntering(Start_Compute)) {
            io.StartRow := True
        } otherwise {
            io.StartRow := False
        }

        val rd_ram_cnt = UInt(3 bits) setAsReg() init (0)
        when(rd_ram_cnt === 4 && io.M_Addr === io.Row_Num_After_Padding - 1) {
            rd_ram_cnt := 0
        } elsewhen (isEntering(Start_Compute)) {
            rd_ram_cnt := rd_ram_cnt + 1
        } otherwise (
            rd_ram_cnt := rd_ram_cnt
            )


        switch(rd_ram_cnt) {
            is(1) {
                ram1.io.enb :=io.M_rd_en
                ram2.io.enb :=io.M_rd_en
                ram3.io.enb :=io.M_rd_en
                ram4.io.enb :=False
//                io.M_DATA := ram3.io.doutb##ram2.io.doutb##ram1.io.doutb
            }
            is(2) {
                ram1.io.enb :=False
                ram2.io.enb :=io.M_rd_en
                ram3.io.enb :=io.M_rd_en
                ram4.io.enb :=io.M_rd_en
//                io.M_DATA := ram4.io.doutb##ram3.io.doutb##ram2.io.doutb
            }
            is(3) {
                ram1.io.enb :=io.M_rd_en
                ram2.io.enb :=False
                ram3.io.enb :=io.M_rd_en
                ram4.io.enb :=io.M_rd_en
//                io.M_DATA := ram1.io.doutb##ram4.io.doutb##ram3.io.doutb
            }
            is(4) {
                ram1.io.enb :=io.M_rd_en
                ram2.io.enb :=io.M_rd_en
                ram3.io.enb :=False
                ram4.io.enb :=io.M_rd_en
//                io.M_DATA := ram2.io.doutb##ram1.io.doutb##ram4.io.doutb
            }
            default {
                ram1.io.enb :=False
                ram2.io.enb :=False
                ram3.io.enb :=False
                ram4.io.enb :=False
//                io.M_DATA := 0
            }
        }
        when(io.M_rd_en){
            io.M_Valid := True
            switch(rd_ram_cnt){
                is(1) {
                    //io.M_DATA := ram1.io.doutb##ram2.io.doutb##ram3.io.doutb
                    io.M_DATA := ram3.io.doutb##ram2.io.doutb##ram1.io.doutb
                }
                is(2) {
//                    io.M_DATA := ram2.io.doutb##ram3.io.doutb##ram4.io.doutb
                    io.M_DATA := ram4.io.doutb##ram3.io.doutb##ram2.io.doutb
                }
                is(3) {
//                    io.M_DATA := ram3.io.doutb##ram4.io.doutb##ram1.io.doutb
                    io.M_DATA := ram1.io.doutb##ram4.io.doutb##ram3.io.doutb
                }
                is(4) {
//                    io.M_DATA := ram4.io.doutb##ram1.io.doutb##ram2.io.doutb
                    io.M_DATA := ram2.io.doutb##ram1.io.doutb##ram4.io.doutb
                }
                default {
                    io.M_DATA := 0
                }
            }
        } otherwise{
            io.M_Valid := False
            io.M_DATA := 0
        }

        IDLE
            .whenIsActive {
                when(io.Start) {
                    goto(Judge_Fifo)
                } otherwise goto(IDLE)
            }
        Judge_Fifo
            .whenIsActive {
                when(four2three_fifo.io.data_out_valid) {
                    goto(Read)
                } otherwise goto(Judge_Fifo)
            }
        Read
            .whenIsActive {
                when(End_Read) {
                    goto(Judge_Compute)
                } otherwise goto(Read)
            }
        Judge_Compute
            .whenIsActive {
                when(Cnt_Ram === 3) {
                    when(io.M_Ready){
                        goto(Start_Compute)
                    } otherwise goto(Judge_Compute)

                } otherwise goto(Judge_Fifo)
            }
        Start_Compute
            .whenIsActive {
                when(Last_Row) {
                    when(io.M_Addr === io.Row_Num_After_Padding -1){
                        goto(IDLE)
                    }otherwise goto(Start_Compute)

                } otherwise {
//                    when(io.M_Ready) {
                        goto(Judge_Fifo)
//                    } otherwise goto(Start_Compute)

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


object image_four2three {
    def main(args: Array[String]): Unit = {
        SpinalVerilog(new image_four2three(3, 10, 1024))
    }
}
