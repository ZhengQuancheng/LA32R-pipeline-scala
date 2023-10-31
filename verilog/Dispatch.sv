// Generated by CIRCT firtool-1.58.0
module Dispatch(
  input        io_inst_packs_0_inst_valid,
  input  [1:0] io_inst_packs_0_fu_id,
  input        io_inst_packs_1_inst_valid,
  input  [1:0] io_inst_packs_1_fu_id,
  input        io_inst_packs_2_inst_valid,
  input  [1:0] io_inst_packs_2_fu_id,
  input        io_inst_packs_3_inst_valid,
  input  [1:0] io_inst_packs_3_fu_id,
  input  [3:0] io_elem_num_0,
               io_elem_num_1,
  output [1:0] io_insts_disp_index_0_0,
               io_insts_disp_index_0_1,
               io_insts_disp_index_0_2,
               io_insts_disp_index_0_3,
               io_insts_disp_index_1_0,
               io_insts_disp_index_1_1,
               io_insts_disp_index_1_2,
               io_insts_disp_index_1_3,
               io_insts_disp_index_2_0,
               io_insts_disp_index_2_1,
               io_insts_disp_index_2_2,
               io_insts_disp_index_2_3,
               io_insts_disp_index_3_0,
               io_insts_disp_index_3_1,
               io_insts_disp_index_3_2,
               io_insts_disp_index_3_3,
  output       io_insts_disp_valid_0_0,
               io_insts_disp_valid_0_1,
               io_insts_disp_valid_0_2,
               io_insts_disp_valid_0_3,
               io_insts_disp_valid_1_0,
               io_insts_disp_valid_1_1,
               io_insts_disp_valid_1_2,
               io_insts_disp_valid_1_3,
               io_insts_disp_valid_2_0,
               io_insts_disp_valid_2_1,
               io_insts_disp_valid_2_2,
               io_insts_disp_valid_2_3,
               io_insts_disp_valid_3_0,
               io_insts_disp_valid_3_1,
               io_insts_disp_valid_3_2,
               io_insts_disp_valid_3_3
);

  wire [1:0] queue_sel_0 =
    io_inst_packs_0_fu_id == 2'h0
      ? {1'h0, io_elem_num_0 > io_elem_num_1}
      : io_inst_packs_0_fu_id;
  wire       _queue_id_hit_0_0_T = queue_sel_0 == 2'h0;
  wire [3:0] fu1_next_num = _queue_id_hit_0_0_T ? io_elem_num_0 + 4'h1 : io_elem_num_0;
  wire       _queue_id_hit_0_1_T = queue_sel_0 == 2'h1;
  wire [3:0] fu2_next_num = _queue_id_hit_0_1_T ? io_elem_num_1 + 4'h1 : io_elem_num_1;
  wire [1:0] queue_sel_1 =
    io_inst_packs_1_fu_id == 2'h0
      ? {1'h0, fu1_next_num > fu2_next_num}
      : io_inst_packs_1_fu_id;
  wire       _queue_id_hit_1_0_T = queue_sel_1 == 2'h0;
  wire [3:0] fu1_next_num_1 = _queue_id_hit_1_0_T ? fu1_next_num + 4'h1 : fu1_next_num;
  wire       _queue_id_hit_1_1_T = queue_sel_1 == 2'h1;
  wire [3:0] fu2_next_num_1 = _queue_id_hit_1_1_T ? fu2_next_num + 4'h1 : fu2_next_num;
  wire [1:0] queue_sel_2 =
    io_inst_packs_2_fu_id == 2'h0
      ? {1'h0, fu1_next_num_1 > fu2_next_num_1}
      : io_inst_packs_2_fu_id;
  wire       _queue_id_hit_2_0_T = queue_sel_2 == 2'h0;
  wire       _queue_id_hit_2_1_T = queue_sel_2 == 2'h1;
  wire [1:0] queue_sel_3 =
    io_inst_packs_3_fu_id == 2'h0
      ? {1'h0,
         (_queue_id_hit_2_0_T
            ? fu1_next_num_1 + 4'h1
            : fu1_next_num_1) > (_queue_id_hit_2_1_T
                                   ? fu2_next_num_1 + 4'h1
                                   : fu2_next_num_1)}
      : io_inst_packs_3_fu_id;
  wire       queue_id_hit_0_0 = _queue_id_hit_0_0_T & io_inst_packs_0_inst_valid;
  wire       queue_id_hit_0_1 = _queue_id_hit_0_1_T & io_inst_packs_0_inst_valid;
  wire       queue_id_hit_0_2 = queue_sel_0 == 2'h2 & io_inst_packs_0_inst_valid;
  wire       queue_id_hit_0_3 = (&queue_sel_0) & io_inst_packs_0_inst_valid;
  wire       queue_id_hit_1_0 = _queue_id_hit_1_0_T & io_inst_packs_1_inst_valid;
  wire       queue_id_hit_1_1 = _queue_id_hit_1_1_T & io_inst_packs_1_inst_valid;
  wire       queue_id_hit_1_2 = queue_sel_1 == 2'h2 & io_inst_packs_1_inst_valid;
  wire       queue_id_hit_1_3 = (&queue_sel_1) & io_inst_packs_1_inst_valid;
  wire       queue_id_hit_2_0 = _queue_id_hit_2_0_T & io_inst_packs_2_inst_valid;
  wire       queue_id_hit_2_1 = _queue_id_hit_2_1_T & io_inst_packs_2_inst_valid;
  wire       queue_id_hit_2_2 = queue_sel_2 == 2'h2 & io_inst_packs_2_inst_valid;
  wire       queue_id_hit_2_3 = (&queue_sel_2) & io_inst_packs_2_inst_valid;
  wire       queue_id_hit_3_0 = queue_sel_3 == 2'h0 & io_inst_packs_3_inst_valid;
  wire       queue_id_hit_3_1 = queue_sel_3 == 2'h1 & io_inst_packs_3_inst_valid;
  wire       queue_id_hit_3_2 = queue_sel_3 == 2'h2 & io_inst_packs_3_inst_valid;
  wire       queue_id_hit_3_3 = (&queue_sel_3) & io_inst_packs_3_inst_valid;
  wire       _GEN = queue_id_hit_1_0 & ~queue_id_hit_0_0;
  wire       _GEN_0 = queue_id_hit_1_0 & queue_id_hit_0_0;
  wire [1:0] next_alloc_index_1_0 =
    queue_id_hit_1_0 ? {1'h0, queue_id_hit_0_0} + 2'h1 : {1'h0, queue_id_hit_0_0};
  wire       _GEN_1 = queue_id_hit_1_1 & ~queue_id_hit_0_1;
  wire       _GEN_2 = queue_id_hit_1_1 & queue_id_hit_0_1;
  wire [1:0] next_alloc_index_1_1 =
    queue_id_hit_1_1 ? {1'h0, queue_id_hit_0_1} + 2'h1 : {1'h0, queue_id_hit_0_1};
  wire       _GEN_3 = queue_id_hit_1_2 & ~queue_id_hit_0_2;
  wire       _GEN_4 = queue_id_hit_1_2 & queue_id_hit_0_2;
  wire [1:0] next_alloc_index_1_2 =
    queue_id_hit_1_2 ? {1'h0, queue_id_hit_0_2} + 2'h1 : {1'h0, queue_id_hit_0_2};
  wire       _GEN_5 = queue_id_hit_1_3 & ~queue_id_hit_0_3;
  wire       _GEN_6 = queue_id_hit_1_3 & queue_id_hit_0_3;
  wire [1:0] next_alloc_index_1_3 =
    queue_id_hit_1_3 ? {1'h0, queue_id_hit_0_3} + 2'h1 : {1'h0, queue_id_hit_0_3};
  wire       _GEN_7 = next_alloc_index_1_0 == 2'h0;
  wire       _GEN_8 = queue_id_hit_2_0 & next_alloc_index_1_0 == 2'h1;
  wire       _GEN_9 = queue_id_hit_2_0 & next_alloc_index_1_0 == 2'h2;
  wire       _GEN_10 = queue_id_hit_2_0 & (&next_alloc_index_1_0);
  wire [1:0] next_alloc_index_2_0 =
    queue_id_hit_2_0 ? next_alloc_index_1_0 + 2'h1 : next_alloc_index_1_0;
  wire       _GEN_11 = next_alloc_index_1_1 == 2'h0;
  wire       _GEN_12 = queue_id_hit_2_1 & next_alloc_index_1_1 == 2'h1;
  wire       _GEN_13 = queue_id_hit_2_1 & next_alloc_index_1_1 == 2'h2;
  wire       _GEN_14 = queue_id_hit_2_1 & (&next_alloc_index_1_1);
  wire [1:0] next_alloc_index_2_1 =
    queue_id_hit_2_1 ? next_alloc_index_1_1 + 2'h1 : next_alloc_index_1_1;
  wire       _GEN_15 = next_alloc_index_1_2 == 2'h0;
  wire       _GEN_16 = queue_id_hit_2_2 & next_alloc_index_1_2 == 2'h1;
  wire       _GEN_17 = queue_id_hit_2_2 & next_alloc_index_1_2 == 2'h2;
  wire       _GEN_18 = queue_id_hit_2_2 & (&next_alloc_index_1_2);
  wire [1:0] next_alloc_index_2_2 =
    queue_id_hit_2_2 ? next_alloc_index_1_2 + 2'h1 : next_alloc_index_1_2;
  wire       _GEN_19 = next_alloc_index_1_3 == 2'h0;
  wire       _GEN_20 = queue_id_hit_2_3 & next_alloc_index_1_3 == 2'h1;
  wire       _GEN_21 = queue_id_hit_2_3 & next_alloc_index_1_3 == 2'h2;
  wire       _GEN_22 = queue_id_hit_2_3 & (&next_alloc_index_1_3);
  wire [1:0] next_alloc_index_2_3 =
    queue_id_hit_2_3 ? next_alloc_index_1_3 + 2'h1 : next_alloc_index_1_3;
  wire       _GEN_23 = queue_id_hit_3_0 & next_alloc_index_2_0 == 2'h0;
  wire       _GEN_24 = next_alloc_index_2_0 == 2'h1;
  wire       _GEN_25 = next_alloc_index_2_0 == 2'h2;
  wire       _GEN_26 = queue_id_hit_3_1 & next_alloc_index_2_1 == 2'h0;
  wire       _GEN_27 = next_alloc_index_2_1 == 2'h1;
  wire       _GEN_28 = next_alloc_index_2_1 == 2'h2;
  wire       _GEN_29 = queue_id_hit_3_2 & next_alloc_index_2_2 == 2'h0;
  wire       _GEN_30 = next_alloc_index_2_2 == 2'h1;
  wire       _GEN_31 = next_alloc_index_2_2 == 2'h2;
  wire       _GEN_32 = queue_id_hit_3_3 & next_alloc_index_2_3 == 2'h0;
  wire       _GEN_33 = next_alloc_index_2_3 == 2'h1;
  wire       _GEN_34 = next_alloc_index_2_3 == 2'h2;
  assign io_insts_disp_index_0_0 =
    _GEN_23 ? 2'h3 : queue_id_hit_2_0 & _GEN_7 ? 2'h2 : {1'h0, _GEN};
  assign io_insts_disp_index_0_1 =
    queue_id_hit_3_0 & _GEN_24
      ? 2'h3
      : _GEN_8 ? 2'h2 : {1'h0, queue_id_hit_1_0 & queue_id_hit_0_0};
  assign io_insts_disp_index_0_2 = queue_id_hit_3_0 & _GEN_25 ? 2'h3 : {_GEN_9, 1'h0};
  assign io_insts_disp_index_0_3 =
    queue_id_hit_3_0 & (&next_alloc_index_2_0) ? 2'h3 : {_GEN_10, 1'h0};
  assign io_insts_disp_index_1_0 =
    _GEN_26 ? 2'h3 : queue_id_hit_2_1 & _GEN_11 ? 2'h2 : {1'h0, _GEN_1};
  assign io_insts_disp_index_1_1 =
    queue_id_hit_3_1 & _GEN_27
      ? 2'h3
      : _GEN_12 ? 2'h2 : {1'h0, queue_id_hit_1_1 & queue_id_hit_0_1};
  assign io_insts_disp_index_1_2 = queue_id_hit_3_1 & _GEN_28 ? 2'h3 : {_GEN_13, 1'h0};
  assign io_insts_disp_index_1_3 =
    queue_id_hit_3_1 & (&next_alloc_index_2_1) ? 2'h3 : {_GEN_14, 1'h0};
  assign io_insts_disp_index_2_0 =
    _GEN_29 ? 2'h3 : queue_id_hit_2_2 & _GEN_15 ? 2'h2 : {1'h0, _GEN_3};
  assign io_insts_disp_index_2_1 =
    queue_id_hit_3_2 & _GEN_30
      ? 2'h3
      : _GEN_16 ? 2'h2 : {1'h0, queue_id_hit_1_2 & queue_id_hit_0_2};
  assign io_insts_disp_index_2_2 = queue_id_hit_3_2 & _GEN_31 ? 2'h3 : {_GEN_17, 1'h0};
  assign io_insts_disp_index_2_3 =
    queue_id_hit_3_2 & (&next_alloc_index_2_2) ? 2'h3 : {_GEN_18, 1'h0};
  assign io_insts_disp_index_3_0 =
    _GEN_32 ? 2'h3 : queue_id_hit_2_3 & _GEN_19 ? 2'h2 : {1'h0, _GEN_5};
  assign io_insts_disp_index_3_1 =
    queue_id_hit_3_3 & _GEN_33
      ? 2'h3
      : _GEN_20 ? 2'h2 : {1'h0, queue_id_hit_1_3 & queue_id_hit_0_3};
  assign io_insts_disp_index_3_2 = queue_id_hit_3_3 & _GEN_34 ? 2'h3 : {_GEN_21, 1'h0};
  assign io_insts_disp_index_3_3 =
    queue_id_hit_3_3 & (&next_alloc_index_2_3) ? 2'h3 : {_GEN_22, 1'h0};
  assign io_insts_disp_valid_0_0 =
    _GEN_23
    | (queue_id_hit_2_0 ? _GEN_7 | _GEN | queue_id_hit_0_0 : _GEN | queue_id_hit_0_0);
  assign io_insts_disp_valid_0_1 =
    queue_id_hit_3_0 ? _GEN_24 | _GEN_8 | _GEN_0 : _GEN_8 | _GEN_0;
  assign io_insts_disp_valid_0_2 = queue_id_hit_3_0 & _GEN_25 | _GEN_9;
  assign io_insts_disp_valid_0_3 = queue_id_hit_3_0 & (&next_alloc_index_2_0) | _GEN_10;
  assign io_insts_disp_valid_1_0 =
    _GEN_26
    | (queue_id_hit_2_1
         ? _GEN_11 | _GEN_1 | queue_id_hit_0_1
         : _GEN_1 | queue_id_hit_0_1);
  assign io_insts_disp_valid_1_1 =
    queue_id_hit_3_1 ? _GEN_27 | _GEN_12 | _GEN_2 : _GEN_12 | _GEN_2;
  assign io_insts_disp_valid_1_2 = queue_id_hit_3_1 & _GEN_28 | _GEN_13;
  assign io_insts_disp_valid_1_3 = queue_id_hit_3_1 & (&next_alloc_index_2_1) | _GEN_14;
  assign io_insts_disp_valid_2_0 =
    _GEN_29
    | (queue_id_hit_2_2
         ? _GEN_15 | _GEN_3 | queue_id_hit_0_2
         : _GEN_3 | queue_id_hit_0_2);
  assign io_insts_disp_valid_2_1 =
    queue_id_hit_3_2 ? _GEN_30 | _GEN_16 | _GEN_4 : _GEN_16 | _GEN_4;
  assign io_insts_disp_valid_2_2 = queue_id_hit_3_2 & _GEN_31 | _GEN_17;
  assign io_insts_disp_valid_2_3 = queue_id_hit_3_2 & (&next_alloc_index_2_2) | _GEN_18;
  assign io_insts_disp_valid_3_0 =
    _GEN_32
    | (queue_id_hit_2_3
         ? _GEN_19 | _GEN_5 | queue_id_hit_0_3
         : _GEN_5 | queue_id_hit_0_3);
  assign io_insts_disp_valid_3_1 =
    queue_id_hit_3_3 ? _GEN_33 | _GEN_20 | _GEN_6 : _GEN_20 | _GEN_6;
  assign io_insts_disp_valid_3_2 = queue_id_hit_3_3 & _GEN_34 | _GEN_21;
  assign io_insts_disp_valid_3_3 = queue_id_hit_3_3 & (&next_alloc_index_2_3) | _GEN_22;
endmodule

