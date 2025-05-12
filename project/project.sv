module traffic_pedestrian_controller_timed (
    input  logic        clk,
    input  logic        reset,
    input  logic        emergency,  // New emergency input
    output logic [3:0]  red,
    output logic [3:0]  yellow,
    output logic [3:0]  green,
    output logic [3:0]  pedestrian_walk
);

    typedef enum logic [1:0] {
        WEST  = 2'b00,
        NORTH = 2'b01,
        EAST  = 2'b10,
        SOUTH = 2'b11
    } direction_t;

    typedef enum logic [1:0] {
        PHASE_RED    = 2'b00,
        PHASE_YELLOW = 2'b01,
        PHASE_GREEN  = 2'b10
    } phase_t;

    direction_t direction, next_direction;
    phase_t phase, next_phase;

    logic [3:0] counter;
    logic counter_done;

    // Phase Durations
    localparam RED_CYCLES    = 4'd10;
    localparam YELLOW_CYCLES = 4'd2;
    localparam GREEN_CYCLES  = 4'd10;

    // Counter Logic
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            counter <= 4'd0;
        else if (counter_done || emergency)
            counter <= 4'd0;
        else
            counter <= counter + 1;
    end

    always_comb begin
        if (emergency)
            counter_done = 1'b0;
        else begin
            case (phase)
                PHASE_RED:    counter_done = (counter == RED_CYCLES - 1);
                PHASE_YELLOW: counter_done = (counter == YELLOW_CYCLES - 1);
                PHASE_GREEN:  counter_done = (counter == GREEN_CYCLES - 1);
                default:      counter_done = 1'b0;
            endcase
        end
    end

    // FSM transition
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            phase <= PHASE_RED;
            direction <= WEST;
        end else if (!emergency && counter_done) begin
            phase <= next_phase;
            direction <= (next_phase == PHASE_RED && phase == PHASE_GREEN) ? next_direction : direction;
        end
    end

    always_comb begin
        next_phase = PHASE_RED;  // Default
        if (!emergency) begin
            case (phase)
                PHASE_RED:    next_phase = PHASE_YELLOW;
                PHASE_YELLOW: next_phase = PHASE_GREEN;
                PHASE_GREEN:  next_phase = PHASE_RED;
                default:      next_phase = PHASE_RED;
            endcase

            case (direction)
                WEST:  next_direction = NORTH;
                NORTH: next_direction = EAST;
                EAST:  next_direction = SOUTH;
                SOUTH: next_direction = WEST;
                default: next_direction = WEST;
            endcase
        end
    end

    // Output Logic
    always_comb begin
        if (emergency) begin
            red             = 4'b0000;  // Optional: or leave high if you want to disable cars
            yellow          = 4'b1111;
            green           = 4'b0000;
            pedestrian_walk = 4'b0000;
        end else begin
            red             = 4'b1111;
            yellow          = 4'b0000;
            green           = 4'b0000;
            pedestrian_walk = 4'b0000;

            case (direction)
                WEST: begin
                    case (phase)
                        PHASE_RED:    red[0]    = 0;
                        PHASE_YELLOW: yellow[0] = 1;
                        PHASE_GREEN:  green[0]  = 1;
                    endcase
                    if (phase == PHASE_GREEN) pedestrian_walk = 4'b1000; // North
                end

                NORTH: begin
                    case (phase)
                        PHASE_RED:    red[1]    = 0;
                        PHASE_YELLOW: yellow[1] = 1;
                        PHASE_GREEN:  green[1]  = 1;
                    endcase
                    if (phase == PHASE_GREEN) pedestrian_walk = 4'b0100; // East
                end

                EAST: begin
                    case (phase)
                        PHASE_RED:    red[2]    = 0;
                        PHASE_YELLOW: yellow[2] = 1;
                        PHASE_GREEN:  green[2]  = 1;
                    endcase
                    if (phase == PHASE_GREEN) pedestrian_walk = 4'b0010; // South
                end

                SOUTH: begin
                    case (phase)
                        PHASE_RED:    red[3]    = 0;
                        PHASE_YELLOW: yellow[3] = 1;
                        PHASE_GREEN:  green[3]  = 1;
                    endcase
                    if (phase == PHASE_GREEN) pedestrian_walk = 4'b0001; // West
                end
            endcase
        end
    end

endmodule
