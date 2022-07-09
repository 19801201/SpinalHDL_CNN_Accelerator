package config

import spinal.core._

object Config {
    val filePath = "./verilog"
    val DDRSize = 4 GiB
    val registerAddrSize = 1 MiB
    val burstSize = 32

    val dsp2x = false

    case class ImageType() {
        val rgb = "RGB"
        val gray = "GRAY"
        val dataType = gray
    }

    val imageType = ImageType()

    val enFocus = false

    val useXilinxDma = true
}
