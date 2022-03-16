module Datapath_Unit(
 input clk,
 input jump,beq,mem_read,mem_write,alu_src,reg_dst,mem_to_reg,reg_write_en,bne,jal_write_en,
 input[1:0] alu_op,
 output Flag_zero,Overflow,
 output[5:0] opcode,funct,
 output [31:0] alu_result,pc_out,instr_out,WD,RDA,RDB,DMEM_OUT,DMEM_IN,INB_ALU,
 output [31:0] r0,r1,r2,r3,r4,r5,r6,r7,ra,
 output [4:0] RD,RAA,RAB
);
 reg  [31:0] pc_current;
 wire [31:0] pc_next,pc4;
 wire [31:0] instr;
 wire [4:0] write_reg;
 wire [31:0] write_data,jal_address;
 wire [4:0] read_reg_1;
 wire [31:0] read_data_1;
 wire [4:0] read_reg_2;
 wire [31:0] read_data_2;
 wire [31:0] ext_im,in2_alu;
 wire [3:0] ALU_Control;
 wire [31:0] ALU_out;
 wire zero_flag,bne_control,of;
 wire [31:0] PC_j, PC_beq, PC_4beq,PC_4bne,PC_bne;
 wire beq_control;
 wire [27:0] jump_shift;
 wire [31:0] mem_read_data;
 wire [4:0] shamt;
 //output 

 assign RD = write_reg;
 assign WD =  write_data;
 assign RAA = read_reg_1;
 assign RDA = read_data_1;
 assign RAB = read_reg_2;
 assign RDB = read_data_2;
 assign DMEM_OUT = mem_read_data;
 assign DMEM_IN = ALU_out;
 assign Flag_zero = zero_flag;
 assign Overflow = of;
 assign opcode = instr[31:26];
 assign funct  = instr[5:0];
 assign shamt = instr[10:6];
 assign alu_result = ALU_out;  
 assign pc_out = pc_current;  
 assign instr_out = instr;
 assign INB_ALU = in2_alu;

 // PC 
 initial begin
  pc_current <= 32'd0;
 end
 always @(posedge clk)
 begin 
   pc_current <= pc_next;

 end
 assign pc4 = pc_current + 32'd4;
 // instruction memory
 Instruction_Memory im1(.PC(pc_current),.instruction(instr));
 // jump shift left 2
 assign jump_shift = {instr[23:0],2'b0};
 // multiplexer regdest
 assign read_reg_1 = instr[25:21];
 assign read_reg_2 = instr[20:16];
 assign write_reg = (reg_dst==1'b1)? instr[15:11] : instr[20:16];


 // GENERAL PURPOSE REGISTERs
 RF reg_file
 (
  .clk(clk),
  .reg_write_en(reg_write_en),
  .jal_write_en(jal_write_en),//Jal
  .write_reg(write_reg),//Write address
  .write_data(write_data),//Write data
  .jal_address(jal_address),//Write address Jal
  .read_reg_1(read_reg_1),//Read address A
  .read_data_1(read_data_1),//Read data A
  .read_reg_2(read_reg_2),//Read address B
  .read_data_2(read_data_2),//Read data B
  .r0(r0),.r1(r1),.r2(r2),.r3(r3),.r4(r4),.r5(r5),.r6(r6),.r7(r7),.ra(ra)
 );
 // immediate extend
 SE SE0(.in(instr[15:0]),.out(ext_im));
 // ALU control unit
 alu_control ALU_Control_unit(.ALU_Cnt(ALU_Control),.ALUOp(alu_op),.Opcode(instr[31:26]),.Funct(funct));
 // multiplexer alu_src
 assign in2_alu = (alu_src==1'b1) ? ext_im : read_data_2;
 // ALU 
 ALU alu_unit(.a(read_data_1),.b(in2_alu),.alu_control(ALU_Control),.shamt(shamt),.result(ALU_out),.zero(zero_flag),.overflow(of));
 // PC beq add
 assign PC_beq = pc4 + {ext_im[29:0],2'b0};
 assign PC_bne = pc4 + {ext_im[29:0],2'b0};
 // beq control
 assign beq_control = beq & zero_flag;
 assign bne_control = bne & (~zero_flag);
 // PC_beq
 assign PC_4beq = (beq_control==1'b1) ? PC_beq : pc4;
 // PC_bne
 assign PC_4bne = (bne_control==1'b1) ? PC_bne : PC_4beq;
 // PC_j
 assign PC_j = {pc4[31:28],jump_shift};
 // PC_next
 assign pc_next = (jump == 1'b1) ? PC_j :  PC_4bne;
 /// Data memory
  Data_Memory dm
   (
    .clk(clk),
    .mem_access_addr(ALU_out),
    .mem_write_data(read_data_2),
    .mem_write_en(mem_write),
    .mem_read(mem_read),
    .mem_read_data(mem_read_data)
   );

 // write back
 wire [31:0] PCRA;
 assign PCRA = PC_j - 31'd4;
 assign write_data = (mem_to_reg == 1'b1)?  mem_read_data: ALU_out;
 assign jal_address = (jal_write_en == 1'b1) ? PCRA : 32'd0; //Jal
 
endmodule