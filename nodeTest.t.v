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
							.instructionTo(instructionTo));

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
    	right_sig <= 32'd42; check_r <= 1'b1; #20
    	check_r <= 1'b0;  #200
    	left_sig <=  32'd73; self_sig <= 32'd89;  check_l <= 1'b1; check_s <= 1'b1; #20
    	check_l <= 1'b0; check_s <= 1'b0; #200
    	right_sig <= 32'b1; check_r <= 1'b1; #20
    	check_r <= 1'b0; #50
    	right_sig <= 32'd2; check_r <= 1'b1; #20
    	check_r <= 1'b0; #200
    	check_l <= 1'b1; #20
    	check_l <=1'b0; #50
    	right_sig <= 32'd500; left_sig <= 32'd800; self_sig <= 32'd4; check_l <= 1'b1; check_r <= 1'b1; check_s <= 1'b1; #20
    	check_l <= 1'b0; check_r <= 1'b0; check_s <= 1'b0; #500

    	$finish;
    end

endmodule