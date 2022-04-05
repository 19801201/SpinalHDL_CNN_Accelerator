import spinal.core._
import conv.compute._
import spinal.lib._
import wa.xip.memory.xpm._

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
        val para = out Bool()
        val control = out Bits (4 bits)
        val state = in Bits (4 bits)
        val instruction = out Vec(Bits(32 bits), 3)
        val mData = in UInt (convConfig.FEATURE_M_DATA_WIDTH bits)
        val mDataValid = in Bool()
        val clk_o = out Bool()
        val rst_o = out Bool()
    }
    noIoPrefix()
    val simPara = SimPara(simConfig)
    setInlineVerilog {
        s"""
        module SimInit (
              output            clk_o                       ,
              output            rst_o                       ,
              input             [3:0]  state              ,
              input             [${convConfig.FEATURE_M_DATA_WIDTH - 1}:0]  mData              ,
              input                    mDataValid         ,
              output   reg      [31:0] instruction_0      ,
              output   reg      [31:0] instruction_1      ,
              output   reg      [31:0] instruction_2      ,
              output   reg             para               ,
              output   reg      [3:0]  control
          );
          reg reset;
          reg clk;
          assign clk_o = clk;
          assign rst_o = reset;
            initial begin
                clk = 1'b0;
                reset = 1'b1;
                #20
                reset = 1'b0;
                para = 1'b1;
                control = 4'b0001;
                instruction_0 = 32'b00000000_00010000_00000001_00000000;
                instruction_1 = 32'b00000000_00000000_00000000_00000000;
                instruction_2 = 32'b00000000_00000000_00000000_00000000;
                #10
                control = 4'b0000;
                while(state != 4'b1111)begin
                #10;
                end
                #10
                control = 4'b1111;
                #100
                control = 4'b0010;
                instruction_0 = 32'b${simPara.computeInstruction0};
                instruction_1 = 32'b${simPara.computeInstruction1};
                instruction_2 = 32'b${simPara.computeInstruction2};
                para = 1'b0;
                while(state != 4'b1111)begin
                    #10;
                end
                #10
                control = 4'b1111;
                #100
                $$stop;
            end
            always #5 clk = ~clk;
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

class test extends Component {
    val b = Reg(UInt(8 bits))
    val a = RegNext(b)
}

class TbConv(simConfig: SimConfig, convConfig: ConvConfig) extends Component {

    val simInit = SimInit(simConfig, convConfig)
    val clk = new ClockingArea(clockDomain = ClockDomain(clock = simInit.io.clk_o, reset = simInit.io.rst_o)) {
        val conv = new Conv(convConfig)
        conv.io.control <> simInit.io.control
        conv.io.state <> simInit.io.state
        conv.io.instruction <> simInit.io.instruction
        conv.io.introut := False
//        val feature = new sprom(convConfig.FEATURE_S_DATA_WIDTH, simConfig.featureMemDepth, MEM_TYPE.distributed, 0, simConfig.featureMemFileName).setDefinitionName("feature")
//        val weight = new sprom(convConfig.FEATURE_S_DATA_WIDTH, simConfig.weightMemDepth, MEM_TYPE.distributed, 0, simConfig.weightMemFileName).setDefinitionName("weight")
        val weight = new Rom(convConfig.FEATURE_S_DATA_WIDTH,scala.math.pow(2,log2Up(simConfig.weightMemDepth)).toInt,simConfig.weightMemFileName)
        val feature = new Rom(convConfig.FEATURE_S_DATA_WIDTH,scala.math.pow(2,log2Up(simConfig.featureMemDepth)).toInt,simConfig.featureMemFileName)

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

        when(simInit.io.para) {
            conv.io.sData <> paraData
            featureData.ready := False
        } otherwise {
            conv.io.sData <> featureData
            paraData.ready := False
        }
        simInit.io.mData <> conv.io.mData.payload
        simInit.io.mDataValid <> conv.io.mData.valid
        conv.io.mData.ready := True
    }

}

object TbConv extends App {
    val simConfig = SimConfig(416, 416, 32, 64, true, true, 68, 1, 68, CONV_STATE.CONV33, 2400, 692224, "simData/all_weight_new.mem", "simData/test_416.mem")
    val convConfig = ConvConfig(8, 8, 8, 12, 8192, 512, 416, 2048, 1)
    SpinalConfig(defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new TbConv(simConfig, convConfig))
    //    SpinalVerilog(new TbConv)
}

