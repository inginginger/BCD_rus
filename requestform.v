module requestform(clk,nRST,RXdone,req);
input clk;
input nRST;
input RXdone;
output reg req;
reg [2:0] cntclick;
reg [2:0] st;
`define WAITFORRXDONE 0
`define RXDONE 1
`define REQUESTFOAM 2
`define CLR 3

always@(posedge clk)
begin
	if(nRST == 1'b0)
	begin
		cntclick <= 3'b0;
		req <= 1'b0;
		st <= 3'b0;
	end
	else
	begin
	case(st)
		`WAITFORRXDONE:
		begin
			if(~RXdone) begin						//поймали срез RXdone
				st <= `REQUESTFOAM;
			end
		end
		`REQUESTFOAM:
		begin
			if(cntclick < 3'd5)
			begin
				req <= 1'b1;							//отправляем запрос
				cntclick <= cntclick+1'b1;	
			end
			else			
				st <= `CLR;
		end
		`CLR:
		begin
			req <= 1'b0;							//сбрасываем сигнал запроса
			cntclick <= 2'b0;
			st <= `RXDONE;
		end
		`RXDONE:
		begin
			if(RXdone)
				st <= `WAITFORRXDONE;
		end
	endcase
	end
end
endmodule
