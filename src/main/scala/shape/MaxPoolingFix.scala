package shape

import spinal.core._
import spinal.lib._
import wa.{WaAddrIncCtr, WaCounter, WaStreamFifo}
import spinal.core.sim._
import spinal.lib.fsm._

/**
 * 生成计算可配置卷积核大小，步长为1，无padding的MaxPooling算子
 * @param DATA_WIDTH 数据位宽
 * @param COMPUTE_CHANNEL_NUM 计算的通道数量
 * @param FEATURE 特征图大小
 * @param CHANNEL_WIDTH 通道位宽
 *
 * 尝试使用不使用储存器的反压，当下级的ready无效时，让每个寄存器的数据都锁存住。
 * 为了消除气泡，当下级的ready无效时，如果本寄存器中没有有效数据，那么本寄存器的ready有效。
 * 更新1：支持根据不同的输入来配置k的大小。
 * 当k<=1时不支持，k=2时让k每次从第一的col和row得到的结果输出即可，当k=3时让col和row从第二个col和row输出结果。
 * 为了方便k==i时，计算k为i+2的maxPool。
 * 需要调整两部分内容，第一部分是数据通路需要调整MEM输出的通路，第二部分是valid信号拉高的条件需要调整，根据不同的k在不同的时机拉高。
 * 更新2：支持根据不同的输入来配置s的大小。
 * 当strideNum为i时，s为i+1。
 */
case class MaxPoolingFixConfig(DATA_WIDTH: Int, COMPUTE_CHANNEL_NUM: Int, FEATURE: Int, CHANNEL_WIDTH: Int) {
    val kernelSize = 5  //配置K的大小。当前最大为5最小为2，修改kernelNum的数量以支持更大的k。
    val MAX_CHANNEL_NUM = 1024//最大支持的通道数量,最小的通道数量不能小于COMPUTE_CHANNEL_NUM * 2，否则地址计数可能会出错
    val MAX_COL_NUM = 24
    val STREAM_DATA_WIDTH = DATA_WIDTH * COMPUTE_CHANNEL_NUM
    val FEATURE_WIDTH = log2Up(FEATURE)
    val channelMemDepth = MAX_CHANNEL_NUM / COMPUTE_CHANNEL_NUM
    val channelMemWidth = FEATURE_WIDTH
    val rowMemDepth = MAX_CHANNEL_NUM / COMPUTE_CHANNEL_NUM * MAX_COL_NUM
    val enStride = false
}

case class MaxPoolingFix(maxPoolingFixConfig: MaxPoolingConfig)extends Component {
    val io = new Bundle {
        val sData = slave Stream (UInt(maxPoolingFixConfig.STREAM_DATA_WIDTH bits))
        val mData = master Stream (UInt(maxPoolingFixConfig.STREAM_DATA_WIDTH bits))
        val start = in Bool()
        val channelIn = in UInt (maxPoolingFixConfig.CHANNEL_WIDTH bits)
        val rowNumIn = in UInt (maxPoolingFixConfig.FEATURE_WIDTH bits)
        val colNumIn = in UInt (maxPoolingFixConfig.FEATURE_WIDTH bits)
        val kernelNum = in UInt (3 bits)//最大支持3bits。这个数据线给出的数如果大于原本kernelSize的最大值得到的结果是错误的。
        val strideNum = if(maxPoolingFixConfig.enStride) in UInt (3 bits) else null
    }
    //流水线控制模块
    val valid = Vec(Reg(Bool()) init(False), 5)
    val ready,fire = Vec(Bool(), 5)

    val delaySData1 = Delay(io.sData.payload, 1, fire(0))

    val computeChannelTimes = io.channelIn >> log2Up(maxPoolingFixConfig.COMPUTE_CHANNEL_NUM)

    val flowEn = History(io.sData.fire, 4, init = False)
    val RowEndNum = computeChannelTimes * io.colNumIn
    //行MEM地址和列MEM地址
    /***********************地址控制模块模块*/
//    val rdRowAddrCnt = WaCounter(fire(0), log2Up(maxPoolingFixConfig.rowMemDepth), RowEndNum)
//    val rdColAddrCnt = WaCounter(fire(0), log2Up(maxPoolingFixConfig.channelMemDepth), computeChannelTimes)
    val rdRowAddrCnt = WaAddrIncCtr(log2Up(maxPoolingFixConfig.rowMemDepth), fire(0), RowEndNum);
    val rdColAddrCnt = WaAddrIncCtr(log2Up(maxPoolingFixConfig.channelMemDepth), fire(0), computeChannelTimes);
    val rdColAddr = rdColAddrCnt.count//下个周期开始读写
    val rdRowAddr = Delay(rdRowAddrCnt.count, 1, fire(0))
    val delayRdColAddr1 = Delay(rdColAddr, 1, fire(0))
    val delayRdColAddr2 = Delay(delayRdColAddr1, 1, fire(1))
    val delayRdColAddr3 = Delay(delayRdColAddr2, 1, fire(2))
    val wrColAddr = delayRdColAddr3
    val delayRdRowAddr1 = Delay(rdRowAddr, 1, fire(1))
    val delayRdRowAddr2 = Delay(delayRdRowAddr1, 1, fire(2))
    val delayRdRowAddr3 = Delay(delayRdRowAddr2, 1, fire(3))
    val wrRowAddr = delayRdRowAddr3
    /***********************状态机模块*/
    // IDLE状态 无法接收数据 无论valid是什么 都拒绝接收 S ready为0 M valid为0
    // 接收到start信号,ready拉高，开始接受数据 调整到wait_ROW状态等待kernelSize-1行数据之后
    // 每接收到一个数据，通道，行，列计数器开始计算。并将数据是否有效的计算结果传递到mdata.valid。
    // wait_ROW:状态等待行计MEM填充满    ROW 》 kernelSize
    // wait_COL:等待列MEM数据恢复正常
    // valid：数据是正常有效的，这时valid才可以为高。VALID状态下，只有行数大于等于Kernel Size - 1，列数也大于Kernel Size-1才 最后一级流水的输出才是有效的
    // END：系统恢复初始化的状态。
    val fsm = new StateMachine{
        val IDLE = new State with EntryPoint
        //        val WAIT_ROW = new State
        //        val WAIT_COL = new State
        val VALID = new State
        val END = new State

        val channelCnt = WaCounter(fire(4), maxPoolingFixConfig.CHANNEL_WIDTH, computeChannelTimes - 1, (1 << maxPoolingFixConfig.CHANNEL_WIDTH) - 1)
        val colCnt = WaCounter(channelCnt.valid && fire(4), maxPoolingFixConfig.FEATURE_WIDTH, io.colNumIn - 1)
        val rowCnt = WaCounter(colCnt.valid && channelCnt.valid && fire(4), maxPoolingFixConfig.FEATURE_WIDTH, io.rowNumIn - 1)
        //流水线最后一个数据接收到的位置，根据这个位置判断当前计算结果是否满足需求

        IDLE
          .whenIsActive{
              when(io.start.rise()){
                  goto(VALID)
              }
          }
        //colCnt.count >= U(maxPoolingFixConfig.kernelSize - 1, log2Up(maxPoolingFixConfig.kernelSize - 1) bits)
        VALID
          .whenIsActive {
              when(channelCnt.valid & colCnt.valid & rowCnt.valid & io.mData.fire) {
                  goto(END)
              }
          }

        END
          .whenIsActive {
              goto(IDLE)
              channelCnt.clear
              colCnt.clear
              rowCnt.clear
          }
    }
    /***********************stride舍弃模块模块*/
    val dataValid1 = fsm.colCnt.count > io.kernelNum & fsm.rowCnt.count > io.kernelNum
    val strideCol = if(maxPoolingFixConfig.enStride) {
        WaCounter(fsm.channelCnt.valid && fire(4) && dataValid1, maxPoolingFixConfig.FEATURE_WIDTH, io.strideNum)
    } else {
        null
    }
    val strideRow = if(maxPoolingFixConfig.enStride) {
        WaCounter(fsm.colCnt.valid && fsm.channelCnt.valid && fire(4) && dataValid1, maxPoolingFixConfig.FEATURE_WIDTH, io.strideNum)
    } else {
        null
    }
    val strideValid = if(maxPoolingFixConfig.enStride) {
        when((strideRow.valid && fsm.channelCnt.valid && fire(4))){
            strideCol.clear
        }
        when(fsm.isActive(fsm.END)){
            strideCol.clear
            strideRow.clear
        }
        !strideCol.count.orR & !strideRow.count.orR
    } else {
        True
    }
    /***********************有效数据监测模块*/
    //val dataValid = fsm.colCnt.count >= U(maxPoolingFixConfig.kernelSize - 1, log2Up(maxPoolingFixConfig.kernelSize) bits) &
    //  fsm.rowCnt.count >= U(maxPoolingFixConfig.kernelSize - 1, log2Up(maxPoolingFixConfig.kernelSize) bits)
    //修改为根据io.kernelNum来判断数据是否有效
    val dataValid = dataValid1 & strideValid
    //这种情况下数据有效
    //数据无效的时候不需要下级模块结束 因此 io.MData.ready必须为1，让数据正常流出，io.MData.valid必须为0
    //VALID状态下，对于下级模块来说，VALID有效的条件为dataValid有效，并且第五级流水的数据真实有效。
    //ready状态，对于上级模块来说，ready应该在dataValid无效的情况下一直有效，让数据可以流出。

    /***********************流水线反压控制模块*/
    //流水线反压控制模块
    io.sData.ready := ready(0) //在VALID状态下才能够接受数据。
    io.mData.valid := valid(4) && dataValid // 当前模块的数据有效，并且数据是有意义的。
    //下一级无数据或者下一级准备好了
    val flowLineCtr = Array.tabulate(5)((i)=> {
        def gen() = {
            when(ready(i)){
                if(i != 0)
                    valid(i) := valid(i-1)
                else
                    valid(i) := io.sData.valid
            }

            if(i < 4) { //ready的结构
                ready(i) := !valid(i) | ready(i + 1)
            } else {
                ready(i) := (!valid(i) | (io.mData.ready | !dataValid)) && fsm.isActive(fsm.VALID)//io准备好或者 状态机不接收数据
            }

            if(i == 0){
                fire(i) := io.sData.fire
            } else {
                fire(i) := valid(i - 1) & ready(i)
            }
        }

        gen()
    })

    /***********************处理数据输入和从colMEM中读取列数据--时序*/
    //(2 -> k)从mem中读 1从sdata中读出。
    val rdColData = Vec(UInt(maxPoolingFixConfig.STREAM_DATA_WIDTH bits), maxPoolingFixConfig.kernelSize)
    val delayRdColData1 = Vec(Reg(UInt(maxPoolingFixConfig.STREAM_DATA_WIDTH bits)) init(0), maxPoolingFixConfig.kernelSize)
    //输入1
    rdColData(0) := delaySData1
    for(i <- 0 until maxPoolingFixConfig.kernelSize){
        when(fire(1)){
            delayRdColData1(i) := rdColData(i)
        }
    }
    /***********************处理计算结果存回MEM模块--时序*/
    //(1 -> k-1)存入mem k输出
    val wrColData = Vec(UInt(maxPoolingFixConfig.STREAM_DATA_WIDTH bits), maxPoolingFixConfig.kernelSize)
    val delayWrColData1 = Vec(Reg(UInt(maxPoolingFixConfig.STREAM_DATA_WIDTH bits)) init(0), maxPoolingFixConfig.kernelSize)
    for(i <- 0 until maxPoolingFixConfig.kernelSize){
        when(fire(2)){
            delayWrColData1(i) := wrColData(i)
        }
    }
    /***********************列比较计算模块--组合*/
    //计算模块
    wrColData(0) := delayRdColData1(0);
    val colComparer = Array.tabulate(maxPoolingFixConfig.kernelSize - 1, maxPoolingFixConfig.COMPUTE_CHANNEL_NUM)((i, j)=> {
        def gen() = {
            when(delayRdColData1(0)((j + 1) * maxPoolingFixConfig.DATA_WIDTH - 1 downto j * maxPoolingFixConfig.DATA_WIDTH) >=
              delayRdColData1(i + 1)((j + 1) * maxPoolingFixConfig.DATA_WIDTH - 1 downto j * maxPoolingFixConfig.DATA_WIDTH)) {
                wrColData(i + 1)((j + 1) * maxPoolingFixConfig.DATA_WIDTH - 1 downto j * maxPoolingFixConfig.DATA_WIDTH) :=
                  delayRdColData1(0)((j + 1) * maxPoolingFixConfig.DATA_WIDTH - 1 downto j * maxPoolingFixConfig.DATA_WIDTH)
            } otherwise {
                wrColData(i + 1)((j + 1) * maxPoolingFixConfig.DATA_WIDTH - 1 downto j * maxPoolingFixConfig.DATA_WIDTH) :=
                  delayRdColData1(i + 1)((j + 1) * maxPoolingFixConfig.DATA_WIDTH - 1 downto j * maxPoolingFixConfig.DATA_WIDTH)
            }
        }

        gen()
    })
    /***********************列MEM储存模块*/
    //定义列MEM，MEM深度为 MAX_CHANNEL_NUM / COMPUTE_CHANNEL_NUM  位宽为 STREAM_DATA_WIDTH
    val colMem = Array.tabulate(maxPoolingFixConfig.kernelSize - 1)(i => {
        def gen(): Mem[UInt] = {
            val mem = Mem(UInt(maxPoolingFixConfig.STREAM_DATA_WIDTH bits), wordCount = maxPoolingFixConfig.channelMemDepth).addAttribute("ram_style = \"block\"")
            mem.write(wrColAddr, delayWrColData1(i), fire(3))
            rdColData(i+1) := mem.readSync(rdColAddr, fire(0))

            mem
        }

        gen()
    })
    /***********************处理计算模块数据输入和从rowMEM中读取列数据--时序*/
    //(2 -> k)从mem中读 1从wrRowData中读出。
    val rdRowData = Vec(UInt(maxPoolingFixConfig.STREAM_DATA_WIDTH bits), maxPoolingFixConfig.kernelSize - 1)
    val rdRowData1 = Vec(UInt(maxPoolingFixConfig.STREAM_DATA_WIDTH bits), maxPoolingFixConfig.kernelSize)
    val delayRdRowData1 = Vec(Reg(UInt(maxPoolingFixConfig.STREAM_DATA_WIDTH bits)) init(0), maxPoolingFixConfig.kernelSize - 1)
    //rdRowData1(0) := delayWrColData1(maxPoolingFixConfig.kernelSize - 1)
    //更新1，修改将原本的rdRowData1(0)的数据通路修改为根据io.kernelNum来判断数据通路。
    switch(io.kernelNum){//kernelNum应该从寄存器传输，所以可以设置多时钟路径
        for(i <- 0 to maxPoolingFixConfig.kernelSize - 2){
            is(i){
                rdRowData1(0) := delayWrColData1(i + 1)
            }
        }
        default{//其他异常情况会设置为最大的数据通路。
            rdRowData1(0) := delayWrColData1(maxPoolingFixConfig.kernelSize - 1)
        }
    }
    for(i <- 0 until maxPoolingFixConfig.kernelSize - 1){
        when(fire(2)){
            delayRdRowData1(i) := rdRowData(i)
        }
        rdRowData1(i + 1) := delayRdRowData1(i)
    }
    /***********************处理计算模块输出的数据向ROWMEM模块中写入--时序*/
    //(1 -> k-1)存入mem k输出
    val wrRowData = Vec(UInt(maxPoolingFixConfig.STREAM_DATA_WIDTH bits), maxPoolingFixConfig.kernelSize)
    val delayWrRowData1 = Vec(Reg(UInt(maxPoolingFixConfig.STREAM_DATA_WIDTH bits)) init(0), maxPoolingFixConfig.kernelSize)
    for(i <- 0 until maxPoolingFixConfig.kernelSize){
        when(fire(3)){
            delayWrRowData1(i) := wrRowData(i)
        }
    }
    /***********************行比较计算模块--组合*/
    //计算模块
    wrRowData(0) := rdRowData1(0);
    val rowComparer = Array.tabulate(maxPoolingFixConfig.kernelSize - 1, maxPoolingFixConfig.COMPUTE_CHANNEL_NUM)((i, j)=> {
        def gen() = {
            when(rdRowData1(0)((j + 1) * maxPoolingFixConfig.DATA_WIDTH - 1 downto j * maxPoolingFixConfig.DATA_WIDTH) >=
              rdRowData1(i + 1)((j + 1) * maxPoolingFixConfig.DATA_WIDTH - 1 downto j * maxPoolingFixConfig.DATA_WIDTH)) {
                wrRowData(i + 1)((j + 1) * maxPoolingFixConfig.DATA_WIDTH - 1 downto j * maxPoolingFixConfig.DATA_WIDTH) :=
                  rdRowData1(0)((j + 1) * maxPoolingFixConfig.DATA_WIDTH - 1 downto j * maxPoolingFixConfig.DATA_WIDTH)
            } otherwise {
                wrRowData(i + 1)((j + 1) * maxPoolingFixConfig.DATA_WIDTH - 1 downto j * maxPoolingFixConfig.DATA_WIDTH) :=
                  rdRowData1(i + 1)((j + 1) * maxPoolingFixConfig.DATA_WIDTH - 1 downto j * maxPoolingFixConfig.DATA_WIDTH)
            }
        }

        gen()
    })
    /***********************行MEM模块--组合*/
    //定义行MEM，MEM深度为 maxcol * MAX_CHANNEL_NUM / COMPUTE_CHANNEL_NUM  位宽为 STREAM_DATA_WIDTH
    val rowMem = Array.tabulate(maxPoolingFixConfig.kernelSize - 1)(i => {
        def gen(): Mem[UInt] = {
            val mem = Mem(UInt(maxPoolingFixConfig.STREAM_DATA_WIDTH bits), wordCount = maxPoolingFixConfig.rowMemDepth).addAttribute("ram_style = \"block\"")
            mem.write(wrRowAddr, delayWrRowData1(i), fire(4))
            rdRowData(i) := mem.readSync(rdRowAddr, fire(1))

            mem
        }

        gen()
    })
    /***********************后处理--给出结果*/
    //修改给出结果的数据通路
    //io.mData.payload := Delay(delayWrRowData1(maxPoolingFixConfig.kernelSize - 1), 1, fire(4))
    val outPutData = UInt(maxPoolingFixConfig.STREAM_DATA_WIDTH bits)
    switch(io.kernelNum){//kernelNum应该从寄存器传输，所以可以设置多时钟路径
        for(i <- 0 to maxPoolingFixConfig.kernelSize - 2){
            is(i){
                outPutData := delayWrRowData1(i + 1)
            }
        }
        default{//其他异常情况会设置为最大的数据通路。
            outPutData := delayWrRowData1(maxPoolingFixConfig.kernelSize - 1)
        }
    }
    io.mData.payload := Delay(outPutData, 1, fire(4))
}

object MaxPoolingFix extends App {
    SpinalVerilog(new MaxPooling(MaxPoolingConfig(8, 8, 640, 10, 1024)))
}
