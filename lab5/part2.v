module part3 #(
    parameter CLOCK_FREQUENCY = 50000000
) (
    input ClockIn,
    input Reset,
    input Start,
    input [2:0] Letter,
    output DotDashOut,
    output NewBitOut
);

    wire PulseOut;
    wire [11:0] MorseCode;

    // Instantiate RateDivider for 0.5 seconds pulse
    RateDivider #(.CLOCK_FREQUENCY(CLOCK_FREQUENCY), .DIVIDE_VALUE(CLOCK_FREQUENCY / 2 - 1)) divider (
        .ClockIn(ClockIn),
        .Reset(Reset),
        .PulseOut(PulseOut)
    );

    // Instantiate MorseEncoder
    MorseEncoder encoder(
        .Letter(Letter),
        .MorseCode(MorseCode)
    );

    // Instantiate ShiftRegister
    ShiftRegister shifter(
        .ClockIn(ClockIn),
        .Reset(Reset),
        .Pulse(PulseOut),
        .ParallelData(MorseCode),
        .SerialOut(DotDashOut),
        .ShiftDone(NewBitOut)
    );

endmodule

module RateDivider #(
    parameter CLOCK_FREQUENCY = 50000000, 
    parameter DIVIDE_VALUE = CLOCK_FREQUENCY / 2 - 1
) (
    input ClockIn,
    input Reset,
    output reg PulseOut
);

    reg [31:0] counter = 0;

    always @(posedge ClockIn or posedge Reset) begin
        if (Reset) begin
            counter <= 0;
            PulseOut <= 0;
        end else if (counter == DIVIDE_VALUE) begin
            PulseOut <= 1;
            counter <= 0;
        end else begin
            PulseOut <= 0;
            counter <= counter + 1;
        end
    end

endmodule

module MorseEncoder(
    input [2:0] Letter,
    output reg [11:0] MorseCode
);

    always @(*) begin
        case(Letter)
            3'b000: MorseCode = 12'b101110000000; // A
            3'b001: MorseCode = 12'b111010101000; // B
            3'b010: MorseCode = 12'b111010111010; // C
            3'b011: MorseCode = 12'b111010100000; // D
            3'b100: MorseCode = 12'b100000000000; // E
            3'b101: MorseCode = 12'b101011101000; // F
            3'b110: MorseCode = 12'b111011101000; // G
            3'b111: MorseCode = 12'b101010100000; // H
        endcase
    end

endmodule

module ShiftRegister(
    input ClockIn,
    input Reset,
    input Pulse, // Comes from RateDivider
    input [11:0] ParallelData, 
    output reg SerialOut,
    output reg ShiftDone
);

    reg [11:0] regData = 0;
    reg [3:0] newBitOutCounter = 0; // 4-bit counter for NewBitOut pulse width

    always @(posedge ClockIn or posedge Reset) begin
        if (Reset) begin
            regData <= 0;
            SerialOut <= 0;
            ShiftDone <= 0;
            newBitOutCounter <= 0;
        end else if (Pulse) begin
            regData <= regData << 1;
            SerialOut <= regData[11];
            if(newBitOutCounter < 9) begin  // 9 clock cycle pulse width
                newBitOutCounter <= newBitOutCounter + 1;
                ShiftDone <= 1;
            end else begin
                ShiftDone <= 0;
            end
        end else begin
            ShiftDone <= 0;
        end
    end

endmodule
