package wa

import spinal.core.{Area, Bool, False, IntToBuilder, Reg, True, UInt, when}

object WaCounter {
    def apply(en: Bool, width: Int, end: UInt) = new WaCounter(en, width, end, 0)
    def apply(en: Bool, width: Int, end: UInt, InitData: Int) = new WaCounter(en, width, end, InitData)
}

class WaCounter(en: Bool, width: Int, cnt: UInt, InitData: Int) extends Area {
    val count = Reg(UInt(width bits)) init InitData
    val valid = Bool()
    when(count === cnt) {
        valid := True
    } otherwise {
        valid := False
    }
    when(en) {
        count := count + 1
        when(valid) {
            count := 0
        }
    }

    def clear = {
        count := InitData
        valid := False
    }
}