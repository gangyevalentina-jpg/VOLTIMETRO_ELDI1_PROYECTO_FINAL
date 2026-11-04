module MUX_2x1_4bits(
    input wire [3:0] in_voltios, 
    input wire [3:0] in_milis,   
    input wire sel,              
    output wire [3:0] out
);

    
    assign out[0] = (sel & in_voltios[0]) | (~sel & in_milis[0]);
    assign out[1] = (sel & in_voltios[1]) | (~sel & in_milis[1]);
    assign out[2] = (sel & in_voltios[2]) | (~sel & in_milis[2]);
    assign out[3] = (sel & in_voltios[3]) | (~sel & in_milis[3]);

endmodule