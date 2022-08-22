package conv.compute

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


    //    val convType = Reg(Bits(2 bits))
    //    when(io.start) {
    //        convType := io.convType
    //    }

    //    val copyWeightTi = UInt(convConfig.KERNEL_NUM.toBinaryString.length bits)
    //    when(convType === CONV_STATE.CONV33){
    //        copyWeightTi := 9
    //    } otherwise{
    //        copyWeightTi := 8
    //    }

    val channelInTimes = io.channelIn >> log2Up(convConfig.COMPUTE_CHANNEL_IN_NUM)
    //    val channelOutTimes = io.channelOut >> log2Up(convConfig.COMPUTE_CHANNEL_OUT_NUM)
    val channelOutTimes = io.channelOut

    val fsm = LoadWeightFsm(io.start)
    val init = WaCounter(fsm.currentState === LoadWeightEnum.INIT, log2Up(5), 5)
    fsm.initEnd := init.valid
    val copyWeightCnt = WaCounter(fsm.currentState === LoadWeightEnum.COPY_WEIGHT && io.sData.fire, log2Up(convConfig.WEIGHT_S_DATA_DEPTH), io.weightNum - 1)
    val copyWeightTimes = WaCounter(copyWeightCnt.valid, convConfig.KERNEL_NUM.toBinaryString.length, convConfig.KERNEL_NUM - 1)
    val channelInCnt = WaCounter(fsm.currentState === LoadWeightEnum.COPY_WEIGHT && io.sData.fire, channelInTimes.getWidth, channelInTimes - 1)
    val computeChannelOut = WaCounter(fsm.currentState === LoadWeightEnum.COPY_WEIGHT && io.sData.fire, log2Up(convConfig.COMPUTE_CHANNEL_OUT_NUM), convConfig.COMPUTE_CHANNEL_OUT_NUM - 1)
    val times = WaCounter(computeChannelOut.valid, log2Up(8), 8 - 1)
    val channelOutCnt = WaCounter(channelInCnt.valid, channelOutTimes.getWidth, channelOutTimes - 1)
    when(fsm.currentState === LoadWeightEnum.IDLE) {
        copyWeightCnt.clear
        copyWeightTimes.clear
        channelInCnt.clear
        channelOutCnt.clear
    }

    when(io.convType === CONV_STATE.CONV33) {
        fsm.copyWeightEnd := copyWeightCnt.valid && copyWeightTimes.valid
    } elsewhen (io.convType === CONV_STATE.CONV11_8X) {
        fsm.copyWeightEnd := channelInCnt.valid && channelOutCnt.valid
    } elsewhen (io.convType === CONV_STATE.CONV11) {
        fsm.copyWeightEnd := copyWeightCnt.valid
    } otherwise {
        fsm.copyWeightEnd := False
    }
    when(fsm.currentState === LoadWeightEnum.COPY_WEIGHT || fsm.currentState === LoadWeightEnum.COPY_SHIFT || fsm.currentState === LoadWeightEnum.COPY_BIAS || fsm.currentState === LoadWeightEnum.COPY_SCALE) {
        io.sData.ready := True
    } otherwise {
        io.sData.ready := False
    }


    val weav = Vec(Bool(), convConfig.KERNEL_NUM)
    when(io.sData.fire && fsm.currentState === LoadWeightEnum.COPY_WEIGHT) {
        when(io.convType === CONV_STATE.CONV33) {
            switch(copyWeightTimes.count) {
                (0 until convConfig.KERNEL_NUM).foreach(i => {
                    is(i) {
                        (0 until convConfig.KERNEL_NUM).foreach(j => {
                            if (i == j) {
                                weav(j) := True
                            } else {
                                weav(j) := False
                            }
                        }
                        )
                    }
                })
                default {
                    weav.map(_ := False)
                }

            }
        } elsewhen (io.convType === CONV_STATE.CONV11_8X) {
            switch(times.count) {
                (0 until 8).foreach(i => {
                    is(i) {
                        (0 until 8).foreach(j => {
                            if (i == j) {
                                weav(j) := True
                            } else {
                                weav(j) := False
                            }
                        }
                        )
                    }
                })
                weav(8) := False
                //                default {
                //                    weav.map(_ := False)
                //                }
            }
        } elsewhen (io.convType === CONV_STATE.CONV11) {
            (1 until convConfig.KERNEL_NUM).foreach(i=>{
                weav(i).clear()
            })
            weav(0).set()
        } otherwise {
            weav.map(_ := False)
        }


    } otherwise {
        weav.map(_ := False)
    }
    val addr = Vec(Reg(UInt(log2Up(convConfig.WEIGHT_S_DATA_DEPTH) bits)) init 0, 9)
    (0 until 9).foreach(i => {
        when(weav(i)) {
            when(addr(i) === io.weightNum - 1) {
                addr(i) := 0
            } otherwise {
                addr(i) := addr(i) + 1
            }
        }
    })
    val weightRam = Array.tabulate(convConfig.KERNEL_NUM) { i =>
        def gen = {
            val temp = new sdpram(convConfig.WEIGHT_S_DATA_WIDTH, convConfig.WEIGHT_S_DATA_DEPTH, convConfig.WEIGHT_M_DATA_WIDTH, convConfig.WEIGHT_M_DATA_DEPTH, MEM_TYPE.block, 2, CLOCK_MODE.common_clock, this.clockDomain, this.clockDomain)
            //            temp.io.wea <> RegNext(weav(i).asBits)
            temp.io.wea <> weav(i).asBits
            temp.io.ena := True
            temp.io.enb := True
            //            temp.io.addra := copyWeightCnt.count.asBits
            temp.io.addra := addr(i).asBits
            temp.io.addrb := io.weightRead(i).addr.asBits
            temp.io.dina <> io.sData.payload.asBits
            temp.io.doutb.asUInt <> io.weightRead(i).data
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
    fsm.copyBiasEnd := copyBias.copyCnt.valid
    val copyScale = copyQuan(fsm.currentState === LoadWeightEnum.COPY_SCALE && io.sData.fire, fsm.currentState === LoadWeightEnum.COPY_SCALE && io.sData.fire, io.sData.payload, io.scaleRead.addr, io.scaleRead.data, this.clockDomain)
    fsm.copyScaleEnd := copyScale.copyCnt.valid
    val copyShift = copyQuan(fsm.currentState === LoadWeightEnum.COPY_SHIFT && io.sData.fire, fsm.currentState === LoadWeightEnum.COPY_SHIFT && io.sData.fire, io.sData.payload, io.shiftRead.addr, io.shiftRead.data, this.clockDomain)
    fsm.copyShiftEnd := copyShift.copyCnt.valid
    setClear(io.copyWeightDone, fsm.currentState === LoadWeightEnum.COPY_SHIFT && fsm.nextState === LoadWeightEnum.IDLE)

}