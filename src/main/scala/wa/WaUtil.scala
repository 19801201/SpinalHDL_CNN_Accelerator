package wa

import spinal.core._


object setClear {
    def apply(data: Bool, set: Bool, clear: Bool) = setClearBool(data: Bool, set: Bool, clear: Bool)

    def apply(data: Bool, set: Bool) = setSelfClearBool(data: Bool, set: Bool)

    def apply(data: UInt, set: Bool, clear: Bool) = setClearUInt(data: UInt, set: Bool, clear: Bool)

    def apply(data: UInt, set: Bool) = setSelfClearUInt(data: UInt, set: Bool)


}

case class setClearBool(data: Bool, set: Bool, clear: Bool) extends Area {
    when(set) {
        data.set()
    } elsewhen clear {
        data.clear()
    } otherwise {
        data := data
    }
}

case class setSelfClearBool(data: Bool, set: Bool) extends Area {
    when(set) {
        data.set()
    } otherwise {
        data.clear()
    }
}

case class setClearUInt(data: UInt, set: Bool, clear: Bool) extends Area {
    when(set) {
        data := data + 1
    } elsewhen clear {
        data := 0
    } otherwise {
        data := data
    }
}

case class setSelfClearUInt(data: UInt, set: Bool) extends Area {
    when(set) {
        data := data + 1
    } otherwise {
        data := 0
    }
}


