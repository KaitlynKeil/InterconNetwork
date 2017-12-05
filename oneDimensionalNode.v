`include "master_spi.v"
`include "receiver_spi.v"
`include "receiver_queue.v"
`include "node_controller.v"

module oneDimensionalNode(shiftInLeftData,shiftInLeftCS,shiftInRightData,shiftInRightCS,shiftInData,shiftInCLK,shiftInCS,shiftOutLeftCS,shiftOutRightCS,shiftOutData,shiftOutCLK,shiftOutCS);

	input [31:0] shiftInLeftData,shiftInRightData,shiftInData;
	input shiftInLeftCS,shiftInRightCS,shiftInCS,shiftInCLK;
	output [31:0] shiftOutLeftData,shiftOutRightData,shiftOutData;
	output shiftOutLeftCS,shiftOutRightCS,shiftOutCS,shiftOutCLK;
	
	wire [31:0] fromRightData,fromLeftData,fromData,instruction,instructionTo;
	wire fromRightCS,fromLeftCS,fromCS,controllerEn;
	wire [1:0] dataSource,outputSelect;

	receiver_spi_no_sclk shiftInRight(.clk (clk),.cs (shiftInRightCS),.in_sig (shiftInRightData),.processed_sig (fromRightData),.sig_alert (fromRightCS));
	
	receiver_spi_no_sclk shiftInLeft(.clk (clk),.cs (shiftInLeftCS),.in_sig (shiftInLeftData),.processed_sig (fromLeftData),.sig_alert (fromLeftCS));
	
	receiver_spi shiftIn(.clk (clk),.sclk (shiftInCLK),.cs (shiftInCS),.in_sig (shiftInData),.processed_sig (fromData),.sig_alert (fromCS));

	receiver_queue receiverQueue(.clk (clk),.check_l (fromLeftCS),.check_r (fromRightCS),.check_s (fromCS),.in_sig_right (fromRightData),.in_sig_left (fromLeftData),.in_sig_self (fromData),.selected_sig (instruction),.sig_alert (controllerEn),.s (dataSource));
	
	node_controller nodeController(.clk (clk),.source_port (dataSource),.controller_enable (controllerEn),.instruction_in (instruction),.instruction_out (instructionTo),.enable (outputSelect));

	master_spi masterSPI(.clk (clk),.enable (outputSelect),.in_instr(instructionTo),.check_self(shiftOutCS),.check_left(shiftOutleftCS),.check_right(shiftOutRightCS),.out_instr(shiftOutData),.clk_out(shiftOutCLK));
	
endmodule
	
	