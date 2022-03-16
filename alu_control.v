module alu_control( ALU_Cnt, ALUOp, Opcode, Funct);

 output reg[3:0] ALU_Cnt;
 input [1:0] ALUOp;
 input [5:0] Opcode;
 input [5:0] Funct;
 
 wire [13:0] ALUControlIn;
 
 assign ALUControlIn = {ALUOp,Opcode,Funct};
	
 always @(ALUControlIn)
 casex (ALUControlIn)
	14'b00000000100000: ALU_Cnt=4'b0000;
	14'b00000000100010: ALU_Cnt=4'b0001;
	14'b00000000100100: ALU_Cnt=4'b0010;
	14'b00000000100101: ALU_Cnt=4'b0011;
	14'b00000000100110: ALU_Cnt=4'b0100;
	14'b00000000100111: ALU_Cnt=4'b0101;
	14'b00000000100001: ALU_Cnt=4'b0000;
	14'b00000000100011: ALU_Cnt=4'b0001;
	14'b00000000101010: ALU_Cnt=4'b0110;
	14'b00000000101011: ALU_Cnt=4'b0111;
	14'b00000000000010: ALU_Cnt=4'b1000;
	14'b00000000000000: ALU_Cnt=4'b1001;
	
	14'b01001000xxxxxx: ALU_Cnt=4'b0000;
	14'b01001001xxxxxx: ALU_Cnt=4'b0000;	
	14'b01001100xxxxxx: ALU_Cnt=4'b0010;
	14'b01001101xxxxxx: ALU_Cnt=4'b0011;
	14'b01001110xxxxxx: ALU_Cnt=4'b0100;
	14'b01001010xxxxxx: ALU_Cnt=4'b0110;
	14'b01001011xxxxxx: ALU_Cnt=4'b0111;
	
	14'b10100011xxxxxx: ALU_Cnt=4'b0000;
	14'b10101011xxxxxx: ALU_Cnt=4'b0000;
	
	14'b11000100xxxxxx: ALU_Cnt=4'b0001;
	14'b11000101xxxxxx: ALU_Cnt=4'b0001;
	//14'11	000010	xxxxxx: ALU_Cnt=4'b0001;
	//14'11	000011	xxxxxx: ALU_Cnt=4'b0001;

	
   
  default: ALU_Cnt=4'b0000;
  endcase
endmodule