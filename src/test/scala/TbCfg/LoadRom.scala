package TbCfg

import scala.io.Source
import scala.math.BigInt

case class LoadRom() {
    def loadRomData(patch: String) = {
        //        val file = new File(patch)
        //        val fileStream = new FileInputStream(file)
        //        val bytes = new Array[Byte](4)
        var list: Seq[BigInt] = Nil
        for (src <- Source.fromFile(patch).getLines()) {
            list = BigInt(src, 16) +: list
        }
        list = list.reverse
        list
    }
}
