module DECO_CONT(
    input [0:3]s,
    output [0:9]E
);
    
    wire S3=s[3], S2=s[2], S1=s[1], S0=s[0];
    wire En_0, En_1, En_2, En_3, En_4, En_5, En_6, En_7, En_8, En_9;
    
    assign En_9 = ~S3 & ~S2 & ~S1 & S0;
    assign En_8 = ~S3 & ~S2 & S1 & ~S0;
    assign En_7 = ~S3 & ~S2 & S1 & S0;
    assign En_6 = ~S3 & S2 & ~S1 & ~S0;
    assign En_5 = ~S3 & S2 & ~S1 & S0;
    assign En_4 = ~S3 & S2 & S1 & ~S0;
    assign En_3 = ~S3 & S2 & S1 & S0;
    assign En_2 = S3 & ~S2 & ~S1 & ~S0;
    assign En_1 = S3 & ~S2 & ~S1 & S0;
    assign En_0 = S3 & ~S2 & S1 & ~S0;

endmodule