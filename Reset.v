module Reset
(
input clk,
output reg nReset
);
reg[8:0] cntclk;
initial begin
cntclk <= 9'b0;
end
always @ (posedge clk)
begin
    if(cntclk == 9'd511)//הכÿ 40 לדצ
    begin
        nReset<=1'b1;
    end
    else
    begin
        nReset<=1'b0;
		cntclk<=cntclk+1'b1;
    end
end
endmodule
//module Reset			// to use this: set the initial for (~reset) and main circuit for (reset)
//(
//	input clk40,			// 40 MHz
//	output reg rst			// global enable
//);
//reg [5:0] count;
//
//always@(posedge clk40)
//begin
//	if (count > 6'b111110) rst <= 1;		// on fpga start count 62 clocks and set global enable
//	else begin rst <= 0; count <= count + 1'b1; end		// while count set enabe to low level
//end
//endmodule