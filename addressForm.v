module addressForm(clk, ack, din1, din2, din3, dout, sRS, addr, readEn, mux3, RESET, TEST);
input clk;
input ack;
input [9:0] din1;
input [9:0] din2;
input [9:0] din3;
output reg [9:0] dout = 10'b0;
output reg 	sRS = 1'b0;
output reg TEST=1'b0;
output reg [6:0] addr = 7'b0;
//output reg [6:0] addr2 = 7'b0;
//output reg [6:0] addr3 = 7'b0;
output reg readEn = 1'b0;
output reg RESET = 1'b0;
//output reg readEn2 = 1'b0;
//output reg readEn3 = 1'b0;
reg [3:0] st = 4'b0;
//reg [2:0] st2 = 3'b0;
//reg [2:0] st3 =3'b0;
reg [1:0] stream = 2'b0;
output reg [1:0] mux3 = 2'b0;
reg [9:0] bufReg = 10'b0;
reg [4:0] rdAddr = 5'b0;
//reg [4:0] rdAddr2 = 5'b0;
//reg [4:0] rdAddr3 = 5'b0;
reg [3:0] inc = 4'b0;
//reg [3:0] inc2 = 4'b0;
//reg [3:0] inc3 =4'b0;
reg temp = 1'b0;
reg tmp = 1'b0;
reg rx = 1'b0;
reg accept = 1'b0;
reg [9:0] data = 10'b0;
reg [7:0] cntRst = 8'b0;

always@(negedge clk)
begin
	if(ack == 0 && temp == 1) 				//если пришел сигнал о том, что запрос принят
		accept <= 1;
	temp <= ack;
	if(accept == 1) begin					//отсчитываем 200 тактов от окончания запросных байтов
		case(st)
			0: begin
				addr <= rdAddr+(inc*16);	//выставим адрес
				st <= 1;
				TEST<=1;
			end
			1: begin
				readEn <= 1;				//установим сигнал разрешения чтения из памяти
				st <= 2;
				TEST<=0;
			end
			2: begin
				TEST<=0;
				case(stream)				//переключение потоков данных
					0: data <= din1;
					1: data <= din2;
					2: begin
						data <= din3;
						inc <= inc+1;
					end
					default: data<=0;
				endcase
				if(readEn == 1)				//если разрешено читать,
					bufReg <= data;			//записываем данные в буфер,
				else bufReg <= 0;			//иначе-обнуляем
				st <= 3;
			end
			3: begin
			TEST<=0;
				dout <= bufReg;				//выставляем данные из буфера на выходную шину
				st <= 4;
			end
			4: begin
			TEST<=0;
				sRS <= 1;					//разрешаем передачу
				mux3 <= mux3+1'b1;
				readEn <= 0;				//отключаем считывание
				st <= 5;
			end
			5: begin
			TEST<=0;				
				st <= 6;
			end
			6: begin
			TEST<=0;
				sRS <= 0;					//отключаем передачу
				if(mux3 == 3) begin			//как прошлись по 3м выводам мультиплексора
					rdAddr <= rdAddr+1'b1;		//переходим к следующему слову
					mux3 <= 0;
				end
				st <= 7;
			end
			7: begin 
			TEST<=0;
				if(rdAddr == 16) begin		//считав 16 слов с одного потока
					stream <= stream+1'b1;		//перейдем к следующему потоку
					rdAddr <=0;				//обнулим счетчик
				end
				st <= 8;
			end
			8: begin
			TEST<=0;
				if(inc == 8)begin 				//как считали 128 слов
					inc <= 0;				//обнулим счетчик
				end
				if(stream == 3) begin		//если прошли все 3 потока
					accept <= 0;
					stream <= 0;
				end
				st <= 0;
			end
		endcase
	end
end
always@(negedge clk)
begin
	if(sRS==0 && tmp==1)begin
		rx<=1;
	end 
	tmp=sRS;
	if(rx==1) begin
		cntRst=cntRst+1;
		rx<=0;
	end
	if(cntRst==144) begin
			RESET<=1;
			cntRst=0;
		end
		else RESET<=0;
end	
endmodule


//case(stream)
//			0: begin
//				case(st)
//					0: begin
//						addr1 <= rdAddr1+(inc1*16);
//						st <= 1;
//					end
//					1: begin
//						readEn1 <= 1;
//						st <= 2;
//					end
//					2: begin
//						if(readEn1 == 1) begin
//							bufReg <= din1;
//						end
//						else bufReg <= 0;
//						st <= 3;
//					end
//					3: begin
//						dout <= bufReg;
//						sRS <= 1;
//						readEn1 <= 0;
//						st <= 4;
//					end
//					4: begin
//						sRS <= 0;
//						st <= 5;
//					end
//					5: begin
//						if(mux3 == 3) begin
//							rdAddr1 <= rdAddr1+1;
//							mux3 <= 0;
//						end
//						else mux3 <= mux3+1;
//						st <= 6;
//					end
//					6: begin 
//						if(rdAddr1 == 16)
//							inc1 <= inc1+1;
//						st <= 7;
//					end
//					7: begin
//						if(inc1 == 8) 
//							inc1 <= 0;
//						stream <= stream+1;
//						st <= 0;
//					end
//				endcase
//			end
//			1: begin
//				case(st)
//					0: begin
//						addr2 <= rdAddr2+(inc2*16);
//						st <= 1;
//					end
//					1: begin
//						readEn2 <= 1;
//						st <= 2;
//					end
//					2: begin
//						if(readEn2 == 1) begin
//							bufReg <= din2;
//							st <= 3;
//						end
//						else bufReg <= 0;
//					end
//					3: begin
//						dout <= bufReg;
//						sRS <= 1;
//						readEn2 <= 0;
//						st <= 4;
//					end
//					4: begin
//						sRS <= 0;
//						st <= 5;
//					end
//					5: begin
//						if(mux3 == 3) begin
//							rdAddr2 <= rdAddr2+1;
//							mux3 <= 0;
//						end
//						else mux3 <= mux3+1;
//						st <= 6;
//					end
//					6: begin 
//						if(rdAddr2 == 16) begin
//							inc2 <= inc2+1;
//						end
//						st <= 7;
//					end
//					7: begin
//						if(inc2 == 8) 
//							inc2 <= 0;
//						stream <= stream+1;
//						st <= 0;
//					end
//				endcase
//			end
//			2: begin
//				case(st)
//					0: begin
//						addr3 <= rdAddr3+(inc3*16);
//						st <= 1;
//					end
//					1: begin
//						readEn3 <= 1;
//						st <= 2;
//					end
//					2: begin
//						if(readEn3 == 1) begin
//							bufReg <= din3;
//							st <= 3;
//						end
//						else bufReg <= 0;
//					end
//					3: begin
//						dout <= bufReg;
//						sRS <= 1;
//						readEn3 <= 0;
//						st <= 4;
//					end
//					4: begin
//						sRS <= 0;
//						st <= 5;
//					end
//					5: begin
//						if(mux3 == 3) begin
//							rdAddr3 <= rdAddr3+1;
//							mux3 <= 0;							
//						end
//						else mux3 <= mux3+1;
//						st <= 6;
//					end
//					6: begin 
//						if(rdAddr3 == 16) begin
//							inc3 <= inc3+1;												
//						end
//						st <= 7;
//					end
//					7: begin
//						if(inc3 == 8) 
//							inc3 <=0;
//						stream <= 0;							
//						accept <= 0;
//						st <=0;
//					end
//				endcase
//			end
//		endcase