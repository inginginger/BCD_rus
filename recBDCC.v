module recBDCC(
input clk,
input nRST,
input HO,
input IM1,
input IM0,
output reg [15:0] oData,
output reg oVal,
output reg TEST);

reg [2:0] cntHO;
reg [1:0] state;
`define HOHOLD 0
`define WAITHO 1
`define WAITIM 2

always@(posedge clk)
begin
	if(nRST == 0) begin
		oData <= 0;
		oVal <= 0;
		TEST <= 0;
		cntHO <= 0;
		state <= 1;
	end
	else
	case(state)
		`HOHOLD: begin
			if(HO) begin
				cntHO <= cntHO + 1;
				if(cntHO == 6) begin
					TEST <= 1;
					state <= `WAITIM;
				end
			end
		end
		`WAITIM: begin
			cntHO <= 0;
			TEST <= 0;
			state <= `WAITHO;
		end
		`WAITHO: begin
			if(~HO)
				state <= `HOHOLD;
		end
	endcase
end
endmodule