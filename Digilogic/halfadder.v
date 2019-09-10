`timescale 1ns / 1ps

module halfadder(a,b,c,s);

input a,b;
output c,s;

assign s=a^b;
assign c=a+b;

endmodule

module fulladder (x,y,z,sum,carry);

input x,y,z;
wire g, h, j;
output sum, carry;

halfadder a1 (.a(x), .b(y), .c(g), .s(h));
halfadder a2 (.a(h), .b(z), .c(j), .s(sum));
assign carry = j +g;

endmodule

