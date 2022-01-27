import spinal.core._
import spinal.lib.{Stream, master}
import wa.{xAdd, xMul}
import wa.WaMul
class test extends Component {

//    val a = in SInt(16 bits)
    val b = 26214
    val mul =  WaMul(16,16,32)
    mul.io.a <> -2
    mul.io.b <> b
}

object test {
    def main(args: Array[String]): Unit = {
        SpinalVerilog(new test)
    }
}
