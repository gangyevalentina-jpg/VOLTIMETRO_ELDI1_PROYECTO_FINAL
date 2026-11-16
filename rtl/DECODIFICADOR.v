module DECODIFICADOR(
    input [3:0] M,

    output [6:0] Di
);
    wire A = M[3], B = M[2], C = M[1], D = M[0]; 
    wire a, b, c, d, e, f, g;

    assign a = ~((~A & ~B & ~C & D) | (~A & B & ~C & ~D));
    assign b = ~((~A & B & ~C & D) | (~A & B & C & ~D));
    assign c = ~((~A & ~B & C & ~D));
    assign d = ~((~A & ~B & ~C & D) | (~A & B & ~C & ~D) | (~A & B & C & D));
    assign e = ~(D | (B & ~C));
    assign f = ~((~A & ~B & D) | (~A & ~B & C) | (~A & C & D));
    assign g = ~((~A & ~B & ~C) | (~A & B & C & D));

    assign Di = {a, b, c, d, e, f, g};
endmodule

