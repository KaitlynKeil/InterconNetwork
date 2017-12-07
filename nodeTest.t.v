`include "oneDimensionalNode.v"

module nodeTest();

	reg clk;

	reg [31:0] left_sig,right_sig,self_sig;
	reg check_l,check_r,check_s;
	wire [31:0] shiftOutLeftData,shiftOutRightData,shiftOutData;
	wire shiftOutLeftCS,shiftOutRightCS,shiftOutCS;
	wire [1:0] dataSource,outputSelect;
	wire controllerEn;
	wire [31:0] instruction;
	wire [31:0] instructionTo;
	wire controller_enable_out;

	oneDimensionalNode dut(.shiftInLeftData(left_sig),
							.shiftInLeftCS(check_l),
							.shiftInRightData(right_sig),
							.shiftInRightCS(check_r),
							.shiftInData(self_sig),
							.shiftInCS(check_s),
							.shiftInCLK(clk),
							.shiftOutLeftCS(shiftOutLeftCS),
							.shiftOutRightCS(shiftOutRightCS),
							.shiftOutCS(shiftOutCS),
							.shiftOutData(shiftOutData),
							.shiftOutLeftData(shiftOutLeftData),
							.shiftOutRightData(shiftOutRightData),
							.shiftOutCLK(_),
							.dataSource(dataSource),
							.outputSelect(outputSelect),
							.controllerEn(controllerEn),
							.instruction(instruction),
							.instructionTo(instructionTo),
							.controller_enable_out(controller_enable_out));

 //    task checkTestCase;
	//   	input sig_alert, exp_alert;
	//   	input [1:0]  source, exp_source;
	//   	input [31:0] out_sig, exp_out;
	// 	begin
	// 		if ((sig_alert != exp_alert) || (out_sig != exp_out) || (source != exp_source)) begin
	// 			$display("Failed   |             Expected             |              Actual             ");
	// 			$display("Alert    |                 %b                |                 %b               ",exp_alert, sig_alert);
	// 			$display("Source   |                %b                |                %b               ",exp_source, source); 
	// 			$display("Signal   | %b | %b ",exp_out, out_sig);
	// 		end
	// 	end
	// endtask

	 // Generate clock (50MHz)
    initial begin 
    clk=0;
    end
    always #10 clk=!clk;    // 50MHz Clock


    initial begin
	    $dumpfile("node_test.vcd");
	    $dumpvars(); #10
    	right_sig <= 32'd11000100000000000000000000000000; check_r <= 1'b1; #20
    	check_r <= 1'b0;  #200
    	left_sig <=  32'd73; self_sig <= 32'd11000100000000000000000000000000;  check_l <= 1'b1; check_s <= 1'b1; #20
    	check_l <= 1'b0; check_s <= 1'b0; #200
    	right_sig <= 32'b00000100000000000000000000000000; check_r <= 1'b1; #20
    	check_r <= 1'b0; #50
    	self_sig <= 32'b10000000000000000000000000000000; check_s <= 1'b1; #20
    	check_s <= 1'b0; #200
    	self_sig <= 32'b01000000000000000000000000000000; check_l <= 1'b1; #20
    	check_l <=1'b0; #50
    	left_sig <= 32'b10000000000000000000000000000000; check_l <= 1'b1; 
    	$finish;
    end

endmodule