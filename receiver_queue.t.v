`include "receiver_queue.v"

module queue_test();
	reg         clk;
	reg  [31:0] right_sig, left_sig, self_sig;
	wire [31:0] sig_to_process;
	wire        sig_alert;
	wire [1:0]  source;

	receiver_queue dut(.clk(clk),
						.in_sig_right(right_sig),
						.in_sig_left(left_sig),
						.in_sig_self(self_sig),
						.selected_sig(sig_to_process),
						.sig_alert(sig_alert),
						.s(source));

    task checkTestCase;
	  	input sig_alert, exp_alert;
	  	input [1:0]  source, exp_source;
	  	input [31:0] out_sig, exp_out;
		begin
			if ((sig_alert != exp_alert) || (out_sig != exp_out) || (source != exp_source)) begin
				$display("Failed   |             Expected             |              Actual             ");
				$display("Alert    |                 %b                |                 %b               ",exp_alert, sig_alert);
				$display("Source   |                %b                |                %b               ",exp_source, source); 
				$display("Signal   | %b | %b ",exp_out, out_sig);
			end
		end
	endtask

	 // Generate clock (50MHz)
    initial begin 
    clk=0;
    end
    always #10 clk=!clk;    // 50MHz Clock

    initial begin
	    $dumpfile("queue_test.vcd");
	    $dumpvars(); #10
    	right_sig <= 32'd42; #200
    	left_sig <=  32'd73; self_sig <= 32'd89; #200
    	right_sig <= 32'b1; #50
    	right_sig <= 32'd2; #200
    	right_sig <= 32'd500; left_sig <= 32'd800; self_sig <= 32'd4; #500

    	$finish;
    end

endmodule