`include "oneDimensionalNode.v"

module multi_node_test ();
	// Test containing 5 nodes
	// NOTE: These are the only important inputs/outputs. I think it should be enough to include only them? Not sure why oneDimensionalNode has all the rest as outputs
	oneDimensionalNode #(.NODE_IP (3'b000),.MIDPOINT_NODE(3'b010)) node000(.shiftInCLK(clk),
																		.shiftInLeftData(oneToZeroData), .shiftInRightData(fourToZeroData), .shiftInData(zeroInData),
																		.shiftInLeftCS(oneToZeroCS), .shiftInRightCS(fourToZeroCS), .shiftInCs(zeroInCS),
																		.shiftOutLeftData(zeroToFourData), .shiftOutRightData(zeroToOneData), .shiftOutData(zeroOutData),
																		.shiftOutLeftCS(zeroToFourCS), .shiftOutRightCS(zeroToOneCS), .shiftOutCS(zeroOutCS));
	oneDimensionalNode #(.NODE_IP (3'b001),.MIDPOINT_NODE(3'b010)) node001(.shiftInCLK(clk),
																		.shiftInLeftData(twoToOneData), .shiftInRightData(zeroToOneData), .shiftInData(oneInData),
																		.shiftInLeftCS(twoToOneCS), .shiftInRightCS(zeroToOneCS), .shiftInCs(oneInCS),
																		.shiftOutLeftData(oneToZeroData), .shiftOutRightData(oneToTwoData), .shiftOutData(oneOutData),
																		.shiftOutLeftCS(oneToZeroCS), .shiftOutRightCS(oneToTwoCS), .shiftOutCS(oneOutCS));
	oneDimensionalNode #(.NODE_IP (3'b010),.MIDPOINT_NODE(3'b010)) node010(.shiftInCLK(clk),
																		.shiftInLeftData(threeToTwoData), .shiftInRightData(oneToTwoData), .shiftInData(twoInData),
																		.shiftInLeftCS(threeToTwoCS), .shiftInRightCS(oneToTwoCS), .shiftInCs(twoInCS),
																		.shiftOutLeftData(twoToOneData), .shiftOutRightData(twoToThreeData), .shiftOutData(twoOutData),
																		.shiftOutLeftCS(twoToOneCS), .shiftOutRightCS(twoToThreeCS), .shiftOutCS(twoOutCS));
	oneDimensionalNode #(.NODE_IP (3'b011),.MIDPOINT_NODE(3'b010)) node011(.shiftInCLK(clk),
																		.shiftInLeftData(fourToThreeData), .shiftInRightData(), .shiftInData(),
																		.shiftInLeftCS(), .shiftInRightCS(), .shiftInCs(),
																		.shiftOutLeftData(), .shiftOutRightData(), .shiftOutData(),
																		.shiftOutLeftCS(), .shiftOutRightCS(), .shiftOutCS());
	oneDimensionalNode #(.NODE_IP (3'b100),.MIDPOINT_NODE(3'b010)) node100(.shiftInCLK,
																		.shiftInLeftData(), .shiftInRightData(), .shiftInData(),
																		.shiftInLeftCS(), .shiftInRightCS(), .shiftInCs(),
																		.shiftOutLeftData(), .shiftOutRightData(), .shiftOutData(),
																		.shiftOutLeftCS(), .shiftOutRightCS(), .shiftOutCS());

endmodule