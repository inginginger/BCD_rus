module recBUFDAT(clk,HO,IM1,IM0,nRST,oData,oVal, TEST);
input clk, HO, IM1, IM0, nRST;
output reg [15:0] oData;
output reg oVal;
output reg TEST;
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
reg [2:0] cntIM0;
reg [6:0] cntWord;
reg [2:0] cntTX;
reg [6:0] i;
always @ (posedge clk)
begin
synh_HO [1:0] <= {synh_HO[0],HO};	//noaaei 2 d-o?eaaa?a-neio?iiece?oai 
synch_IM1 [1:0] <= {synch_IM1[0], IM1};//ana aoiaiua neaiaeu, ?oiau 
synch_IM0 [1:0] <= {synch_IM0[0], IM0};//ecaa?aou ia?aciaaiey iaoanoaaeeuiinoe
end
always@(posedge clk)
begin
	if(nRST == 1'b0)begin
		oData <= 0;
		oVal <= 0;
		cntHO <= 0;
		state <= 0;
		TEST <= 0;
		cnt16 <= 0;
		bufDat <= 0;
		cntIM1 <= 0;
		cntIM0 <= 0;
		cntWord <= 0;
		i <=0;
		cntTX <= 0;
	end
	else
	case(state)
		`HOHIGH: begin
			oData <= 0;
			oVal <= 0;
			cntHO <= 0;
			TEST <= 0;
			cnt16 <= 0;
			bufDat <= 0;
			cntIM1 <= 0;
			cntIM0 <= 0;
			cntWord <= 0;
			i <= 0;
			cntTX <= 0;
			if(synh_HO[1]) begin
				cntHO <= cntHO + 1;
				if(cntHO == 5) begin
					state <= `IMWR1;
					cntHO <= 0;
					cnt16 <= 0;
				end
			end
		end
		`IMWR1: begin
			TEST <= 0;
			if((synch_IM1[1] == 1)||(synch_IM0[1] == 1))begin
				cntIM1 <= cntIM1 + 1;
				if(cntIM1 == 5) begin
//					if(synch_IM1[1] == 1)
//						bufDat[cnt16] <= 1;
//					else
//						bufDat[cnt16] <= 0;
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
					state <= `TXD;
					if(cntWord == 94) begin
						state <= `HOWAIT;
						i<=0;
						cntWord <= 0;
					end
				end
			end
		end
		`TXD: begin
			TEST <= 1;
			cntTX <= cntTX + 1'b1;
			case(cntTX)
				0: oData <= i;//bufDat;
				1: oVal <= 1;
				2: i <= i+1;
				3: oVal <= 0;
				4: begin
					bufDat <= 0;
					state <= `IMWR1;
					cntTX <=0;
				end
			endcase
		end
		`HOWAIT: begin
			if(~synh_HO[1])
				state <= `HOHIGH;
		end
	endcase
end
endmodule
