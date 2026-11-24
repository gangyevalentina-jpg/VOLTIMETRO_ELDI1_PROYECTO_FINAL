// Declaración de uso de IA:
//   generada con asistencia de Google Gemini (2026)
//   y validada por los autores.
module Divisor_Frecuencia(
    input  wire clk_Basys, 
    input  wire rst,
  
    output reg  clk        
);

    reg [10:0] contador;

    always @(posedge clk_Basys or posedge rst) begin
        if (rst) begin
            contador <= 11'd0;
            clk      <= 1'b0;
        end else begin
            if (contador == 11'd1249) begin
                contador <= 11'd0;
                clk      <= ~clk; 
            end else begin
                contador <= contador + 11'd1;
            end
        end
    end

endmodule