`timescale 1ns/1ps

module exp_7_tb;

    // Testbench signals
    logic clk, reset, write;
    logic [3:0] num;
    logic [2:0] sel;
    logic [6:0] segments;
    logic [7:0] anode;

    // Instantiate the DUT (Device Under Test)
    exp_7 dut (
        .clk(clk),
        .reset(reset),
        .write(write),
        .num(num),
        .sel(sel),
        .segments(segments),
        .anode(anode)
    );

    // Clock generation (50 MHz)
    always #10 clk = ~clk; // 20ns period -> 50 MHz clock

    // Testbench procedure
    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;
        write = 0;
        num = 4'b0000;
        sel = 3'b000;

        // Apply reset
        #50 reset = 0;

        // Write values to memory to display "2023EE29"
        write = 1;
        num = 4'h2; sel = 3'b000; #20; // Write '2' to mem[1]
        num = 4'h0; sel = 3'b001; #20; // Write '0' to mem[2]
        num = 4'h2; sel = 3'b010; #20; // Write '2' to mem[3]
        num = 4'h3; sel = 3'b011; #20; // Write '3' to mem[4]
        num = 4'hE; sel = 3'b100; #20; // Write 'E' to mem[5]
        num = 4'hE; sel = 3'b101; #20; // Write 'E' to mem[6]
        num = 4'h2; sel = 3'b110; #20; // Write '2' to mem[7]
        num = 4'h9; sel = 3'b111; #20; // Write '9' to mem[8]
        write = 0;

        // Observe the display cycling
        #1000;

        // Apply reset again
        reset = 1; #50; reset = 0;

        // Observe behavior after reset
        #500;

        // Finish simulation
        $finish;
    end

    // Monitor outputs for each anode
    initial begin
        $monitor("Time: %0t | reset: %b | write: %b | sel: %b | num: %b | segments: %b | anode: %b",
                 $time, reset, write, sel, num, segments, anode);
    end

    // Check each anode explicitly
    always @(posedge clk) begin
        case (anode)
            8'b11111110: $display("Time: %0t | Display 0 active | segments: %b (Expected: 2)", $time, segments);
            8'b11111101: $display("Time: %0t | Display 1 active | segments: %b (Expected: 0)", $time, segments);
            8'b11111011: $display("Time: %0t | Display 2 active | segments: %b (Expected: 2)", $time, segments);
            8'b11110111: $display("Time: %0t | Display 3 active | segments: %b (Expected: 3)", $time, segments);
            8'b11101111: $display("Time: %0t | Display 4 active | segments: %b (Expected: E)", $time, segments);
            8'b11011111: $display("Time: %0t | Display 5 active | segments: %b (Expected: E)", $time, segments);
            8'b10111111: $display("Time: %0t | Display 6 active | segments: %b (Expected: 2)", $time, segments);
            8'b01111111: $display("Time: %0t | Display 7 active | segments: %b (Expected: 9)", $time, segments);
            default: $display("Time: %0t | Unknown anode state: %b", $time, anode);
        endcase
    end

endmodule