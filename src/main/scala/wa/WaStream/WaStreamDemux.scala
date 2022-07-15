package wa.WaStream

import spinal.core._
import spinal.lib._

import scala.collection.Seq

object WaStreamDemux {
    def apply[T <: Data](candidate: Seq[Int], input: Stream[T], select: Bits): Vec[Stream[T]] = {
        val c = new WaStreamDemux(input.payload, candidate, candidate.length,select.getWidth)
        c.io.input << input
        c.io.select := select
        c.io.outputs
    }
}

class WaStreamDemux[T <: Data](dataType: T, candidate: Seq[Int], portCount: Int, selectWidth:Int) extends Component {
    val io = new Bundle {
        val select = in Bits (selectWidth bit)
        val input = slave Stream (dataType)
        val outputs = Vec(master Stream (dataType), portCount)
    }
    io.input.ready := False
    for (i <- 0 until portCount) {
        io.outputs(i).payload := io.input.payload
        when(candidate(i) =/= io.select) {
            io.outputs(i).valid := False
        } otherwise {
            io.outputs(i).valid := io.input.valid
            io.input.ready := io.outputs(i).ready
        }
    }

}

//class test() extends Component {
//
//    val a = master Stream (UInt(8 bits))
//    val b = master Stream (UInt(8 bits))
//    val c = master Stream (UInt(8 bits))
//    val d = master Stream (UInt(8 bits))
////    val e = master Stream (UInt(8 bits))
////    val f = master Stream (UInt(8 bits))
//
//    val o = slave Stream (UInt(8 bits))
//
//    val aaa = in Bits (3 bits)
//
//    //    o <> WaStreamMux(Seq(1,2,3,4,5,6),aaa,Vec(a,b,c,d,e,f))
//    Vec(a, b, c, d) <> WaStreamDemux(Seq(3, 4, 5, 6), o, aaa)
//}
//
//
//object test {
//    def main(args: Array[String]): Unit = {
//        //        SpinalVerilog(new test())
//        SpinalConfig().generateVerilog(new test)
//    }
//}