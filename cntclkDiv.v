module cntclkDiv(clk,divby2,divby4,divby8,divby16);
input clk;
output divby2;
output divby4;
output divby8;
output divby16;
reg [3:0]clkcnt1;
always@(posedge clk) 
begin                              
    clkcnt1 <= clkcnt1 +1'b1;                                  
end
assign divby2 =  clkcnt1[0];
assign divby4 =  clkcnt1[1];
assign divby8 =  clkcnt1[2];
assign divby16 =  clkcnt1[3];
endmodule