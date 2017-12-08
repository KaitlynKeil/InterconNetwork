`include "oneDimensionalNode.v"

module multi_node_test ();
	// Test containing 5 nodes
	// NOTE: These are the only important inputs/outputs. I think it should be enough to include only them? Not sure why oneDimensionalNode has all the rest as outputs
	oneDimensionalNode #(.NODE_IP (3'b000),.MIDPOINT_NODE(3'b010)) node000(.shiftInCLK,
																		.shiftInLeftData(), .shiftInRightData(), .shiftInData(),
																		.shiftInLeftCS(), .shiftInRightCS(), .shiftInCs(),
																		.shiftOutLeftData(), .shiftOutRightData(), .shiftOutData(),
																		.shiftOutLeftCS(), .shiftOutRightCS(), .shiftOutCS());
	oneDimensionalNode #(.NODE_IP (3'b001),.MIDPOINT_NODE(3'b010)) node001(.shiftInCLK,
																		.shiftInLeftData(), .shiftInRightData(), .shiftInData(),
																		.shiftInLeftCS(), .shiftInRightCS(), .shiftInCs(),
																		.shiftOutLeftData(), .shiftOutRightData(), .shiftOutData(),
																		.shiftOutLeftCS(), .shiftOutRightCS(), .shiftOutCS());
	oneDimensionalNode #(.NODE_IP (3'b010),.MIDPOINT_NODE(3'b010)) node010(.shiftInCLK,
																		.shiftInLeftData(), .shiftInRightData(), .shiftInData(),
																		.shiftInLeftCS(), .shiftInRightCS(), .shiftInCs(),
																		.shiftOutLeftData(), .shiftOutRightData(), .shiftOutData(),
																		.shiftOutLeftCS(), .shiftOutRightCS(), .shiftOutCS());
	oneDimensionalNode #(.NODE_IP (3'b011),.MIDPOINT_NODE(3'b010)) node011(.shiftInCLK,
																		.shiftInLeftData(), .shiftInRightData(), .shiftInData(),
																		.shiftInLeftCS(), .shiftInRightCS(), .shiftInCs(),
																		.shiftOutLeftData(), .shiftOutRightData(), .shiftOutData(),
																		.shiftOutLeftCS(), .shiftOutRightCS(), .shiftOutCS());
	oneDimensionalNode #(.NODE_IP (3'b100),.MIDPOINT_NODE(3'b010)) node100(.shiftInCLK,
																		.shiftInLeftData(), .shiftInRightData(), .shiftInData(),
																		.shiftInLeftCS(), .shiftInRightCS(), .shiftInCs(),
																		.shiftOutLeftData(), .shiftOutRightData(), .shiftOutData(),
																		.shiftOutLeftCS(), .shiftOutRightCS(), .shiftOutCS());

endmodule