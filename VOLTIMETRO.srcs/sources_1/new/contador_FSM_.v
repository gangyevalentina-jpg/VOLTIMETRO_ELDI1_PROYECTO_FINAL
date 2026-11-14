module contador_FSM_ (
    input clk,              
    input rst_FSM_,         
    input En_FSM_,           
  	output reg [3:0] S_FSM_, 
    output reg F_FSM_        
);

    always @(posedge clk or posedge rst_FSM_) begin
        if (rst_FSM_) begin
            S_FSM_ <= 4'd0;
            F_FSM_ <= 1'b0;
        end 
     	else if (En_FSM_) begin
          	if (S_FSM_ == 4'd10) begin
                S_FSM_ <= 4'd10; 
                F_FSM_ <= 1'b1;
            end 
          
          	else begin
                S_FSM_ <= x_FSM_ + 1'b1;
                F_FSM_ <= 1'b0;
            end
        end
    end

endmodule