package conv.compute

import conv.dataGenerate.DataGenerate
import spinal.core._
import spinal.lib._
import wa.xip.math.DSP
import wa.xip.memory.xpm.{FIFO_READ_MODE, MEM_TYPE, XPM_FIFO_SYNC_CONFIG}
import wa.{WaXpmSyncFifo, xAdd, xMul}

class ConvCompute(convConfig: ConvConfig) extends Component {

    val io = new Bundle {
        val startPa = in Bool()
        val startCu = in Bool()
        val sParaData = slave Stream UInt(convConfig.WEIGHT_S_DATA_WIDTH bits)
        val sFeatureData = slave Stream UInt(convConfig.FEATURE_S_DATA_WIDTH bits)
        val mFeatureData = master Stream UInt(convConfig.FEATURE_M_DATA_WIDTH bits)
        val mNormData = master(Stream(Vec(SInt(convConfig.addChannelTimesWidth bits), convConfig.COMPUTE_CHANNEL_OUT_NUM))) //调试使用
        val copyWeightDone = out Bool()

        val rowNumIn = in UInt (convConfig.FEATURE_WIDTH bits)
        val colNumIn = in UInt (convConfig.FEATURE_WIDTH bits)
        val channelIn = in UInt (convConfig.CHANNEL_WIDTH bits)
        val channelOut = in UInt (convConfig.CHANNEL_WIDTH bits)
        val enPadding = in Bool()
        val enActivation = in Bool()
        val zeroDara = in Bits (convConfig.dataGenerateConfig.DATA_WIDTH bits)
        val zeroNum = in UInt (convConfig.dataGenerateConfig.paddingConfig.ZERO_NUM_WIDTH bits)
        val weightNum = in UInt (log2Up(convConfig.WEIGHT_S_DATA_DEPTH) bits)
        val quanNum = in UInt (log2Up(convConfig.QUAN_S_DATA_DEPTH) bits)
        val quanZeroData = in UInt (8 bits)

        val convType = in Bits (2 bits)
    }
    noIoPrefix()

    val convType = Reg(Bits(2 bits))
    when(io.startPa) {
        convType := io.convType
    }

    val dataGenerate = new DataGenerate(convConfig.dataGenerateConfig)
    dataGenerate.io.sData <> io.sFeatureData
    dataGenerate.io.start <> io.startCu
    dataGenerate.io.rowNumIn <> io.rowNumIn
    dataGenerate.io.colNumIn <> io.colNumIn
    dataGenerate.io.channelIn <> io.channelIn
    dataGenerate.io.zeroDara <> io.zeroDara
    dataGenerate.io.zeroNum <> io.zeroNum
    dataGenerate.io.enPadding <> io.enPadding
    dataGenerate.io.convType <> convType

    val computeCtrl = ConvComputeCtrl(convConfig)
    computeCtrl.io.start <> io.startCu
    computeCtrl.io.colNumIn <> io.colNumIn
    computeCtrl.io.rowNumIn <> io.rowNumIn
    computeCtrl.io.channelIn <> io.channelIn
    computeCtrl.io.channelOut <> io.channelOut
    computeCtrl.io.activationEn <> io.enActivation

    /** *********************************************************** */
    computeCtrl.io.mDataReady <> io.mFeatureData.ready
    computeCtrl.io.mDataValid <> io.mFeatureData.valid

    /** *********************************************************** */
    computeCtrl.io.convType <> convType

    val loadWeight = LoadWeight(convConfig)
    loadWeight.io.sData <> io.sParaData
    loadWeight.io.start <> io.startPa
    (0 until convConfig.KERNEL_NUM).foreach { i =>
        loadWeight.io.weightRead(i).addr <> computeCtrl.io.weightReadAddr(i)
    }
    loadWeight.io.copyWeightDone <> io.copyWeightDone
    loadWeight.io.weightNum <> io.weightNum
    loadWeight.io.quanNum <> io.quanNum
    loadWeight.io.convType <> io.convType
    loadWeight.io.channelIn <> io.channelIn
    loadWeight.io.channelOut <> io.channelOut

    /** ******************************************************************* */
    loadWeight.io.shiftRead.addr := computeCtrl.io.shiftReadAddr
    loadWeight.io.scaleRead.addr := computeCtrl.io.scaleReadAddr
    loadWeight.io.biasRead.addr := computeCtrl.io.biasReadAddr
    /** ******************************************************************* */

    val sReady = Vec(Bool(), convConfig.KERNEL_NUM)
    val mReady = Vec(Bool(), convConfig.KERNEL_NUM)
    computeCtrl.io.sDataReady <> mReady(0)
    dataGenerate.io.mData.ready := sReady(0)
    val featureFifo = Array.tabulate(convConfig.KERNEL_NUM) { i =>
        def gen: WaXpmSyncFifo = {
            val fifo = WaXpmSyncFifo(XPM_FIFO_SYNC_CONFIG(MEM_TYPE.block, 0, FIFO_READ_MODE.fwft, convConfig.FEATURE_RAM_DEPTH, convConfig.FEATURE_S_DATA_WIDTH, convConfig.FEATURE_S_DATA_WIDTH))
            //val fifo = WaStreamFifo(UInt(convConfig.FEATURE_S_DATA_WIDTH bits), convConfig.FEATURE_RAM_DEPTH, computeCtrl.io.mCount, computeCtrl.io.sCount, sReady(i), mReady(i))
            if (convConfig.KERNEL_NUM == 9) {
                fifo.dataIn <> dataGenerate.io.mData.mData(i)
            }
            //            else {
            //                fifo.dataIn <> io.sFeatureData
            //            }
            //fifo.io.pop.valid <> computeCtrl.io.featureMemWriteValid
            fifo.rd_en <> computeCtrl.io.featureMemWriteReady
            fifo.sCount <> computeCtrl.io.sCount.resized
            fifo.mCount <> computeCtrl.io.mCount.resized
            fifo.sReady <> sReady(i)
            fifo.mReady <> mReady(i)
            fifo
        }

        gen
    }

    val featureMemOutData = Vec(UInt(convConfig.FEATURE_S_DATA_WIDTH bits), convConfig.KERNEL_NUM)
    val featureMem = Array.tabulate(convConfig.KERNEL_NUM) { i =>
        def gen = {
            //            val mem = new sdpram(convConfig.FEATURE_S_DATA_WIDTH,convConfig.FEATURE_MEM_DEPTH,convConfig.FEATURE_S_DATA_WIDTH,convConfig.FEATURE_MEM_DEPTH,MEM_TYPE.distributed,0,CLOCK_MODE.common_clock,this.clockDomain,this.clockDomain)
            //            mem.io.wea <> B"1'b1"
            //            mem.io.ena := featureFifo(i).rd_en
            //            mem.io.dina <> featureFifo(i).dout.asBits
            //            mem.io.addra <> computeCtrl.io.featureMemWriteAddr.asBits
            //            featureMemOutData(i) := mem.io.doutb.asUInt
            //            mem.io.addrb <> computeCtrl.io.featureMemReadAddr.asBits
            //            mem.io.enb <> True
            val mem = new Mem(UInt(convConfig.FEATURE_S_DATA_WIDTH bits), wordCount = convConfig.FEATURE_MEM_DEPTH)
            mem.write(computeCtrl.io.featureMemWriteAddr, featureFifo(i).dout, featureFifo(i).rd_en)
            featureMemOutData(i) := mem.readAsync(computeCtrl.io.featureMemReadAddr)
            mem
        }

        gen
    }
    val mulFeatureWeightData = Vec(Vec(Vec(UInt(convConfig.mulWeightWidth bits), convConfig.COMPUTE_CHANNEL_IN_NUM), convConfig.COMPUTE_CHANNEL_OUT_NUM / 2), convConfig.KERNEL_NUM)
    val mulFeatureWeight = Array.tabulate(convConfig.KERNEL_NUM, convConfig.COMPUTE_CHANNEL_OUT_NUM / 2, convConfig.COMPUTE_CHANNEL_IN_NUM)((i, j, k) => {
        def gen = {
            //提供了两种方式，第二种直接调用DSP IP，节省了资源
//            val mul = xMul(24, 8, convConfig.mulWeightWidth)
//            mul.io.A <> loadWeight.io.weightRead(i).data(((2 * j + 1) * convConfig.COMPUTE_CHANNEL_IN_NUM + k + 1) * 8 - 1 downto ((2 * j + 1) * convConfig.COMPUTE_CHANNEL_IN_NUM + k) * 8) @@ U"8'd0" @@ loadWeight.io.weightRead(i).data(((2 * j) * convConfig.COMPUTE_CHANNEL_IN_NUM + k + 1) * 8 - 1 downto ((2 * j) * convConfig.COMPUTE_CHANNEL_IN_NUM + k) * 8)
//            mul.io.B <> featureMemOutData(i)((k + 1) * 8 - 1 downto 8 * k)
//            mul.io.P <> mulFeatureWeightData(i)(j)(k)
            val mul = DSP("mulWeight",i==0)
            mul.a <> loadWeight.io.weightRead(i).data(((2 * j) * convConfig.COMPUTE_CHANNEL_IN_NUM + k + 1) * 8 - 1 downto ((2 * j) * convConfig.COMPUTE_CHANNEL_IN_NUM + k) * 8)
            mul.d <> loadWeight.io.weightRead(i).data(((2 * j + 1) * convConfig.COMPUTE_CHANNEL_IN_NUM + k + 1) * 8 - 1 downto ((2 * j + 1) * convConfig.COMPUTE_CHANNEL_IN_NUM + k) * 8)
            mul.b <> featureMemOutData(i)((k + 1) * 8 - 1 downto 8 * k)
            mul.p <> mulFeatureWeightData(i)(j)(k)
        }

        gen
    })
    val addKernelData = Vec(Vec(SInt(convConfig.addKernelWidth bits), convConfig.COMPUTE_CHANNEL_IN_NUM), convConfig.COMPUTE_CHANNEL_OUT_NUM / 2)
    val addKernel = Array.tabulate(convConfig.COMPUTE_CHANNEL_OUT_NUM / 2, convConfig.COMPUTE_CHANNEL_IN_NUM) { (i, j) =>
        def gen = {
            val add = xAdd(convConfig.mulWeightWidth, convConfig.addKernelWidth, convConfig.KERNEL_NUM).setName("addKernel")
            (0 until convConfig.KERNEL_NUM).foreach(k => {
                add.io.A(k) <> mulFeatureWeightData(k)(i)(j).asSInt
            }
            )
            add.io.S <> addKernelData(i)(j)
        }

        gen
    }


    val addChannelData = Vec(SInt(convConfig.addChannelInWidth bits), convConfig.COMPUTE_CHANNEL_OUT_NUM / 2)
    val addChannelIn = Array.tabulate(convConfig.COMPUTE_CHANNEL_OUT_NUM / 2) { i =>
        def gen = {
            val add = xAdd(convConfig.addKernelWidth, convConfig.addChannelInWidth, convConfig.COMPUTE_CHANNEL_IN_NUM)
            (0 until convConfig.COMPUTE_CHANNEL_IN_NUM).foreach(j => {
                add.io.A(j) <> addKernelData(i)(j)
            })
            add.io.S <> addChannelData(i)
        }

        gen
    }

    val addChannelTimesData = Vec(SInt(convConfig.addChannelTimesWidth bits), convConfig.COMPUTE_CHANNEL_OUT_NUM)
    val addChannelTimes = Array.tabulate(convConfig.COMPUTE_CHANNEL_OUT_NUM) { i =>
        def gen = {
            val add = xAdd(convConfig.addChannelInWidth / 2, convConfig.addChannelTimesWidth)
            add.io.A <> addChannelData(i / 2).subdivideIn(2 slices)(i % 2)
            add.io.S <> addChannelTimesData(i)
            add.io.init <> computeCtrl.io.normPreValid
        }

        gen
    }

    /** ************************************************************** */
    io.mNormData.valid <> computeCtrl.io.normValid
    (0 until convConfig.COMPUTE_CHANNEL_OUT_NUM).foreach(i => {
        io.mNormData.payload(i) <> addChannelTimesData(i)
    })

    /** ************************************************************** */

    val quan = new Quan(convConfig)
    quan.io.dataIn <> addChannelTimesData
    quan.io.biasIn <> loadWeight.io.biasRead.data
    quan.io.scaleIn <> loadWeight.io.scaleRead.data
    quan.io.shiftIn <> loadWeight.io.shiftRead.data
    quan.io.zeroIn <> io.quanZeroData
    quan.io.dataOut <> io.mFeatureData.payload
    quan.io.activationEn <> io.enActivation

}

object ConvCompute extends App {
    SpinalVerilog(new ConvCompute(ConvConfig(8, 8, 8, 12, 8192, 512, 416, 2048, 1, ConvType.conv33)))
}
