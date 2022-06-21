package conv.compute

import config.Config.imageType
import conv.dataGenerate._
import spinal.core._
import spinal.lib._
import wa._


class Conv(convConfig: ConvConfig) extends Component {
    val io = new Bundle {
        val sData = slave Stream UInt(convConfig.FEATURE_S_DATA_WIDTH bits)
        val sFeatureFirstLayerData = slave Stream UInt((if (imageType.dataType == imageType.rgb) 4 * convConfig.DATA_WIDTH else 1 * convConfig.DATA_WIDTH) bits)
        val mData = master Stream UInt(convConfig.FEATURE_M_DATA_WIDTH bits)
        //        val start = in Bool()
        val instruction = in Vec(Bits(32 bits), 3)
        val control = in Bits (4 bits)
        val state = out Bits (4 bits)

        val dmaReadValid = out Bool()
        val dmaFirstLayerReadValid = out Bool()
        val dmaWriteValid = out Bool()

        val introut = in Bool()
    }
    noIoPrefix()

    val convState = ConvState(convConfig)
    convState.io.control <> io.control
    convState.io.state <> io.state

    val para = Reg(Bool()) init False setWhen (convState.io.sign === CONV_STATE.PARA_SIGN) clearWhen (convState.io.sign =/= CONV_STATE.PARA_SIGN)
    val compute = Reg(Bool()) init False setWhen (convState.io.sign === CONV_STATE.COMPUTE_SIGN) clearWhen (convState.io.sign =/= CONV_STATE.COMPUTE_SIGN)

//    val paraInstruction = io.instruction(0)
    val computeInstruction = io.instruction.reverse.reduceRight(_ ## _)

//    val paraInstructionReg = Reg(Bits(32 bits)) init 0
//    val computeInstructionReg = Reg(Bits(computeInstruction.getWidth bits)) init 0
    val computeInstructionReg = RegNext(computeInstruction) init 0

//    when(convState.io.sign === CONV_STATE.PARA_SIGN) {
//        paraInstructionReg := paraInstruction
//        computeInstructionReg := computeInstructionReg
//    } elsewhen (convState.io.sign === CONV_STATE.COMPUTE_SIGN) {
//        paraInstructionReg := paraInstructionReg
//        computeInstructionReg := computeInstruction
//    } otherwise {
//        paraInstructionReg := paraInstructionReg
//        computeInstructionReg := computeInstructionReg
//    }

    val convCompute = new ConvCompute(convConfig)
    convCompute.io.startPa := Delay(para, 3)
    convCompute.io.startCu := Delay(compute, 3)

    convCompute.io.sFeatureFirstLayerData <> io.sFeatureFirstLayerData

    convCompute.io.channelIn := computeInstructionReg(CONV_STATE.CHANNEL_IN).asUInt.resized
    convCompute.io.channelOut := computeInstructionReg(CONV_STATE.CHANNEL_OUT).asUInt.resized
    convCompute.io.rowNumIn := computeInstructionReg(CONV_STATE.ROW_NUM_IN).asUInt.resized
    convCompute.io.colNumIn := computeInstructionReg(CONV_STATE.COL_NUM_IN).asUInt.resized
    convCompute.io.enPadding := computeInstructionReg(CONV_STATE.EN_PADDING).asBool
    convCompute.io.enActivation := computeInstructionReg(CONV_STATE.EN_ACTIVATION).asBool
    convCompute.io.zeroDara := computeInstructionReg(CONV_STATE.Z1).resized
    convCompute.io.zeroNum := computeInstructionReg(CONV_STATE.Z1_NUM).asUInt.resized
    convCompute.io.quanZeroData := computeInstructionReg(CONV_STATE.Z3).asUInt.resized
    convCompute.io.convType := computeInstructionReg(CONV_STATE.CONV_TYPE).resized
    convCompute.io.enStride := computeInstructionReg(CONV_STATE.EN_STRIDE)
    convCompute.io.firstLayer := computeInstructionReg(CONV_STATE.FIRST_LAYER)

//    convCompute.io.weightNum := paraInstructionReg(CONV_STATE.WEIGHT_NUM).asUInt.resized
    convCompute.io.weightNum := computeInstructionReg(CONV_STATE.WEIGHT_NUM).asUInt.resized
//    convCompute.io.quanNum := paraInstructionReg(CONV_STATE.QUAN_NUM).asUInt.resized
    convCompute.io.quanNum := computeInstructionReg(CONV_STATE.QUAN_NUM).asUInt.resized


    (convState.io.dmaReadValid & (!computeInstructionReg(CONV_STATE.FIRST_LAYER))) <> io.dmaReadValid
    (convState.io.dmaReadValid & (computeInstructionReg(CONV_STATE.FIRST_LAYER))) <> io.dmaFirstLayerReadValid
    convState.io.dmaWriteValid <> io.dmaWriteValid


    val writeComplete = Reg(Bool()) init(False)
    writeComplete.setWhen(io.introut)
    writeComplete.clearWhen(io.control === CONV_STATE.START_PA)

    val computeComplete = Reg(Bool()) init(False)
    computeComplete.setWhen(convCompute.io.computeComplete)
    computeComplete.clearWhen(io.control === CONV_STATE.START_PA)

    when(convCompute.io.copyWeightDone) {
        convState.io.complete := CONV_STATE.END_PA
    }elsewhen (writeComplete & computeComplete){
        convState.io.complete := CONV_STATE.END_CU
    } otherwise {
        convState.io.complete := 0
    }

    val dest = Reg(Bits(2 bits)) init 0
    when(io.control === CONV_STATE.START_PA) {
        dest := 0
    } elsewhen (io.control === CONV_STATE.START_CU) {
        dest := 1
    } otherwise {
        dest := dest
    }

    when(dest === 0) {
        io.sData <> convCompute.io.sParaData
        convCompute.io.sFeatureData.valid := False
        convCompute.io.sFeatureData.payload := 0
    } elsewhen (dest === 1) {
        io.sData <> convCompute.io.sFeatureData
        convCompute.io.sParaData.valid := False
        convCompute.io.sParaData.payload := 0
    } otherwise {
        io.sData.ready := False
        convCompute.io.sFeatureData.valid := False
        convCompute.io.sFeatureData.payload := 0
        convCompute.io.sParaData.valid := False
        convCompute.io.sParaData.payload := 0
    }
    io.mData <> convCompute.io.mFeatureData

}


object Conv {
    def main(args: Array[String]): Unit = {
        SpinalConfig(removePruned = true).generateVerilog(new Conv(ConvConfig(8, 8, 8, 12, 8192, 512, 416, 2048, 1)))
    }
}
