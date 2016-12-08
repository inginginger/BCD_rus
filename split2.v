module split2(clk, txValid, nRST, data, RXdone, dout, busy, TXen, req , dirRX, dirTX,  cntWord, cntAll); 
input clk; 
input txValid; 
input nRST; 
input [17:0] data; 
input RXdone; 
input busy;
output reg [7:0] dout; 
output reg TXen; 
output reg req;  
reg [1:0] clkcnt; 
output reg [1:0] cntWord; 
reg [3:0]state; 
reg [7:0] iWord [2:0]; 
output reg [5:0] cntAll; 
reg [6:0] delayDIR;
reg [7:0] tx;
reg [17:0] data2; 
output reg dirRX;
output reg dirTX;
`define RXDONE 1
`define WAITFORRXDONE 0 
`define REQUESTFOAM 2 
`define WAITVLD 3
`define DIVIDE 4
`define TXEN 5  
`define CNTWORDS 6
`define VALID 7
`define DIRSET 8
`define DIRCLR 9

always@(posedge clk or negedge nRST) 
begin 
	if(~nRST) 
	begin 
		clkcnt <= 2'b0; 
		req <= 1'b0; 
		cntAll <= 6'b0; 
		state <= 4'd0; 
		TXen <= 1'b0;  
		cntWord <= 2'b0; 
		dout <= 8'b0; 
		delayDIR <= 7'b0;
		dirRX <= 1'b0;
		dirTX <= 1'b0;
		tx <= 8'b0;
	end 
	else 
	begin 
	case(state) 
		`WAITFORRXDONE: 
		begin 
			if(RXdone)//ловим срез RXdone 
				state <= `DIRSET; //идем генерить запрос
		end 
		`DIRSET:				//установим DIR'ы
		begin
			dirRX <= 1'b1;
			delayDIR <= delayDIR + 1'b1;
			if(delayDIR == 7'd60)
			begin
				dirTX <= 1'b1;
			end
			else if(delayDIR == 7'd120)
			begin
				delayDIR <= 7'b0;
				state <= `REQUESTFOAM;
			end
		end
		`REQUESTFOAM: 
		begin  
			req <= 1'b1; //формируем запрос
			clkcnt <= clkcnt+1'b1; 
			if(clkcnt == 2'd3) 
			begin
				state <= `WAITVLD; //идем ловить валиды
			end	
		end 
		`WAITVLD: 
		begin
			clkcnt <= 2'b0;
			req <= 1'b0;
			if(txValid) //по срезу валида
			begin 
				state <= `DIVIDE; //идем записывать слова
			end 
		end 
		`DIVIDE: 
		begin 
			iWord[0] <= data[15:8]; //разобьем 18-битное слово
			iWord[1] <= data[7:0];//на 3 8-битных 
			iWord[2] <= {6'b0, data[17:16]}; //во внутренней памяти
			state <= `TXEN; 
		end 
		`CNTWORDS:
		begin			
			if(cntAll == 6'd48) 
				state <= `DIRCLR; 
			else 
				state <= `REQUESTFOAM;
		end
		`TXEN: 
		begin
			if(busy == 1'b0)
			begin
				tx <= tx + 1'b1;
				case(tx)
					3: dout <= iWord[cntWord]; //данные на выходную шину 
					4: TXen <= 1'b1;
					22: TXen <= 1'b0;
					30: cntWord <= cntWord + 1'b1;
					50: begin
						if(cntWord == 2'd3) 
						begin
							cntAll <= cntAll + 1'b1;
							cntWord <= 2'd0;
							state <= `CNTWORDS; 
						end
						else state <= `TXEN;
						tx <= 8'd0; 
					end
				endcase
			end
		end 
		`DIRCLR:
		begin
			cntAll <= 6'd0;
			delayDIR <= delayDIR + 1'b1;
			if(delayDIR == 7'd60)
				dirTX <= 1'b0;
			else if(delayDIR == 7'd120)
			begin
				state <= `RXDONE;
				dirRX <= 1'b0;
				delayDIR <= 7'b0;
			end
		end
		`RXDONE: 
		begin
			if(~RXdone) 
				state <= `WAITFORRXDONE; 
		end 
	endcase 
	end 
end 
endmodule
//module split2(clk, txValid, nRST, data, RXdone, dout, TXen, req , TEST); 
//input clk; 
//input txValid; 
//input nRST; 
//input [17:0] data; 
//input RXdone; 
//output [9:0] dout; 
//output reg TXen; 
//output reg req; 
//output reg TEST; 
//reg [1:0] clkcnt; 
//reg [1:0] cntWord; 
//reg [2:0]state; 
//reg [7:0] iWord [2:0]; 
//reg [7:0] pause; 
//reg [5:0] cntAll; 
//reg [7:0] delay; 
//`define WAITFORRXDONE 0 
//`define RXDONE 1
//`define REQUESTFOAM 2
//`define WAIT 3 
//`define DIVIDE 4 
//`define TXEN 5 
//`define COUNT 6 
//`define READY 7 
//
//assign dout = {1'b1, iWord[cntWord], 1'b0};
//
//always@(negedge clk) 
//begin 
//	if(nRST == 1'b0) 
//	begin 
//		clkcnt <= 2'b0; 
//		req <= 1'b0; 
//		cntAll <= 6'b0; 
//		delay <= 8'b0; 
//		state <= 4'b0; 
//		TXen <= 1'b0;  
//		cntWord <= 2'b0; 
//		pause <= 8'b0; 
//		TEST <= 1'b0; 
//	end 
//	else 
//	begin 
//	case(state) 
//		`WAITFORRXDONE: 
//		begin 
//			if(~RXdone) begin //ловим срез RXdone 
//				state <= `REQUESTFOAM; //идем генерить запрос
//			end 
//		end 
//		`REQUESTFOAM: 
//		begin  
//			if(clkcnt < 2'd3) 
//			begin 
//				req <= 1'b1; //формируем запрос
//				clkcnt <= clkcnt+1'b1; 
//			end 
//			else 
//			begin
//				clkcnt <= 2'b0;
//				req <= 1'b0;
//				state <= `READY; //идем ловить валиды
//			end
//		end 
//		`WAIT: 
//		begin 
//			if(~txValid) //по срезу валида
//			begin 
//				state <= `DIVIDE; //идем записывать слова
//			end 
//		end 
//		`DIVIDE: 
//		begin 
//			iWord[0] <= {data[17:16], 6'b0}; //разобьем 18-битное слово
//			iWord[1] <= data[15:8]; //на 3 8-битных 
//			iWord[2] <= data[7:0]; //во внутренней памяти
//			state <= `COUNT; 
//		end 
//		`COUNT: 
//		begin 
//			if(cntWord < 2'd3)
//			begin
//				cntWord <= cntWord + 1'b1;
//				state <= `TXEN;
//			end
//			else
//			begin
//				cntWord <= 2'b0;
//				cntAll <= cntAll + 1'b1;
//				if(cntAll == 8'd48)
//				begin
//					cntAll <= 8'b0;
//					state <= `RXDONE;
//				end
//				state <= `REQUESTFOAM;
//			end
//		end 
//		`TXEN: 
//		begin
//			if(pause < 8'd160)
//			begin
//				TXen <= 1'b1; //формируем сигнал разрешения передачи слов
//				pause <= pause + 1'b1; 
//			end
//			else if( delay < 8'd160)
//			begin
//				delay <= delay + 1'b1;
//				pause <= 8'b0;
//				TXen <= 1'b0;
//			end
//			else
//				state <= `COUNT; //идем считать слова
//		end 
//		`READY: 
//		begin 
//			if(txValid) //по фронту валида
//			begin 
//				state <= `WAIT; 
//			end 
//		end 
//		`RXDONE: 
//		begin 
//			cntAll <= 6'b0;
//			if(RXdone) 
//				state <= `WAITFORRXDONE; 
//		end 
//	endcase 
//	end 
//end 
//endmodule
