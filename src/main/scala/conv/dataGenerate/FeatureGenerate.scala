package conv.dataGenerate
import spinal.core.{Area, Bits, Bool, Bundle, Component, Device, False, IntToBuilder, Mem, Reg, RegInit, RegNext, SpinalEnum, SpinalVerilog, True, UInt, Vec, binaryOneHot, default, in, is, log2Up, out, switch, when}
import spinal.lib.{Flow, IMasterSlave, StreamFifo, flowBitsPimped, master, slave}
import wa.{WaCounter, WaStreamFifo}

case class FeatureGenerateConfig(DATA_WIDTH: Int, CHANNEL_WIDTH: Int, COMPUTE_CHANNEL_NUM: Int, FEATURE_WIDTH: Int, KERNEL_NUM: Int, FEATURE_RAM_ADDR_WIDTH: Int) {
    val PICTURE_NUM = 1
    val STREAM_DATA_WIDTH = DATA_WIDTH * PICTURE_NUM * COMPUTE_CHANNEL_NUM
}

object FeatureGenerateEnum extends SpinalEnum(defaultEncoding = binaryOneHot) {
    val IDLE, INIT, WAIT3, WR, END, CLEAR = newElement
}

case class FeatureGenerateFsm(start: Bool) extends Area {

    val initEnd = Bool()
    val wait3End = Bool()
    val wrEnd = Bool()
    val endEnd = Bool()

    val wait3 = Bool()

    val currentState = Reg(FeatureGenerateEnum()) init FeatureGenerateEnum.IDLE
    val nextState = FeatureGenerateEnum()
    currentState := nextState

    switch(currentState) {
        is(FeatureGenerateEnum.IDLE) {
            when(start) {
                nextState := FeatureGenerateEnum.INIT
            } otherwise {
                nextState := FeatureGenerateEnum.IDLE
            }
        }
        is(FeatureGenerateEnum.INIT) {
            when(initEnd) {
                nextState := FeatureGenerateEnum.WAIT3
            } otherwise {
                nextState := FeatureGenerateEnum.INIT
            }
        }
        is(FeatureGenerateEnum.WAIT3) {
            when(wait3End) {
                nextState := FeatureGenerateEnum.END
            } otherwise {
                nextState := FeatureGenerateEnum.WAIT3
            }
        }
        is(FeatureGenerateEnum.WR) {
            when(wrEnd) {
                nextState := FeatureGenerateEnum.END
            } otherwise {
                nextState := FeatureGenerateEnum.WR
            }
        }
        is(FeatureGenerateEnum.END) {
            when(endEnd) {
                nextState := FeatureGenerateEnum.CLEAR
            } otherwise {
                when(wait3) {
                    nextState := FeatureGenerateEnum.WAIT3
                } otherwise {
                    nextState := FeatureGenerateEnum.WR
                }

            }
        }
        is(FeatureGenerateEnum.CLEAR) {
            when(wrEnd) {
                nextState := FeatureGenerateEnum.IDLE
            } otherwise {
                nextState := FeatureGenerateEnum.CLEAR
            }
        }
    }


}

class FeatureGenerate(featureGenerateConfig: FeatureGenerateConfig) extends Component {
    val io = new Bundle {
        val sData = slave Stream UInt(featureGenerateConfig.STREAM_DATA_WIDTH bits)
        val mData = Vec(master Stream UInt(featureGenerateConfig.STREAM_DATA_WIDTH bits), featureGenerateConfig.KERNEL_NUM)
        val rowNumIn = in UInt (featureGenerateConfig.FEATURE_WIDTH bits)
        val colNumIn = in UInt (featureGenerateConfig.FEATURE_WIDTH bits)
        val start = in Bool()
        val channelIn = in UInt (featureGenerateConfig.CHANNEL_WIDTH bits)
        val last = out Bool()
    }
    noIoPrefix()

    val channelTimes: UInt = RegNext(io.channelIn >> log2Up(featureGenerateConfig.COMPUTE_CHANNEL_NUM), 0)
    val totalColAddr: UInt = RegNext(channelTimes * io.colNumIn, 0)
    val fsm = FeatureGenerateFsm(io.start)


    val initEn = RegInit(False) setWhen (fsm.currentState === FeatureGenerateEnum.INIT) clearWhen (fsm.nextState =/= FeatureGenerateEnum.INIT)
    val initCount = WaCounter(initEn, 5, 8)
    when(fsm.currentState === FeatureGenerateEnum.IDLE) {
        initCount.clear
    }
    fsm.initEnd := initCount.valid


    val wrEn = Vec(Bool(), 4)
    val wrAddr = Reg(UInt(featureGenerateConfig.FEATURE_RAM_ADDR_WIDTH bits)) init 0
    val wrData = UInt(featureGenerateConfig.STREAM_DATA_WIDTH bits)
    val rdData = Vec(UInt(featureGenerateConfig.STREAM_DATA_WIDTH bits), 4)
    val rdAddr = Vec(Reg(UInt(featureGenerateConfig.FEATURE_RAM_ADDR_WIDTH bits)) init 0, 4)
    wrData := io.sData.payload
    val mem = Array.tabulate(4)(i => {
        def gen(): Mem[UInt] = {
            val mem = Mem(UInt(featureGenerateConfig.STREAM_DATA_WIDTH bits), wordCount = scala.math.pow(2, featureGenerateConfig.FEATURE_RAM_ADDR_WIDTH).toInt)
            mem.write(wrAddr, wrData, wrEn(i))
            rdData(i) := mem.readSync(rdAddr(i))
            mem
        }

        gen()
    })
    val rowCnt = WaCounter(fsm.nextState === FeatureGenerateEnum.END, featureGenerateConfig.FEATURE_WIDTH, io.rowNumIn)
    when(fsm.currentState === FeatureGenerateEnum.IDLE) {
        rowCnt.clear
    }
    val inDone = Bool()
    when(io.sData.fire) {
        wrAddr := wrAddr + 1
    } elsewhen (fsm.currentState === FeatureGenerateEnum.END && (fsm.nextState === FeatureGenerateEnum.WAIT3||fsm.nextState === FeatureGenerateEnum.WR)) {
        wrAddr := 0
    } elsewhen (wrAddr === totalColAddr - 1) {
        wrAddr := wrAddr
    } otherwise {
        wrAddr := wrAddr
    }
    fsm.wait3End := inDone

    when(wrAddr < totalColAddr ) {
        io.sData.ready := True
    } otherwise {
        io.sData.ready := False
    }
    when(wrAddr === totalColAddr - 1) {
        inDone := True
    } otherwise {
        inDone := False
    }


    fsm.endEnd := rowCnt.valid
    when(rowCnt.count < 3) {
        fsm.wait3 := True
    } otherwise {
        fsm.wait3 := False
    }

    case class stream(count: Int, al: Boolean) extends Area {
        val Data = Vec(UInt(featureGenerateConfig.STREAM_DATA_WIDTH bits), count)
        val Valid = Vec(Bool(), count)
        val Ready = Vec(Bool(), count)
        val Fire = Vec(Bool(), count)
        val almostFull = if (al) Vec(Bool(), count) else null
        (0 until count).map(i => {
            Fire(i) := Valid(i) & Ready(i)
        })
    }

    val push = stream(3, true)
    val pop = stream(3, false)

    val fifo = Array.tabulate(3)(i => {
        def gen(): WaStreamFifo[UInt] = {
            val fifo = WaStreamFifo(UInt(featureGenerateConfig.STREAM_DATA_WIDTH bits), 5)
            fifo.io.push.ready <> push.Ready(i)
            fifo.io.push.valid <> push.Valid(i)
            fifo.io.push.payload <> push.Data(i)
            fifo.io.pop.ready := pop.Ready(i)
            fifo.io.pop.valid <> pop.Valid(i)
            fifo.io.pop.payload <> pop.Data(i)
            fifo.almost_full <> push.almostFull(i)
            fifo
        }

        gen()
    })


    val mAddr = WaCounter(fifo(0).io.pop.fire, featureGenerateConfig.FEATURE_WIDTH, totalColAddr - 1)
    when(fsm.currentState === FeatureGenerateEnum.IDLE) {
        mAddr.clear
    }
    (0 until 9).foreach(i => {
        when(if (i % 3 == 0) mAddr.count < (totalColAddr - 2 * channelTimes) else mAddr.count >= (i % 3) * channelTimes && mAddr.count < totalColAddr - (2 - (i % 3)) * channelTimes) {
            io.mData(i).valid := pop.Valid(i / 3)
        } otherwise {
            io.mData(i).valid := False
        }
        io.mData(i).payload <> pop.Data(i / 3)
    })

    (0 until 3).foreach(i => {
        pop.Ready(i) := io.mData(i * 3).ready
    })


    val currentRow = rowCnt.count(1 downto 0)
    switch(currentRow) {
        (0 until 4).map((i) => {
            is(i) {
                (0 until 4).foreach(j => {
                    if (i == j) {
                        wrEn(j) := io.sData.fire
                    } else {
                        wrEn(j) := False
                    }
                })
            }
        })
    }

    switch(currentRow) {
        (0 until 4).foreach(i => {
            is(i) {
                when((fsm.currentState === FeatureGenerateEnum.WR || fsm.currentState === FeatureGenerateEnum.CLEAR)) {
                    (1 to 3).foreach(j => {
                        when(!push.almostFull(0)) {
                            when(rdAddr((i + j) % 4) === totalColAddr) {
                                rdAddr((i + j) % 4) := rdAddr((i + j) % 4)
                            } otherwise {
                                rdAddr((i + j) % 4) := rdAddr((i + j) % 4) + 1
                            }
                        } otherwise {
                            rdAddr((i + j) % 4) := rdAddr((i + j) % 4)
                        }
                    })
                } otherwise {
                    (1 to 3).foreach(j => {
                        rdAddr((i + j) % 4) := 0
                    })
                }
            }
        })
    }
    val rdAddrNext = RegNext(rdAddr)
    val rdEnd = Bool()
    when(rdAddr(0) === totalColAddr) {
        rdEnd := True
    } otherwise {
        rdEnd := False
    }
    fsm.wrEnd := mAddr.valid.fall()
    val valid = Vec(Bool(), 4)
    (0 until 4).foreach(i => {

        when(fsm.currentState === FeatureGenerateEnum.WR || fsm.currentState === FeatureGenerateEnum.CLEAR) {
            when(rdAddr(i) =/= rdAddrNext(i) && rdAddr(i) =/= 0) {
                valid(i) := RegNext(True)
            } otherwise {
                valid(i) := RegNext(False)
            }
        } otherwise {
            valid(i) := False
        }
    })
    switch(currentRow) {
        (0 until 4).foreach(i => {
            is(i) {
                (0 until 3).foreach(j => {
                    push.Valid(j) := valid((i + j + 1) % 4)
                    push.Data(j) := rdData((i + j + 1) % 4)
                })
            }

        })
    }

    when(fsm.nextState === FeatureGenerateEnum.IDLE && fsm.currentState === FeatureGenerateEnum.CLEAR) {
        io.last := True
    } otherwise {
        io.last := False
    }

}

//object FeatureGenerateConfig {
//    def main(args: Array[String]): Unit = {
//        SpinalVerilog(new FeatureGenerate(FeatureGenerateConfig(8, 10, 8, 8, 9, 10)))
//    }
//}

