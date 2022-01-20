import spinal.core._
import spinal.lib.{Stream, master}
import wa.{xAdd, xMul}

class test extends Component {

    val mNormData = master(Stream(Vec(SInt(32 bits), 2))) //调试使用
    mNormData.valid := True
    mNormData.payload(0) := S"32'd0"
    mNormData.payload(1) := S"32'd0"
}

object test {
    def main(args: Array[String]): Unit = {
        SpinalVerilog(new test)
    }
}
