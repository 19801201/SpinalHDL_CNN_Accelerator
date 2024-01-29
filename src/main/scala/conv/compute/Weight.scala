package conv.compute

import config.Config
import spinal.core._
import spinal.lib._
import wa.xip.memory.xpm.{CLOCK_MODE, MEM_TYPE, sdpram}
import wa.{WaCounter, setClear}

case class WeightReadPort[T <: Data](dataType: HardType[T], depth: Int) extends Bundle {
    val addr = in UInt (log2Up(depth) bits)
    //    val en = in Bool()
    val data = out(cloneOf(dataType))
}

object LoadWeightEnum extends SpinalEnum(defaultEncoding = binaryOneHot) {
    val IDLE, INIT, COPY_WEIGHT, COPY_BIAS, COPY_SCALE, COPY_SHIFT = newElement
}

case class LoadWeightFsm(start: Bool) extends Area {

    val initEnd = Bool()
    val copyWeightEnd = Bool()
    val copyBiasEnd = Bool()
    val copyScaleEnd = Bool()
    val copyShiftEnd = Bool()

    val currentState = Reg(LoadWeightEnum()) init LoadWeightEnum.IDLE
    val nextState = LoadWeightEnum()
    currentState := nextState
    switch(currentState) {
        is(LoadWeightEnum.IDLE) {
            when(start) {
                nextState := LoadWeightEnum.INIT
            } otherwise {
                nextState := LoadWeightEnum.IDLE
            }
        }
        is(LoadWeightEnum.INIT) {
            when(initEnd) {
                nextState := LoadWeightEnum.COPY_WEIGHT
            } otherwise {
                nextState := LoadWeightEnum.INIT
            }
        }
        is(LoadWeightEnum.COPY_WEIGHT) {
            when(copyWeightEnd) {
                nextState := LoadWeightEnum.COPY_BIAS
            } otherwise {
                nextState := LoadWeightEnum.COPY_WEIGHT
            }
        }
        is(LoadWeightEnum.COPY_BIAS) {
            when(copyBiasEnd) {
                nextState := LoadWeightEnum.COPY_SCALE
            } otherwise {
                nextState := LoadWeightEnum.COPY_BIAS
            }
        }
        is(LoadWeightEnum.COPY_SCALE) {
            when(copyScaleEnd) {
                nextState := LoadWeightEnum.COPY_SHIFT
            } otherwise {
                nextState := LoadWeightEnum.COPY_SCALE
            }
        }
        is(LoadWeightEnum.COPY_SHIFT) {
            when(copyShiftEnd) {
                nextState := LoadWeightEnum.IDLE
            } otherwise {
                nextState := LoadWeightEnum.COPY_SHIFT
            }
        }
    }
}

case class LoadWeight(convConfig: ConvConfig) extends Component {
    val io = new Bundle {
        val start = in Bool()
        val sData = slave Stream UInt(convConfig.WEIGHT_S_DATA_WIDTH bits)
        val weightNum = in UInt (log2Up(convConfig.WEIGHT_S_DATA_DEPTH) bits)
        val quanNum = in UInt (log2Up(convConfig.QUAN_S_DATA_DEPTH) bits)
        val weightRead = Vec(WeightReadPort(UInt(convConfig.WEIGHT_M_DATA_WIDTH bits), convConfig.WEIGHT_M_DATA_DEPTH), convConfig.KERNEL_NUM)
        val biasRead = WeightReadPort(UInt(convConfig.QUAN_M_DATA_WIDTH bits), convConfig.QUAN_M_DATA_DEPTH)
        val scaleRead = WeightReadPort(UInt(convConfig.QUAN_M_DATA_WIDTH bits), convConfig.QUAN_M_DATA_DEPTH)
        val shiftRead = WeightReadPort(UInt(convConfig.QUAN_M_DATA_WIDTH bits), convConfig.QUAN_M_DATA_DEPTH)
        val copyWeightDone = out Bool()
        val convType = in Bits (2 bits)
        val channelIn = in UInt (convConfig.CHANNEL_WIDTH bits)
        val channelOut = in UInt (convConfig.CHANNEL_WIDTH bits)

    }
    noIoPrefix()

    val fsm = LoadWeightFsm(io.start)
    val init = WaCounter(fsm.currentState === LoadWeightEnum.INIT, log2Up(5), 5)
    fsm.initEnd := init.valid

    val channelInTimes = RegNext(io.channelIn >> log2Up(convConfig.COMPUTE_CHANNEL_IN_NUM)) init(0)
    val channelOutTimes = RegNext(io.channelOut) init(0)
    val copyTimes = Reg(UInt(4 bits)) init 0
    switch(io.convType) {
        is(CONV_STATE.CONV11) {
            copyTimes := 1 - 1
        }
        is(CONV_STATE.CONV11_8X) {
            copyTimes := 8 - 1
        }
        default {
            copyTimes := 0
        }
    }
    val copyWeightCnt = WaCounter(fsm.currentState === LoadWeightEnum.COPY_WEIGHT && io.sData.fire, log2Up(convConfig.WEIGHT_S_DATA_DEPTH), io.weightNum - 1)
    val copyWeightTimes = WaCounter(copyWeightCnt.last_valid, convConfig.KERNEL_NUM.toBinaryString.length, convConfig.KERNEL_NUM - 1)

    val channelInCnt = WaCounter(fsm.currentState === LoadWeightEnum.COPY_WEIGHT && io.sData.fire, channelInTimes.getWidth, channelInTimes - 1)
    val computeChannelOut = WaCounter(fsm.currentState === LoadWeightEnum.COPY_WEIGHT && io.sData.fire, log2Up(convConfig.COMPUTE_CHANNEL_OUT_NUM), convConfig.COMPUTE_CHANNEL_OUT_NUM - 1)
    val times = WaCounter(computeChannelOut.last_valid, 4, copyTimes)
    val channelOutCnt = WaCounter(channelInCnt.last_valid, channelOutTimes.getWidth, channelOutTimes - 1)
    when(fsm.currentState === LoadWeightEnum.IDLE) {
        channelInCnt.clear
        computeChannelOut.clear
        times.clear
        channelOutCnt.clear
    }
    when(io.convType === CONV_STATE.CONV33) {
        fsm.copyWeightEnd := copyWeightTimes.last_valid
    } elsewhen (io.convType === CONV_STATE.CONV11_8X) {
        fsm.copyWeightEnd := channelOutCnt.last_valid
    } elsewhen (io.convType === CONV_STATE.CONV11) {
        fsm.copyWeightEnd := copyWeightCnt.last_valid
    } otherwise {
        fsm.copyWeightEnd := False
    }

    when(fsm.currentState === LoadWeightEnum.COPY_WEIGHT || fsm.currentState === LoadWeightEnum.COPY_SHIFT || fsm.currentState === LoadWeightEnum.COPY_BIAS || fsm.currentState === LoadWeightEnum.COPY_SCALE) {
        io.sData.ready := True
    } otherwise {
        io.sData.ready := False
    }
    val weav = Vec(Vec(Bool(), convConfig.COMPUTE_CHANNEL_OUT_NUM), convConfig.KERNEL_NUM)
    when(io.sData.fire && fsm.currentState === LoadWeightEnum.COPY_WEIGHT) {
        switch(io.convType) {
            is(CONV_STATE.CONV33) {
                (0 until convConfig.KERNEL_NUM).foreach(i => {
                    (0 until convConfig.COMPUTE_CHANNEL_OUT_NUM).foreach(j => {
                        when(copyWeightTimes.count === i && computeChannelOut.count === j) {
                            weav(i)(j).set()
                        } otherwise {
                            weav(i)(j).clear()
                        }
                    })
                })
            }
            is(CONV_STATE.CONV11) {
                (1 until convConfig.KERNEL_NUM).foreach(i => {
                    (0 until convConfig.COMPUTE_CHANNEL_OUT_NUM).foreach(j => {
                        weav(i)(j).clear()
                    })
                })
                (0 until convConfig.COMPUTE_CHANNEL_OUT_NUM).foreach(j => {
                    when(computeChannelOut.count === j) {
                        weav(0)(j).set()
                    } otherwise {
                        weav(0)(j).clear()
                    }
                })
            }
            is(CONV_STATE.CONV11_8X) {
                (0 until 8).foreach(i => {
                    (0 until convConfig.COMPUTE_CHANNEL_OUT_NUM).foreach(j => {
                        when(times.count === i && computeChannelOut.count === j) {
                            weav(i)(j).set()
                        } otherwise {
                            weav(i)(j).clear()
                        }
                    })
                })
                weav(8).foreach(w => w.clear())
            }
            default {
                weav.map(w => w.map(_ := False))
            }
        }
    } otherwise {
        weav.map(w => w.map(_ := False))
    }
    val addr = Vec(Vec(Reg(UInt(log2Up(convConfig.WEIGHT_S_DATA_DEPTH) bits)) init 0, convConfig.COMPUTE_CHANNEL_OUT_NUM), 9)
    (0 until 9).foreach(i => {
        (0 until convConfig.COMPUTE_CHANNEL_OUT_NUM).foreach(j => {
            when(weav(i)(j)) {
                when(addr(i)(j) === io.weightNum - 1) {
                    addr(i)(j) := 0
                } otherwise {
                    addr(i)(j) := addr(i)(j) + 1
                }
            }
        })
    })
    val weightData = Vec(Vec(UInt(convConfig.WEIGHT_S_DATA_WIDTH bits), convConfig.COMPUTE_CHANNEL_OUT_NUM), convConfig.KERNEL_NUM)
    (0 until convConfig.KERNEL_NUM).foreach(i => {
        io.weightRead(i).data := weightData(i).reverse.reduce(_ @@ _)
    })
    val weightRam = Array.tabulate(convConfig.KERNEL_NUM, convConfig.COMPUTE_CHANNEL_OUT_NUM) { (i, j) =>
        def gen = {
            val memType = if (Config.useUram) MEM_TYPE.ultra else MEM_TYPE.block
            val latency = if (Config.useUram) 12 else 2
            val temp = new sdpram(convConfig.WEIGHT_S_DATA_WIDTH, convConfig.WEIGHT_S_DATA_DEPTH / convConfig.COMPUTE_CHANNEL_OUT_NUM, convConfig.WEIGHT_S_DATA_WIDTH, convConfig.WEIGHT_S_DATA_DEPTH / convConfig.COMPUTE_CHANNEL_OUT_NUM, memType, latency, CLOCK_MODE.common_clock, this.clockDomain, this.clockDomain)
            //            temp.io.wea <> RegNext(weav(i).asBits)
            temp.io.wea <> weav(i)(j).asBits
            temp.io.ena := True
            temp.io.enb := True
            //            temp.io.addra := copyWeightCnt.count.asBits
            temp.io.addra := addr(i)(j).asBits.resized
            temp.io.addrb := io.weightRead(i).addr.asBits.resized
            temp.io.dina <> io.sData.payload.asBits
            weightData(i)(j) := temp.io.doutb.asUInt
            temp
        }

        gen
    }

    case class copyQuan(enCnt: Bool, wea: Bool, dina: UInt, addrb: UInt, doutb: UInt, clk: ClockDomain) extends Area {
        val copyCnt = WaCounter(enCnt, log2Up(convConfig.QUAN_S_DATA_DEPTH), io.quanNum - 1)
        val ram = new sdpram(convConfig.QUAN_S_DATA_WIDTH, convConfig.QUAN_S_DATA_DEPTH, convConfig.QUAN_M_DATA_WIDTH, convConfig.QUAN_M_DATA_DEPTH, MEM_TYPE.block, 2, CLOCK_MODE.common_clock, clk, clk)
        ram.io.ena <> True
        ram.io.wea <> wea.asBits
        ram.io.dina <> dina.asBits
        ram.io.addra <> copyCnt.count.asBits
        ram.io.addrb <> addrb.asBits
        ram.io.doutb.asUInt <> doutb
        ram.io.enb <> True
    }

    val copyBias = copyQuan(fsm.currentState === LoadWeightEnum.COPY_BIAS && io.sData.fire, fsm.currentState === LoadWeightEnum.COPY_BIAS && io.sData.fire, io.sData.payload, io.biasRead.addr, io.biasRead.data, this.clockDomain)
    fsm.copyBiasEnd := copyBias.copyCnt.last_valid
    val copyScale = copyQuan(fsm.currentState === LoadWeightEnum.COPY_SCALE && io.sData.fire, fsm.currentState === LoadWeightEnum.COPY_SCALE && io.sData.fire, io.sData.payload, io.scaleRead.addr, io.scaleRead.data, this.clockDomain)
    fsm.copyScaleEnd := copyScale.copyCnt.last_valid
    val copyShift = copyQuan(fsm.currentState === LoadWeightEnum.COPY_SHIFT && io.sData.fire, fsm.currentState === LoadWeightEnum.COPY_SHIFT && io.sData.fire, io.sData.payload, io.shiftRead.addr, io.shiftRead.data, this.clockDomain)
    fsm.copyShiftEnd := copyShift.copyCnt.last_valid
    setClear(io.copyWeightDone, fsm.currentState === LoadWeightEnum.COPY_SHIFT && fsm.nextState === LoadWeightEnum.IDLE)

}