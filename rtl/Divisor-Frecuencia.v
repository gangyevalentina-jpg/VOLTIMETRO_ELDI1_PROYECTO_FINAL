module Divisor_Frecuencia(
    input  wire clk_Basys, 
    input  wire rst,
  
    output reg  clk        
);

    reg [11:0] contador;

    always @(posedge clk_Basys or posedge rst) begin
        if (rst) begin
            contador <= 12'd0;
            clk      <= 1'b0;
        end else begin
            if (contador == 12'd2499) begin
                contador <= 12'd0;
                clk      <= ~clk; 
            end else begin
                contador <= contador + 1'b1;
            end
        end
    end

endmodule