//import TbCfg.{AxiLite4Bus, SimConfig, SimType}
//import config.Config._
//import conv.compute.{CONV_STATE, ConvConfig}
//import shape.ShapeConfig
//import spinal.core._
//import spinal.lib.bus.amba4.axilite._
//import spinal.lib.fsm._
//
//class TbNpu(simConfig: SimConfig, convConfig: ConvConfig, shapeConfig: ShapeConfig
//           ) extends Component {
//
//    val regBus = AxiLite4(log2Up(registerAddrSize), 32)
//
//    val regFactory =  AxiLite4Bus(regBus)
//    val npu = new Npu(convConfig, shapeConfig)
//
//    val fsm = new StateMachine {
//        val IDLE = new State() with EntryPoint
//        val WEIGHT_CFG = if (simConfig.simType == SimType.CONV) new State() else null
//        val WEIGHT = if (simConfig.simType == SimType.CONV) new State() else null
//        val WEIGHT_IRQ = if (simConfig.simType == SimType.CONV) new State() else null
//        val FEATURE = new State()
//        val FEATURE_IRQ = new State()
//
//        val start = Reg(Bool()) init (False)
//        start := True
//
//        IDLE.whenIsActive {
//            when(start) {
//                regFactory.reset()
//                if (simConfig.simType == SimType.CONV) {
//                    goto(WEIGHT_CFG)
//                } else {
//
//                }
//            }
//        }
//        if (simConfig.simType == SimType.CONV) {
//            val weightNum = if (simConfig.convType == CONV_STATE.CONV33) simConfig.channelIn * simConfig.channelOut / convConfig.COMPUTE_CHANNEL_IN_NUM else simConfig.channelIn * simConfig.channelOut / (convConfig.COMPUTE_CHANNEL_IN_NUM * 8)
//            val quanNum = if (simConfig.convType == CONV_STATE.CONV33) (simConfig.weightMemDepth - weightNum * 9) / 3 else (simConfig.weightMemDepth - weightNum * 8) / 3
//            val convWeightReg = B(32 bits, CONV_STATE.WEIGHT_NUM -> B(weightNum), CONV_STATE.QUAN_NUM -> B(quanNum), default -> false)
//            WEIGHT_CFG.whenIsActive {
//                regFactory.write(convWeightReg, 0x10)
//                regFactory.write(0x10)
//            }
//        }
//
//    }
//
//}
