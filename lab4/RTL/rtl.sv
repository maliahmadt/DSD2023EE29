module rtl(
 input logic[1:0]a,
 input logic[1:0]b,
 output logic r,
 output logic g,
 output logic bl
   );
wire r1, r2, r3, r4, r5;
wire g1, g2, g3, g4, g5;
wire bl1, bl2, bl3, bl4;
assign r1= (~b[0])&(~b[1]);
assign r2= (a[1]&(~b[0]));
assign r3= (a[0]&(~b[0]));
assign r4= (a[0]&(~b[1]));
assign r5= (a[0]& a[1]);
assign r= r1 | r2 | r3 | r4 | r5;
assign g1= (~a[0])&(~a[1]);
assign g2=(b[1]&(~a[0]));
assign g3= (b[0]&(~a[0]));
assign g4= (b[0]&(~a[1]));
assign g5= (b[0]& b[1]);
assign g= g1 | g2 | g3 | g4 | g5;
assign bl1= (b[1]&(~a[1]));
assign bl2= (b[0]&(~a[0]));
assign bl3= (a[1]&(~b[1]));
assign bl4= (a[0]&(~b[0]));
assign bl= bl1 | bl2 | bl3 | bl4;
endmodule
