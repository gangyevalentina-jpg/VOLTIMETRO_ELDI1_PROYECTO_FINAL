module mem_rom(
    input wire [9:0] B,     
    output reg [15:0] S  
);

    reg [15:0] rom_mem[0:1023];

    initial begin
        $readmemh("rom_data.mem", rom_mem);
    end

    always @(*) begin
        S = rom_mem[B];
    end

endmodule
