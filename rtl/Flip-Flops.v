module Flip_Flops (
    input  wire       clk,    
    input  wire       R,   
    input  wire       B,      
    input  wire [9:0] E_ff, 
    input  wire       P,   
    input wire        Sw1,
    input wire        WE,
        
    output reg  [9:0] Addr,  
    output wire [9:0] R_2R 
);

    reg [9:0] Etapa1;
    assign R_2R = Etapa1;

    wire En_Etapa2 = P & ~Sw1;

    always @(posedge clk or posedge R) begin
        if (R) begin
            Etapa1 <= 10'b0000000000;
        end 
        else begin
            if (E_ff[0]) Etapa1[0] <= B;
            if (E_ff[1]) Etapa1[1] <= B;
            if (E_ff[2]) Etapa1[2] <= B;
            if (E_ff[3]) Etapa1[3] <= B;
            if (E_ff[4]) Etapa1[4] <= B;
            if (E_ff[5]) Etapa1[5] <= B;
            if (E_ff[6]) Etapa1[6] <= B;
            if (E_ff[7]) Etapa1[7] <= B;
            if (E_ff[8]) Etapa1[8] <= B;
            if (E_ff[9]) Etapa1[9] <= B;
        end
    end

    always @(posedge clk or posedge R) begin
        if (WE) begin
            if (En_Etapa2) begin
                Addr[0] <= Etapa1[0];
                Addr[1] <= Etapa1[1];
                Addr[2] <= Etapa1[2];
                Addr[3] <= Etapa1[3];
                Addr[4] <= Etapa1[4];
                Addr[5] <= Etapa1[5];
                Addr[6] <= Etapa1[6];
                Addr[7] <= Etapa1[7];
                Addr[8] <= Etapa1[8];
                Addr[9] <= Etapa1[9];
            end
        end
    end

endmodule