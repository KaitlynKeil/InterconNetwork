`include "inputconditioner.v"
`include "SPI_Dependencies/datamemory.v"
`include "SPI_Dependencies/addresslatch.v"

// change so it is only a pulse that lasts for one

module master_spi
#(
	parameter width = 32
)
(
	input clk, new_instr,
	input [1:0] enable,
	input [width-1:0] in_instr,
	output reg check_self, check_left, check_right,
	output reg [width-1:0] self_instr, left_instr, right_instr,
	output clk_out
);

	reg self_assert, left_assert, right_assert;
	reg [31:0] in_instr_d1;

	always @(negedge clk) begin
		if (new_instr === 1'b1) begin
			if (enable == 2'b01) begin
				self_assert <= 1'b1;
				left_assert <= 1'b0;
				right_assert <= 1'b0;
				self_instr <= in_instr;
				left_instr <= 32'bZ;
				right_instr <= 32'bZ;
				check_right <= 1'b0;
				check_left <= 1'b0;
				check_self <= 1'b1;

			end else if (enable == 2'b00) begin
				left_assert <= 1'b1;
				self_assert <= 1'b0;
				right_assert <= 1'b0;

				self_instr <= 32'bZ;
				right_instr <= in_instr;
				left_instr <= 32'bZ;
				check_left <= 1'b0;
				check_right <= 1'b1;
				check_self <= 1'b0;
			end else if (enable == 2'b10) begin
				right_assert <= 1'b1;
				self_assert <= 1'b0;
				left_assert <= 1'b0;
				self_instr <= 32'bZ;
				right_instr <= 32'bZ;
				left_instr <= in_instr;
				check_left <= 1'b1;
				check_right <= 1'b0;
				check_self <= 1'b0;
			end
		end
		else begin
			self_instr <= 32'bZ;
			left_instr <= 32'bZ;
			right_instr <= 32'bZ;
			check_right <= 1'b0;
			check_left <= 1'b0;
			check_self <= 1'b0;
		end
		// in_instr_d1 <= in_instr;
	end

	// self in (clk, self_assert, in_instr_d1, check_self, self_instr);
	// sender left (clk, left_assert, in_instr_d1, check_right, right_instr);
	// sender right (clk, right_assert, in_instr_d1, check_left, left_instr);

endmodule

// module self
// #(
// 	parameter width = 32,
// 	parameter [7:0] address = 8'b0,
// 	parameter addr_width = 8
// )
// (
// 	input clk,
// 	input assert,
// 	input [width-1: 0] in_instr,
// 	// input [addr_width-1: 0] address,
// 	output check,
// 	output [width-1: 0] out_instr
// );

// 	wire [addr_width-1:0] addressOut;

// 	assign check = assert;

// 	addresslatch addr(.addressIn(address),
// 		.writeEnable(assert),
// 		.clk(clk),
// 		.addressOut(addressOut));

// 	datamemory dm(.clk(clk),
// 		.dataOut(out_instr),
// 		.address(addressOut),
// 		.writeEnable(assert),
// 		.dataIn(in_instr));


// endmodule

// module sender
// #(
// 	parameter width = 32,
// 	parameter [7:0] address = 8'b0,
// 	parameter addr_width = 8
// )
// (
// 	input clk,
// 	input assert,
// 	input [width-1: 0] in_instr,
// 	// input [addr_width-1: 0] address,
// 	output check,
// 	output reg [width-1: 0] out_instr
// );

// 	assign check = assert;
// 	always @(negedge clk) begin
// 		if (assert == 1) begin
// 			out_instr <= in_instr;
// 		end
// 	end


// endmodule