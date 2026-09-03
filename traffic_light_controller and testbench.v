//====================================================
// FPGA-Based Traffic Light Controller
// With Emergency Priority System
//====================================================

module traffic_light_controller (
    input clk,
    input reset,
    input emergency_A,
    input emergency_B,

    output reg A_red,
    output reg A_yellow,
    output reg A_green,

    output reg B_red,
    output reg B_yellow,
    output reg B_green
);

    // State encoding
    reg [1:0] state;

    parameter A_GREEN  = 2'b00;
    parameter A_YELLOW = 2'b01;
    parameter B_GREEN  = 2'b10;
    parameter B_YELLOW = 2'b11;

    // State register
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= A_GREEN;
        else begin

            // Emergency priority
            if (emergency_A)
                state <= A_GREEN;

            else if (emergency_B)
                state <= B_GREEN;

            else begin
                case (state)

                    A_GREEN:
                        state <= A_YELLOW;

                    A_YELLOW:
                        state <= B_GREEN;

                    B_GREEN:
                        state <= B_YELLOW;

                    B_YELLOW:
                        state <= A_GREEN;

                    default:
                        state <= A_GREEN;

                endcase
            end
        end
    end

    // Output logic
    always @(*) begin

        // Default: all lights OFF
        A_red    = 0;
        A_yellow = 0;
        A_green  = 0;

        B_red    = 0;
        B_yellow = 0;
        B_green  = 0;

        case (state)

            // Road A GREEN, Road B RED
            A_GREEN: begin
                A_green = 1;
                B_red   = 1;
            end

            // Road A YELLOW, Road B RED
            A_YELLOW: begin
                A_yellow = 1;
                B_red    = 1;
            end

            // Road B GREEN, Road A RED
            B_GREEN: begin
                A_red   = 1;
                B_green = 1;
            end

            // Road B YELLOW, Road A RED
            B_YELLOW: begin
                A_red    = 1;
                B_yellow = 1;
            end

            default: begin
                A_red = 1;
                B_red = 1;
            end

        endcase
    end

endmodule


//====================================================
// TESTBENCH
//====================================================

module tb;

    reg clk;
    reg reset;
    reg emergency_A;
    reg emergency_B;

    wire A_red;
    wire A_yellow;
    wire A_green;

    wire B_red;
    wire B_yellow;
    wire B_green;

    // Instantiate the traffic light controller
    traffic_light_controller uut (
        .clk(clk),
        .reset(reset),
        .emergency_A(emergency_A),
        .emergency_B(emergency_B),

        .A_red(A_red),
        .A_yellow(A_yellow),
        .A_green(A_green),

        .B_red(B_red),
        .B_yellow(B_yellow),
        .B_green(B_green)
    );

    //================================================
    // CLOCK
    //================================================
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    //================================================
    // WAVEFORM DUMP
    //================================================
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);
    end

    //================================================
    // TEST
    //================================================
    initial begin

        // Initial values
        reset = 1;
        emergency_A = 0;
        emergency_B = 0;

        #10;

        // Release reset
        reset = 0;

        // Normal operation
        #20;

        // Emergency for Road B
        emergency_B = 1;
        #20;
        emergency_B = 0;

        // Normal operation
        #30;

        // Emergency for Road A
        emergency_A = 1;
        #20;
        emergency_A = 0;

        // Continue normal operation
        #30;

        $finish;
    end

    //================================================
    // DISPLAY OUTPUT
    //================================================
    initial begin
        $monitor(
            "TIME=%0t | A(RYG)=%b%b%b | B(RYG)=%b%b%b | Emergency A=%b B=%b",
            $time,
            A_red, A_yellow, A_green,
            B_red, B_yellow, B_green,
            emergency_A, emergency_B
        );
    end

endmodule