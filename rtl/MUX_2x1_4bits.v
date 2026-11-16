module MUX_2x1_4bits(
    input wire [3:0] in_voltios, 
    input wire [3:0] in_milis,   
    input wire A,

    output wire [3:0] M
);

    
    assign M[0] = (A & in_voltios[0]) | (~A & in_milis[0]);
    assign M[1] = (A & in_voltios[1]) | (~A & in_milis[1]);
    assign M[2] = (A & in_voltios[2]) | (~A & in_milis[2]);
    assign M[3] = (A & in_voltios[3]) | (~A & in_milis[3]);

endmodule