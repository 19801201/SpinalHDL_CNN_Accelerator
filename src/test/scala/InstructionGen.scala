import TbCfg.LoadRom
import conv.compute.{CONV_STATE, ConvConfig}
import spinal.core._
import spinal.core.sim._
import spinal.lib.StreamFifo

class InstructionGen(simConfig: ConvSimConfig, convConfig: ConvConfig) extends Component {
    val weightNum = if (simConfig.convType == CONV_STATE.CONV33) simConfig.channelIn * simConfig.channelOut / convConfig.COMPUTE_CHANNEL_IN_NUM else simConfig.channelIn * simConfig.channelOut / (convConfig.COMPUTE_CHANNEL_IN_NUM * 8)
    val quanNum = if (simConfig.convType == CONV_STATE.CONV33) (simConfig.weightMemDepth - weightNum * 9) / 3 else (simConfig.weightMemDepth - weightNum * 8) / 3

    val in = Bits(32 * 5 bits) simPublic()
    in := (CONV_STATE.ROW_NUM_IN -> B(simConfig.rowNumIn), CONV_STATE.COL_NUM_IN -> B(simConfig.colNumIn), CONV_STATE.CHANNEL_IN -> B(simConfig.channelIn),
        CONV_STATE.CHANNEL_OUT -> B(simConfig.channelOut), CONV_STATE.EN_PADDING -> simConfig.enPadding, CONV_STATE.EN_ACTIVATION -> simConfig.enActivation,
        CONV_STATE.Z1 -> B(simConfig.zeroDara), CONV_STATE.Z1_NUM -> B(simConfig.zeroNum), CONV_STATE.Z3 -> B(simConfig.quanZeroData), CONV_STATE.CONV_TYPE -> B(simConfig.convType),
        CONV_STATE.EN_STRIDE -> simConfig.enStride, CONV_STATE.FIRST_LAYER -> simConfig.firstLayer, CONV_STATE.QUAN_NUM -> B(quanNum), CONV_STATE.WEIGHT_NUM -> B(weightNum), CONV_STATE.AMEND->B(simConfig.amend),default -> false)
    val instruction = in.subdivideIn(5 slices) simPublic()

}

object InstructionGen extends App {
//    val simConfig = ConvSimConfig(416, 416, 32, 64, true, true, 68, 1, 68, CONV_STATE.CONV33, 2400, 692224, false, false, 1114133,"simData/all_weight_new.mem", "simData/test_416.mem")
    val simConfig = ConvSimConfig(160, 160, 128, 128, true, true, 14, 1, 67, CONV_STATE.CONV11, 2240, 409600, false, false, 8914965,"simData/conv11/weight_rs1_conv4.mem", "simData/conv11/feature_real825_640_rs1_conv4_leak.mem")
//        val simConfig = ConvSimConfig(160, 160, 64, 64, true, true, 68, 1, 70, CONV_STATE.CONV33, 4704, 204800, false, false,1114133,"simData/conv3/conv3_weight.coe", "simData/conv3/out_api_conv2_leak_stride2.coe")
    val convConfig = ConvConfig(8, 8, 8, 12, 8192, 512, 416, 2048, 1)
    //     val a = new  InstructionGen(simConfig, convConfig)
    SpinalVerilog(new InstructionGen(simConfig, convConfig))
    SimConfig.withWave.compile(new InstructionGen(simConfig, convConfig)).doSim {
        dut =>
            println(dut.instruction(0).toBigInt)
            println(dut.instruction(1).toBigInt)
            println(dut.instruction(2).toBigInt)
            println(dut.instruction(3).toBigInt)
            println(dut.instruction(4).toBigInt)
    }
}


class ShapeInstructionGen() extends Component{

}
