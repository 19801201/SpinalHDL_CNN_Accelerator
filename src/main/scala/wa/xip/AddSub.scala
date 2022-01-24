package wa.xip

import spinal.core._
object AddSubConfig {
    val signed = "signed"
    val unsigned = "Unsigned"
    val dsp = "DSP"
    val lut = "LUT"
    val subtract = "Subtract"
    val add = "Add"
}
class AddSub(A_WIDTH: Int, B_WIDTH: Int, S_WIDTH: Int, A_TYPE: String, B_TYPE: String, clockDomain: ClockDomain, componentName: String)
    extends BlackBox {
    val io = new Bundle {
        val A = if (A_TYPE == MulConfig.signed) {
            in SInt (A_WIDTH bits)
        } else {
            in UInt (A_WIDTH bits)
        }
        val B = if (B_TYPE == MulConfig.signed) {
            in SInt (B_WIDTH bits)
        } else {
            in UInt (B_WIDTH bits)
        }
        val S = if (A_TYPE == MulConfig.signed || B_TYPE == MulConfig.signed) {
            out SInt (S_WIDTH bits)
        } else {
            out UInt (S_WIDTH bits)
        }
        val CLK = in Bool()
    }
    noIoPrefix()
    this.setDefinitionName(componentName)

    mapClockDomain(clockDomain, io.CLK)
}
object AddSub{
    private def genTcl(A_WIDTH: Int, B_WIDTH: Int, P_WIDTH: Int, A_TYPE: String, B_TYPE: String, PIPELINE_STAGE: Int, RESOURCES_TYPE: String,ADD_MODE:String,componentName:String): Unit ={
        import java.io._
        val createIlaCmd = s"set addSubExit [lsearch -exact [get_ips $componentName] $componentName]\n" +
            s"if { $$addSubExit <0} {\n" +
            s"create_ip -name c_addsub -vendor xilinx.com -library ip -version 12.0 -module_name $componentName\n" +
            s"}\n"
        val tclHeader = new PrintWriter(new File(s"generate$componentName.tcl"))
        tclHeader.write(createIlaCmd)
        tclHeader.write(s"set_property -dict [list ")
        tclHeader.write(s"CONFIG.A_Width {$A_WIDTH} ")
        tclHeader.write(s"CONFIG.A_Type {$A_TYPE} ")
        tclHeader.write(s"CONFIG.B_Width {$B_WIDTH} ")
        tclHeader.write(s"CONFIG.B_Type {$B_TYPE} ")
        tclHeader.write(s"CONFIG.CE {false} ")
        tclHeader.write(s"CONFIG.Add_Mode {$ADD_MODE} ")
       // tclHeader.write(s"CONFIG.B_Value {false} ")
        val res = if(RESOURCES_TYPE == AddSubConfig.dsp){
            "DSP48"
        } else {
            "Fabric"
        }
        tclHeader.write(s"CONFIG.Implementation {$res} ")
//        val w = P_WIDTH - 1
        tclHeader.write(s"CONFIG.Out_Width {$P_WIDTH} ")
        tclHeader.write(s"CONFIG.Latency {$PIPELINE_STAGE} ")
        tclHeader.write(s"] [get_ips $componentName] \n")
        tclHeader.close()


    }
    def apply(A_WIDTH: Int, B_WIDTH: Int, S_WIDTH: Int, A_TYPE: String, B_TYPE: String, PIPELINE_STAGE: Int, RESOURCES_TYPE: String,clockDomain: ClockDomain,ADD_MODE:String,componentName:String,genTclScript:Boolean=true) = {
        if(genTclScript){
            genTcl(A_WIDTH, B_WIDTH, S_WIDTH, A_TYPE, B_TYPE, PIPELINE_STAGE, RESOURCES_TYPE,ADD_MODE,componentName)
        }
        val addSub = new AddSub(A_WIDTH, B_WIDTH, S_WIDTH, A_TYPE, B_TYPE,clockDomain,componentName)
        addSub
    }
}

//class testAddSub extends Component{
//    val io = new Bundle{
//        val A = in SInt(8 bits)
//        val B = in UInt(8 bits)
//        val P = out Vec(SInt(8 bits),5)
//    }
//    noIoPrefix()
//    val mul = Array.tabulate(5){i=>
//        def gen = {
//            val m = AddSub(8,8,8,AddSubConfig.signed,AddSubConfig.unsigned,1,AddSubConfig.lut,this.clockDomain,AddSubConfig.add,"add8_8_8",i==0)
//            m.io.A <> io.A
//            m.io.B <> io.B
//            m.io.S <> io.P(i)
//        }
//        gen
//    }
//
//
//}
//object testAddSub extends App {
//    SpinalVerilog(new testAddSub)
//}
