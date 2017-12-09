`include "oneDimensionalNode.v"

module multi_node_test ();
	// Test containing 5 nodes
	// NOTE: These are the only important inputs/outputs. I think it should be enough to include only them? Not sure why oneDimensionalNode has all the rest as outputs
	reg clk;
	// Outputs of node Zero
	wire zeroToFourCS, zeroToOneCS, zeroOutCS;
	wire [31:0] zeroToFourData, zeroToOneData, zeroOutData;
	// Outputs of node One
	wire oneToZeroCS, oneToTwoCS, oneOutCS;
	wire [31:0] oneToZeroData, oneToTwoData, oneOutData;
	// Outputs of node Two
	wire twoToOneCS, twoToThreeCS, twoOutCS;
	wire [31:0] twoToOneData, twoToThreeData, twoOutData;
	// Outputs of node Three
	wire threeToTwoCS, threeToFourCS, threeOutCS;
	wire [31:0] threeToTwoData, threeToFourData, threeOutData;
	// Outputs of node Three
	wire fourToThreeCS, fourToZeroCS, fourOutCS;
	wire [31:0] fourToThreeData, fourToZeroData, fourOutData;
	// Inputs
	reg zeroInCS, oneInCS, twoInCS, threeInCS, fourInCS;
	reg [31:0] zeroInData, oneInData, twoInData, threeInData, fourInData;
	

	oneDimensionalNode #(.NODE_IP (3'b000),.MIDPOINT_NODE(3'b010)) node000(.shiftInCLK(clk),
																		.shiftInLeftData(fourToZeroData), .shiftInRightData(oneToZeroData), .shiftInData(zeroInData),
																		.shiftInLeftCS(fourToZeroCS), .shiftInRightCS(oneToZeroCS), .shiftInCS(zeroInCS),
																		.shiftOutLeftData(zeroToFourData), .shiftOutRightData(zeroToOneData), .shiftOutData(zeroOutData),
																		.shiftOutLeftCS(zeroToFourCS), .shiftOutRightCS(zeroToOneCS), .shiftOutCS(zeroOutCS));
	oneDimensionalNode #(.NODE_IP (3'b001),.MIDPOINT_NODE(3'b010)) node001(.shiftInCLK(clk),
																		.shiftInLeftData(zeroToOneData), .shiftInRightData(twoToOneData), .shiftInData(oneInData),
																		.shiftInLeftCS(zeroToOneCS), .shiftInRightCS(twoToOneCS), .shiftInCS(oneInCS),
																		.shiftOutLeftData(oneToZeroData), .shiftOutRightData(oneToTwoData), .shiftOutData(oneOutData),
																		.shiftOutLeftCS(oneToZeroCS), .shiftOutRightCS(oneToTwoCS), .shiftOutCS(oneOutCS));
	oneDimensionalNode #(.NODE_IP (3'b010),.MIDPOINT_NODE(3'b010)) node010(.shiftInCLK(clk),
																		.shiftInLeftData(oneToTwoData), .shiftInRightData(threeToTwoData), .shiftInData(twoInData),
																		.shiftInLeftCS(oneToTwoCS), .shiftInRightCS(threeToTwoCS), .shiftInCS(twoInCS),
																		.shiftOutLeftData(twoToOneData), .shiftOutRightData(twoToThreeData), .shiftOutData(twoOutData),
																		.shiftOutLeftCS(twoToOneCS), .shiftOutRightCS(twoToThreeCS), .shiftOutCS(twoOutCS));
	oneDimensionalNode #(.NODE_IP (3'b011),.MIDPOINT_NODE(3'b010)) node011(.shiftInCLK(clk),
																		.shiftInLeftData(twoToThreeData), .shiftInRightData(fourToThreeData), .shiftInData(threeInData),
																		.shiftInLeftCS(twoToThreeCS), .shiftInRightCS(fourToThreeCS), .shiftInCS(threeInCS),
																		.shiftOutLeftData(threeToTwoData), .shiftOutRightData(threeToFourData), .shiftOutData(threeOutData),
																		.shiftOutLeftCS(threeToTwoCS), .shiftOutRightCS(threeToFourCS), .shiftOutCS(threeOutCS));
	oneDimensionalNode #(.NODE_IP (3'b100),.MIDPOINT_NODE(3'b010)) node100(.shiftInCLK(clk),
																		.shiftInLeftData(threeToFourData), .shiftInRightData(zeroToFourData), .shiftInData(fourInData),
																		.shiftInLeftCS(threeToFourCS), .shiftInRightCS(zeroToFourCS), .shiftInCS(fourInCS),
																		.shiftOutLeftData(fourToThreeData), .shiftOutRightData(fourToZeroData), .shiftOutData(fourOutData),
																		.shiftOutLeftCS(fourToThreeCS), .shiftOutRightCS(fourToZeroCS), .shiftOutCS(fourOutCS));

	// Generate clock (50MHz)
    initial begin 
    clk=0;
    end
    always #10 clk=!clk;    // 50MHz Clock

    initial begin
    	$dumpfile("multi_node_test.vcd");
	    $dumpvars(); #10

	    fourInData = 32'b00010000100100100100100100100100; fourInCS = 1'b1; #20 // Message from four to zero
	    fourInCS = 1'b0;

	    threeInData = 32'b00110000100100100100100100100100; threeInCS = 1'b1; #20 // Message from three to one
	    threeInCS = 1'b0;

	    threeInData = 32'b00010000100100100100100100100100; threeInCS = 1'b1; twoInData = 32'b10010000100100100100100100100100; twoInCS = 1'b1; #20 // Message from three to zero, message from two to 4
	    threeInCS = 1'b0; twoInCS = 1'b0;

	    #1000
	    $finish;
    end

endmodule