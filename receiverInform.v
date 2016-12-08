module receiverInform(clk13MHz, nRST, HO, IM1, IM0, dout, iVal, cntWord, WRdone, TEST);
input clk13MHz;
input nRST;
input HO;
input IM1;
input IM0;
output reg iVal;
output reg [15:0] dout;
output reg [6:0] cntWord;
output reg TEST;
output reg WRdone;
reg [4:0] cntHO;
reg [4:0] cntIM1;
reg [4:0] cntIM0;
reg [2:0] state;
reg [15:0] bufDat [0: 94];
reg [4:0] cnt16;
reg ack;
`define HOHIGH 0
`define WAITHO 1
`define IMWR 2
`define COUNTALL 3
`define FINAL 4

always@(posedge clk13MHz)
begin
	if(nRST) begin
		iVal <= 1'b0;
		dout <= 16'd0;
		cntWord <= 7'd0;
		cntHO <= 5'd0;
		cntIM1 <= 5'd0;
		cntIM0 <= 5'd0;
		state <= 3'd1;
//		bufDat <= 16'd0;
		cnt16 <= 5'd0;
		TEST <= 1'b0;
		ack <= 1'b0;
		WRdone <= 1'd0;
	end
	else
	case(state)
		`HOHIGH: begin
			if(HO == 1'b1) begin
				cntHO <= cntHO + 1'b1;
				if(cntHO == 5'd20) begin
					state <= `IMWR;
					cntHO <= 5'd0;
				end
			end

		end
		`IMWR: begin
			if(IM1 == 1'b1) begin
				state <= `COUNTALL;
				cntIM1 <= cntIM1 + 1'b1;
				if(cntIM1 == 5'd20) begin
					bufDat[5'd16-cnt16] <= 16'd1;
					cnt16 <= cnt16 + 1'b1;
					cntIM1 <= 5'd0;
				end
			end
			else if(IM0 == 1'b1) begin
				state <= `COUNTALL;
				cntIM0 <= cntIM0 + 1'b1;
				if(cntIM0 == 5'd20) begin
					bufDat[cnt16] <= 16'd0;
					cnt16 <= cnt16 + 1;
					cntIM0 <= 5'd0;
				end
			end
			
		end
		`COUNTALL: begin
			iVal <= 1'b0;
			state <= `IMWR;
			if(cnt16 == 5'd16) begin
				dout <= bufDat[cntWord];
				iVal <= 1'd1;
				cnt16 <= 5'd0;
				cntWord <=cntWord + 1'b1;
				if(cntWord == 7'd95) begin
	//				bufDat <= 16'd0;
					WRdone <= 1'd1;
					cntWord <= 7'd0;
					state <= `WAITHO;
				end
			end
		end
		`WAITHO:begin
			if( HO == 1'b0)begin
				WRdone <= 1'd0;
				state <= `HOHIGH;
			end
		end
	endcase
end
endmodule