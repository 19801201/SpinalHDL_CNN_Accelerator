import config.Config
import conv.compute.{Conv, ConvConfig}
import spinal.core.SpinalConfig

object top extends App {
    SpinalConfig(removePruned = true,targetDirectory = Config.filePath).generateVerilog(new Conv(ConvConfig(8, 8, 8, 12, 8192, 512, 416, 2048, 1)))
}
