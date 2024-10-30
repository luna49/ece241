module part3 #(
    parameter CLOCK_FREQUENCY = 50000000
) (
    input ClockIn,
    input Reset,
    input Start,
    input [2:0] Letter,
    output reg DotDashOut,
    output reg NewBitOut
);

    // Morse Code Patterns
    wire [11:0] MorseCodes[7:0];
    assign MorseCodes[0] = 12'b101110000000; // A
    assign MorseCodes[1] = 12'b111010101000; // B
    assign MorseCodes[2] = 12'b111010111010; // C
    assign MorseCodes[3] = 12'b111010100000; // D
    assign MorseCodes[4] = 12'b100000000000; // E
    assign MorseCodes[5] = 12'b101011101000; // F
    assign MorseCodes[6] = 12'b111011101000; // G
    assign MorseCodes[7] = 12'b101010100000; // H

    // MUX output
    wire [11:0] selectedCode = MorseCodes[Letter];

    // Shift Register with parallel load
    reg [11:0] shiftRegister = 12'b0;
    always @(posedge ClockIn or posedge Reset) begin
        if (Reset) 
            shiftRegister <= 12'b0;
        else if (Start)
            shiftRegister <= selectedCode;
        else 
            shiftRegister <= shiftRegister << 1;
    end

    // Rate Divider (pulse every 0.5 seconds)
    reg [31:0] dividerCounter = 0;
    reg halfSecondPulse = 0;
    always @(posedge ClockIn or posedge Reset) begin
        if (Reset) 
            dividerCounter <= 0;
        else if (dividerCounter == (CLOCK_FREQUENCY/2) - 1) begin
            dividerCounter <= 0;
            halfSecondPulse <= ~halfSecondPulse;
        end
        else 
            dividerCounter <= dividerCounter + 1;
    end

    // DotDashOut and NewBitOut logic
    reg [3:0] newBitOutCounter = 0; // 4-bit counter for NewBitOut pulse width
    always @(posedge ClockIn or posedge Reset) begin
        if (Reset) begin
            DotDashOut <= 0;
            NewBitOut <= 0;
            newBitOutCounter <= 0;
        end else if (halfSecondPulse) begin
            DotDashOut <= shiftRegister[11];
            NewBitOut <= 1;         // Begin the NewBitOut pulse
            newBitOutCounter <= 0;  // Reset the counter for NewBitOut pulse width
        end else if (newBitOutCounter < 9) begin  // 9 clock cycle pulse width
            newBitOutCounter <= newBitOutCounter + 1;
            NewBitOut <= 1;
        end else begin
            NewBitOut <= 0;
        end
    end

endmodule
