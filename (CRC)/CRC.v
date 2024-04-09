module CRC (Data,Active,clk,rst,CRC,Valid);

	parameter SEED=8'hD8;
	input Data;
	input Active;
	input clk,rst;
	output reg CRC,Valid;

	reg [7:0] LFSR;
	wire feedback;
	reg [3:0] counter;
	wire Done_Flag;
	reg operation_start;


	always @ (posedge clk or negedge rst) begin
		if(!rst) begin
			LFSR<=SEED;
			CRC<=1'b0;
			Valid<=1'b0;
			operation_start<=1'b0;
		end
		else begin
			if(Active) begin
				operation_start<=1'b1;
				LFSR[7]<=feedback;
				LFSR[6]<= LFSR[7] ^ feedback;
				LFSR[5]<= LFSR[6];
				LFSR[4]<= LFSR[5];
				LFSR[3]<= LFSR[4];
				LFSR[2]<= LFSR[3] ^ feedback;
				LFSR[1]<= LFSR[2];
				LFSR[0]<= LFSR[1];
			end
			else if (!Done_Flag && operation_start) begin
				Valid<=1'b1;
				{LFSR[6:0],CRC}<=LFSR;
				LFSR[7]<=0;
			end
			else begin
				operation_start<=1'b0;
				Valid<=1'b0;
				LFSR<=SEED;
			end
			
		end
	end


	always @(posedge clk or negedge rst) begin
		if(! rst )
			counter<=0;
		else begin
			if( !Active && operation_start)
				counter<=counter+4'b1;
			else
				counter<=4'b0;	
		end	
	end


	assign Done_Flag = (counter =='d8);
	assign feedback =Data ^ LFSR[0];

endmodule