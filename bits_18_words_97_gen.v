module bits_18_words_97_gen(clk,din,wCtrl,valid,par,oWord,addr,ram_valid);
input clk,valid,par;
input [15:0] din;
input [15:0] wCtrl;
output reg [6:0]addr=7'b0;
output reg [17:0] oWord=18'b0;
output reg ram_valid=0;
reg en=0;
reg [17:0] d_reg [94:0];
reg [17:0] word [127:0];
integer  parity=0,ack=0,temp=0;//,sign=1;
reg [15:0] wMark1=16'hFFFF;
reg [1:0] wMark0=2'b0;
wire sign=1'b1;
integer i=0, j=0, k=0, m=0, clkcnt=0, cnt=0, label=0, cntX=0;

initial begin
oWord<=word[i];			//������������� �������
for(i=0;i<128;i=i+1)		//�� 100 18-������ 
	word[i]<=18'b0;		//���� ������
for(m=0;m<95;m=m+1)
	d_reg[m]=18'b0;
end
always@(negedge valid)
begin
			d_reg[k]={par,1'b1,din};		//� �� ������� ���������� � ������� ���������� � ������� ������� ��������
			k=k+1;
			if(k==94) 				
				begin
					ack=1;
				end
			if(k==95)				//��� ������ ���������
				begin
					k=0;			//�������� ������� �� ���������� ������� �� ��������� ������ �� ���� din
					ack=0;
				end
end
always@(negedge clk)
begin
	if(ack==1 && temp==0) 
		en=1;
	temp=ack;
	if(en==1)								//�� ������� ���������� ������
		begin
			
			case(cnt)
			/*
//			0:word[cnt]=65535;
//			1:word[cnt]=65535;
//			2:word[cnt]=65535;
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
//			99:word[cnt]=99;*/
				0,1,2:
					begin
						word[cnt]={wMark0,wMark1};	//������ ��� ����� ��������� ��� �������
					end
				3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,
				33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,
				63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95:
					begin
						word[cnt]=d_reg[cnt-2];
					end
				96:
					begin
						parity=wCtrl[0]^wCtrl[1]^wCtrl[2]^wCtrl[3]^wCtrl[4]^wCtrl[5]^wCtrl[6]^wCtrl[7]^wCtrl[8]^wCtrl[9]^wCtrl[10]^wCtrl[11]^wCtrl[12]^wCtrl[13]^wCtrl[14]^wCtrl[15]^sign;
						word[cnt]={parity,!sign,wCtrl};
					end
				97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,
				121,122,123,124,125,126,127: 
					begin
						word[cnt]=18'b0;
					end
				128:
					begin
						word[cnt]=18'b0;
						cnt=0;
						en=0;
					end
			endcase
			clkcnt=clkcnt+1;
			if(clkcnt==16)
				begin
					addr=cnt;
					cnt=cnt+1;			//�������� ������� 100 ���� �� 18 �����
					clkcnt=0;
				end
			if(clkcnt==2)					
				ram_valid=1;				//�������� ������ �����, ��������� ������ ��������� ������ ��� ������� ������
			else
				ram_valid=0;
		end
	else 
		cnt=0;
	oWord<=word[cnt];						
end
endmodule


//module bits_18_words_97_gen(clk, din, wCtrl, valid, par, nRST,ctrl, oWord, addr, TXout, RXdone);
//input clk;
//input valid;
//input par;
//input [15:0] din;
//input [15:0] wCtrl;
//input nRST;
//input ctrl;
//output reg [6:0] addr;
//output reg [17:0] oWord;
//reg [17:0] word [127:0];
//reg [7:0] i;
//reg [7:0] j;
//reg [6:0] m;
//reg [6:0] cntVal;
//reg [7:0] cntWord;
//reg [2:0] clkcnt;
//reg ack;
//output reg TXout;
//output reg RXdone;
//reg [2:0] wr;
//reg [2:0] state;
//reg [1:0] st;
//reg [17:0] temp;
//reg [3:0] cntDone;
//
//`define WAITVALID 0
//`define VALIDDONE 1
//`define WRMEM 2
//`define CNTVALID 3
//`define RXDONEP 0
//`define RXDONEN 1
//`define TXDATA 2
//
//initial begin
//word[0] = 18'd65535;
//word[1] = 18'd65535;
//word[2] = 18'd65535;
//for(i=3; i<96; i=i+1)
//	word[i] = i;//18'b0;
//word[96] = {ctrl,1'b0,wCtrl};
//for(j=97; j<128; j=j+1)
//	word[j] = j;//18'b0;
//end
//
//always@(negedge clk)
//begin
//	if(nRST == 1'b0)
//	begin
//		cntVal <= 7'd3;
//		state <= 3'b0;
//		RXdone <= 1'b0;
//		wr <= 3'b0;
//		temp <= 18'b0;
//		cntDone <= 1'b0;
//	end  
//	else
//	/*������������ ������ �� ����*/
//	case(state)
//		`WAITVALID:
//		begin
//			if(valid)
//			begin
//				state <= `WRMEM;
//				cntVal <= cntVal + 1'b1;
//				if (cntVal == 0) state <= `VALIDDONE;
//				if (cntVal == 94) begin	
//					state <= `VALIDDONE;
//					RXdone <= 1'b1;
//					cntVal <= 0;
//				end
//			end
//			if (RXdone) cntDone <= cntDone + 1;
//			if (cntDone == 10) RXdone <= 0;
//		end
//		`WRMEM:
//		begin
//			wr <= wr + 1'b1;
//			case(wr)
//				0: temp[17] <= par;
//				1: temp[16] <= 1'b1;
//				2: temp[15:0] <= din[15:0];
//				3: word[(cntVal + 2)] <= temp;
//				4: state <= `VALIDDONE;
//
//			endcase
//		end
//		`VALIDDONE:
//		begin
//			wr <= 3'b0;
//			if(~valid)
//			begin
//				state <= `WAITVALID;
//			end
//		end
//	endcase
//end
///*������������ ������ ��� ������ �� ������� RAM*/
//always@(negedge clk)
//begin
//	if(nRST == 1'b0)
//	begin
//		ack <= 1'b0;
//		st <= 2'b01;
//		cntWord <= 8'b0;
//		clkcnt <= 3'b0;
//		TXout <= 1'b0;
//		addr <= 7'b0;
//	end
//	else
//	case(st)
//		`RXDONEP:
//		begin
//			if(RXdone)
//				ack <= 1'b1;
//			if(ack == 1'b1)
//				st <= `TXDATA;
//		end
//		`TXDATA:
//		begin
//			clkcnt <= clkcnt + 1'b1;
//			case(clkcnt)
//				0: addr <= cntWord;
//				//1: oWord <= word [cntWord];
//				2: TXout <= 1'b1;
//				3: cntWord <= cntWord + 1'b1;
//				4: TXout <= 1'b0;
//				5: if(cntWord == 8'd128)
//					begin
//						cntWord <= 8'b0;
//						clkcnt <= 3'b0;
//						st <= `RXDONEN;
//					end
//			endcase
//		end
//		`RXDONEN:
//		begin
//			ack <= 1'b0;
//			if(~RXdone)
//				st <= `RXDONEP;
//		end
//	endcase
//end
//endmodule