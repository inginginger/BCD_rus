module data_req(clk, from_mfk, rx_valid, rstClr, dir_RX, dir_TX, addr_ena,TEST);
input clk;
input rx_valid;
input rstClr;
input [7:0] from_mfk;
output reg addr_ena=0;
output reg dir_RX=0;
output reg dir_TX=0;
output reg TEST=0;
reg ack=0;
reg [11:0] cnt=12'b0;
reg [11:0] cntClr=12'b0;
reg [7:0] req;
reg [7:0] d_req [7:0];
reg accept=0;
reg RESET=0;
reg temp=0;
reg rx=0;
reg cntrlDirRX=0;
reg cntrlDirTX=0;
reg edgeDirRX=0;
reg edgeDirTX=0;
reg [3:0] i=4'b0;
reg tmpRX=0;
reg tmpTX=0;
reg tmpDirRX=0;
reg tmpDirTX=0;
reg tmpClr=0;
reg tmpVal=0;

always@(posedge clk)
begin
	if(rx_valid==0 && tmpVal==1) begin
		rx<=1;
		if(from_mfk==8'd66)begin
		
			i<=1;
			TEST<=1;
		end
	end
	tmpVal<=rx_valid;
	
	if (rx==1) begin
		i<=i+1;
		if(i==8)begin
			ack<=1;
			i<=0;	
		end
		else begin 
			ack<=0;
		end
		TEST<=0;
	rx<=0;
	end
end
always@(posedge clk)
begin
	if(ack==1 && temp==0)					//если приняли все валиды
		accept<=1;							//разрешаем управление dir'ами и передачей
	temp<=ack;
	if(accept==1) begin
		if(cnt<1000) 
			cntrlDirRX<=1;					//разрешаем управление dir_RX
		else if(cnt==1000)
			cntrlDirRX<=0;
		else if(cnt>1000 && cnt<1500)
			cntrlDirTX=1;					//разрешаем управление dir_TX
		else if(cnt==1500)
			cntrlDirTX<=0;
		else if(cnt>1500 && cnt<2000)
			addr_ena<=1;						//разрешаем управление передачей
		else if(cnt==2000) begin
			addr_ena<=0;
			cnt<=0;
			accept<=0;
		end
		cnt<=cnt+1'b1;
	end
end
always@(posedge clk)
begin
	if(rstClr==0 && tmpClr==1)				//по срезу сигнала окончания передачи
		RESET<=1;							//сформируем сброс
	tmpClr<=rstClr;
	if(RESET==1) begin
		if(cntClr<1000)
			edgeDirTX<=1;
		else if(cntClr==1000)
			edgeDirTX<=0;
		else if(cntClr>1000 && cntClr<1500)
			edgeDirRX<=1;
		else if(cntClr==1500) begin
			edgeDirRX<=0;
			cntClr<=0;
			RESET<=0;
		end
		cntClr<=cntClr+1;
	end
end
always@(posedge clk)
begin 
	if(cntrlDirRX==0 && tmpRX==1) 			//по срезу сигнала управления
	begin
		dir_RX<=1;							//отключим приемник
	end
	tmpRX<=cntrlDirRX;
	if(cntrlDirTX==0 && tmpTX==1)			//по срезу сигнала управления
	begin
		dir_TX<=1;							//включим передатчик
	end
	tmpTX<=cntrlDirTX;
	if(edgeDirTX==0 && tmpDirTX==1)
	begin
		dir_TX<=0;
	end
	tmpDirTX<=edgeDirTX;
	if(edgeDirRX==0 && tmpDirRX==1)
	begin
		dir_RX<=0;
	end
	tmpDirRX<=edgeDirRX;	
//	//test=1;
//		dir_TX=0;							//отключим передатчик
//		cntClr=cntClr+1;
//		if(cntClr==500) begin				//позднее
//			dir_RX=0;						//отключим приемник
//			cntClr=0;
//			RESET=0;
//			//test=0;
//		end

end
endmodule