module adder(a,b,sum,overflow);
input signed [31:0] a,b;
output signed  [31:0] sum;
output overflow;

wire signed [32:0] temp;

assign temp = a + b;
assign sum = temp[31:0];
assign overflow = temp[32];

endmodule 