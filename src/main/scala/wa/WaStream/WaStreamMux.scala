package wa.WaStream

import spinal.core._
import spinal.lib._

import scala.collection.Seq

object WaStreamMux {
    def apply[T <: Data](candidate: Seq[Int], select: Bits, inputs: Seq[Stream[T]]): Stream[T] = {
        val vec = Vec(inputs)
        WaStreamMux(candidate, select, vec)
    }

    def apply[T <: Data](candidate: Seq[Int], select: Bits, inputs: Vec[Stream[T]]): Stream[T] = {
        //assert(candidate.max.toBinaryString.length == select.getWidth, "候选项的最大值位宽和select的位宽不一致,即"+candidate.max.toBinaryString.length+"和"+select.getWidth)
        val c = new WaStreamMux(candidate, select.getWidth, inputs(0).payload, inputs.length)
        (c.io.inputs, inputs).zipped.foreach(_ << _)
        c.io.select := select
        c.io.output
    }
}

class WaStreamMux[T <: Data](candidate: Seq[Int], selectWidth: Int, dataType: T, portCount: Int) extends Component {
    val io = new Bundle {
        val select = in Bits (selectWidth bits)
        val inputs = Vec(slave Stream (dataType), portCount)
        val output = master Stream (dataType)
    }
    for ((input, index) <- io.inputs.zipWithIndex) {
        input.ready := candidate(index) === io.select && io.output.ready
    }

    switch(io.select) {
        for ((input, index) <- candidate.zipWithIndex) {
            is(input) {
                io.output.valid := io.inputs(index).valid
                io.output.payload := io.inputs(index).payload
            }

        }
        default {
            io.output.valid := False
            io.output.payload.assignFrom(U(0))
        }

    }
}
//class test() extends Component {
//
//    val a = slave Stream (UInt(8 bits))
//    val b = slave Stream (UInt(8 bits))
//    val c = slave Stream (UInt(8 bits))
//    val d = slave Stream (UInt(8 bits))
//    val e = slave Stream (UInt(8 bits))
//    val f = slave Stream (UInt(8 bits))
//
//    val o = master Stream (UInt(8 bits))
//
//    val aaa = in Bits(3 bits)
//
//    o <> WaStreamMux(Seq(1,2,3,4,5,6),aaa,Vec(a,b,c,d,e,f))
//}
//
//
//object test {
//    def main(args: Array[String]): Unit = {
//        //        SpinalVerilog(new test())
//        SpinalConfig().generateVerilog(new test)
//    }
//}