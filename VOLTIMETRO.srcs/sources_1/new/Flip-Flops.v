module Flip-Flops
  (
    input  wire       clk,    
    input  wire       rst,   
    input  wire       B,      
    input  wire [9:0] E_deco, 
    input  wire       P,      
    output reg  [9:0] Q_rom  
);

    reg [9:0] ff_etapa1;


    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ff_etapa1 <= 10'b0000000000;
        end else begin
            if (E_deco[0]) ff_etapa1[0] <= B;
            if (E_deco[1]) ff_etapa1[1] <= B;
            if (E_deco[2]) ff_etapa1[2] <= B;
            if (E_deco[3]) ff_etapa1[3] <= B;
            if (E_deco[4]) ff_etapa1[4] <= B;
            if (E_deco[5]) ff_etapa1[5] <= B;
            if (E_deco[6]) ff_etapa1[6] <= B;
            if (E_deco[7]) ff_etapa1[7] <= B;
            if (E_deco[8]) ff_etapa1[8] <= B;
            if (E_deco[9]) ff_etapa1[9] <= B;
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            Q_rom <= 10'b0000000000;
        end else if (P) begin
            Q_rom[0] <= ff_etapa1[0];
            Q_rom[1] <= ff_etapa1[1];
            Q_rom[2] <= ff_etapa1[2];
            Q_rom[3] <= ff_etapa1[3];
            Q_rom[4] <= ff_etapa1[4];
            Q_rom[5] <= ff_etapa1[5];
            Q_rom[6] <= ff_etapa1[6];
            Q_rom[7] <= ff_etapa1[7];
            Q_rom[8] <= ff_etapa1[8];
            Q_rom[9] <= ff_etapa1[9];
        end
    end

endmodule