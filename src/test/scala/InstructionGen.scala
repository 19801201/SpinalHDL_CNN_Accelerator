//import TbCfg.LoadRom
//import conv.compute.{CONV_STATE, ConvConfig}
//import spinal.core._
//import spinal.core.sim._
//import spinal.lib.StreamFifo
//
//class InstructionGen(simConfig: ConvSimConfig, convConfig: ConvConfig) extends Component {
//    //    val weightNum = if (simConfig.convType == CONV_STATE.CONV33) simConfig.channelIn * simConfig.channelOut / convConfig.COMPUTE_CHANNEL_IN_NUM else simConfig.channelIn * simConfig.channelOut / (convConfig.COMPUTE_CHANNEL_IN_NUM * 8)
//    //    val quanNum = if (simConfig.convType == CONV_STATE.CONV33) (simConfig.weightMemDepth - weightNum * 9) / 3 else (simConfig.weightMemDepth - weightNum * 8) / 3
//
//    val weightNum = simConfig.convType match {
//        case CONV_STATE.CONV33 => simConfig.channelIn * simConfig.channelOut / convConfig.COMPUTE_CHANNEL_IN_NUM
//        case CONV_STATE.CONV11_8X => simConfig.channelIn * simConfig.channelOut / (convConfig.COMPUTE_CHANNEL_IN_NUM * 8)
//        case CONV_STATE.CONV11 => simConfig.channelIn * simConfig.channelOut / convConfig.COMPUTE_CHANNEL_IN_NUM
//        case _ => 0
//    }
//    val quanNum = simConfig.convType match {
//        case CONV_STATE.CONV33 => (simConfig.weightMemDepth - weightNum * 9) / 3
//        case CONV_STATE.CONV11_8X => (simConfig.weightMemDepth - weightNum * 8) / 3
//        case CONV_STATE.CONV11 => (simConfig.weightMemDepth - weightNum) / 3
//        case _ => 0
//    }
//
//    val in = Bits(32 * 5 bits) simPublic()
//    in := (CONV_STATE.ROW_NUM_IN -> B(simConfig.rowNumIn), CONV_STATE.COL_NUM_IN -> B(simConfig.colNumIn), CONV_STATE.CHANNEL_IN -> B(simConfig.channelIn),
//        CONV_STATE.CHANNEL_OUT -> B(simConfig.channelOut), CONV_STATE.EN_PADDING_LEFT -> simConfig.enPadding, CONV_STATE.EN_ACTIVATION -> simConfig.enActivation,
//        CONV_STATE.Z1 -> B(simConfig.zeroDara), CONV_STATE.Z3 -> B(simConfig.quanZeroData), CONV_STATE.CONV_TYPE -> B(simConfig.convType),
//        CONV_STATE.EN_STRIDE -> simConfig.enStride, CONV_STATE.FIRST_LAYER -> simConfig.firstLayer, CONV_STATE.QUAN_NUM -> B(quanNum), CONV_STATE.WEIGHT_NUM -> B(weightNum), CONV_STATE.AMEND -> B(simConfig.amend), default -> false)
//    val instruction = in.subdivideIn(5 slices) simPublic()
//
//}
//
//object InstructionGen extends App {
//    //    val simConfig = ConvSimConfig(416, 416, 32, 64, true, true, 68, 1, 68, CONV_STATE.CONV33, 2400, 692224, false, false, 1114133,"simData/all_weight_new.mem", "simData/test_416.mem")
//    //    val simConfig = ConvSimConfig(160, 160, 128, 128, true, true, 14, 1, 67, CONV_STATE.CONV11, 2240, 409600, false, false, 8914965,"simData/conv11/weight_rs1_conv4.mem", "simData/conv11/feature_real825_640_rs1_conv4_leak.mem")
//    //val simConfig = ConvSimConfig(640, 640, 8, 32, true, true, 0, 1, 68, CONV_STATE.CONV33, 336, 409600, true, true,8390805,"simData/player1.coe", "simData/quant(2).coe")
////    val simConfig = ConvSimConfig(104, 104, 64, 64, true, true, 17, 1, 88, CONV_STATE.CONV11, 304, 43264, false, false, 8388629, "simData/player1.coe", "simData/quant(2).coe")
//    val simConfig = ConvSimConfig(640, 640, 16, 32, true, true, 0, 1, 68, CONV_STATE.CONV33, 312, 409600/2, true, false, 800895, "simData/player1.coe", "simData/quant(2).coe")
//    val convConfig = ConvConfig(8, 16, 16, 12, 8192, 512, 640, 2048, 1)
//    //     val a = new  InstructionGen(simConfig, convConfig)
//    SpinalVerilog(new InstructionGen(simConfig, convConfig))
//    SimConfig.withWave.compile(new InstructionGen(simConfig, convConfig)).doSim {
//        dut =>
//            //            println(dut.instruction(0).toBigInt)
//            //            println(dut.instruction(1).toBigInt)
//            //            println(dut.instruction(2).toBigInt)
//            //            println(dut.instruction(3).toBigInt)
//            //            println(dut.instruction(4).toBigInt)
//            printf("%08x\n", dut.instruction(0).toBigInt)
//            printf("%08x\n", dut.instruction(1).toBigInt)
//            printf("%08x\n", dut.instruction(2).toBigInt)
//            printf("%08x\n", dut.instruction(3).toBigInt)
//            printf("%08x\n", dut.instruction(4).toBigInt)
//    }
//}
//
//
//class ShapeInstructionGen() extends Component {
//
//}
