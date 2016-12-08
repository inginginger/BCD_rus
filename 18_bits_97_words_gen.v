module 18_bits_97_words_gen(clk,din,wCtrl,valid,par,oWord,addr,ram_valid,tmp,tl);
input clk,valid,par;
input [15:0] din;
input [15:0] wCtrl;
output reg [7:0]addr=8'b0;
output reg [17:0] oWord=18'b0;
output reg ram_valid=0,tmp=0,tl=0;
reg [17:0] d_reg [94:0];
reg [17:0] word [99:0];
integer en=0, parity=0,ack=0,temp=0;//,sign=1;
reg [15:0] wMark1=16'hFFFF;
reg [1:0] wMark0=2'b0;
wire sign=1'b1;
integer i=0, j=0, k=0, m=0, clkcnt=0, cnt=0, label=0, cntX=0;

initial begin
oWord<=word[i];			//инициализация массива
for(i=0;i<100;i=i+1)		//из 97 18-битных 
	word[i]<=18'b0;		//слов нулями
for(m=0;m<95;m=m+1)
	d_reg[m]=18'b0;
end
always@(negedge valid)
begin
			d_reg[k]={par,1'b1,din};		//и по каждому записываем в регистр информацию и считаем признак четности
			k=k+1;
			if(k==94) 				
				begin
					ack=1;
				end
			if(k==95)				//как только досчитали
				begin
					k=0;			//сбросили счетчик до следующего сигнала об изменении данных на шине din
					ack=0;
				end
end
always@(negedge clk)
begin
	if(ack==1 && temp==0) 
		en=1;
	temp=ack;
	if(en==1)								//по сигналу разрешения записи
		begin
			
//			case(cnt)
//			0:word[cnt]=0;
//			1:word[cnt]=1;
//			2:word[cnt]=2;
//			3:word[cnt]=3;
//			4:word[cnt]=4;
//			5:word[cnt]=5;
//			6:word[cnt]=6;
//			7:word[cnt]=7;
//			8:word[cnt]=8;
//			9:word[cnt]=9;
//			10:word[cnt]=10;
//			11:word[cnt]=11;
//			12:word[cnt]=12;
//			13:word[cnt]=13;
//			14:word[cnt]=14;
//			15:word[cnt]=15;
//			16:word[cnt]=16;
//			17:word[cnt]=17;
//			18:word[cnt]=18;
//			19:word[cnt]=19;
//			20:word[cnt]=20;
//			21:word[cnt]=21;
//			22:word[cnt]=22;
//			23:word[cnt]=23;
//			24:word[cnt]=24;
//			25:word[cnt]=25;
//			26:word[cnt]=26;
//			27:word[cnt]=27;
//			28:word[cnt]=28;
//			29:word[cnt]=29;
//			30:word[cnt]=30;
//			31:word[cnt]=31;
//			32:word[cnt]=32;
//			33:word[cnt]=33;
//			34:word[cnt]=34;
//			35:word[cnt]=35;
//			36:word[cnt]=36;
//			37:word[cnt]=37;
//			38:word[cnt]=38;
//			39:word[cnt]=39;
//			40:word[cnt]=40;
//			41:word[cnt]=41;
//			42:word[cnt]=42;
//			43:word[cnt]=43;
//			44:word[cnt]=44;
//			45:word[cnt]=45;
//			46:word[cnt]=46;
//			47:word[cnt]=47;
//			48:word[cnt]=48;
//			49:word[cnt]=49;
//			50:word[cnt]=50;
//			51:word[cnt]=51;
//			52:word[cnt]=52;
//			53:word[cnt]=53;
//			54:word[cnt]=54;
//			55:word[cnt]=55;
//			56:word[cnt]=56;
//			57:word[cnt]=57;
//			58:word[cnt]=58;
//			59:word[cnt]=59;
//			60:word[cnt]=60;
//			61:word[cnt]=61;
//			62:word[cnt]=62;
//			63:word[cnt]=63;
//			64:word[cnt]=64;
//			65:word[cnt]=65;
//			66:word[cnt]=66;
//			67:word[cnt]=67;
//			68:word[cnt]=68;
//			69:word[cnt]=69;
//			70:word[cnt]=70;
//			71:word[cnt]=71;
//			72:word[cnt]=72;
//			73:word[cnt]=73;
//			74:word[cnt]=74;
//			75:word[cnt]=75;
//			76:word[cnt]=76;
//			77:word[cnt]=77;
//			78:word[cnt]=78;
//			79:word[cnt]=79;
//			80:word[cnt]=80;
//			81:word[cnt]=81;
//			82:word[cnt]=82;
//			83:word[cnt]=83;
//			84:word[cnt]=84;
//			85:word[cnt]=85;
//			86:word[cnt]=86;
//			87:word[cnt]=87;
//			88:word[cnt]=88;
//			89:word[cnt]=89;
//			90:word[cnt]=90;
//			91:word[cnt]=91;
//			92:word[cnt]=92;
//			93:word[cnt]=93;
//			94:word[cnt]=94;
//			95:word[cnt]=95;
//			96:word[cnt]=96;
//			97:word[cnt]=97;
//			98:word[cnt]=98;
//			99:word[cnt]=99;
				0,1,2:
					begin
						word[cnt]={wMark0,wMark1};	//первые три слова заполняем как маркеры
					end
				3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,
				33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,
				63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95:
					begin
						word[cnt]=d_reg[cnt-2];
					end
				96,97,98: 
					begin
						word[cnt]=18'b0;
					end
				99:
					begin
						parity=wCtrl[0]^wCtrl[1]^wCtrl[2]^wCtrl[3]^wCtrl[4]^wCtrl[5]^wCtrl[6]^wCtrl[7]^wCtrl[8]^wCtrl[9]^wCtrl[10]^wCtrl[11]^wCtrl[12]^wCtrl[13]^wCtrl[14]^wCtrl[15]^sign;
						word[cnt]={parity,!sign,wCtrl};
					end
				100:
					begin
						word[cnt]=18'b0;
						label=addr+1;
						cntX=0;
						cnt=0;
						en=0;
					end
			endcase
			clkcnt=clkcnt+1;
			if(clkcnt==16)
				begin
					if(cnt+label>=256)begin
						addr=cnt+label-256;
					end
					else begin
						addr=cnt+label;
					end
					cntX=cntX+1;
					cnt=cnt+1;			//начинаем считать 100 слов из 18 битов
					clkcnt=0;
				end
			if(clkcnt==2)					
				ram_valid=1;				//принимая каждое слово, формируем сигнал изменения данных для внешней памяти
			else
				ram_valid=0;
		end
	else 
		cnt=0;
		cntX=0;
	oWord<=word[cnt];						
end
endmodule