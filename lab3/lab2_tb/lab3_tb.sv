module lab3_tb;
logic a1;
logic b1;
logic c1;
logic x1;
logic y1;
localparam period = 10;
lab3 UUT(
.a(a1),
.b(b1),
.c(c1),
.x(x1),
.y(y1)
);
initial //initial block executes only once
begin
// Provide different combinations of the inputs to check validity of code
a1 = 0; b1 = 0; c1 = 0;
#period;
a1 = 0; b1 = 0; c1 = 1;
#period;
a1 = 0; b1 = 1; c1 = 0;
#period;
a1 = 0; b1 = 1; c1 = 1;
#period;
a1 = 1; b1 = 0; c1 = 0;
#period;
a1 = 1; b1 = 0; c1 = 1;
#period;
a1 = 1; b1 = 1; c1 = 0;
#period;
a1 = 1; b1 = 1; c1 = 1;
#period;
$stop;
end
initial
begin
/*the following system task will print out the signal values
every time they change on the Transcript Window */
$monitor("x=%x y=%b, a=%b, b=%b, c=%b",x1, y1,a1,b1,c1);
end
endmodule
