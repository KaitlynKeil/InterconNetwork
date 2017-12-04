`include "inputconditioner.v"
`include "SPI_Dependencies/datamemory.v"
`include "SPI_Dependencies/addresslatch.v"

module master_spimemory
#(
	parameter width = 32,
	parameter addr_width = 8
)
(
	input clk,
	input assert,
	input [width-1: 0] in_instr,
	input [addr_width-1: 0] address,
	output check,
	output [width-1: 0] out_instr
);

	wire [width -1: 0] conditioned;
	wire [addr_width-1:0] addressOut;

	inputconditioner debounce(.clk(clk),
								.noisysignal(in_instr),
								.conditioned(conditioned),
								.positiveedge(_),
								.negativeedge(_));

	addresslatch addr(.addressIn(address),
		.writeEnable(assert),
		.clk(clk),
		.addressOut(addressOut));

	datamemory dm(.clk(clk),
		.dataOut(out_instr),
		.address(addressOut),
		.writeEnable(assert),
		.dataIn(conditioned));

	assign check = assert;


endmodule