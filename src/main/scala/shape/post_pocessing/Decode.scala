package shape.post_pocessing

import spinal.core._
import spinal.lib._
import config.Config._
import java.io.File

class Decode(pocessingConfig: PocessingConfig) extends Component {
    val io = new Bundle {
        val start = in Bool()
        val sData = slave Stream UInt(pocessingConfig.STREAM_DATA_WIDTH bits)
        val scale = in UInt (16 bits)
        val zp    = in SInt (16 bits)

        val w_addr  = out UInt (12 bits)
        val w_data  = out UInt (64 bits)
        val w_en    = out Bool()
        val finish  = out Bool()
    }

    noIoPrefix()

    val channelChoice = new ChannelChoice(pocessingConfig)
    channelChoice.io.start <> io.start
    channelChoice.io.sData <> io.sData

    val deQuant = new DeQuant(pocessingConfig)
    deQuant.io.scale        <> io.scale
    deQuant.io.zp           <> io.zp
    deQuant.io.sData_valid  <> channelChoice.io.mData_valid
    deQuant.io.reg_data     <> channelChoice.io.reg_data
    deQuant.io.obj_data     <> channelChoice.io.obj_data
    deQuant.io.cls_data     <> channelChoice.io.cls_data
    deQuant.io.x            <> channelChoice.io.x
    deQuant.io.y            <> channelChoice.io.y
    deQuant.io.z            <> channelChoice.io.z

    val sigmoid = new Sigmoid(pocessingConfig)
    sigmoid.io.sData_valid          <> deQuant.io.mData_valid
    sigmoid.io.reg_data_quan        <> deQuant.io.reg_data_quan
    sigmoid.io.obj_data_quan        <> deQuant.io.obj_data_quan
    sigmoid.io.cls_data_quan        <> deQuant.io.cls_data_quan
    sigmoid.io.obj_data_dequan      <> deQuant.io.obj_data_dequan
    sigmoid.io.cls_data_dequan      <> deQuant.io.cls_data_dequan
    sigmoid.io.x_1                  <> deQuant.io.x_1
    sigmoid.io.y_1                  <> deQuant.io.y_1
    sigmoid.io.z_1                  <> deQuant.io.z_1

    val filter = new Filter(pocessingConfig)
    filter.io.start                 <> io.start
    filter.io.sData_valid           <> sigmoid.io.mData_valid
    filter.io.s_reg_data            <> sigmoid.io.m_reg_data
    filter.io.s_obj_data_quan       <> sigmoid.io.m_obj_data_quan
    filter.io.s_cls_data_quan       <> sigmoid.io.m_cls_data_quan
    filter.io.s_obj_data            <> sigmoid.io.m_obj_data
    filter.io.s_cls_data            <> sigmoid.io.m_cls_data
    filter.io.s_x                   <> sigmoid.io.m_x
    filter.io.s_y                   <> sigmoid.io.m_y
    filter.io.s_z                   <> sigmoid.io.m_z

    io.w_addr       <> filter.io.w_addr
    io.w_data       <> filter.io.w_data
    io.w_en         <> filter.io.w_en
    io.finish       <> filter.io.finish

}

object Decode extends App {
    val clkCfg = ClockDomainConfig(resetKind = SYNC, resetActiveLevel = LOW) // 同步低电平复位
    SpinalConfig(
        headerWithDate = true,
        oneFilePerComponent = false,
        targetDirectory = filePath, // 文件生成路径
        defaultConfigForClockDomains = clkCfg
    ).generateVerilog(new Decode(PocessingConfig(8, 16)))
}
