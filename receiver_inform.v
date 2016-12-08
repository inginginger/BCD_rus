module receiver_inform(clk,HO,IM1,IM0,nRST,oData,oVal);
input clk, HO, IM1, IM0, nRST;
output reg [15:0] oData;
output reg oVal;
reg [2:0] cntHO;
reg [2:0] state;
`define HOHIGH 0
`define HOWAIT 1
`define IMWR1 2
`define IMWR0 3
`define TXD 4
reg [1:0] synh_HO;
reg [1:0] synch_IM1;
reg [1:0] synch_IM0;
reg [3:0] cnt16;
reg [15:0] bufDat;
reg [2:0] cntIM1;
reg [6:0] cntWord;
reg [2:0] cntTX;
reg WRdone;
always @ (posedge clk)
begin
synh_HO [1:0] <= {synh_HO[0],HO};	//ставим 2 d-триггера-синхронизируем 
synch_IM1 [1:0] <= {synch_IM1[0], IM1};//все входные сигналы, чтобы 
synch_IM0 [1:0] <= {synch_IM0[0], IM0};//избежать образования метастабильности
end
always@(posedge clk  or negedge nRST)
begin
	if(~nRST)begin
		oData <= 0;
		oVal <= 0;
		cntHO <= 0;
		state <= 0;
		cnt16 <= 0;
		bufDat <= 0;
		cntIM1 <= 0;
		cntWord <= 0;
		cntTX <= 0;
		WRdone <= 0;
	end
	else begin
		case(state)
			`HOHIGH: begin
				if(synh_HO[1]) begin
					cntHO <= cntHO + 1;
					if(cntHO == 5) begin
						state <= `IMWR1;
						cntHO <= 0;
					end
				end
			end
			`IMWR1: begin
				
				if((synch_IM1[1] == 1)||(synch_IM0[1] == 1))begin
					cntIM1 <= cntIM1 + 1;
					if(cntIM1 == 5) begin
						if(synch_IM1[1] == 1)
							bufDat[cnt16] <= 1;
						else
							bufDat[cnt16] <= 0;
						cnt16 <= cnt16 + 1;
						state <= `IMWR0;
						cntIM1 <= 0;
					end
				end
			end
			`IMWR0: begin
				if((synch_IM1[1] == 0)&&(synch_IM0[1] == 0))begin				
					state <= `IMWR1;
					if(cnt16 == 0) begin
						cntWord <= cntWord + 1;
						WRdone <= 1;
						if(cntWord == 94) begin
							state <= `HOWAIT;
							cntWord <= 0;
						end
					end
				end
			end
			`HOWAIT: begin
				if(~synh_HO[1])
					state <= `HOHIGH;
			end
		endcase
		
		if(WRdone == 1) begin
			cntTX <= cntTX + 1'b1;
			case(cntTX)
				0: oData <= bufDat;
				1: oVal <= 1;
				3: oVal <= 0;
				4: begin
					bufDat <= 0;
					cntTX <=0;
					WRdone <= 0;
				end
			endcase
		end
	end
end
endmodule
