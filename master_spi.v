// MASTER 'SPI' sends out signals. Currently does not save or process them.
//  Future work: the self_spi could become a CPU that performs calculations
//  and otherwise operates on the instructions sent, rather than simply
//  outputting values.


// `include "inputconditioner.v"
// `include "SPI_Dependencies/datamemory.v"
// `include "SPI_Dependencies/addresslatch.v"

// change so it is only a pulse that lasts for one

module master_spi
#(
	parameter width = 32
)
(
	input clk, new_instr,                                        // clk: system clock. new_instr: lets the master_spi know there is something new to look at, otherwise not to act
	input [1:0] enable,                                          // 2 bit signal that lets it know which way it is sending information. 01: send to self; 00: send right; 10: send left
	input [width-1:0] in_instr,                                  // instruction to be sent some direction
	output reg check_self, check_left, check_right,              // single-bit flags to let the other nodes know they have a new value to consider
	output reg [width-1:0] self_instr, left_instr, right_instr  // the 3 directions instructions can go
);

	reg self_assert, left_assert, right_assert; // Currently not used; would act as enables for different CPUs/senders

	always @(negedge clk) begin                 // Operates on negative edge to avoid some strange timing issues
		if (new_instr === 1'b1) begin           // Run only when a new instruction is available
			if (enable == 2'b01) begin
				// In an ideal world, this section would be a CPU
				self_assert <= 1'b1;            // Set asserts (defunct)
				left_assert <= 1'b0;
				right_assert <= 1'b0;
				self_instr <= in_instr;         // Assign the output as the instruction
				left_instr <= 32'bZ;            // Set other instructions to high impedance to avoid noise
				right_instr <= 32'bZ;
				check_right <= 1'b0;            // Set alerts for other nodes
				check_left <= 1'b0;
				check_self <= 1'b1;

			end else if (enable == 2'b00) begin
				// Sends it left
				left_assert <= 1'b1;
				self_assert <= 1'b0;
				right_assert <= 1'b0;
				self_instr <= 32'bZ;
				left_instr <= in_instr;
				right_instr <= 32'bZ;
				check_left <= 1'b1;
				check_right <= 1'b0;
				check_self <= 1'b0;
			end else if (enable == 2'b10) begin
				// Sends it left
				right_assert <= 1'b1;
				self_assert <= 1'b0;
				left_assert <= 1'b0;
				self_instr <= 32'bZ;
				left_instr <= 32'bZ;
				right_instr <= in_instr;
				check_left <= 1'b0;
				check_right <= 1'b1;
				check_self <= 1'b0;
			end
		end
		else begin
			// If not a new instruction, everything is high impedance and no flags are set
			self_instr <= 32'bZ;
			left_instr <= 32'bZ;
			right_instr <= 32'bZ;
			check_right <= 1'b0;
			check_left <= 1'b0;
			check_self <= 1'b0;
		end
	end

	// Relic of trying to use separate modules for what we now are doing behaviorally
	// self in (clk, self_assert, in_instr_d1, check_self, self_instr);
	// sender left (clk, left_assert, in_instr_d1, check_right, right_instr);
	// sender right (clk, right_assert, in_instr_d1, check_left, left_instr);

endmodule

// DEFUNCT MODULES; use in future versions?

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