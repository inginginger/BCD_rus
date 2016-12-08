module reader(clk, reqMFK, nRST, din, reqSPLIT, dout, addrRD, readEN, TXen, cntStream, RXdone, addrMEM);
input clk;
input reqMFK;
input nRST;
input [17:0] din;
input reqSPLIT;
output reg [17:0] dout;
output reg [6:0] addrRD;
output reg readEN;
output reg TXen;
output reg RXdone;
output reg [1:0] cntStream;
reg [3:0] state;
reg [17:0] mem [0:47];
reg [3:0] cnt16;
reg [2:0] mult;
output reg [6:0] addrMEM;
reg [5:0] i;
reg [1:0] req;
reg [5:0] cntWord;
reg [3:0] read;
reg [2:0] tx;
reg ack;
reg accept;

`define MFKHIGH 0
`define MFKLOW 1
`define READ 2
`define HIGHSPLIT 3
`define LOWSPLIT 4
`define TX 5

initial begin
	for(i=0; i<48; i=i+1'b1)
		mem[i] <= 0;
end

always@(posedge clk or negedge nRST) begin
/*СБРОС*/
	if(~nRST)
	begin
		addrRD <= 7'd0;
		readEN <= 1'b0;
		state <= 4'd0;
		cntStream <= 2'd0;
		cnt16 <= 4'd0;
		mult <= 3'd0;
		RXdone <= 1'd0;
		read <= 4'd0;
		addrMEM <= 6'd0;
		TXen <= 1'b0;
		dout <= 18'd0;
		cntWord <= 6'd0;
		tx <= 3'd0;
	end 
	else begin
/*ЧТЕНИЕ*/	
	case(state)
		`MFKHIGH:
			if(reqMFK) begin					//если пришел запрос от МФК	
				state <= `READ;			//начинаем читать данные из памяти
			end
		`READ: begin
			read <= read + 1'b1;
			case(read)
				1: begin
					addrMEM <= cnt16 + (cntStream << 4); // адрес внутренней памяти на текущий запрос МФК(48 слов-по 16 от каждого канала)
					addrRD <= cnt16 + (mult << 4);	//выставляем адрес для чтения из памяти - от 0 до 127
				end
				2: cnt16 <= cnt16 + 1'b1;
				3: readEN <= 1'b1;
				7: mem[addrMEM] <= din;//18'd134919;//считываем во внутренний буфер// 
				10: readEN <= 1'b0;
				13: begin
					if (cnt16 == 4'd0) begin //отсчитываем 16 слов с одного потока
						state <= `READ;//считываем следующее слово
						cntStream <= cntStream + 1'b1;
						if(cntStream == 2'd3) begin	//прочли 3 потока
							cntStream <= 2'b0;
							mult <= mult + 1'b1;
							RXdone <= 1'b1;	//ФЛАГ - считали весь пакет - 48 слов за один запрос МФК
							state <= `HIGHSPLIT;//ждем запрос от SPLIT
						end
					end
					read <= 4'b0;
				end
			endcase
		end
		`HIGHSPLIT: begin
			RXdone <= 1'd0;
			if(reqSPLIT) state <= `TX;//если пришел запрос от SPLIT начинаем передачу
		end	
		`TX: begin
			tx <= tx + 1'b1;
			case(tx)//передаем 48 слов - по 16 от каждого потока
				0: dout <= mem[cntWord];
				1: TXen <= 1'b1;
				2: mem[cntWord] <= 18'd0;
				4: cntWord <= cntWord + 1'b1;
				5: TXen <= 1'b0;
				6: begin
					state <= `LOWSPLIT;//иначе ждем запрос от SPLIT
					if(cntWord == 6'd48)//когда передали первую пачку ответов
						begin
							cntWord <= 6'b0;
							state <= `MFKLOW;//ждем следующего запроса МФК
						end
					tx <= 3'b0;
				end
			endcase
		end
		`LOWSPLIT: 
			if(~reqSPLIT) state <= `HIGHSPLIT;//ждем запрос от SPLIT
		`MFKLOW: 
			if(~reqMFK) state <= `MFKHIGH;//ждем запрос от МФК
		endcase
	end
end
endmodule