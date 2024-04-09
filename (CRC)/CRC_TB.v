`timescale 1ns/1ns
module CRC_TB ();
	
	parameter clk_period=100;
	parameter TEST_CASES=10;

	reg Data;
	reg Active;
	reg clk,rst;
	wire CRC,Valid;

	reg [7:0] Data_Bytes [TEST_CASES-1:0];
	reg [7:0] Expected_Out [TEST_CASES-1:0];
	reg [7:0] collect;


	integer i,j,k;



	//************************************************************

	initial begin
		clk=0;
		forever
		#(clk_period/2) clk=~clk;
	end

	//*****************************************************

	CRC c1(Data,Active,clk,rst,CRC,Valid);

	//********** Tasks **************************

	task initialization ();
	begin
		i=0;j=0;k=0;
		collect=0;
		Data=0;
		Active=0;
		assert_reset();
	end
	endtask

	task assert_reset();
	begin
		rst=0;
		@(negedge clk) rst=1;
	end
	endtask

	task do_operation(input [7:0] Data_TEST );
	begin
		for(j=0;j<8;j=j+1) begin
				@(negedge clk);
				Data=Data_TEST[j];
				Active=1;
			end	
			@(negedge clk ) Active=0;
	end
	endtask

	task check_out ( input [7:0] Expected_Out_t);
	begin
		for(k=0;k<8;k=k+1) begin
				@(negedge clk);
				collect[k]=CRC;
			end
			//@(negedge clk);

			if(collect != Expected_Out_t)
				$display("Error in your Design : CRC=%h Expected_Out=%h",collect,Expected_Out_t);
			else 
				$display("Test Passed : CRC=%h Expected_Out=%h",collect,Expected_Out_t);
				//rst=0;
				//#1 rst=1;	
	end
	endtask



	
	initial begin
		$readmemh("DATA_h.txt",Data_Bytes);
		$readmemh("Expec_Out_h.txt",Expected_Out);

		initialization();

		
		for (i=0;i<TEST_CASES;i=i+1) begin
			do_operation(Data_Bytes[i]);
			check_out(Expected_Out[i]);
		end
		#2 $stop;

	end


endmodule