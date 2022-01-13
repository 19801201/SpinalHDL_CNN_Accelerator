import spinal.core._
import wa.xMul
class test extends Component {
    val a = Vec(Vec(UInt(8 bits),3),9)
    a(8)(0):=5
//    val a = in Bits(4098 bits)
}
object test{
    def main(args: Array[String]): Unit = {
        SpinalVerilog(new test)
    }
}
