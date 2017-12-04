`include "master_spi.v"

module master_spi_test();

	reg clk, new_sig;
	reg [31:0] in_instr;
	reg [7:0] address;

	wire check;
	wire [31:0] out_instr;

	master_spimemory dut(.clk(clk),
		.assert(new_sig),
		.in_instr(in_instr),
		.address(address),
		.check(check),
		.out_instr(out_instr));


	initial begin
		clk = 0;
	end
	always #10 clk =! clk;


	task checkTestCase;
		input instr_check, exp_check;
		input [31:0] out_instr, exp_instr;

		begin
			if ((instr_check != exp_check) || (out_instr != exp_instr)) begin
				$display("Test failed!");
				$display("Check was %b and was expected to be %b.", instr_check, exp_check);
				$display("Instr was %b and was expected to be %b.", out_instr, exp_instr);
			end
		end
	endtask

	initial begin
		$dumpfile("master_spi.vcd");
		$dumpvars();

		address <= 8'b0; #100

		new_sig <= 1'b0; in_instr <= 32'd50000; #100
		checkTestCase(check, new_sig, out_instr, 32'bx); #50

		new_sig <= 1'b1; in_instr <= 32'd50000; #100
		checkTestCase(check, new_sig, out_instr, in_instr); #50

		new_sig <= 1'b0; in_instr <= 32'd10000; #100
		checkTestCase(check, new_sig, out_instr, 32'd50000); #50

		new_sig <= 1'b1; in_instr <= 32'd10000; #100
		checkTestCase(check, new_sig, out_instr, in_instr); #50

		$finish();
	end


endmodule

