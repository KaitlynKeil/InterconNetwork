`include "master_spi.v"

module master_spi_test();

	reg clk;
	reg [1:0] enable;
	reg [31:0] in_instr;

	wire check_self, check_left, check_right;
	wire [31:0] out_instr;


	master_spi dut(.clk(clk),
		.enable(enable),
		.in_instr(in_instr),
		.check_self(check_self),
		.check_left(check_left),
		.check_right(check_right),
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
				$display("SPI Test failed!");
				$display("Check was %b and was expected to be %b.", instr_check, exp_check);
				$display("Instr was %b and was expected to be %b.", out_instr, exp_instr);
			end
		end
	endtask

	initial begin
		$dumpfile("master_spi.vcd");
		$dumpvars();

		// enable <=  2'b0; in_instr <= 32'd30000; #100

		// enable <= 2'b1; in_instr <= 32'd50000; #100

		enable <= 2'b10; in_instr <= 32'd10000; #1000

		$finish();
	end


endmodule

