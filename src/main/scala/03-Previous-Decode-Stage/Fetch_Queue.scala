import chisel3._
import chisel3.util._
import Inst_Pack._
import CPU_Config._

class Fetch_Queue_IO extends Bundle{
    val insts_pack          = Input(Vec(2, new inst_pack_PD_t))

    val next_ready          = Input(Bool())
    val insts_valid_decode  = Output(Vec(2, Bool()))
    val insts_pack_id       = Output(Vec(2, new inst_pack_PD_t))
    
    val full                = Output(Bool())
    val flush               = Input(Bool())
}

class Fetch_Queue extends Module{
    val io = IO(new Fetch_Queue_IO)

    /* config */
    val ROW_WIDTH = FQ_NUM / 2
    val queue = RegInit(VecInit.fill(2)(VecInit.fill(ROW_WIDTH)(0.U.asTypeOf(new inst_pack_PD_t))))

    // val head = RegInit(VecInit.fill(2)(0.U(log2Ceil(ROW_WIDTH).W)))
    // val tail = RegInit(0.U(log2Ceil(FQ_NUM).W))
    def shift_add1(x: UInt): UInt = {
        val n = x.getWidth
        x(n-2, 0) ## x(n-1)
    }
    def shift_add2(x: UInt): UInt = {
        val n = x.getWidth
        x(n-3, 0) ## x(n-1, n-2)
    }
    val head = RegInit(1.U(ROW_WIDTH.W))
    val tail = RegInit(1.U(FQ_NUM.W))
    val tail_odd = VecInit.tabulate(ROW_WIDTH)(i => tail(2*i+1)).asUInt 
    val tail_even = VecInit.tabulate(ROW_WIDTH)(i => tail(2*i)).asUInt
    val tail_for_compare = tail_odd | tail_even

    val full = (head & shift_add1(tail_for_compare)).orR
    val empty = (head & tail_for_compare).orR

    // val full  = !(head(0) ^ (tail(log2Ceil(FQ_NUM)-1, 1) + 1.U))
    // val empty = !(head(1) ^ tail(log2Ceil(FQ_NUM)-1, 1))


    // Enqueue
    io.full := full

    // calculate the entry index for each instruction
    // val entry_idxs = Wire(Vec(2, UInt(log2Ceil(FQ_NUM).W)))
    // var entry_index = tail
    // for(i <- 0 until 2){
    //     entry_idxs(i) := entry_index
    //     entry_index = Mux(io.insts_pack(i).inst_valid, entry_index + 1.U, entry_index)
    // }
    val write_mask = tail & Fill(FQ_NUM, io.insts_pack(0).inst_valid) | shift_add1(tail) & Fill(FQ_NUM, io.insts_pack(1).inst_valid)
    val write_mask_odd = VecInit.tabulate(ROW_WIDTH)(i => write_mask(2*i+1)).asUInt
    val write_mask_even = VecInit.tabulate(ROW_WIDTH)(i => write_mask(2*i)).asUInt

    val write_data_even = Mux(tail_even.orR, io.insts_pack(0), io.insts_pack(1))
    val write_data_odd = Mux(!tail_even.orR, io.insts_pack(0), io.insts_pack(1))


    // // write to queue
    // for(i <- 0 until 2){
    //     when(!full && io.insts_pack(i).inst_valid){
    //         queue(entry_idxs(i)(0))(entry_idxs(i)(log2Ceil(FQ_NUM)-1, 1)) := io.insts_pack(i)
    //     }
    // }
    // even queue write
    for(i <- 0 until ROW_WIDTH){
        when(!full && write_mask_even(i)){
            queue(0)(i) := write_data_even
        }
    }
    // odd queue write
    for(i <- 0 until ROW_WIDTH){
        when(!full && write_mask_odd(i)){
            queue(1)(i) := write_data_odd
        }
    }

    // Dequeue
    for(i <- 0 until 2){
        io.insts_pack_id(i) := Mux1H(head, queue(i))
        io.insts_valid_decode(i) := !empty
    }
    // update ptrs
    when(!full){
        tail := Mux(io.insts_pack(0).inst_valid, Mux(io.insts_pack(1).inst_valid, shift_add2(tail), shift_add1(tail)), tail)
    }
    when(io.next_ready && !empty){
        // head := head + 1.U
        // for(i <- 0 until 2){
        //     head(i) := head(i) + 1.U
        // }
        head := shift_add1(head)
    }
    when(io.flush){
        // head.foreach(_ := 0.U)
        // tail := 0.U
        head := 1.U
        tail := 1.U
    }


}
// object Fetch_Queue extends App{
//     emitVerilog(new Fetch_Queue, Array("-td", "build/"))
// }
