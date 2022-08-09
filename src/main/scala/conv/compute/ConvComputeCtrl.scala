package conv.compute

import spinal.core._
import spinal.lib._
import wa.{WaCounter, setClear}


object ConvComputeCtrlEnum extends SpinalEnum(defaultEncoding = binaryOneHot) {
    val IDLE, INIT, DATA_READY, FIFO_READY, COMPUTE, END = newElement
}

case class ConvComputeCtrlFsm() extends Area {
    val start = Bool()
    val dataReady = Bool()
    val fifoReady = Bool()
    val initEnd = Bool()
    val computeEnd = Bool()
    val endEnd = Bool()

    val currentState = Reg(ConvComputeCtrlEnum()) init ConvComputeCtrlEnum.IDLE
    val nextState = ConvComputeCtrlEnum()
    currentState := nextState
    switch(currentState) {
        is(ConvComputeCtrlEnum.IDLE) {
            when(start) {
                nextState := ConvComputeCtrlEnum.INIT
            } otherwise {
                nextState := ConvComputeCtrlEnum.IDLE
            }
        }
        is(ConvComputeCtrlEnum.INIT) {
            when(initEnd) {
                nextState := ConvComputeCtrlEnum.DATA_READY
            } otherwise {
                nextState := ConvComputeCtrlEnum.INIT
            }
        }
        is(ConvComputeCtrlEnum.DATA_READY) {
            when(dataReady) {
                nextState := ConvComputeCtrlEnum.FIFO_READY
            } otherwise {
                nextState := ConvComputeCtrlEnum.DATA_READY
            }
        }
        is(ConvComputeCtrlEnum.FIFO_READY) {
            when(fifoReady) {
                nextState := ConvComputeCtrlEnum.COMPUTE
            } otherwise {
                nextState := ConvComputeCtrlEnum.FIFO_READY
            }
        }
        is(ConvComputeCtrlEnum.COMPUTE) {
            when(computeEnd) {
                nextState := ConvComputeCtrlEnum.END
            } otherwise {
                nextState := ConvComputeCtrlEnum.COMPUTE
            }
        }
        is(ConvComputeCtrlEnum.END) {
            when(endEnd) {
                nextState := ConvComputeCtrlEnum.IDLE
            } otherwise {
                nextState := ConvComputeCtrlEnum.DATA_READY
            }
        }
    }

}


case class ConvComputeCtrl(convConfig: ConvConfig) extends Component {

    val io = new Bundle {
        val start = in Bool()
        val mDataValid = out Bool() //
        val mDataReady = in Bool() //mData
        val normValid = out Bool() //卷积
        val normPreValid = out Bool() //通道累计
        val normEnd = out Bool()
        //val sDataValid = in Bool()  //sData
        val sDataReady = in Bool()
        val rowNumIn = in UInt (convConfig.FEATURE_WIDTH bits)
        val colNumIn = in UInt (convConfig.FEATURE_WIDTH bits)
        val channelIn = in UInt (convConfig.CHANNEL_WIDTH bits)
        val channelOut = in UInt (convConfig.CHANNEL_WIDTH bits)

        val featureMemReadAddr = out UInt (log2Up(convConfig.FEATURE_MEM_DEPTH) bits)
        val featureMemWriteAddr = out((UInt(log2Up(convConfig.FEATURE_MEM_DEPTH) bits)))
        val featureMemWriteReady = out(Reg(Bool()) init False)

        val weightReadAddr = out Vec(UInt(log2Up(convConfig.WEIGHT_M_DATA_DEPTH) bits), convConfig.KERNEL_NUM)
        val biasReadAddr = out(UInt(log2Up(convConfig.QUAN_M_DATA_DEPTH) bits))
        val scaleReadAddr = out(UInt(log2Up(convConfig.QUAN_M_DATA_DEPTH) bits))
        val shiftReadAddr = out(UInt(log2Up(convConfig.QUAN_M_DATA_DEPTH) bits))
        val activationEn = in Bool()

        val sCount = out UInt (log2Up(convConfig.FEATURE_RAM_DEPTH) bits)
        val mCount = out UInt (log2Up(convConfig.FEATURE_RAM_DEPTH) bits)

        val convType = in Bits (2 bits)
    }
    noIoPrefix()
    //    val computeChannelInTimes = RegNext(io.channelIn >> log2Up(convConfig.COMPUTE_CHANNEL_IN_NUM))
    //    val computeChannelOutTimes = RegNext(io.channelOut >> log2Up(convConfig.COMPUTE_CHANNEL_OUT_NUM))


    val convComputeCtrlFsm = ConvComputeCtrlFsm()
    convComputeCtrlFsm.start <> io.start
    convComputeCtrlFsm.dataReady <> io.sDataReady
    convComputeCtrlFsm.fifoReady <> io.mDataReady

    val initCnt = WaCounter(convComputeCtrlFsm.currentState === ConvComputeCtrlEnum.INIT, 3, 7)
    val temp = UInt(convConfig.CHANNEL_WIDTH bits)
//    when(io.convType === CONV_STATE.CONV33) {
//        temp := (io.channelIn >> log2Up(convConfig.COMPUTE_CHANNEL_IN_NUM)).resized
//    } otherwise {
//        temp := (io.channelIn >> (log2Up(convConfig.COMPUTE_CHANNEL_IN_NUM) + 3)).resized
//    }
    switch(io.convType)
    {
        is(CONV_STATE.CONV33,CONV_STATE.CONV11){
            temp := (io.channelIn >> log2Up(convConfig.COMPUTE_CHANNEL_IN_NUM)).resized
        }
        is(CONV_STATE.CONV11_8X) {
            temp := (io.channelIn >> (log2Up(convConfig.COMPUTE_CHANNEL_IN_NUM) + 3)).resized
        }
        default{
            temp := 0
        }
    }
    val channelInTimes = RegNext(temp)

    val channelOutTimes = RegNext(io.channelOut >> log2Up(convConfig.COMPUTE_CHANNEL_OUT_NUM))
    val channelInCnt = WaCounter(convComputeCtrlFsm.currentState === ConvComputeCtrlEnum.COMPUTE, convConfig.CHANNEL_WIDTH, channelInTimes - 1)
    val channelOutCnt = WaCounter(convComputeCtrlFsm.currentState === ConvComputeCtrlEnum.COMPUTE && channelInCnt.valid, convConfig.CHANNEL_WIDTH, channelOutTimes - 1)
    val columnCnt = WaCounter(channelInCnt.valid && channelOutCnt.valid, convConfig.FEATURE_WIDTH, io.colNumIn - 1)
    val rowCnt = WaCounter(convComputeCtrlFsm.currentState === ConvComputeCtrlEnum.END, convConfig.FEATURE_WIDTH, io.rowNumIn - 1)
    when(convComputeCtrlFsm.currentState === ConvComputeCtrlEnum.IDLE) {
        channelInCnt.clear
        channelOutCnt.clear
        columnCnt.clear
    }
    setClear(convComputeCtrlFsm.computeEnd, channelInCnt.valid && channelOutCnt.valid && columnCnt.valid)
    setClear(convComputeCtrlFsm.endEnd, rowCnt.valid)
    setClear(io.normEnd, convComputeCtrlFsm.currentState === ConvComputeCtrlEnum.END && convComputeCtrlFsm.nextState === ConvComputeCtrlEnum.IDLE)
    setClear(convComputeCtrlFsm.initEnd, initCnt.valid)

    setClear(io.featureMemWriteReady, convComputeCtrlFsm.currentState === ConvComputeCtrlEnum.COMPUTE && channelOutCnt.count === 0)
    val featureMemWriteAddr = Reg(UInt(log2Up(convConfig.FEATURE_MEM_DEPTH) bits)) init 0 addAttribute ("max_fanout = \"50\"")
    io.featureMemWriteAddr := featureMemWriteAddr
    when(channelOutCnt.count === 0 && channelInCnt.count === 0) {
        featureMemWriteAddr := 0
    } elsewhen io.featureMemWriteReady {
        featureMemWriteAddr := featureMemWriteAddr + 1
    } otherwise {
        featureMemWriteAddr := 0
    }

    def increase(data: UInt, clear: Bool, delay: Int): UInt = {
        when(convComputeCtrlFsm.currentState === ConvComputeCtrlEnum.COMPUTE) {
            when(clear) {
                data := 0
            } otherwise {
                data := data + 1
            }
        } otherwise {
            data := 0
        }
        val a = Delay(data, delay).addAttribute("max_fanout = \"50\"")
        a
    }

    val featureMemReadAddrTemp = Reg(UInt(log2Up(convConfig.FEATURE_MEM_DEPTH) bits)) init 0 addAttribute ("max_fanout = \"50\"")
    io.featureMemReadAddr := increase(featureMemReadAddrTemp, channelInCnt.valid, 2)

    val weightReadAddr = Reg(UInt(log2Up(convConfig.WEIGHT_M_DATA_DEPTH) bits)) addAttribute ("max_fanout = \"50\"")
    val weightReadAddrTemp = increase(weightReadAddr, channelInCnt.valid && channelOutCnt.valid, 1)
    io.weightReadAddr.map(_ := weightReadAddrTemp)

    val channelTimesAdd = Reg(Bool()) init False
    setClear(channelTimesAdd, convComputeCtrlFsm.currentState === ConvComputeCtrlEnum.COMPUTE && channelInCnt.count === 0)
    /** **************************************************************************************** */
    //这个值有待测试其他情况
    val normDelayCount = 2 + (if (!config.Config.dsp2x) 3 else 10) + 4 + log2Up(convConfig.COMPUTE_CHANNEL_IN_NUM)
    val biasDelayCount = normDelayCount - 1
    val scaleDealyCount = 8
    val shiftDealyCount = 1
    val activationDealyCount = 8
    val mValidDelayCountActivation = normDelayCount + 2 + scaleDealyCount + shiftDealyCount + activationDealyCount + 2
    val mValidDelayCountNoActivation = normDelayCount + 2 + scaleDealyCount + shiftDealyCount + 2
    io.normPreValid := Delay(channelTimesAdd, normDelayCount - 1)
    val normValidTemp = Reg(Bool()) init False
    setClear(normValidTemp, convComputeCtrlFsm.currentState === ConvComputeCtrlEnum.COMPUTE && channelInCnt.valid)
    val normValidTempQ = History(normValidTemp, mValidDelayCountActivation + 1)
    io.normValid := normValidTempQ(normDelayCount)

    /** **************************************************************************************** */
    io.sCount := RegNext(io.colNumIn * channelInTimes).resized
    io.mCount := io.sCount
    val biasAddrCnt = WaCounter(normValidTempQ(biasDelayCount), log2Up(convConfig.QUAN_M_DATA_DEPTH), channelOutTimes - 1)
    io.biasReadAddr := biasAddrCnt.count
    val quanDelayTemp = History(io.biasReadAddr, shiftDealyCount + scaleDealyCount + 1)
    //    io.scaleReadAddr := quanDelayTemp(scaleDealyCount)
    //    io.shiftReadAddr := quanDelayTemp(shiftDealyCount + scaleDealyCount)
    //    io.scaleReadAddr := quanDelayTemp(1)
    //    io.shiftReadAddr := quanDelayTemp(1 + scaleDealyCount)
    io.scaleReadAddr := biasAddrCnt.count
    io.shiftReadAddr := biasAddrCnt.count
    when(io.activationEn) {
        io.mDataValid := normValidTempQ(mValidDelayCountActivation)
    } otherwise {
        io.mDataValid := normValidTempQ(mValidDelayCountNoActivation)
    }

}

//
//object ConvComputeCtrl extends App {
//    SpinalVerilog(ConvComputeCtrl(ConvConfig(8, 16, 8, 12, 2048, 512, 640, 2048, 1, ConvType.conv33)))
//}