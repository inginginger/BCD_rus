module split(clk, txValid, nRST, data, RXdone, dout, TXen, req , TEST); 
input clk; 
input txValid; 
input nRST; 
input [17:0] data; 
input RXdone; 
output reg [9:0] dout; 
output reg TXen; 
output reg req; 
output reg TEST; 
reg [2:0] clkcnt; 
reg [1:0] cntWord; 
reg [3:0]state; 
reg [9:0] iWord [2:0]; 
reg [7:0] pause; 
reg [5:0] cntAll; 
reg [7:0] delay; 
`define WAITFORRXDONE 1 
`define RXDONE 0 
`define REQUESTFOAM 2 
`define WAIT 3 
`define DIVIDE 4 
`define TXEN 5 
`define COUNT 6 
`define READY 7 
`define REQTWICE 8

always@(negedge clk) 
begin 
	if(nRST == 1'b0) 
	begin 
		clkcnt <= 3'b0; 
		req <= 1'b0; 
		cntAll <= 6'b0; 
		delay <= 8'b0; 
		state <= 4'b0; 
		TXen <= 1'b0;  
		cntWord <= 2'b0; 
		dout <= 10'b0; 
		pause <= 8'b0; 
		TEST <= 1'b0; 
	end 
	else 
	begin 
	case(state) 
		`WAITFORRXDONE: 
		begin 
			if(~RXdone) begin 				//ловим срез RXdone 
				state <= `REQUESTFOAM;		//идем генерить запрос
			end 
		end 
		`REQUESTFOAM: 
		begin 
			pause <= 8'b0; 
			if(clkcnt < 3'd5) 
			begin 
				req <= 1'b1; 				//формируем запрос
				clkcnt <= clkcnt+1'b1; 
			end 
			else 
			begin
				req <= 1'b0;
				state <= `READY; 			//идем ловить валиды
			end
		end 
		`WAIT: 
		begin 
			if(~txValid) 					//по срезу валида
			begin 
				clkcnt <= 3'b0; 
				state <= `DIVIDE; 			//идем записывать слова
			end 
		end 
		`DIVIDE: 
		begin 
			iWord[0] <= {1'b1, data[17:16], 6'b0, 1'b0};	//разобьем 18-битное слово
			iWord[1] <= {1'b1, data[15:8], 1'b0}; 			//на 3 8-битных 
			iWord[2] <= {1'b1, data[7:0], 1'b0}; 			//во внутренней памяти
			state <= `COUNT; 
		end 
		`COUNT: 
		begin 
			if(cntWord < 2'd3) 								//пока не выдадим 3 куска 18-битного слова
			begin 
				if(pause < 8'd160)
				begin 
					pause <= pause + 1'b1;
					dout <= iWord[cntWord]; 				//данные на выходную шину 
				end 
				else 
				begin
					cntWord <= cntWord+1'b1;
					state <= `TXEN; 						//идем формировать сигнал для передачи первого куска
				end
			end 
			else 
			begin 
				cntWord <= 0;								// обнуляем, сосчитав 3 слова (0 1 2)
				cntAll <= cntAll+1'b1; 						//считаем 48 слов(16 с каждого из 3-х каналов)
				if(cntAll < 6'd48) 
				begin 
					state <= `REQTWICE; 
				end 
				else 
				begin 
//					cntWord <= 1'b0; 
					state <= `RXDONE; 
				end 
			end 
		end 
		`TXEN: 
		begin
			if(delay < 8'd160)
			begin
				TXen <= 1'b1; 							//формируем сигнал разрешения передачи слов
				delay <= delay + 1'b1;
			end
			else
			begin
				TXen <= 1'b0;
				state <= `COUNT; 						//идем считать следующие слова
			end
		end 
		`REQTWICE:
		begin
			if(clkcnt < 3'd5) 
			begin 
				req <= 1'b1; 				//формируем запрос
				clkcnt <= clkcnt+1'b1; 
			end 
			else 
			begin
				req <= 1'b0;
				state <= `READY; 			//идем ловить валиды
			end
		end
		`READY: 
		begin 
			if(txValid) //по фронту валида
			begin 
				state <= `WAIT; 
			end 
		end 
		`RXDONE: 
		begin 
			if(RXdone) 
				state <= `WAITFORRXDONE; 
		end 
	endcase 
	end 
end 
endmodule
