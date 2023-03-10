package wa

import spinal.core.{Area, Bool, False, IntToBuilder, Reg, True, UInt, when}

object WaAddrIncCtr {
    def apply(width: Int, en: Bool, cnt: UInt) = new addrIncCtr(width, en, cnt)
}

class addrIncCtr(width: Int, en: Bool, cnt: UInt) extends Area {
    val count = Reg(UInt(width bits)) init 0
    val valid = Reg(Bool()) init False
    when(en) {
        when(count === cnt - 2){//cnt == 真实的计数值 - 2，这样改可以在valid的路径上插入寄存器。
            valid := True
        } otherwise {
            valid := False
        }
        count := count + 1
        when(valid) {
            count := 0
        }
    }
}