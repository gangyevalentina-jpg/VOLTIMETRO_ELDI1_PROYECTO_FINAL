module FSM(
    input wire clk,       
    input wire rst,      
    input wire C,         
    input wire F,        
    
    output wire R,        
    output wire E,       
    output wire B,        
    output wire P,
    output wire WE         
);

    reg [3:0] Q;
    wire [3:0] D;

  	assign D[3] = ~Q[3] & ~Q[2] & ~Q[1] & Q[0] & F;
  	assign D[2] = (Q[3] & ~Q[2] & ~Q[1] & ~Q[0]) | (~Q[3] & ~Q[2] & ~Q[1] & Q[0] & ~F);
    assign D[1] = ~Q[3] & Q[2] & ~Q[1] & ~Q[0];
  	assign D[0] = (~Q[3] & ~Q[2] & Q[1] & ~Q[0] & ~C) | (~Q[3] & ~Q[2] & Q[1] & ~Q[0] & C);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            Q <= 4'b1000; 
          
        end else begin
            Q <= D;
        end
    end

    assign R = Q[3] & ~Q[2] & ~Q[1] & ~Q[0];
  	assign E = ~Q[3] & ~Q[2] & ~Q[1] & Q[0] & ~F;
    assign B = (~Q[3] & Q[2] & ~Q[1] & ~Q[0]) | (~Q[3] & ~Q[2] & Q[1] & ~Q[0] & C);
    assign P = ~Q[3] & ~Q[2] & ~Q[1] & Q[0] & F;
    assign WE = (~Q[3] & Q[2] & ~Q[1] & ~Q[0]) | (~Q[3] & ~Q[2] & Q[1] & ~Q[0])

endmodule