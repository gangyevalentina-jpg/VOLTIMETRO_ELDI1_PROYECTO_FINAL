module contador_FSM_ (
    input clk,              
    input R,         
    input E,           

  	output reg [3:0] S, 
    output reg F        
);

    always @(posedge clk or posedge R) begin
        if (R) begin
            S <= 4'd0;
            F <= 1'b0;
        end 
     	else if (E) begin
          	if (S >= 4'd8) begin
                S <= 4'd9; 
                F <= 1'b1;
            end 
          
          	else begin
                S <= S + 1'b1;
                F <= 1'b0;
            end
        end
    end

endmodule