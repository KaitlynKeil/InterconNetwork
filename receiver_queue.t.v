`include "receiver_queue.v"

module queue_test();
	reg         clk;                             // System clock
	reg         check_r = 1'b0, check_l = 1'b0, check_s = 1'b0;       // Signals to tell queue that there is a new instruction
	reg  [31:0] right_sig, left_sig, self_sig;   // Instructions to pass
	wire [31:0] sig_to_process;                  // Output instruction of the queue
	wire        sig_alert;                       // Alert to main system that there is a new instruction
	wire [1:0]  source;                          // Where that new instruction is from

	receiver_queue dut(.clk(clk),
						.check_l(check_l),
						.check_r(check_r),
						.check_s(check_s),
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
    	right_sig <= 32'd42; check_r <= 1'b1; #20
    	check_r <= 1'b0;  #200
    	left_sig <=  32'd73; self_sig <= 32'd89;  check_l <= 1'b1; check_s <= 1'b1; #20
    	check_l <= 1'b0; check_s <= 1'b0; #200
    	right_sig <= 32'b1; check_r <= 1'b1; #20
    	check_r <= 1'b0; #50
    	right_sig <= 32'd2; check_r <= 1'b1; #20
    	check_r <= 1'b0; #200
    	check_l <= 1'b1; #20
    	check_l <=1'b0; #50
    	right_sig <= 32'd500; left_sig <= 32'd800; self_sig <= 32'd4; check_l <= 1'b1; check_r <= 1'b1; check_s <= 1'b1; #20
    	check_l <= 1'b0; check_r <= 1'b0; check_s <= 1'b0; #500

    	$finish;
    end

endmodule