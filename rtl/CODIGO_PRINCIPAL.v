module Modulo_Principal (
    input  wire       clk_Basys, 
    input  wire       Sw1,       
    input  wire       Sw2,       
    input  wire       C,         
    
    output wire [9:0] R_2R,    
    output wire [6:0] Di_1,     
    output wire [6:0] Di_2,      
    output wire [6:0] Di_3,      
    output wire       PUNTO     
);

    wire clk; 

    Divisor_Frecuencia Bloque_Clk (
        .clk_Basys(clk_Basys), 
        .rst(Sw2),             
        .clk(clk)              
    );

    wire       F;
    wire       E;
    wire       R; 
    wire       A;
    wire       B;
    wire       P;
    wire       WE;

  	wire [3:0] S;
  	wire [3:0] M1;
    wire [3:0] M2;
    wire [3:0] M3;
  
    wire [9:0] E_ff;
    wire [9:0] Addr;
  
    wire [15:0] Out;  
    
    wire [3:0] U    = Out[15:12];
    wire [3:0] DD   = Out[11:8];
    wire [3:0] Ce   = Out[7:4];
    wire [3:0] Mi   = Out[3:0];

    FSM Bloque_FSM(
        .clk(clk),
        .rst(Sw2),      
        .C(C),
        .F(F),
        .R(R),    
        .E(E),
        .B(B),
        .P(P),
        .WE(WE)
    );

    contador_FSM_ Bloque_Contador(
        .clk(clk),
        .R(R),    
        .E(E),
        .S(S),
        .F(F)
    );

    DECO_CONT Bloque_DecoCont(
        .s(S),
        .E_ff(E_ff)
    );

    Flip_Flops Bloque_FlipFlops(
        .clk(clk),
        .R(R),    
        .B(B),
        .E_ff(E_ff),
        .P(P),
        .Sw1(Sw1),      
        .Addr(Addr),
        .R_2R(R_2R),
        .WE(WE) 
    );

    mem_rom Bloque_Memoria(
        .Addr(Addr),
        .Out(Out)
    );

    COMPARADOR Bloque_Comparador(
        .Addr(Addr),
        .A(A)
    );
  
  	assign PUNTO = A;
  

    MUX_2x1_4bits MUX1(
        .in_voltios(U),
        .in_milis(DD),
        .A(A),
        .M(M1)
    );

    MUX_2x1_4bits MUX2(
        .in_voltios(DD),
        .in_milis(Ce),
        .A(A),
        .M(M2)
    );

    MUX_2x1_4bits MUX3(
        .in_voltios(Ce),
        .in_milis(Mi),
        .A(A),
        .M(M3)
    );

    DECODIFICADOR DECO_1(
        .M(M1),
        .Di(Di_1)
    );

    DECODIFICADOR DECO_2(
        .M(M2),
        .Di(Di_2)
    );

    DECODIFICADOR DECO_3(
        .M(M3),
        .Di(Di_3)
    );

endmodule