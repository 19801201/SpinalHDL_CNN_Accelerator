package TbCfg

object Util {
    def toBinString(src: Int, width: Int): String = {
        var temp = src.toBinaryString
        val len = temp.length
        require(len <= width)
        for (i <- 0 until (width - len)) {
            temp = 0 + temp
        }
        //    (0 until width - len).foreach(temp = (0.toString + temp))
        temp
    }
}
