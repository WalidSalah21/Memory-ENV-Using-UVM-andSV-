module Memory (
    input [31:0] Data_in,
    input [3:0] Address,
    input EN,
    input CLK,
    input RST,
    input W_R, // 0 for write, 1 for read
    output reg [31:0] Data_out,
    output reg valid_out
);
    //declare index
    reg [4:0] i;
    // Declare memory array of size 16x32
    reg [31:0] memory [0:15];
    
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            // Reset memory and outputs
            Data_out <= 32'b0;
            valid_out <= 1'b0; //do that for can monitor the response of the memory
            for (i = 0; i < 16; i = i + 1) begin
                memory[i] <= 32'b0;
            end
        end else if (EN) begin
            if (W_R == 0) begin
                // Write to memory
                memory[Address] <= Data_in;
                valid_out <= 1'b0; // No valid output on write
            end
             else begin
                // Read from memory
                Data_out <= memory[Address];
                valid_out <= 1'b1; // Valid output on read
            end
        end else begin
            valid_out <= 1'b0;
        end
    end

endmodule