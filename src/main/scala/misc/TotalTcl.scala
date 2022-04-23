package misc

import java.io._
import scala.io.Source

class TotalTcl(srcPath: String = ".", destPath: String = ".") {
    def genTotalTcl: Unit = {
        val files = new File(srcPath).listFiles().filter(_.isFile).filter(t => t.toString.endsWith("tcl"))
        val destFile = new PrintWriter(new File(destPath + File.separator + "totalIpTcl.tcl"))
        val destFileList = new PrintWriter(new File(destPath + File.separator + "totalIpTclList.txt"))
        files.foreach(t => {
            destFileList.write(t.toString + "\n")
            destFile.write(Source.fromFile(t.toString).getLines().mkString("\n") + "\n")
        })
        destFileList.close()
        destFile.close()
    }
}

object TotalTcl {
    def apply(srcPath: String = ".", destPath: String = ".") = new TotalTcl(srcPath, destPath)
}
