module tsb5;

    logic [3:0] num_tb;
    logic [2:0] sel_tb;
    logic A1, B1, C1, D1, E1, F1, G1, DP1;
    logic [7:0] AN_tb;

    localparam period = 10;

    lab5_rtl_behave UUT (
        .num(num_tb),
        .sel(sel_tb),
        .A(A1),
        .B(B1),
        .C(C1),
        .D(D1),
        .E(E1),
        .F(F1),
        .G(G1),
        .DP(DP1),
        .AN(AN_tb)
    );

    // Test sequence
    initial begin
        num_tb = 4'b0000; sel_tb = 3'b000; #period;
        num_tb = 4'b0001; sel_tb = 3'b001; #period;
        num_tb = 4'b0010; sel_tb = 3'b010; #period;
        num_tb = 4'b0011; sel_tb = 3'b011; #period;
        num_tb = 4'b0100; sel_tb = 3'b100; #period;
        num_tb = 4'b0101; sel_tb = 3'b101; #period;
        num_tb = 4'b0110; sel_tb = 3'b110; #period;
        num_tb = 4'b0111; sel_tb = 3'b111; #period;
        num_tb = 4'b1000; sel_tb = 3'b000; #period;
        num_tb = 4'b1001; sel_tb = 3'b001; #period;
        num_tb = 4'b1010; sel_tb = 3'b010; #period;
        num_tb = 4'b1011; sel_tb = 3'b011; #period;
        num_tb = 4'b1100; sel_tb = 3'b100; #period;
        num_tb = 4'b1101; sel_tb = 3'b101; #period;
        num_tb = 4'b1110; sel_tb = 3'b110; #period;
        num_tb = 4'b1111; sel_tb = 3'b111; #period;
        $stop;
    end 

    // Monitor the outputs of the DUT
    initial begin
        $monitor("num=%b, sel=%b, A1=%b, B1=%b, C1=%b, D1=%b, E1=%b, F1=%b, G1=%b, DP1=%b, AN=%b", 
                 num_tb, sel_tb, A1, B1, C1, D1, E1, F1, G1, DP1, AN_tb);
    end

endmodule