package conv.dataGenerate

import spinal.core._
import spinal.lib._
import config.Config._
import conv.compute._
import wa.WaCounter

object FocusEnum extends SpinalEnum(defaultEncoding = binaryOneHot) {
    val IDLE, INIT, COMPUTE, END = newElement
}

case class FocusFsm(start: Bool) extends Area {

    val initEnd = Bool()
    val computeEnd = Bool()
    val currentState = Reg(FocusEnum()) init FocusEnum.IDLE
    val nextState = FocusEnum()
    currentState := nextState

    switch(currentState) {
        is(FocusEnum.IDLE) {
            when(start) {
                nextState := FocusEnum.INIT
            } otherwise {
                nextState := FocusEnum.IDLE
            }
        }
        is(FocusEnum.INIT) {
            when(initEnd) {
                nextState := FocusEnum.COMPUTE
            } otherwise {
                nextState := FocusEnum.INIT
            }
        }
        is(FocusEnum.COMPUTE) {
            when(computeEnd) {
                nextState := FocusEnum.END
            } otherwise {
                nextState := FocusEnum.COMPUTE
            }
        }
        is(FocusEnum.END) {
            nextState := FocusEnum.IDLE
        }
    }


}


class Focus(convConfig: ConvConfig) extends Component {
    val sDataWidth = convConfig.DATA_WIDTH * (if (imageType.dataType == imageType.rgb) 3 else if (imageType.dataType == imageType.gray) 1 else {
        assert(false, "imageType不正确");
        0
    })
    val io = new Bundle {
        val sData = slave Stream (UInt(sDataWidth bits))
        val mData = master Stream (UInt(sDataWidth * 4 bits))
        val rowNumIn = in UInt (convConfig.FEATURE_WIDTH bits)
        val colNumIn = in UInt (convConfig.FEATURE_WIDTH bits)
        val start = in Bool()
    }
    noIoPrefix()

    val fsm = FocusFsm(io.start)
    val initCnt = WaCounter(fsm.currentState === FocusEnum.INIT, 3, 7)
    fsm.initEnd := initCnt.valid

    val columnCnt = WaCounter(io.sData.fire, convConfig.FEATURE_WIDTH, io.colNumIn - 1)
    val rowCnt = WaCounter(columnCnt.valid && io.sData.fire, convConfig.FEATURE_WIDTH, io.rowNumIn - 1)

    fsm.computeEnd := columnCnt.valid && rowCnt.valid

    val mem = Mem(UInt(sDataWidth bits), convConfig.FEATURE)
    val rowMemWriteAddr = WaCounter((!rowCnt.count(0)) && io.sData.fire, convConfig.FEATURE_WIDTH, io.colNumIn - 1)
    mem.write(rowMemWriteAddr.count.resized, io.sData.payload, enable = (!rowCnt.count(0)) && io.sData.fire)
    val rowMemReadAddr = WaCounter(rowCnt.count(0) && io.sData.fire, convConfig.FEATURE_WIDTH, io.colNumIn - 1)


    when(fsm.currentState === FocusEnum.IDLE) {
        columnCnt.clear
        rowCnt.clear
        rowMemWriteAddr.clear
        rowMemReadAddr.clear
    }

    val pix1 = Reg(UInt(sDataWidth bits))
    val pix2 = Reg(UInt(sDataWidth bits))

    //    val zeroWidth = if (imageType.dataType == imageType.rgb) {
    //        4
    //    } else if (imageType.dataType == imageType.gray) {
    //        convConfig.COMPUTE_CHANNEL_IN_NUM - 4
    //    } else {
    //        assert(false, "imageType不正确");
    //        0
    //    }
    //    val zero = UInt()
    io.sData.ready <> io.mData.ready
    when(fsm.currentState === FocusEnum.COMPUTE) {
        when(!rowCnt.count(0)) {
            pix1 := 0
            pix2 := 0
            io.mData.payload := 0
            io.mData.valid := False
        } otherwise {

            when(!columnCnt.count(0)) {
                io.mData.valid := False
                io.mData.payload := 0
                pix1 := mem.readAsync(rowMemReadAddr.count.resized)
                pix2 := io.sData.payload
            } otherwise {
                io.mData.valid := io.sData.fire
                io.mData.payload := io.sData.payload @@ mem.readAsync(rowMemReadAddr.count.resized) @@ pix2 @@ pix1
            }
        }
    } otherwise {
        io.sData.ready := False
        io.mData.valid := False
        io.mData.payload := 0
    }


}

object Focus extends App {
    SpinalVerilog(new Focus(ConvConfig(8, 8, 8, 12, 8192, 512, 416, 2048, 1)))
}

