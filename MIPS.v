module MIPS(
 input clk,
 output [31:0] pc_out,
 output [31:0] r0,r1,r2,r3,r4,r5,r6,r7,ra,
 output Overflow,Flag_zero
);
 wire [4:0] RD,RAA,RAB;
 wire [31:0] alu_result,instr_out,WD,RDA,RDB,DMEM_OUT,DMEM_IN,INB_ALU;
 wire jump,bne,beq,mem_read,mem_write,alu_src,reg_dst,mem_to_reg,reg_write_en,jal_write_en;
 wire[1:0] alu_op;
 wire [5:0] opcode;
 wire [5:0] funct;
 // Datapath
 Datapath_Unit DU
 (
  .clk(clk),
  .jump(jump),
  .beq(beq),
  .mem_read(mem_read),
  .mem_write(mem_write),
  .alu_src(alu_src),
  .reg_dst(reg_dst),
  .mem_to_reg(mem_to_reg),
  .reg_write_en(reg_write_en),
  .jal_write_en(jal_write_en),// Jal
  .bne(bne),
  .alu_op(alu_op),
  .opcode(opcode),
  .funct(funct),
  .alu_result(alu_result),
  .pc_out(pc_out),
  .instr_out(instr_out),
  .Overflow(Overflow),
  .Flag_zero(Flag_zero),
  .RD(RD),
  .WD(WD),
  .RAA(RAA),
  .RDA(RDA),
  .RAB(RAB),
  .RDB(RDB),
  .DMEM_IN(DMEM_IN),
  .DMEM_OUT(DMEM_OUT),
  .INB_ALU(INB_ALU),
  .r0(r0),.r1(r1),.r2(r2),.r3(r3),.r4(r4),.r5(r5),.r6(r6),.r7(r7),.ra(ra)
 );
 // control unit
 Control_Unit control
 (
  .opcode(opcode),
  .funct(funct),
  .reg_dst(reg_dst),
  .mem_to_reg(mem_to_reg),
  .alu_op(alu_op),
  .jump(jump),
  .bne(bne),
  .beq(beq),
  .jal(jal_write_en),
  .mem_read(mem_read),
  .mem_write(mem_write),
  .alu_src(alu_src),
  .reg_write(reg_write_en)
 );

endmodule