module UART_TX(clk, en,din, rs485_tx/*,oTest*/);
input clk;
input en;
input [9:0] din;
output reg rs485_tx;
//output reg oTest=0;
reg ack=0;
reg temp=0;
//reg tmp=0;
//reg rx=0;
reg [3:0] rsTXcnt=4'b0;
//reg [7:0] cntRst=8'b0;		

//always@(posedge clk)
//begin
//	if(en==0 && tmp==1)begin
//		rx<=1;
//	end 
//	tmp=en;
//	if(rx==1) begin
//		cntRst=cntRst+1;
//		rx<=0;
//	end
//	if(cntRst==144) begin
//			oTest<=1;
//			cntRst=0;
//		end
//		else oTest<=0;
//end			

always@(posedge clk)
begin	
		if(en==1 && temp==0)begin	
			ack<=1;
		end
		temp=en;
		if(ack==1)
					begin
						rs485_tx<=din[rsTXcnt];			//передаем 10 бит информации ПСК
						rsTXcnt=rsTXcnt+1;
						if(rsTXcnt==10)	begin					//если передали 10-битное слово
								rsTXcnt=0;
								ack<=0;
						end
					end
		else rs485_tx<=1;		//устанавливаем линию на RS485 в лог.1
end
endmodule