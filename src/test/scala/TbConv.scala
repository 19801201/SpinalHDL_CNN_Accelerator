import spinal.core._
import conv.compute._
import spinal.lib._
import spinal.lib.fsm._

import scala.language.implicitConversions


case class SimConfig(rowNumIn: Int,
                     colNumIn: Int,
                     channelIn: Int,
                     channelOut: Int,
                     enPadding: Boolean,
                     enActivation: Boolean,
                     zeroDara: Int,
                     zeroNum: Int,
                     quanZeroData: Int,
                     convType: Int = CONV_STATE.CONV33,
                     weightMemDepth: Int,
                     featureMemDepth: Int,
                     enStride: Boolean,
                     weightMemFileName: String,
                     featureMemFileName: String
                    ) {

}


case class SimPara(simConfig: SimConfig) {

    implicit def BooleanToInt(a: Boolean) = {
        if (a) {
            1
        } else {
            0
        }
    }

    val rowNumIn = Util.toBinString(simConfig.rowNumIn, CONV_STATE.ROW_NUM_IN.length)
    val colNumIn = Util.toBinString(simConfig.colNumIn, CONV_STATE.COL_NUM_IN.length)
    val channelIn = Util.toBinString(simConfig.channelIn, CONV_STATE.CHANNEL_IN.length)
    val channelOut = Util.toBinString(simConfig.channelOut, CONV_STATE.CHANNEL_OUT.length)
    val enPadding = Util.toBinString(simConfig.enPadding, CONV_STATE.EN_PADDING.length)
    val enActivation = Util.toBinString(simConfig.enActivation, CONV_STATE.EN_ACTIVATION.length)
    val zeroDara = Util.toBinString(simConfig.zeroDara, CONV_STATE.Z1.length)
    val zeroNum = Util.toBinString(simConfig.zeroNum, CONV_STATE.Z1_NUM.length)
    val quanZeroData = Util.toBinString(simConfig.quanZeroData, CONV_STATE.Z3.length)
    val convType = Util.toBinString(simConfig.convType, CONV_STATE.CONV_TYPE.length)
    val computeInstruction0 = channelIn + colNumIn + rowNumIn
    val computeInstruction1 = 0 + quanZeroData + zeroNum + zeroDara + enActivation + enPadding + channelOut
    val computeInstruction2 = Util.toBinString(0, 30) + convType

}

case class SimInit(simConfig: SimConfig, convConfig: ConvConfig) extends BlackBox {
    val io = new Bundle {
        //        val para = out Bool()
        //        val control = out Bits (4 bits)
        //        val state = in Bits (4 bits)
        //        val instruction = out Vec(Bits(32 bits), 3)
        val mData = in UInt (convConfig.FEATURE_M_DATA_WIDTH bits)
        val mDataValid = in Bool()
        //        val clk_o = out Bool()
        //        val rst_o = out Bool()
        val clk = in Bool()
    }
    noIoPrefix()
    mapClockDomain(clock = io.clk)
    val simPara = SimPara(simConfig)
    setInlineVerilog {
        s"""
        module SimInit (
//              output            clk_o                       ,
//              output            rst_o                       ,
              input             [3:0]  state              ,
              input             [${convConfig.FEATURE_M_DATA_WIDTH - 1}:0]  mData              ,
              input                    mDataValid         ,
//              output   reg      [31:0] instruction_0      ,
//              output   reg      [31:0] instruction_1      ,
//              output   reg      [31:0] instruction_2      ,
//              output   reg             para               ,
//              output   reg      [3:0]  control
              input clk
          );
//          reg reset;
//          reg clk;
//          assign clk_o = clk;
//          assign rst_o = reset;
//            initial begin
//                clk = 1'b0;
//                reset = 1'b1;
//                #20
//                reset = 1'b0;
//                para = 1'b1;
//                control = 4'b0001;
//                instruction_0 = 32'b00000000_00010000_00000001_00000000;
//                instruction_1 = 32'b00000000_00000000_00000000_00000000;
//                instruction_2 = 32'b00000000_00000000_00000000_00000000;
//                #10
//                control = 4'b0000;
//                while(state != 4'b1111)begin
//                #10;
//                end
//                #10
//                control = 4'b1111;
//                #100
//                control = 4'b0010;
//                instruction_0 = 32'b${simPara.computeInstruction0};
//                instruction_1 = 32'b${simPara.computeInstruction1};
//                instruction_2 = 32'b${simPara.computeInstruction2};
//                para = 1'b0;
//                while(state != 4'b1111)begin
//                    #10;
//                end
//                #10
//                control = 4'b1111;
//                #100
//                $$stop;
//            end
//            always #5 clk = ~clk;
            integer mFeature_data;
            initial
            begin
                mFeature_data=$$fopen("mData.txt");

            end
            always@(posedge clk)begin
                if(mDataValid)
                    $$fwrite(mFeature_data,"%h\\n",mData);
            end
        endmodule
        """.stripMargin
    }
}

/**
 *
 * @param simConfig  仿真参数
 * @param convConfig 加速器参数
 *
 *
 *                   提供两种仿真方式：
 *                   1.和我们以前一样，手动配置寄存器，在initial begin里面根据state控制control信号完成仿真，这个利用了BlackBox的inline功能，将以前verilog写的TB内嵌进来，可参考被注释掉的内容
 *
 *                   2.采用状态机的方式进行仿真，寄存器采用spinalHDL的Bits进行封装。在生成的仿真代码之后，会引出clk和reset信号，需要我们进行配置
 *                   建议采用这种方式进行仿真，因为不需要我们手动去配置寄存器，避免出错。如果寄存器的位宽或位置需要改变只需要在CONV_STATE中进行改变即可，在仿真文件中不需要手动更新
 *                   所有的寄存器位宽或位置会自动完成匹配
 */

class TbConv(simConfig: SimConfig, convConfig: ConvConfig) extends Component {

    //    val simInit = SimInit(simConfig, convConfig)
    //    val clk = new ClockingArea(clockDomain = ClockDomain(clock = simInit.io.clk_o, reset = simInit.io.rst_o)) {
    //        val conv = new Conv(convConfig)
    //        conv.io.control <> simInit.io.control
    //        conv.io.state <> simInit.io.state
    //        conv.io.instruction <> simInit.io.instruction
    //        conv.io.introut := False
    ////        val feature = new sprom(convConfig.FEATURE_S_DATA_WIDTH, simConfig.featureMemDepth, MEM_TYPE.distributed, 0, simConfig.featureMemFileName).setDefinitionName("feature")
    ////        val weight = new sprom(convConfig.FEATURE_S_DATA_WIDTH, simConfig.weightMemDepth, MEM_TYPE.distributed, 0, simConfig.weightMemFileName).setDefinitionName("weight")
    //        val weight = new Rom(convConfig.FEATURE_S_DATA_WIDTH,scala.math.pow(2,log2Up(simConfig.weightMemDepth)).toInt,simConfig.weightMemFileName)
    //        val feature = new Rom(convConfig.FEATURE_S_DATA_WIDTH,scala.math.pow(2,log2Up(simConfig.featureMemDepth)).toInt,simConfig.featureMemFileName)
    //
    //        val paraData = Stream(UInt(convConfig.FEATURE_S_DATA_WIDTH bits))
    //        val featureData = Stream(UInt(convConfig.FEATURE_S_DATA_WIDTH bits))
    //        paraData.valid.setAsReg() init (False) assignFromBits (B"1'b1")
    //        featureData.valid.setAsReg() init (False) assignFromBits (B"1'b1")
    //        paraData.payload := weight.io.data
    //        featureData.payload := feature.io.data
    //        val paraAddr = Counter(simConfig.weightMemDepth, inc = paraData.fire) init (0)
    //        val featureAddr = Counter(simConfig.featureMemDepth, inc = featureData.fire) init (0)
    //        weight.io.addr <> paraAddr
    //        feature.io.addr <> featureAddr
    //
    //        when(simInit.io.para) {
    //            conv.io.sData <> paraData
    //            featureData.ready := False
    //        } otherwise {
    //            conv.io.sData <> featureData
    //            paraData.ready := False
    //        }
    //        simInit.io.mData <> conv.io.mData.payload
    //        simInit.io.mDataValid <> conv.io.mData.valid
    //        conv.io.mData.ready := True
    //    }


    val simInit = SimInit(simConfig, convConfig)

    val conv = new Conv(convConfig)
    val weight = new Rom(convConfig.FEATURE_S_DATA_WIDTH, scala.math.pow(2, log2Up(simConfig.weightMemDepth)).toInt, simConfig.weightMemFileName)
    val feature = new Rom(convConfig.FEATURE_S_DATA_WIDTH, scala.math.pow(2, log2Up(simConfig.featureMemDepth)).toInt, simConfig.featureMemFileName)

    val paraData = Stream(UInt(convConfig.FEATURE_S_DATA_WIDTH bits))
    val featureData = Stream(UInt(convConfig.FEATURE_S_DATA_WIDTH bits))
    paraData.valid.setAsReg() init (False) assignFromBits (B"1'b1")
    featureData.valid.setAsReg() init (False) assignFromBits (B"1'b1")
    paraData.payload := weight.io.data
    featureData.payload := feature.io.data
    val paraAddr = Counter(simConfig.weightMemDepth, inc = paraData.fire) init (0)
    val featureAddr = Counter(simConfig.featureMemDepth, inc = featureData.fire) init (0)
    weight.io.addr <> paraAddr
    feature.io.addr <> featureAddr

    val instruction = Bits(32 * 3 bits)
    instruction := 0

    conv.io.instruction <> instruction.subdivideIn(32 bits)
    conv.io.mData.ready <> True
    conv.io.mData.payload <> simInit.io.mData
    conv.io.mData.valid <> simInit.io.mDataValid

    conv.io.introut := False

    featureData.ready := False
    paraData.ready := False
    conv.io.sData.valid := False
    conv.io.sData.payload := 0
    conv.io.control := 0

    val fsm = new StateMachine {
        val IDLE = new State() with EntryPoint
        val WEIGHT = new State()
        val WEIGHT_IRQ = new State()
        val FEATURE = new State()
        val FEATURE_IRQ = new State()

        val start = Reg(Bool()) init (False)
        start := True


        val weightNum = if (simConfig.convType == CONV_STATE.CONV33) simConfig.channelIn * simConfig.channelOut / convConfig.COMPUTE_CHANNEL_IN_NUM else simConfig.channelIn * simConfig.channelOut / (convConfig.COMPUTE_CHANNEL_IN_NUM * 8)
        val quanNum = if (simConfig.convType == CONV_STATE.CONV33) (simConfig.weightMemDepth - weightNum * 9) / 3 else (simConfig.weightMemDepth - weightNum * 8) / 3

        val add = Reg(Bool()) init (False)
        IDLE.whenIsActive {
            when(start) {
                goto(WEIGHT)
            }
        }
        WEIGHT.onEntry(conv.io.control := B"4'b0001")
            .whenIsActive {
                instruction := (CONV_STATE.WEIGHT_NUM -> B(weightNum), CONV_STATE.QUAN_NUM -> B(quanNum), default -> false)
                conv.io.sData <> paraData
                featureData.ready := False
                when(conv.io.state === B"4'b1111") {
                    goto(WEIGHT_IRQ)
                }
            }
        WEIGHT_IRQ.onEntry(add := False)
            .whenIsActive {
                when(conv.io.state === B"4'b1111") {
                    conv.io.control := B"4'b1111"
                    add := True
                } otherwise {
                    conv.io.control := B"4'b0000"
                    add := False
                }
                when(add) {
                    when(conv.io.state =/= B"4'b1111") {
                        add := False
                        goto(FEATURE)
                    }
                }
            }
        FEATURE.onEntry(conv.io.control := B"4'b0010")
            .whenIsActive {
                instruction := (CONV_STATE.ROW_NUM_IN -> B(simConfig.rowNumIn), CONV_STATE.COL_NUM_IN -> B(simConfig.colNumIn), CONV_STATE.CHANNEL_IN -> B(simConfig.channelIn),
                    CONV_STATE.CHANNEL_OUT -> B(simConfig.channelOut), CONV_STATE.EN_PADDING -> simConfig.enPadding, CONV_STATE.EN_ACTIVATION -> simConfig.enActivation,
                    CONV_STATE.Z1 -> B(simConfig.zeroDara), CONV_STATE.Z1_NUM -> B(simConfig.zeroNum), CONV_STATE.Z3 -> B(simConfig.quanZeroData), CONV_STATE.CONV_TYPE -> B(simConfig.convType), CONV_STATE.EN_STRIDE -> simConfig.enStride, default -> false)
                conv.io.sData <> featureData
                paraData.ready := False
                when(conv.io.state === B"4'b1111") {
                    goto(FEATURE_IRQ)
                }
            }
        FEATURE_IRQ.onEntry(add := False)
            .whenIsActive {
                when(conv.io.state === B"4'b1111") {
                    conv.io.control := B"4'b1111"
                    add := True
                } otherwise {
                    conv.io.control := B"4'b0000"
                    add := False
                }
                when(add) {
                    when(conv.io.state =/= B"4'b1111") {
                        add := False
                        goto(IDLE)
                    }
                }
            }
            .onExit {
                conv.io.introut := True
            }

    }


}

object TbConv extends App {
    val simConfig = SimConfig(416, 416, 32, 64, true, true, 68, 1, 68, CONV_STATE.CONV33, 2400, 692224, false, "simData/all_weight_new.mem", "simData/test_416.mem")
    val convConfig = ConvConfig(8, 8, 8, 12, 8192, 512, 416, 2048, 1)
    SpinalConfig(defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new TbConv(simConfig, convConfig))
    //    SpinalVerilog(new TbConv)
}

