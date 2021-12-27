package util
import spinal.core._
class leaky_relu(
                    S_DATA_WIDTH: Int,
                    ZERO_POINT_WIDTH: Int,
                    M_DATA_WIDTH: Int,
                    clk:ClockDomain
                ) extends BlackBox {
    val io = new Bundle {
        val data_in = in Bits (S_DATA_WIDTH bits)
        val zero_data_in = in Bits (ZERO_POINT_WIDTH bits)
        val data_out = out Bits (M_DATA_WIDTH bits)
        val clk = in Bool()
    }
    noIoPrefix()
    mapClockDomain(clk , io.clk)
}
