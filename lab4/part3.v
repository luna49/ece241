module part3(
    input wire clock,
    input wire reset,
    input wire ParallelLoadn,
    input wire RotateRight,
    input wire ASRight,
    input wire [3:0] Data_IN,
    output reg [3:0] Q
);

    always @(posedge clock or posedge reset) begin
        if (reset) 
            Q <= 4'b0; // Reset
        else if (!ParallelLoadn) 
            Q <= Data_IN; // Parallel load
        else if (RotateRight) 
            Q <= (ASRight) ? {Q[3], Q[3:1]} : {Q[0], Q[3:1]}; // Right rotation
        else 
            Q <= {Q[2:0], Q[3]}; // Left rotation
    end

endmodule
