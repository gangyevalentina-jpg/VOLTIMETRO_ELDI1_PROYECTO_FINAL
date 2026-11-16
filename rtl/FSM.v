module FSM(
    input wire clk,       
    input wire rst,      
    input wire C,         
    input wire F,        
    
    output wire [3:0] Q,  
    output wire R,        
    output wire E,       
    output wire B,        
    output wire P         
);

    reg [3:0] RQ;
    wire [3:0] D;

  	assign D[3] = ~RQ[3] & ~RQ[2] & ~RQ[1] & RQ[0] & F;
  	assign D[2] = (RQ[3] & ~RQ[2] & ~RQ[1] & ~RQ[0]) | (~RQ[3] & ~RQ[2] & ~RQ[1] & RQ[0] & ~F);
    assign D[1] = ~RQ[3] & RQ[2] & ~RQ[1] & ~RQ[0];
  	assign D[0] = (~RQ[3] & ~RQ[2] & RQ[1] & ~RQ[0] & ~C) | (~RQ[3] & ~RQ[2] & RQ[1] & ~RQ[0] & C);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            RQ <= 4'b1000; 
          
        end else begin
            RQ <= D;
        end
    end

    assign Q = RQ;

    assign R = RQ[3] & ~RQ[2] & ~RQ[1] & ~RQ[0];
  	assign E = (~RQ[3] & RQ[2] & ~RQ[1] & ~RQ[0]) | (~RQ[3] & ~RQ[2] & ~RQ[1] & RQ[0] & ~F);
  assign B =  (~RQ[3] & RQ[2] & ~RQ[1] & ~RQ[0]) | (~RQ[3] & ~RQ[2] & RQ[1] & ~RQ[0] & C);
    assign P = ~RQ[3] & ~RQ[2] & ~RQ[1] & RQ[0] & F;

endmodule