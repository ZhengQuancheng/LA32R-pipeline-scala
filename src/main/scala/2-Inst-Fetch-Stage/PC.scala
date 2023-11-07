import chisel3._
import chisel3.util._

class PC_IO extends Bundle {
    val pc_IF           = Output(UInt(32.W))
    val pc_stall        = Input(Bool())
    val predict_fail    = Input(Bool())
    val npc             = Output(UInt(32.W))
    val pred_jump       = Input(Vec(4, Bool()))
    val pred_npc        = Input(UInt(32.W))
    val branch_target   = Input(UInt(32.W))
    val inst_valid_IF   = Output(Vec(4, Bool()))

    val flush_by_pd     = Input(Bool())
    val flush_pd_target = Input(UInt(32.W))
}

class PC(reset_val: Int) extends Module {
    val io = IO(new PC_IO)

    val pc = RegInit(reset_val.U(32.W))

    when(io.predict_fail) {
        io.npc := io.branch_target
    }
    .elsewhen(io.flush_by_pd){
        io.npc := io.flush_pd_target
    }
    .elsewhen(!io.pc_stall) {
        when(io.pred_jump.reduce(_||_)){
            io.npc := io.pred_npc
        }.otherwise{
            io.npc := (pc + 16.U)(31, 4) ## (Mux(pc(5, 4) === 3.U, 0.U(4.W), pc(3, 2) ## 0.U(2.W)))
        }
    }
    .otherwise{
        io.npc := pc
    }

    io.pc_IF := pc
    pc := io.npc

    val inst_valid_temp = Wire(Vec(4, Bool()))
    inst_valid_temp := PriorityEncoderOH(io.pred_jump)

    io.inst_valid_IF := (((inst_valid_temp.asUInt << 1.U)(3, 0) - 1.U) & (15.U(4.W) >> (Mux(pc(5, 4) === 3.U, pc(3, 2), 0.U)))).asBools

}