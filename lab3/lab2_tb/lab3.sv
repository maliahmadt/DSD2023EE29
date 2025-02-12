module lab3 (
    input logic a,
    input logic b,
    input logic c,
    output logic x,
    output logic y
);
// Local vars
logic x1,x2,x3,x4;
// Circuit Description
assign x1 = ~c;
assign x2 = a|b;
assign x3 = ~(a&b);
assign x4 = x2^x3;

// output vars
assign x = x1^x2;
assign y = x2&x4;
    
endmodule