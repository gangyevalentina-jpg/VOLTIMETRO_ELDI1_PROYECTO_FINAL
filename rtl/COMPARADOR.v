module COMPARADOR(
    input wire [9:0] Addr,
    output wire A
);
    
    assign A = Addr[9] | Addr[8] | ( Addr[7] & Addr[6] & ( Addr[5] | Addr[4] | (Addr[3] & Addr[2] & (Addr[1] | Addr[0])) ) );

endmodule