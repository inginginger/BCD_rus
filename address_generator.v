module address_generator(clk,din,ack,dout,sRS,pack,mux3,addr1,addr2,addr3,rdEn1,rdEn2,rdEn3,oTest,oTmp/*,FIFO1,FIFO2,FIFO3*/);
input clk;
input ack;
input [9:0] din;
output reg [9:0] dout=10'b0;
output reg [1:0] pack=2'b0;
output reg [1:0] mux3=2'b0;
output reg [6:0] addr1=7'b0;
output reg [6:0] addr2=7'b0;
output reg [6:0] addr3=7'b0;
output reg rdEn1=0;
output reg rdEn2=0;
output reg rdEn3=0;
output reg sRS=0;
output reg oTest=0;
output reg oTmp=0;
reg stop=0;
reg temp=0;
reg ena=0;
reg accept=0;
reg rx=0;
reg tmp=0;
reg[9:0] buf_reg=10'b0;
reg [4:0] rdA3=5'b0;
reg [4:0] rdA2=5'b0;
reg [4:0] rdA1=5'b0;
reg [2:0] pauseRX=3'b0;
reg [2:0] pauseTX=3'b0;
reg [2:0] inc3=3'b0;
reg [2:0] inc2=0;
reg [2:0] inc1=0;
reg [3:0] clkFlow=4'b0;
//reg [7:0]cntRst=8'b0;

always@(posedge clk)
begin
	if(ack==0 && temp==1) begin				//если пришел сигнал о том, что запрос принят
		accept<=1;
		oTmp<=1;
	end
	temp<=ack;
	if(accept==1) begin					//отсчитываем 200 тактов от окончания запросных байтов
			case(pack)
			0: begin
				case(clkFlow)
					1: begin
						buf_reg<=0;							//обнуляем буфер хранения данных	
						addr1<=rdA1+(inc1*16);		
						rdEn1<=1;							//формируем сигнал разрешения чтения из памяти
					end
					2: begin
						buf_reg<=din;				//записываем входные данные в буфер хранения
					end
					3: begin
						rdEn1<=0;					//сбрасываем сигнал разрешения чтения
						dout<=buf_reg;				//подаем на выходную шину содержимое буфера
					end
					4: begin
						buf_reg<=0;					//обнуляем буфер
						sRS<=1;						//отправляем сигнал о передаче слова
						mux3<=mux3+1;			//переключаем шину на мультиплексоре 3-в-1
					end
					6: begin
						sRS<=0;									//сбрасываем сигнал передачи
					end
					7: begin
						if(mux3==3)begin	
							rdA1<=rdA1+1;						//инкрементируем счетчик чтения адреса	
							mux3<=0;
						end
					end
					8:begin
						if(rdA1==16) begin					//когда считали 16 слов
							inc1<=inc1+1;					//инкрементируем счетчик 16-словных пачек
							rdA1<=0;							//сбросим счетчик чтения адреса
						end	
					end
					9: begin
						if(inc1==8)
								inc1<=0;
						pack<=pack+1;					//переходим к следующему информационному каналу 
					end
				endcase
				clkFlow<=clkFlow+1;
				if(clkFlow==12)			
					clkFlow<=0;
			end
			1: begin
				case(clkFlow)
					1: begin
						buf_reg<=0;							//обнуляем буфер хранения данных
						addr2<=rdA2+(inc2*16);	
						rdEn2<=1;
					end
					2: begin
						buf_reg<=din;				//записываем входные данные в буфер хранения
					end
					3: begin
						rdEn2<=0;
						dout<=buf_reg;				//подаем на выходную шину содержимое буфера
					end
					4: begin
						buf_reg<=0;					//обнуляем буфер
						sRS<=1;						//отправляем сигнал о передаче слова
						mux3<=mux3+1;			//переключаем шину на мультиплексоре 4-в-1
					end
					6: begin
						sRS<=0;									//сбрасываем сигнал передачи
					end
					7: begin
						if(mux3==3)begin	
							rdA2<=rdA2+1;						//eie?aiaioe?oai n?ao?ee ?oaiey aa?ana	
							mux3<=0;
						end
					end
					8:begin
						if(rdA2==16) begin					//eiaaa n?eoaee 16 neia
							inc2<=inc2+1;					//eie?aiaioe?oai n?ao?ee 16-neiaiuo ia?ae
							rdA2<=0;							//na?inei n?ao?ee ?oaiey aa?ana
						end	
					end
					9: begin
						if(inc2==8)
								inc2<=0;
						pack<=pack+1;					//ia?aoiaei e neaao?uaio eioi?iaoeiiiiio eaiaeo 
					end
				endcase
				clkFlow<=clkFlow+1;
				if(clkFlow==12) begin
					clkFlow<=0;
				end
			end
			2: begin
				case(clkFlow)
					1: begin
						buf_reg<=0;							//обнуляем буфер хранения данных
						addr3<=rdA3+(inc3*16);
						rdEn3<=1;
					end
					2: begin
						buf_reg<=din;				//записываем входные данные в буфер хранения
					end
					3: begin
						rdEn3<=0;
						dout<=buf_reg;				//подаем на выходную шину содержимое буфера
					end
					4: begin
						buf_reg<=0;					//обнуляем буфер
						sRS<=1;						//отправляем сигнал о передаче слова
						mux3<=mux3+1;			//переключаем шину на мультиплексоре 4-в-1
					end
					6: begin
						sRS<=0;									//сбрасываем сигнал передачи
					end
					7: begin
						if(mux3==3)begin	
							rdA3<=rdA3+1;						//eie?aiaioe?oai n?ao?ee ?oaiey aa?ana	
							mux3<=0;
						end
					end
					8:begin
						if(rdA3==16) begin					//eiaaa n?eoaee 16 neia
							inc3<=inc3+1;					//eie?aiaioe?oai n?ao?ee 16-neiaiuo ia?ae
							rdA3<=0;							//na?inei n?ao?ee ?oaiey aa?ana
						end	
					end
					9: begin
						if(inc3==8)
								inc3<=0;
						pack<=0;					//ia?aoiaei e neaao?uaio eioi?iaoeiiiiio eaiaeo
						oTmp<=0;
						accept<=0; 
					end
				endcase
				clkFlow<=clkFlow+1;
				if(clkFlow==12)begin
					clkFlow<=0;
				end
			end
			endcase
		end
//		else
//			begin
//				rdEn1=0;
//				rdEn2=0;
//				rdEn3=0; 
//				sRS=0;
//				tmp=0;
//				cntDat=0;
//				mux3=0;
//				pack=0;
//				buf_reg=0;
//				dout=0;
//				clkFlow=0;
//			end
end
//always@(posedge clk)
//begin
//	if(sRS==0 && tmp==1)begin
//		rx<=1;
//	end 
//	tmp=sRS;
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
endmodule


//
//module tranceiver(clk,clk80MHz,din,ack,wrEn1,wrEn2,wrEn3,dout,dir_TX,dir_RX,sRS,muxDat,pack,mux4,addr1,addr2,addr3,rdEn1,rdEn2,rdEn3,mux_ram1,mux_ram2, mux_ram3,inc1,rdA1,tmp/*,FIFO1,FIFO2,FIFO3*/);
//input clk, ack, wrEn1, wrEn2, wrEn3, clk80MHz;
//input [9:0] din;
//output reg [9:0] dout=10'b0;
//output reg [1:0] pack=2'b0;
//output reg [2:0] mux4=3'b0;
//output reg [7:0] addr1=8'b0;
//output reg [7:0] addr2=8'b0;
//output reg [7:0] addr3=8'b0;
//output reg [2:0] inc1=3'b0;
//output reg [4:0] rdA1=5'b0;
//output reg muxDat=0,rdEn1=0,mux_ram1=0,mux_ram2=0,mux_ram3=0,/*FIFO1=0,FIFO2=0,FIFO3=0,*/tmp=0,dir_RX=0, dir_TX=0,sRS=0,rdEn2=0,rdEn3=0;
//reg temp=0,ena=0;
//reg[9:0] buf_reg=10'b0;
//integer stop=0,delay=0,en=0,rdA2=0,rdA3=0,pauseDirTX=0,mark1=0,mark2=0,mark3=0,inc2=0,inc3=0,cnt1=0,cnt2=0,cnt3=0,pauseRX=0,pauseTX=0,test=0,trmp=0,cntWord=0,accept=0,clkFlow=0,cntDat=0;
//integer cntWr1=0, cntWr2=0, cntWr3=0,addr_1=0, addr_2=0,addr_3=0, enable=0;
//
//always@(posedge clk80MHz)
//begin
//	if(wrEn1==1)
//		cntWr1=cntWr1+1;
//	if(wrEn2==1) 
//		cntWr2=cntWr2+1;
//	if(wrEn3==1)
//		cntWr3=cntWr3+1;
//end
//
//always@(posedge clk)
//begin
//	if(ack==1 && temp==0)				//если пришел сигнал о том, что запрос принят
//		accept=1;
//	temp=ack;
//	if(accept==1) begin					//отсчитываем 200 тактов от окончания запросных байтов
//		delay=delay+1;
//		if(delay>200) begin
//			dir_RX=1;					//отключаем приемник
//			pauseTX=pauseTX+1;			//отсчитываем еще 4 такта
//			if(pauseTX==4)
//				dir_TX=1;				//включаем передатчик
////			if(dir_TX==1) begin
////				pauseDirTX=pauseDirTX+1;
////				if(pauseDirTX==5)
////					enable=1;
////			end
//			if(sRS==1 && test==0) 		//если поймали фронт сигнала
//				cntWord=cntWord+1;		//инкрементируем счетчик слов
//			test=sRS;				
//			if(cntWord==544)begin		//как отсчитали 544 слова
//				cntWord=0;				//обнулим счетчик слов
//				enable=0;
//				dir_TX=0;				//отключим передатчик
//				stop=1;					//выставим флаг окончания передачи
//			end
//			if(stop==1)
//				pauseRX=pauseRX+1;
//			if(pauseRX==4) begin		//и через 4 такта
//						dir_RX=0;		//включим приемник
//						delay=0;		//обнулим
//						pauseTX=0;		//все внутренние
//						pauseRX=0;		//счетчики
//						pauseDirTX=0;
//						stop=0;			//и сигналы
//						accept=0;
//			end	
//		end	
//	end
//end
//
//always@(posedge clk)
//begin
//	if(dir_TX==1) begin	
//			case(pack)
//			0: begin
//				case(clkFlow)
//					1: begin
//						buf_reg=0;							//обнуляем буфер хранения данных
//						
//						addr1=(rdA1+(inc1*20))+mark1;
////						cntFIFO1=cntWr1;		
//						rdEn1=1;							//формируем сигнал разрешения чтения из памяти
//					end
//					2: begin
////						if(rdEn1==1)
////							cntFIFO1=cntFIFO1-1;
//						buf_reg=din;				//записываем входные данные в буфер хранения
//					end
//					3: begin
//						rdEn1=0;					//сбрасываем сигнал разрешения чтения
//						dout=buf_reg;				//подаем на выходную шину содержимое буфера
//					end
//					4: begin
//						buf_reg=0;					//обнуляем буфер
//						sRS=1;						//отправляем сигнал о передаче слова
//						if(muxDat==0)
//						mux4=mux4+1;			//переключаем шину на мультиплексоре 4-в-1
//					end
//					6: begin
//						sRS=0;									//сбрасываем сигнал передачи
//					end
//					7: begin
//						if(mux4==4)begin	
//							tmp=1;
//							mux4=0;
//							rdA1=rdA1+1;						//инкрементируем счетчик чтения адреса	
//							if((rdA1+(inc1*20))+mark1>=256)
//								addr1=((rdA1+(inc1*20))+mark1)-256;
////							addr_1=addr_1+1;
////							if(addr_1>=256)
////								addr_1=0;
//						end
//						else tmp=0;
//					end
//				endcase
//				clkFlow=clkFlow+1;
//				if(clkFlow==10) begin
//					 if(rdA1+(inc1*20)==100) begin	
//								mark1=addr1;
//								inc1=0;
//								rdA1=0;
//							end	
//					 else if(rdA1==20) begin					//когда считали 20 слов
//						rdA1=0;							//сбросим счетчик чтения адреса
//						inc1=inc1+1;					//инкрементируем счетчик 20-словных пачек
////						if(inc1==5) begin
////							inc1=0;
////							mark1=rdA1+(inc1*20)+mark1;
////						end
//						pack=pack+1;					//переходим к следующему информационному каналу
//					end	
//					
////							else if((rdA1+inc1*20)==97) begin		//если просчитали 97 слов с 1-го канала
////								if(cntFIFO1>128) begin
////									mux_ram1=0;
////									mark1=addr1+1;					//а счетчику данных присвоим следующее после текущего значение адреса
////									inc1=0;							//сбросим счетчик 20-словных пачек
////									rdA1=0;							//и счетчик чтения адреса
////									pack=pack+1;
////								end
////								else if(cntFIFO1>96 && cntFIFO1<128) begin
////									mux_ram1=1;
////									mark1=addr1+1;
////									inc1=0;
////									rdA1=0;
////									pack=pack+1;
////								end
////								else if(cntFIFO1<96) begin
////									mux_ram1=1;
////									mark1=addr1+1;
////									inc1=0;
////									rdA1=0;
////									pack=pack+1;
////								end
////							end				
//					clkFlow=0;
//				end
//			end
//			1: begin
//				case(clkFlow)
//					1: begin
//						buf_reg=0;							//обнуляем буфер хранения данных
//						
//						addr2=(rdA2+(inc2*20))+mark2;	
////						cntFIFO2=cntWr2;
//						rdEn2=1;
//					end
//					2: begin
////						if(rdEn2==1)
////							cntFIFO2=cntFIFO2-1;
//						buf_reg=din;				//записываем входные данные в буфер хранения
//					end
//					3: begin
//						rdEn2=0;
//						dout=buf_reg;				//подаем на выходную шину содержимое буфера
//					end
//					4: begin
//						buf_reg=0;					//обнуляем буфер
//						sRS=1;						//отправляем сигнал о передаче слова
//						if(muxDat==0)
//							mux4=mux4+1;			//переключаем шину на мультиплексоре 4-в-1
//					end
//					6: begin
//						sRS=0;									//сбрасываем сигнал передачи
//					end
//					7: begin
//						if(mux4==4)begin	
//							mux4=0;
//							rdA2=rdA2+1;						//инкрементируем счетчик чтения адреса
//							
//							if((rdA2+(inc2*20))+mark2>=256)
//								addr2=((rdA2+(inc2*20))+mark2)-256;
////							addr_2=addr_2+1;
////							if(addr_2>=256)
////								addr_2=0;
//						end
//					end
//				endcase
//				clkFlow=clkFlow+1;
//				if(clkFlow==10) begin
//					if(rdA2+(inc2*20)==100) begin	
//								mark2=addr2;
//								inc2=0;
//								rdA2=0;
//							end
//					else if(rdA2==20) begin					//когда считали 20 слов
//						rdA2=0;
//						inc2=inc2+1;
////						if(inc2==5)begin
////							inc2=0;
////							mark2=rdA2+(inc2*20)+mark2;
////						end
//						pack=pack+1;					//переходим к следующему информационному каналу
//					end
////					else if((rdA2+inc2*20)==97) begin
////						if(cntFIFO2>128) begin
////							mux_ram2=0;
////							mark2=addr2+1;					//а счетчику данных присвоим следующее после текущего значение адреса
////							inc2=0;							//сбросим счетчик 20-словных пачек
////							rdA2=0;							//и счетчик чтения адреса
////							pack=pack+1;
////						end
////						else if(cntFIFO2>96 && cntFIFO2<128) begin
////							mux_ram2=1;
////							mark2=addr2+1;
////							inc2=0;
////							rdA2=0;
////							pack=pack+1;
////						end
////						else if(cntFIFO2<96) begin
////							mux_ram2=1;
////							mark2=addr2+1;
////							inc2=0; 
////							rdA2=0;
////							pack=pack+1;
////						end
////					end
//					clkFlow=0;
//				end
//			end
//			2: begin
//				case(clkFlow)
//					1: begin
//						buf_reg=0;							//обнуляем буфер хранения данных
//						addr3=(rdA3+(inc3*20))+mark3;
////						cntFIFO3=cntWr3;
//						rdEn3=1;
//					end
//					2: begin
////						if(rdEn3==1)
////							cntFIFO3=cntFIFO3-1;
//						buf_reg=din;				//записываем входные данные в буфер хранения
//					end
//					3: begin
//						rdEn3=0;
//						dout=buf_reg;				//подаем на выходную шину содержимое буфера
//					end
//					4: begin
//						buf_reg=0;					//обнуляем буфер
//						sRS=1;						//отправляем сигнал о передаче слова
//						if(muxDat==0)
//							mux4=mux4+1;			//переключаем шину на мультиплексоре 4-в-1
//					end
//					6: begin
//						sRS=0;									//сбрасываем сигнал передачи
//					end
//					7: begin
//						if(mux4==4)begin	
//							mux4=0;
//							rdA3=rdA3+1;						//инкрементируем счетчик чтения адреса
//							
//							if((rdA3+(inc3*20))+mark3>=256)
//								addr3=((rdA3+(inc3*20))+mark3)-256;
////							addr_3=addr_3+1;
////							if(addr_3>=256)
////								addr_3=0;
//						end
//					end
//				endcase
//				clkFlow=clkFlow+1;
//				if(clkFlow==10)begin
//					if(rdA3+(inc3*20)==100) begin	
//								mark3=addr3;
//								inc3=0;
//								rdA3=0;
//							end
//					 else if(rdA3==20) begin					
//						rdA3=0;
//						inc3=inc3+1;
////						if(inc3==5)begin
////							inc3=0;
////							mark3=rdA3+(inc3*20)+mark3;
////						end
//						pack=pack+1;					
//					end
////					else if((rdA3+inc3*20)==97) begin
////						if(cntFIFO3>128) begin
////							mux_ram3=0;
////							mark3=addr3+1;					
////							inc3=0;							
////							rdA3=0;							
////							pack=pack+1;
////						end
////						else if(cntFIFO3>96 && cntFIFO3<128) begin
////							mux_ram3=1;
////							mark3=addr3+1;
////							inc3=0;
////							rdA3=0;
////							pack=pack+1;
////						end
////						else if(cntFIFO3<96) begin
////							mux_ram3=1;
////							mark3=addr3+1;
////							inc3=0;
////							rdA3=0;
////							pack=pack+1;
////						end
////					end
//					clkFlow=0;
//				end
//			end
//
//			3: begin
//				muxDat=1;
//				if(muxDat==1) begin
//				case(clkFlow)
//				4: begin
//					sRS=1;					//отправляем сигнал о передаче слова
//					end
//				6: begin
//					sRS=0;					//сбрасываем сигнал передачи
//					end
//				8: begin
//							cntDat=cntDat+1'b1;
//							if(cntDat==304) begin	//если получили 304 байта нулей
//								cntDat=0;			//обнулим
//								muxDat=0;			//все счетчики
//								pack=0;
//							end
//				end
//				endcase
//				clkFlow=clkFlow+1;
//				if(clkFlow==10)
//					clkFlow=0;
//				end
//			end
//			endcase
//		end
//
//		else
//			begin
//	//			rdA1=0;
//	//			rdA2=0;
//	//			rdA3=0;
//				rdEn1=0;
//				rdEn2=0;
//				rdEn3=0; 
//				sRS=0;
//				tmp=0;
//				muxDat=0;
//				cntDat=0;
//				mux4=0;
//				pack=0;
//				buf_reg=0;
//				dout=0;
//				clkFlow=0;
//	//			mark1=0;
//	//			mark2=0;
//	//			mark3=0;
//			end
//end			
//endmodule