`include "inputconditioner.v"
`include "SPI_Dependencies/datamemory.v"
`include "SPI_Dependencies/addresslatch.v"


module master_spi
#(
	parameter width = 32
)
(
	input clk,
	input [1:0] enable,
	input [width-1:0] in_instr,
	output check_self, check_left, check_right,
	output [width-1:0] out_instr,
	output clk_out
);

	reg self_assert, left_assert, right_assert;

	always @(posedge clk) begin
		if (enable == 2'b01) begin
			self_assert = 1'b1;
			left_assert = 1'b0;
			right_assert = 1'b0;
		end else if (enable == 2'b00) begin
			left_assert = 1'b1;
			self_assert = 1'b0;
			right_assert = 1'b0;
		end else if (enable == 2'b10) begin
			right_assert = 1'b1;
			self_assert = 1'b0;
			left_assert = 1'b0;
		end
	end

	self in (clk, self_assert, in_instr, check_self, out_instr);
	sender left (clk, left_assert, in_instr, check_right, out_instr);
	sender right (clk, right_assert, in_instr, check_left, out_instr);

endmodule

module self
#(
	parameter width = 32,
	parameter [7:0] address = 8'b0,
	parameter addr_width = 8
)
(
	input clk,
	input assert,
	input [width-1: 0] in_instr,
	// input [addr_width-1: 0] address,
	output check,
	output [width-1: 0] out_instr
);

	wire [addr_width-1:0] addressOut;

	addresslatch addr(.addressIn(address),
		.writeEnable(assert),
		.clk(clk),
		.addressOut(addressOut));

	datamemory dm(.clk(clk),
		.dataOut(out_instr),
		.address(addressOut),
		.writeEnable(assert),
		.dataIn(in_instr));

	assign check = assert;


endmodule

module sender
#(
	parameter width = 32,
	parameter [7:0] address = 8'b0,
	parameter addr_width = 8
)
(
	input clk,
	input assert,
	input [width-1: 0] in_instr,
	// input [addr_width-1: 0] address,
	output check,
	output reg [width-1: 0] out_instr
);

	always @(posedge clk) begin
		if (assert == 1) begin
			out_instr <= in_instr;
		end
	end

	assign check = assert;


endmodule