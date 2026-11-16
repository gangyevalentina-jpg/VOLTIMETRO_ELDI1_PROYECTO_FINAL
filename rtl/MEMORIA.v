module mem_rom(
    input wire [9:0] Addr,

    output reg [15:0] Out  
);

    reg [15:0] rom_mem[0:1023];

    initial begin
        $readmemh("rom_data.mem", rom_mem);
    end

    always @(*) begin
        Out = rom_mem[Addr];
    end

endmodule
