module ALU(
 input signed [31:0] a,  //src1
 input signed [31:0] b,  //src2
 input  [3:0] alu_control, //function sel
 input [4:0] shamt,
 
 output reg signed [31:0] result,  //result 
 output zero,
 output reg overflow
);
wire lt_result,gt_result,lt_result_un,gt_result_un;
wire signed [31:0] sum,sub;
wire ofadd,ofsub;
adder adder1(
.a(a),
.b(b),
.sum(sum),
.overflow(ofadd)
);
subtractor sub1(
.a(a),
.b(b),
.sub(sub),
.overflow(ofsub)
);
comp c1(
.a(a),
.b(b),
.lt(lt_result),
.gt(gt_result),
.eq()
);
comp_un c1_un(
.a(a),
.b(b),
.lt(lt_result_un),
.gt(gt_result_un),
.eq()
);
always @(*)
begin 
 case(alu_control)
 4'b0000: begin 
			 result = sum; // add
			 overflow = ofadd;
 end 
 4'b0001: begin 
			 result = sub; // sub
			 overflow = ofsub;
 end 
 4'b0010: result = a&b; 	 // and
 4'b0011: result = a|b;   // or
 4'b0100: result = a^b;   // xor
 4'b0101: result = ~(a|b); // nor
 4'b0110: result = lt_result; //SLT
 4'b0111: result = lt_result_un; //SLTU
 4'b1000: result = b>>shamt;  // SRL
 4'b1001: result = b<<shamt; //SLL
 default:begin 
			result = a + b;// add
			end
 endcase
end

assign zero = (result==32'd0) ? 1'b1: 1'b0;
 
endmodule