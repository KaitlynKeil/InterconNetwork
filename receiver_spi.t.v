`include "receiver_spi.v"

module receiver_spi_test();

	reg clk, new_sig = 0;
	reg [31:0] in_sig;

	wire sig_alert;
	wire [31:0] out_sig;


	receiver_spi dut(
			.clk(clk),
			.new_sig(new_sig),
			.in_sig(in_sig),
			.processed_sig(out_sig),
			.sig_alert(sig_alert)
		);

	// Generate clock (50MHz)
    initial begin 
    clk=0;
    end
    always #10 clk=!clk;    // 50MHz Clock

	task checkTestCase;
	  	input sig_alert, exp_alert;
	  	input [31:0] out_sig, exp_out;
		 begin
			if ((sig_alert != exp_alert) || (out_sig != exp_out)) begin
				$display("Test Case Failed: expected alert %b, received %b; expected signal %b, received %b",exp_alert, sig_alert, exp_out, out_sig);
			end
		 end
	 endtask

	initial begin
	    $dumpfile("receiver_test.vcd");
	    $dumpvars(); #10

        in_sig <= 31'd50000; new_sig <= 1'b1; #80
        checkTestCase(sig_alert, 1'b1,out_sig, 32'd50000); #20

        new_sig <= 1'b0; #80
        checkTestCase(sig_alert, 0'b0, out_sig, 32'd50000);

        in_sig <= 31'd32; new_sig <= 1'b1; #140
        checkTestCase(sig_alert, 1'b1,out_sig, 32'd32); #20

        new_sig <= 1'b0; #80
        checkTestCase(sig_alert, 0'b0, out_sig, 32'd32);

        #100
        $finish;

	end
endmodule // receiver_spi