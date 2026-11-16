module DECODIFICADOR(
    input [3:0] in,
    output [6:0] out
);
    wire A = in[3], B = in[2], C = in[1], D = in[0]; 
    wire a, b, c, d, e, f, g;

    assign a = ~((~A & ~B & ~C & D) | (~A & B & ~C & ~D));
    assign b = ~((~A & B & ~C & D) | (~A & B & C & ~D));
    assign c = ~((~A & ~B & C & ~D));
    assign d = ~((~A & ~B & ~C & D) | (~A & B & ~C & ~D) | (~A & B & C & D));
    assign e = ~(D | (B & ~C));
    assign f = ~((~A & ~B & D) | (~A & ~B & C) | (~A & C & D));
    assign g = ~((~A & ~B & ~C) | (~A & B & C & D));

    assign out = {a, b, c, d, e, f, g};
endmodule

