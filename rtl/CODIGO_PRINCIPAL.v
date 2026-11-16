module modulo_principal (
    
    input wire [9:0] B, 

    output wire [15:0] SS, 
    output wire [6:0] DISP1,DISP2,DISP3,
    output wire PUNTO

);
    wire [3:0] U,DD,C,M;
    wire [15:0] S;

    mem_rom MEMORIA(
        .B(B), 
        .S(SS)        
    );
    
    assign U[3:0]=SS[15:12];
    assign DD[3:0]=SS[11:8];
    assign C[3:0]=SS[7:4];
    assign M[3:0]=SS[3:0];

    wire modo_mili;
    COMPARADOR Comp (
        .B(B),
        .mayor(modo_mili)
    );

    wire [3:0] out_mux3;
    wire [3:0] out_mux2;
    wire [3:0] out_mux1;

    MUX_2x1_4bits MUX3 (
        .in_voltios(U),   
        .in_milis(DD),    
        .sel(modo_mili),
        .out(out_mux3)
    );

    MUX_2x1_4bits MUX2 (
        .in_voltios(DD),  
        .in_milis(C),     
        .sel(modo_mili),
        .out(out_mux2)
    );

    MUX_2x1_4bits MUX1 (
        .in_voltios(C),   
        .in_milis(M),     
        .sel(modo_mili),
        .out(out_mux1)
    );

    DECODIFICADOR Deco_Izquierda (.in(out_mux3), .out(DISP1));
    DECODIFICADOR Deco_Medio     (.in(out_mux2), .out(DISP2));
    DECODIFICADOR Deco_Derecha   (.in(out_mux1), .out(DISP3));
    
    assign PUNTO = modo_mili; 
endmodule