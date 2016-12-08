module TX_without_req(clk5MHz, wrEn, data_in, rs485_tx, dir_RX, dir_TX, accept);
input clk5MHz;
input wrEn; 
input [17:0] data_in;
output reg rs485_tx=0;
output reg accept=0;
output reg dir_TX=0;
output reg dir_RX=0;

reg [1:0] phrase=2'b0;
reg [3:0] cntBits=4'b0;
reg [6:0] cntWords=7'b0;
reg temp=0;
reg ack=0;
reg [6:0] i=7'b0;
reg [6:0] j=7'b0;
reg [31:0] delay=31'b0;
reg [31:0] pauseTX=31'b0;
reg [31:0] pauseRX=31'b0;
reg [31:0] pauseDirTX=31'b0;
reg ena=0;
reg stop=0;
reg [9:0] buff1=10'b0;
reg [9:0] buff2=10'b0;
reg [9:0] buff3=10'b0;
reg [17:0] word [96:0];
reg [17:0] mem=18'b0;

initial begin			//������������� �������
	for(i=0;i<97;i=i+1'b1)	//�� 97 18-������ 
		word[i]<=18'b0;	//���� ������
end

always@(negedge wrEn)
begin
			word[j]<=data_in;		//� �� ������� ���������� � ������� ���������� � ������� ������� ��������
			j<=j+1'b1;
			if(j==96) 				
				begin
					ack<=1;
				end
			if(j==97)				//��� ������ ���������
				begin
					j<=0;			//�������� ������� �� ���������� ������� �� ��������� ������ �� ���� data_in
					ack<=0;
				end         
end
always@(posedge clk5MHz)
begin
	if(ack==1 && temp==0)
		accept<=1;
	temp<=ack;
	if(accept==1)
		begin
			delay<=delay+1'b1;
			if(delay>10) begin
				dir_RX<=1;
				if(dir_RX==1) begin					
					pauseTX<=pauseTX+1'b1;			
					if(pauseTX==5)
						dir_TX<=1;				
						if(dir_TX==1) begin
							pauseDirTX<=pauseDirTX+1'b1;
							if(pauseDirTX==15)
								ena<=1;
						end
				end
			end
				if(ena==1) begin
					mem<=word[cntWords];
					case(phrase)
						0: begin
							buff1<={1'b0,mem[15:8],1'b1};
							rs485_tx<=buff1[9-cntBits];
							cntBits<=cntBits+1'b1;
							if(cntBits==10)
								begin
									cntBits<=0;
									buff1<=10'b0;
									phrase<=1;
								end
						end
						1: begin
							buff2<={1'b0,mem[7:0],1'b1};
							rs485_tx<=buff2[9-cntBits];
							cntBits<=cntBits+1'b1;
							if(cntBits==10)
								begin
									cntBits<=0;
									buff2<=10'b0;
									phrase<=2;
								end
						end
						2: begin
							buff3<={1'b0,mem[17:16],6'b0,1'b1};
							rs485_tx<=buff3[9-cntBits];
							cntBits<=cntBits+1'b1;
							if(cntBits==10)
								begin
									cntBits<=0;
									buff3<=10'b0;
									cntWords<=cntWords+1'b1;
									phrase<=0;
								end
						end
					endcase
					
					if(cntWords==97)
						begin
							cntWords<=0;
							ena<=0;
							dir_TX<=0;				
							stop<=1;					
						end
				end
					if(stop==1)
						pauseRX<=pauseRX+1'b1;
					if(pauseRX==5) begin		
								dir_RX<=0;		
								delay<=0;		
								pauseTX<=0;		
								pauseRX<=0;		
								pauseDirTX<=0;
								stop<=0;			
								accept<=0;
					end	
				end					
					
end
endmodule
//always@(posedge enable)
//begin
//	if(enable==1 && temp==0)						//�������� ����� ������� ���������� ������ � ������
//			ack<=1;										//���������� ������ ���������� ��������
//	if(cntWords==97)						//��� ������� 97 ����
//			ack<=0;							//������� ������ ���������� ��������
//end
//always@(posedge clk5MHz)
//begin
//	if(enable==1 && temp==0)						//�������� ����� ������� ���������� ������ � ������
//			ack=1;										//���������� ������ ���������� ��������
//	if(ack==1)
//		begin
//			case(phrase)							//������������� �� ������
//				0: begin
//					rs485_tx<=din1[cntBits];		//������ �� ����� ������ 10 ����� 18-���������� �����
//					cntBits=cntBits+1;
//					if(cntBits==10)
//						begin
//							cntBits=0;
//							phrase<=1;				//��������� � ��������� �����
//						end
//				end
//				1: begin
//					rs485_tx<=din2[cntBits];		//������ �� ����� ������ 10 ����� 18-���������� �����
//					cntBits=cntBits+1;
//					if(cntBits==10)
//						begin
//							cntBits=0;
//							phrase<=2;				//��������� � ��������� �����
//						end
//				end
//				2: begin	
//					rs485_tx<=din3[cntBits];		//������ �� ����� �������� ���� 18-���������� �����
//					cntBits=cntBits+1;
//					if(cntBits==10)
//						begin
//							cntBits=0;
//							cntWords=cntWords+1;	//�������������� ������� ����
//							phrase<=0;				//������������ � ������ �����
//						end
//				end	
//			endcase
//			
//			if(cntWords==97)						//��� ������� 97 ����
//				begin
//					cntWords=0;						//������� ������� ����
//					ack=0;							//������� ������ ���������� ��������
//				end
//		end
//end
//endmodule
//
