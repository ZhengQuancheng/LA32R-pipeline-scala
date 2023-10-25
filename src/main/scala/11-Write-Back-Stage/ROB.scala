import chisel3._
import chisel3.util._

// LUT: 1119 FF: 425

object ROB_Pack{
    class rob_t extends Bundle(){
        val rd = UInt(5.W)
        val rd_valid = Bool()
        val prd = UInt(7.W)
        val pprd = UInt(7.W)
        val predict_fail = Bool()
        val branch_target = UInt(32.W)
        val real_jump = Bool()
        val pred_update_en = Bool()
        val ras_update_en = Bool()
        val br_type_pred = UInt(2.W)
        val complete = Bool()
        val pc = UInt(32.W)
        val rf_wdata = UInt(32.W)
        val is_store = Bool()
        val is_ucread = Bool()
    }
    
}
class ROB_IO(n: Int) extends Bundle{
    // for reg rename
    val inst_valid_rn           = Input(Vec(4, Bool()))
    val rd_rn                   = Input(Vec(4, UInt(5.W)))
    val rd_valid_rn             = Input(Vec(4, Bool()))
    val prd_rn                  = Input(Vec(4, UInt(7.W)))
    val pprd_rn                 = Input(Vec(4, UInt(7.W)))
    val rob_index_rn            = Output(Vec(4, UInt(log2Ceil(n).W)))
    val pc_rn                   = Input(Vec(4, UInt(32.W)))
    val is_store_rn             = Input(Vec(4, Bool()))
    val pred_update_en_rn       = Input(Vec(4, Bool()))
    val ras_update_en_rn        = Input(Vec(4, Bool()))
    val br_type_pred_rn         = Input(Vec(4, UInt(2.W)))
    val full                    = Output(Bool())
    val stall                   = Input(Bool())

    // for wb stage 
    val inst_valid_wb           = Input(Vec(4, Bool()))
    val rob_index_wb            = Input(Vec(4, UInt(log2Ceil(n).W)))
    val is_ucread_wb            = Input(Vec(4, Bool()))
    val predict_fail_wb         = Input(Vec(4, Bool()))
    val real_jump_wb            = Input(Vec(4, Bool()))
    val branch_target_wb        = Input(Vec(4, UInt(32.W)))
    val rf_wdata_wb             = Input(Vec(4, UInt(32.W)))

    // for cpu state: arch rat
    val cmt_en                  = Output(Vec(4, Bool()))
    val is_ucread_cmt           = Output(Vec(4, Bool()))
    val rd_cmt                  = Output(Vec(4, UInt(5.W)))
    val prd_cmt                 = Output(Vec(4, UInt(7.W)))
    val rd_valid_cmt            = Output(Vec(4, Bool()))
    val pprd_cmt                = Output(Vec(4, UInt(7.W)))
    val pc_cmt                  = Output(Vec(4, UInt(32.W)))
    val is_store_num_cmt        = Output(UInt(2.W))

    val predict_fail_cmt        = Output(Bool())
    val branch_target_cmt       = Output(UInt(32.W))
    val pred_update_en_cmt      = Output(Bool())
    val ras_update_en_cmt       = Output(Bool())
    val pred_branch_target_cmt  = Output(UInt(32.W))
    val pred_pc_cmt             = Output(UInt(32.W))
    val pred_real_jump_cmt      = Output(Bool())
    val br_type_pred_cmt        = Output(UInt(2.W))

    val rf_wdata_cmt            = Output(Vec(4, UInt(32.W)))

    // stat
    val predict_fail_stat       = Output(Vec(4, Bool()))
    val br_type_stat            = Output(Vec(4, UInt(2.W)))
    val is_br_stat              = Output(Vec(4, Bool()))
}

class ROB(n: Int) extends Module{
    val io = IO(new ROB_IO(n))
    val neach = n / 4
    import ROB_Pack._
    val rob         = RegInit(VecInit(Seq.fill(4)(VecInit(Seq.fill(neach)(0.U.asTypeOf(new rob_t))))))
    val head        = RegInit(VecInit(Seq.fill(4)(0.U(log2Ceil(neach).W))))
    val tail        = RegInit(VecInit(Seq.fill(4)(0.U(log2Ceil(neach).W))))
    val elem_num    = RegInit(VecInit(Seq.fill(4)(0.U((log2Ceil(neach)+1).W))))
    val head_sel    = RegInit(0.U(2.W))

    val empty       = VecInit(elem_num.map(_ === 0.U))
    val full        = VecInit(elem_num.map(_ === neach.U)).asUInt.orR
    // rn stage
    when(!full){
        for(i <- 0 until 4){
            when(io.inst_valid_rn(i)){
                rob(i)(tail(i)).rd              := io.rd_rn(i)
                rob(i)(tail(i)).rd_valid        := io.rd_valid_rn(i)
                rob(i)(tail(i)).prd             := io.prd_rn(i)
                rob(i)(tail(i)).pprd            := io.pprd_rn(i)
                rob(i)(tail(i)).pc              := io.pc_rn(i)
                rob(i)(tail(i)).is_store        := io.is_store_rn(i)
                rob(i)(tail(i)).pred_update_en  := io.pred_update_en_rn(i)
                rob(i)(tail(i)).br_type_pred    := io.br_type_pred_rn(i)
                rob(i)(tail(i)).ras_update_en   := io.ras_update_en_rn(i)
                rob(i)(tail(i)).complete        := false.B
            }
        }
    }

    for(i <- 0 until 4){
        io.rob_index_rn(i) := tail(i) ## i.U(2.W)
    }

    // wb stage
    for(i <- 0 until 4){
        when(io.inst_valid_wb(i)){
            rob(io.rob_index_wb(i)(1, 0))(io.rob_index_wb(i)(log2Ceil(neach)+1, 2)).complete        := true.B
            rob(io.rob_index_wb(i)(1, 0))(io.rob_index_wb(i)(log2Ceil(neach)+1, 2)).predict_fail    := io.predict_fail_wb(i)
            rob(io.rob_index_wb(i)(1, 0))(io.rob_index_wb(i)(log2Ceil(neach)+1, 2)).branch_target   := io.branch_target_wb(i)
            rob(io.rob_index_wb(i)(1, 0))(io.rob_index_wb(i)(log2Ceil(neach)+1, 2)).rf_wdata        := io.rf_wdata_wb(i)
            rob(io.rob_index_wb(i)(1, 0))(io.rob_index_wb(i)(log2Ceil(neach)+1, 2)).real_jump       := io.real_jump_wb(i)
            rob(io.rob_index_wb(i)(1, 0))(io.rob_index_wb(i)(log2Ceil(neach)+1, 2)).is_ucread       := io.is_ucread_wb(i)
        }
    }
    
    // cmt stage
    io.cmt_en(0) := rob(head_sel)(head(head_sel)).complete && !empty(head_sel)
    for(i <- 1 until 4){
        io.cmt_en(i) := (io.cmt_en(i-1) && rob(head_sel+i.U)(head(head_sel+i.U)).complete && !rob(head_sel+(i-1).U)(head(head_sel+(i-1).U)).predict_fail && !empty(head_sel+i.U))
    }
    io.full                     := full
    val predict_fail_bit        = VecInit(Seq.tabulate(4)(i => rob(head_sel+i.U)(head(head_sel+i.U)).predict_fail && io.cmt_en(i)))
    val pred_update_en_bit      = VecInit(Seq.tabulate(4)(i => rob(head_sel+i.U)(head(head_sel+i.U)).pred_update_en && io.cmt_en(i)))
    val ras_update_en_bit       = VecInit(Seq.tabulate(4)(i => rob(head_sel+i.U)(head(head_sel+i.U)).ras_update_en && io.cmt_en(i)))
    val ras_pred_fail           =  VecInit(Seq.tabulate(4)(i => ras_update_en_bit(i) && predict_fail_bit(i)))

    val pred_fail_ohbit         = PriorityEncoder(predict_fail_bit.asUInt)
    val pred_update_ohbit       = PriorityEncoder(pred_update_en_bit.asUInt)
    val ras_update_ohbit        = PriorityEncoder(ras_update_en_bit.asUInt)
    val cmt_index               = head_sel+pred_fail_ohbit
    val cmt_pred_index          = head_sel+Mux(!ras_pred_fail.asUInt.orR, pred_update_ohbit, ras_update_ohbit)
    io.ras_update_en_cmt        := ras_update_en_bit.asUInt.orR
    io.predict_fail_cmt         := predict_fail_bit.asUInt.orR
    io.branch_target_cmt        := Mux(rob(cmt_index)(head(cmt_index)).real_jump, 
                                   rob(cmt_index)(head(cmt_index)).branch_target,
                                   rob(cmt_index)(head(cmt_index)).pc + 4.U)
    io.pred_update_en_cmt       := pred_update_en_bit.asUInt.orR
    io.pred_branch_target_cmt   := rob(cmt_pred_index)(head(cmt_pred_index)).branch_target
    io.br_type_pred_cmt         := rob(cmt_pred_index)(head(cmt_pred_index)).br_type_pred
    io.pred_pc_cmt              := rob(cmt_pred_index)(head(cmt_pred_index)).pc
    io.pred_real_jump_cmt       := rob(cmt_pred_index)(head(cmt_pred_index)).real_jump

    val is_store_cmt_bit        = VecInit(Seq.tabulate(4)(i => rob(head_sel+i.U)(head(head_sel+i.U)).is_store && io.cmt_en(i)))
    io.is_store_num_cmt         := PopCount(is_store_cmt_bit.asUInt)

    io.rd_cmt                   := VecInit(Seq.tabulate(4)(i => rob(head_sel+i.U)(head(head_sel+i.U)).rd))
    io.rd_valid_cmt             := VecInit(Seq.tabulate(4)(i => rob(head_sel+i.U)(head(head_sel+i.U)).rd_valid))
    io.prd_cmt                  := VecInit(Seq.tabulate(4)(i => rob(head_sel+i.U)(head(head_sel+i.U)).prd))
    io.pprd_cmt                 := VecInit(Seq.tabulate(4)(i => rob(head_sel+i.U)(head(head_sel+i.U)).pprd))
    io.pc_cmt                   := VecInit(Seq.tabulate(4)(i => Mux(rob(head_sel+i.U)(head(head_sel+i.U)).real_jump, rob(head_sel+i.U)(head(head_sel+i.U)).branch_target, rob(head_sel+i.U)(head(head_sel+i.U)).pc+4.U)))
    io.rf_wdata_cmt             := VecInit(Seq.tabulate(4)(i => rob(head_sel+i.U)(head(head_sel+i.U)).rf_wdata))
    io.is_ucread_cmt            := VecInit(Seq.tabulate(4)(i => rob(head_sel+i.U)(head(head_sel+i.U)).is_ucread && io.cmt_en(i)))
    
    head_sel                    := Mux(io.predict_fail_cmt, 0.U, head_sel + PopCount(io.cmt_en))
    val head_inc                = VecInit(Seq.fill(4)(false.B))
    for(i <- 0 until 4){
        head(head_sel+i.U)      := Mux(io.predict_fail_cmt, 0.U, Mux(head(head_sel+i.U) + io.cmt_en(i) === neach.U, 0.U, head(head_sel+i.U) + io.cmt_en(i)))
        head_inc(head_sel+i.U)  := io.cmt_en(i)
    }
    for(i <- 0 until 4){
        tail(i)                 := Mux(io.predict_fail_cmt, 0.U, Mux(!full && !io.stall, Mux(tail(i) + io.inst_valid_rn(i) === neach.U, 0.U, tail(i) + io.inst_valid_rn(i)), tail(i)))
        elem_num(i)             := Mux(io.predict_fail_cmt, 0.U, Mux(!full && !io.stall, elem_num(i) + io.inst_valid_rn(i) - head_inc(i), elem_num(i) - head_inc(i)))
    }


    // stat
    io.predict_fail_stat        := predict_fail_bit
    io.br_type_stat             := VecInit(Seq.tabulate(4)(i => rob(head_sel+i.U)(head(head_sel+i.U)).br_type_pred))
    io.is_br_stat(0) := pred_update_en_bit(0) 
    for(i <- 1 until 4){
        io.is_br_stat(i) := pred_update_en_bit(i) && !(predict_fail_bit(i-1) && io.is_br_stat(i-1))
    }
} 

// object ROB extends App {
//     emitVerilog(new ROB(8), Array("-td", "build/"))
// }