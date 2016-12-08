module wrmem(clk, din, valid, par, nRST, HO, oWord, addr, WE, RXdone);
input clk;
input valid;
input par;
input [15:0] din;
input nRST;
input HO;
output reg [6:0] addr;
output reg [17:0] oWord;
output reg WE;
reg [6:0] cntVal;
output reg RXdone;
reg [3:0] wr;
reg [2:0] state;
reg [17:0] temp;
`define HOSYNCH 0
`define WAITVAL 1
`define VALIDDONE 2
`define WRMEM 3
`define CNTVALID 4
reg [1:0] synchPar;
reg [1:0] synchHO;
reg [1:0] synchVal;


always@(posedge clk)
begin
	synchHO[1:0] <= {synchHO[0], HO};
	synchPar[1:0] <= {synchPar[0], par};
	synchVal[1:0] <= {synchVal[0], valid};
end

always@(posedge clk or negedge nRST)
begin
	if(~nRST)
	begin
		cntVal <= 0;
		state <= 0;
		RXdone <= 0;
		wr <= 0;
		temp <= 0;
		oWord <= 0;
		WE <= 0;
	end  
	else
	case(state)
		`HOSYNCH:
			if(synchHO[1]) begin
				cntVal <= 0;
				RXdone <= 0;
				wr <= 0;
				temp <= 0;
				oWord <= 0;
				WE <= 0;
				state <= `WAITVAL;
			end
		`WAITVAL:
		begin
			if(synchVal[1])
				state <= `WRMEM;
		end
		`WRMEM:
		begin
			wr <= wr + 1'b1;
			case(wr)
				0: addr <= cntVal;
				1: begin 
					temp[17] <= synchPar[1];
					temp[16] <= 1;
					temp[15:0] <= din[15:0];
				end
				2: oWord[17:0] <= temp[17:0];
				3: WE <= 1;
				6: WE <= 0;
				7: begin
					cntVal <= cntVal + 1'b1;
					RXdone <= 0;
					if (cntVal == 94) begin	
						cntVal <= 0;
						RXdone <= 1;
						state <= `HOSYNCH;
					end
					state <= `VALIDDONE;
					wr <= 0;
				end
			endcase
		end
		`VALIDDONE:
		begin
			if(~synchVal[1])
				state <= `WAITVAL;
		end
	endcase
end
endmodule