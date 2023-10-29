// Generated by CIRCT firtool-1.56.1
module PD_FQ_Reg(
  input         clock,
                reset,
                io_flush,
                io_stall,
  input  [31:0] io_insts_pack_PD_0_pc,
                io_insts_pack_PD_0_inst,
  input         io_insts_pack_PD_0_inst_valid,
                io_insts_pack_PD_0_predict_jump,
  input  [31:0] io_insts_pack_PD_0_pred_npc,
                io_insts_pack_PD_1_pc,
                io_insts_pack_PD_1_inst,
  input         io_insts_pack_PD_1_inst_valid,
                io_insts_pack_PD_1_predict_jump,
  input  [31:0] io_insts_pack_PD_1_pred_npc,
                io_insts_pack_PD_2_pc,
                io_insts_pack_PD_2_inst,
  input         io_insts_pack_PD_2_inst_valid,
                io_insts_pack_PD_2_predict_jump,
  input  [31:0] io_insts_pack_PD_2_pred_npc,
                io_insts_pack_PD_3_pc,
                io_insts_pack_PD_3_inst,
  input         io_insts_pack_PD_3_inst_valid,
                io_insts_pack_PD_3_predict_jump,
  input  [31:0] io_insts_pack_PD_3_pred_npc,
  output [31:0] io_insts_pack_FQ_0_pc,
                io_insts_pack_FQ_0_inst,
  output        io_insts_pack_FQ_0_inst_valid,
                io_insts_pack_FQ_0_predict_jump,
  output [31:0] io_insts_pack_FQ_0_pred_npc,
                io_insts_pack_FQ_1_pc,
                io_insts_pack_FQ_1_inst,
  output        io_insts_pack_FQ_1_inst_valid,
                io_insts_pack_FQ_1_predict_jump,
  output [31:0] io_insts_pack_FQ_1_pred_npc,
                io_insts_pack_FQ_2_pc,
                io_insts_pack_FQ_2_inst,
  output        io_insts_pack_FQ_2_inst_valid,
                io_insts_pack_FQ_2_predict_jump,
  output [31:0] io_insts_pack_FQ_2_pred_npc,
                io_insts_pack_FQ_3_pc,
                io_insts_pack_FQ_3_inst,
  output        io_insts_pack_FQ_3_inst_valid,
                io_insts_pack_FQ_3_predict_jump,
  output [31:0] io_insts_pack_FQ_3_pred_npc
);

  reg [31:0] insts_pack_reg_0_pc;
  reg [31:0] insts_pack_reg_0_inst;
  reg        insts_pack_reg_0_inst_valid;
  reg        insts_pack_reg_0_predict_jump;
  reg [31:0] insts_pack_reg_0_pred_npc;
  reg [31:0] insts_pack_reg_1_pc;
  reg [31:0] insts_pack_reg_1_inst;
  reg        insts_pack_reg_1_inst_valid;
  reg        insts_pack_reg_1_predict_jump;
  reg [31:0] insts_pack_reg_1_pred_npc;
  reg [31:0] insts_pack_reg_2_pc;
  reg [31:0] insts_pack_reg_2_inst;
  reg        insts_pack_reg_2_inst_valid;
  reg        insts_pack_reg_2_predict_jump;
  reg [31:0] insts_pack_reg_2_pred_npc;
  reg [31:0] insts_pack_reg_3_pc;
  reg [31:0] insts_pack_reg_3_inst;
  reg        insts_pack_reg_3_inst_valid;
  reg        insts_pack_reg_3_predict_jump;
  reg [31:0] insts_pack_reg_3_pred_npc;
  always @(posedge clock) begin
    if (reset) begin
      insts_pack_reg_0_pc <= 32'h0;
      insts_pack_reg_0_inst <= 32'h0;
      insts_pack_reg_0_inst_valid <= 1'h0;
      insts_pack_reg_0_predict_jump <= 1'h0;
      insts_pack_reg_0_pred_npc <= 32'h0;
      insts_pack_reg_1_pc <= 32'h0;
      insts_pack_reg_1_inst <= 32'h0;
      insts_pack_reg_1_inst_valid <= 1'h0;
      insts_pack_reg_1_predict_jump <= 1'h0;
      insts_pack_reg_1_pred_npc <= 32'h0;
      insts_pack_reg_2_pc <= 32'h0;
      insts_pack_reg_2_inst <= 32'h0;
      insts_pack_reg_2_inst_valid <= 1'h0;
      insts_pack_reg_2_predict_jump <= 1'h0;
      insts_pack_reg_2_pred_npc <= 32'h0;
      insts_pack_reg_3_pc <= 32'h0;
      insts_pack_reg_3_inst <= 32'h0;
      insts_pack_reg_3_inst_valid <= 1'h0;
      insts_pack_reg_3_predict_jump <= 1'h0;
      insts_pack_reg_3_pred_npc <= 32'h0;
    end
    else begin
      if (io_flush) begin
        insts_pack_reg_0_pc <= 32'h0;
        insts_pack_reg_0_inst <= 32'h0;
        insts_pack_reg_0_pred_npc <= 32'h0;
        insts_pack_reg_1_pc <= 32'h0;
        insts_pack_reg_1_inst <= 32'h0;
        insts_pack_reg_1_pred_npc <= 32'h0;
        insts_pack_reg_2_pc <= 32'h0;
        insts_pack_reg_2_inst <= 32'h0;
        insts_pack_reg_2_pred_npc <= 32'h0;
        insts_pack_reg_3_pc <= 32'h0;
        insts_pack_reg_3_inst <= 32'h0;
        insts_pack_reg_3_pred_npc <= 32'h0;
      end
      else if (io_stall) begin
      end
      else begin
        insts_pack_reg_0_pc <= io_insts_pack_PD_0_pc;
        insts_pack_reg_0_inst <= io_insts_pack_PD_0_inst;
        insts_pack_reg_0_pred_npc <= io_insts_pack_PD_0_pred_npc;
        insts_pack_reg_1_pc <= io_insts_pack_PD_1_pc;
        insts_pack_reg_1_inst <= io_insts_pack_PD_1_inst;
        insts_pack_reg_1_pred_npc <= io_insts_pack_PD_1_pred_npc;
        insts_pack_reg_2_pc <= io_insts_pack_PD_2_pc;
        insts_pack_reg_2_inst <= io_insts_pack_PD_2_inst;
        insts_pack_reg_2_pred_npc <= io_insts_pack_PD_2_pred_npc;
        insts_pack_reg_3_pc <= io_insts_pack_PD_3_pc;
        insts_pack_reg_3_inst <= io_insts_pack_PD_3_inst;
        insts_pack_reg_3_pred_npc <= io_insts_pack_PD_3_pred_npc;
      end
      insts_pack_reg_0_inst_valid <=
        ~io_flush
        & (io_stall ? insts_pack_reg_0_inst_valid : io_insts_pack_PD_0_inst_valid);
      insts_pack_reg_0_predict_jump <=
        ~io_flush
        & (io_stall ? insts_pack_reg_0_predict_jump : io_insts_pack_PD_0_predict_jump);
      insts_pack_reg_1_inst_valid <=
        ~io_flush
        & (io_stall ? insts_pack_reg_1_inst_valid : io_insts_pack_PD_1_inst_valid);
      insts_pack_reg_1_predict_jump <=
        ~io_flush
        & (io_stall ? insts_pack_reg_1_predict_jump : io_insts_pack_PD_1_predict_jump);
      insts_pack_reg_2_inst_valid <=
        ~io_flush
        & (io_stall ? insts_pack_reg_2_inst_valid : io_insts_pack_PD_2_inst_valid);
      insts_pack_reg_2_predict_jump <=
        ~io_flush
        & (io_stall ? insts_pack_reg_2_predict_jump : io_insts_pack_PD_2_predict_jump);
      insts_pack_reg_3_inst_valid <=
        ~io_flush
        & (io_stall ? insts_pack_reg_3_inst_valid : io_insts_pack_PD_3_inst_valid);
      insts_pack_reg_3_predict_jump <=
        ~io_flush
        & (io_stall ? insts_pack_reg_3_predict_jump : io_insts_pack_PD_3_predict_jump);
    end
  end // always @(posedge)
  assign io_insts_pack_FQ_0_pc = insts_pack_reg_0_pc;
  assign io_insts_pack_FQ_0_inst = insts_pack_reg_0_inst;
  assign io_insts_pack_FQ_0_inst_valid = insts_pack_reg_0_inst_valid;
  assign io_insts_pack_FQ_0_predict_jump = insts_pack_reg_0_predict_jump;
  assign io_insts_pack_FQ_0_pred_npc = insts_pack_reg_0_pred_npc;
  assign io_insts_pack_FQ_1_pc = insts_pack_reg_1_pc;
  assign io_insts_pack_FQ_1_inst = insts_pack_reg_1_inst;
  assign io_insts_pack_FQ_1_inst_valid = insts_pack_reg_1_inst_valid;
  assign io_insts_pack_FQ_1_predict_jump = insts_pack_reg_1_predict_jump;
  assign io_insts_pack_FQ_1_pred_npc = insts_pack_reg_1_pred_npc;
  assign io_insts_pack_FQ_2_pc = insts_pack_reg_2_pc;
  assign io_insts_pack_FQ_2_inst = insts_pack_reg_2_inst;
  assign io_insts_pack_FQ_2_inst_valid = insts_pack_reg_2_inst_valid;
  assign io_insts_pack_FQ_2_predict_jump = insts_pack_reg_2_predict_jump;
  assign io_insts_pack_FQ_2_pred_npc = insts_pack_reg_2_pred_npc;
  assign io_insts_pack_FQ_3_pc = insts_pack_reg_3_pc;
  assign io_insts_pack_FQ_3_inst = insts_pack_reg_3_inst;
  assign io_insts_pack_FQ_3_inst_valid = insts_pack_reg_3_inst_valid;
  assign io_insts_pack_FQ_3_predict_jump = insts_pack_reg_3_predict_jump;
  assign io_insts_pack_FQ_3_pred_npc = insts_pack_reg_3_pred_npc;
endmodule

