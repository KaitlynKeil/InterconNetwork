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
	
	receiver_queue receiverQueue(.clk (clk),.check_l (shiftInLeftCS),.check_r (shiftInRightCS),.check_s (shiftInCS),.in_sig_right (shiftInRightData),.in_sig_left (shiftInLeftData),.in_sig_self (shiftInData),.selected_sig (instruction),.sig_alert (controllerEn),.s (dataSource));
	
	node_controller nodeController(.clk (clk),.source_port (dataSource),.controller_enable (controllerEn),.instruction_in (instruction),.instruction_out (instructionTo),.enable (outputSelect));

	master_spi masterSPI(.clk (clk),.enable (outputSelect),.in_instr(instructionTo),.check_self(shiftOutCS),.check_left(shiftOutleftCS),.check_right(shiftOutRightCS),.out_instr(shiftOutData),.clk_out(shiftOutCLK));
	
endmodule
	
	