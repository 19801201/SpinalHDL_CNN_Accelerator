import spinal.core._
import wa.xMul
class test extends Component {
    val mulFeatureWeight = Array.tabulate(9,8,4 )((i,j,k) => {
        def gen = {
            val mul = new xMul(24, 8, 32, this.clockDomain)
            mul.io.A <> i
            mul.io.B <> j
            mul
        }
        gen
    })
//    val a = in Bits(4098 bits)
}
object test{
    def main(args: Array[String]): Unit = {
        SpinalVerilog(new test)
    }
}
