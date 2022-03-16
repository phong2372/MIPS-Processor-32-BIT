module GPRs(
 input    clk,
 // write port
 input    reg_write_en,
 input  [4:0] write_reg,
 input  [31:0] write_data,
 input [31:0] write_lo,write_hi,
 //read port 1
 input  [4:0] read_reg_1,
 output  [31:0] read_data_1,
 //read port 2
 input  [4:0] read_reg_2,
 output  [31:0] read_data_2,
 //
 output [31:0] r0,r1,r2,r3,r4,r5,r6,r7,lo,hi
);

 reg [31:0] reg_array [33:0];
 integer i;
 // write port
 //reg [2:0] i;
 initial begin
  for(i=1;i<34;i=i+1)
   reg_array[i] <= 32'd0;
 end
 always @ (posedge clk ) begin
   if(reg_write_en) begin
    reg_array[write_reg] <= write_data;
	 reg_array[32] <= write_lo;
	 reg_array[33] <= write_hi;
   end
	 reg_array[0] <= 32'd0;
 end
 
 assign read_data_1 = reg_array[read_reg_1];
 assign read_data_2 = reg_array[read_reg_2];
 
 assign r0 = reg_array[0];
 assign r1 = reg_array[1];
 assign r2 = reg_array[2];
 assign r3 = reg_array[3];
 assign r4 = reg_array[4];
 assign r5 = reg_array[5];
 assign r6 = reg_array[6];
 assign r7 = reg_array[7];
 assign lo = reg_array[32];
 assign hi = reg_array[33];
 
 /*
 assign r8 = reg_array[8];
 assign r9 = reg_array[9];
 assign r10 = reg_array[10];
 assign r11 = reg_array[11];
 assign r12 = reg_array[12];
 assign r13 = reg_array[13];
 assign r14 = reg_array[14];
 assign r15 = reg_array[15];
 assign r16 = reg_array[16];
 assign r17 = reg_array[17];
 assign r18 = reg_array[18];
 assign r19 = reg_array[19];
 assign r20 = reg_array[20];
 assign r21 = reg_array[21];
 assign r22 = reg_array[22];
 assign r23 = reg_array[23];
 assign r24 = reg_array[24];
 assign r25 = reg_array[25];
 assign r26 = reg_array[26];
 assign r27 = reg_array[27];
 assign r28 = reg_array[28];
 assign r29 = reg_array[29];
 assign r30 = reg_array[30];
 assign r31 = reg_array[31];
*/


endmodule
