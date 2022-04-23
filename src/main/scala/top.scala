import config.Config
import conv.compute._
import shape._
import spinal.core.SpinalConfig
import misc.TotalTcl
import java.io.File

object top extends App {
    SpinalConfig(removePruned = true, targetDirectory = Config.filePath).generateVerilog(new Conv(ConvConfig(8, 8, 8, 12, 8192, 512, 416, 2048, 1)))
    TotalTcl(Config.filePath + File.separator + "tcl", Config.filePath).genTotalTcl
}
