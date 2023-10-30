import chisel3._
import chisel3.util._
import Inst_Pack._
import Control_Signal._

// LUT: 2377
object Dispatch_Func{
    def Dispatch_Ready_Generate(pr: UInt, prd_queue: Vec[UInt], queue_sel: UInt, index: UInt): Bool = {
        val prd_hit = Wire(Vec(9, Bool()))
        prd_hit := 0.U.asTypeOf(Vec(9, Bool()))
        val n = MuxLookup(index, 0.U)(Seq(
            0.U -> 8.U,
            1.U -> 8.U,
            2.U -> 9.U,
            3.U -> 8.U
        ))
        for(i <- 0 until 9){
            when(i.U < n) {
                prd_hit(i) := pr === prd_queue(i)
            }
        }
        !(prd_hit.exists(_ === true.B))
    }
    def Ready_Generate(pr: UInt, prd_queue: Vec[Vec[UInt]], queue_sel: UInt): Bool = {
        val prd_ready = Wire(Vec(4, Bool()))
        for(i <- 0 until 4){
            prd_ready(i) := Dispatch_Ready_Generate(pr, prd_queue(i), queue_sel, i.U(2.W))
        }
        prd_ready.forall(_ === true.B)
    }

}
class Dispatch_IO(n: Int) extends Bundle{
    val inst_packs          = Input(Vec(4, new inst_pack_RN_t))

    // index of rd in the issue queue
    val prd_queue           = Input(Vec(4, Vec(n+1, UInt(7.W))))
    val elem_num            = Input(Vec(2, UInt((log2Ceil(n)+1).W)))

    // output for each issue queue
    val insts_disp_index    = Output(Vec(4, Vec(4, UInt(2.W))))
    val insts_disp_valid    = Output(Vec(4, Vec(4, Bool())))

    val insert_num          = Output(Vec(4, UInt(3.W)))

    val prj_ready           = Output(Vec(4, Bool()))

    val prk_ready           = Output(Vec(4, Bool()))
    
}

class Dispatch extends RawModule{
    val io = IO(new Dispatch_IO(8))

    val queue_sel = Wire(Vec(4, UInt(2.W)))
    val queue_id_hit = Wire(Vec(4, Vec(4, Bool())))
    val queue_id_hit_trav = Wire(Vec(4, Vec(4, Bool())))
    for(i <- 0 until 4){
        queue_sel(i) := Mux(io.inst_packs(i).fu_id === ARITH, 
                        Mux(io.elem_num(0) <= io.elem_num(1), 0.U, 1.U), io.inst_packs(i).fu_id)
    }
    for(i <- 0 until 4){
        for(j <- 0 until 4){
            queue_id_hit(i)(j) := queue_sel(i) === j.U && io.inst_packs(i).inst_valid
            queue_id_hit_trav(i)(j) := queue_id_hit(j)(i)
        }
        io.insert_num(i) := Mux(queue_id_hit_trav(i).asUInt.orR, PopCount(queue_id_hit_trav(i)), 0.U)
    }
    import Dispatch_Func._
    for(i <- 0 until 4){
        io.prj_ready(i) := !io.inst_packs(i).rj_valid || io.inst_packs(i).prj === 0.U || (!io.inst_packs(i).prj_raw && Ready_Generate(io.inst_packs(i).prj, io.prd_queue, queue_sel(i)))
        io.prk_ready(i) := !io.inst_packs(i).rk_valid || io.inst_packs(i).prk === 0.U || (!io.inst_packs(i).prk_raw && Ready_Generate(io.inst_packs(i).prk, io.prd_queue, queue_sel(i)))
    }
    
    // alloc insts to issue queue, pressed
    io.insts_disp_index := DontCare
    var alloc_index = VecInit(Seq.fill(4)(0.U(2.W)))
    for(i <- 0 until 4){
        var next_alloc_index = Wire(Vec(4, UInt(2.W)))
        for(j <- 0 until 4){
            when(queue_id_hit(i)(j)){
                io.insts_disp_index(j)(alloc_index(j)) := i.U(3.W)
            }
            next_alloc_index(j) := Mux(queue_id_hit(i)(j), alloc_index(j) + 1.U, alloc_index(j))
        }
        alloc_index = next_alloc_index
    }
    io.insts_disp_valid := io.insert_num.map(x => VecInit(((1.U(4.W) << x)(3, 0) - 1.U).asBools))
}

