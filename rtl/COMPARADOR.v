module COMPARADOR(
    input wire [9:0] B,
    output wire mayor
);
    
    assign mayor = B[9] | B[8] | ( B[7] & B[6] & ( B[5] | B[4] | (B[3] & B[2] & (B[1] | B[0])) ) );

endmodule