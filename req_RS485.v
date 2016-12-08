module req_RS485(clk, dataMFK, rValid, nRST, ack, TEST);
input clk;
input rValid;
input [7:0] dataMFK;
input nRST;
output reg ack, TEST;
reg [3:0] cntReq;
reg [2:0] state;
reg [7:0] cntclk;
reg  ENcnt;

`define WAIT 0
`define READY 1
`define COUNT_VALID 2
`define RESET 3

always@(posedge clk)
begin
	if(nRST == 1'b0) begin
		ack <= 1'b0;
		cntReq <= 3'b0;
		TEST <= 1'b0;
		ENcnt <= 1'b0;
		cntclk <= 8'b0;
		state <= 4'b0;
	end
	else 
	begin
		case(state)
		`WAIT:
		begin
			if(rValid)				
			begin
				if(dataMFK == 8'd66)
					ENcnt <= 1;
				state <= `COUNT_VALID;
			end
		end
		`COUNT_VALID:
		begin
			if(ENcnt) begin
				if(cntReq==6)
				begin
					state <= `RESET;
					cntReq <= 0;
				end
				else
				begin
					cntReq <= cntReq+1'b1;
					state <= `READY;
				end
			end
			else
				state <= `READY;
		end
		`RESET:
		begin
			if(cntclk == 240)
			begin
				ack <= 1'b0;
				ENcnt <= 0;
				cntclk <= 0;
				state <= `READY;
			end
			else
			begin
				cntclk <= cntclk+1'b1;
				ack <= 1'b1;
			end
		end
		`READY:
		begin
			if(~rValid)
				state <= `WAIT;
		end
		endcase
	end
end
endmodule		
		
		
//		case(state)
//		`WAIT:
//		begin
//			if(~ena)				
//			begin
//				state <= `COUNT ;
//			end
//		end
//		`COUNT:
//		begin
//			dirRX <= 1'b1;
//			if(pauseTX == 7'd200)
//			begin
//				state <= `DIR;
//				pauseTX <=0;
//			end
//			else
//				pauseTX <= pauseTX+1'b1;
//		end
//		`DIR:
//		begin
//			if(rstDir == 1)
//				
//			
//		end
//		`READY: 
//		begin
//			if(ena)
//			begin
//				state <= `WAIT ;
//			end
//		end
//	