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
			if(~RXdone) begin 				//����� ���� RXdone 
				state <= `REQUESTFOAM;		//���� �������� ������
			end 
		end 
		`REQUESTFOAM: 
		begin 
			pause <= 8'b0; 
			if(clkcnt < 3'd5) 
			begin 
				req <= 1'b1; 				//��������� ������
				clkcnt <= clkcnt+1'b1; 
			end 
			else 
			begin
				req <= 1'b0;
				state <= `READY; 			//���� ������ ������
			end
		end 
		`WAIT: 
		begin 
			if(~txValid) 					//�� ����� ������
			begin 
				clkcnt <= 3'b0; 
				state <= `DIVIDE; 			//���� ���������� �����
			end 
		end 
		`DIVIDE: 
		begin 
			iWord[0] <= {1'b1, data[17:16], 6'b0, 1'b0};	//�������� 18-������ �����
			iWord[1] <= {1'b1, data[15:8], 1'b0}; 			//�� 3 8-������ 
			iWord[2] <= {1'b1, data[7:0], 1'b0}; 			//�� ���������� ������
			state <= `COUNT; 
		end 
		`COUNT: 
		begin 
			if(cntWord < 2'd3) 								//���� �� ������� 3 ����� 18-������� �����
			begin 
				if(pause < 8'd160)
				begin 
					pause <= pause + 1'b1;
					dout <= iWord[cntWord]; 				//������ �� �������� ���� 
				end 
				else 
				begin
					cntWord <= cntWord+1'b1;
					state <= `TXEN; 						//���� ����������� ������ ��� �������� ������� �����
				end
			end 
			else 
			begin 
				cntWord <= 0;								// ��������, �������� 3 ����� (0 1 2)
				cntAll <= cntAll+1'b1; 						//������� 48 ����(16 � ������� �� 3-� �������)
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
				TXen <= 1'b1; 							//��������� ������ ���������� �������� ����
				delay <= delay + 1'b1;
			end
			else
			begin
				TXen <= 1'b0;
				state <= `COUNT; 						//���� ������� ��������� �����
			end
		end 
		`REQTWICE:
		begin
			if(clkcnt < 3'd5) 
			begin 
				req <= 1'b1; 				//��������� ������
				clkcnt <= clkcnt+1'b1; 
			end 
			else 
			begin
				req <= 1'b0;
				state <= `READY; 			//���� ������ ������
			end
		end
		`READY: 
		begin 
			if(txValid) //�� ������ ������
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
