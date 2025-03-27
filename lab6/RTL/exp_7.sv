`timescale 1ns / 1ps

module exp_7(
    input logic [3:0] num,
    input logic [2:0] sel,
    input logic clk,
    input logic reset,
    input logic write,
    output logic [7:0] anode,
    output logic [6:0] segments
    );

    logic [7:0][3:0] mem; // Memory array for mem[1] to mem[8]
    logic [3:0] mem0;     // Separate variable for mem[0]
    logic newclk = 0;
    logic [2:0] innersel;
    logic [17:0] count;

    // Clock divider to generate a slower clock (newclk)
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            newclk <= 0;
            count <= 0;
        end else if (count == 18'd249999) begin
            newclk <= ~newclk;
            count <= 0;
        end else begin
            count <= count + 1;
        end
    end

    // Memory initialization and write logic
    always_ff @(posedge newclk or posedge reset) begin
        if (reset) begin
            for (int i = 0; i < 8; i++) begin
                mem[i] <= 0;
            end
        end else if (write) begin
            if (sel >= 3'h0 && sel <= 3'h7) begin
                mem[sel] <= num;
            end
        end
    end

    // Memory read logic (assign mem0 in the sequential block)
    always_ff @(posedge newclk or posedge reset) begin
        if (reset) begin
            mem0 <= 4'b0000;
        end else begin
            if (innersel >= 3'h0 && innersel <= 3'h7) begin
                mem0 <= mem[innersel];
            end else begin
                mem0 <= 4'b0000;
            end
        end
    end

    // innersel generation logic
    always_ff @(posedge newclk or posedge reset) begin
        if (reset) begin
            innersel <= 3'b000;
        end else begin
            innersel <= innersel + 1;
        end
    end

    // 7-segment display decoder
    always_comb begin
        case (mem0)
            4'h0: segments = 7'b0000001;
            4'h1: segments = 7'b1001111;
            4'h2: segments = 7'b0010010;
            4'h3: segments = 7'b0000110;
            4'h4: segments = 7'b1001100;
            4'h5: segments = 7'b0100100;
            4'h6: segments = 7'b0100000;
            4'h7: segments = 7'b0001111;
            4'h8: segments = 7'b0000000;
            4'h9: segments = 7'b0000100;
            4'hA: segments = 7'b0001000;
            4'hB: segments = 7'b1100000;
            4'hC: segments = 7'b0110001;
            4'hD: segments = 7'b1000010;
            4'hE: segments = 7'b0110000;
            4'hF: segments = 7'b0111000;
            default: segments = 7'b1111111;
        endcase
    end

    // Anode control logic
    always_comb begin
        if (write == 0) begin
            anode = ~(8'b1 << innersel); // Activate one anode at a time
        end else begin
            anode = 8'b00000000; // Turn off all anodes during write
        end
    end

endmodule