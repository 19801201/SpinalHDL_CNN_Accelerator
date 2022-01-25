import spinal.core._
import spinal.lib.{Stream, master}
import wa.{xAdd, xMul}

class test extends Component {

    val a = SInt(16 bits)
}

object test {
    def main(args: Array[String]): Unit = {
        SpinalVerilog(new test)
    }
}
