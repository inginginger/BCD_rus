module rdmem(clk,nRST,valid,iData,addrRD,addrWR,rdVal,wrVal,oData,test);
input clk;
input nRST;
input valid;
input [17:0] iData;
output reg [6:0] addrRD;
output reg [6:0] addrWR;
output reg [17:0] oData;
reg [6:0] cntWord;
reg [3:0] clkcnt;
output reg rdVal, test;
output reg wrVal;
reg [2:0] st;
reg [2:0] cntVal;
reg [17:0] tmp;
`define VALIDATOR 0
`define WAITVALIDATOR 1
`define TXDATA 2

//assign addrRD = cntWord;

/*Сормирование данных дл§ записи во внешнюю RAM*/
always@(posedge clk or negedge nRST) begin
	if(nRST == 1'b0) begin
		st <= 3'b1;
		cntWord <= 7'b0;
		clkcnt <= 4'b0;
		rdVal <= 1'b0;
		wrVal <= 1'b0;
		addrWR <= 7'b0;
		addrRD <= 7'd0;
//		cntVal <= 7'b0;
		oData <= 18'd0;
		test <= 1'b0;
		tmp <= 18'd0;
	end else begin
		case(st)
			`VALIDATOR: begin
				addrRD <= 0;
				addrWR <= 0;
				cntWord <= 7'b0;
				if(valid) st <= `TXDATA; 
				//else st <= `WAITVALIDATOR;
			end
			
			`TXDATA: begin
				clkcnt <= clkcnt + 1'b1;
				case(clkcnt)
					0: addrRD <= cntWord;
					1: rdVal <= 1;
					3: tmp <= iData;
					5: rdVal <= 0;
					10: case(cntWord)
						2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,
						50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94:
						begin
							addrWR <= cntWord + 2'd1;
							oData <= tmp;
							wrVal <= 1;
						end
					endcase 
					12: cntWord <= cntWord + 1'b1;
					14: wrVal <= 0;
					15: begin
						if(cntWord == 7'd95) begin
							st <= `WAITVALIDATOR;
							test <= 1'b1;		
						end
						clkcnt <=4'b0;	
					end
				endcase
			end
			`WAITVALIDATOR: begin
				if(~valid) begin
					test<=1'b0;
					st <= `VALIDATOR;
				end
			end
		endcase
	end
end
endmodule

