import config.Config
import conv.compute._
import shape._
import spinal.core.SpinalConfig
import misc.TotalTcl
import java.io.File

object top extends App {
    SpinalConfig(removePruned = true, targetDirectory = Config.filePath).generateVerilog(new Conv(ConvConfig(8, 16, 16, 12, 4096, 512, 640, 4096, 1)))
    TotalTcl(Config.filePath + File.separator + "tcl", Config.filePath).genTotalTcl
}
