module cntWr(input Wr, output reg outFlag=0);
integer cnt=0;

always@(posedge Wr)
begin
	cnt=cnt+1;
	if(cnt==128)begin
		outFlag=1;
		cnt=0;
	end
	else outFlag=0;
end
endmodule