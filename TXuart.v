module TXuart(clk, nRST, data, valid, rs485_tx, busy);
input clk;
input nRST;
input [7:0] data;
input valid;
output reg rs485_tx;
output reg busy;
reg [3:0] rsTXcnt;
reg [1:0] state;
reg [9:0] bufReg;
`define WAIT 0
`define READY 1
`define TXN 2
always@(posedge clk or negedge nRST)
begin
	if(~nRST)
	begin
		state <= 2'b0;
		rsTXcnt <= 4'b0;
		rs485_tx <= 1'b1;
		busy <= 1'b0;
	end
	else
	begin
	case(state)
		`WAIT:
		begin
			if(valid)
			//begin
				busy <= 1'b1;
				if(busy == 1)
				state <= `TXN;
			//end
		end
		`TXN:
		begin
			rsTXcnt <= rsTXcnt + 1'b1;
			case (rsTXcnt)
				0: rs485_tx <= 0;
				1,2,3,4,5,6,7,8: rs485_tx <= data[rsTXcnt-1'b1];
				9: begin
					rs485_tx <= 1;
				end
				10: begin
					state <= `READY;
				end
			endcase
		end
		`READY:
		begin
			busy <= 1'b0;
			if(~valid)
			begin
				state <= `WAIT;
				rsTXcnt <= 0;
			end
		end
	endcase
	end
end
endmodule