import spinal.core._
import wa.{xAdd, xMul}
class test extends Component {

    val addChannelData = Vec(S"40'd0",8)
    val addChannelTimesData = Vec(SInt(32 bits), 16)
    val addChannelTimes = Array.tabulate(16) { i =>
        def gen = {
            val add = xAdd(20, 32)
            add.io.A <> addChannelData(i/2).subdivideIn(2 slices)(i%2)
            add.io.init <> False
            add.io.S <> addChannelTimesData(i)
        }

        gen
    }
}
object test{
    def main(args: Array[String]): Unit = {
        SpinalVerilog(new test)
    }
}
