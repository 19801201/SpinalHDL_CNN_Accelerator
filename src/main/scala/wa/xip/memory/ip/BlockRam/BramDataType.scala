package wa.xip.memory.ip.BlockRam

import spinal.core._
object BramDataType{
    def apply[T <: Data]( dinAType: T,  dOutAType: T,  dinBType: T,  dOutBType: T)=new TDramDataType[T](dinAType, dOutAType, dinBType, dOutBType)
}
class TDramDataType[T <: Data](val dinAType: T, val dOutAType: T, val dinBType: T, val dOutBType: T) {

}

