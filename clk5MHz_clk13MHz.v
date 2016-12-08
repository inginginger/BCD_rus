module clk5MHz_clk13MHz//(clk,clk5MHz,clk13MHz);
(
    input wire clkIN,			// whatever clock needed to be divided
    output reg clkOUT = 1'd0	// awesome result
    );

reg [2:0] count=3'd0;

always @ (posedge clkIN)
begin
	count <= count + 1'b1;		// always increment
	if(count == 3)				// if counted half of phase
		clkOUT <= 1;			// set output to high level
	else if(count == 5) begin	// when counted to the end of period
		count<=0;				// reset the counter
		clkOUT <=0;				// set output to low level
	end
end
endmodule



//input clk;
//output reg clk13MHz=0;
//reg [2:0] clkcnt2=3'b0;
//output reg clk5MHz=0;
//
//always@(posedge clk)
//begin 
//	clkcnt2 <= clkcnt2+1'b1;
//	if(clkcnt2==5)
//		clkcnt2 <= 0;
//	if(clkcnt2==2)
//		clk13MHz <= 0;
//	else
//		clk13MHz <= 1;
//end
//endmodule