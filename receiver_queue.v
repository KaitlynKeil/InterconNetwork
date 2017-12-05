`include "inputconditioner.v"

module receiver_queue
#(parameter width = 32) (
	input                  clk,                       // Clock
	input                  check_l, check_r, check_s, // signal to tell the system that that input is important
	input      [width-1:0] in_sig_right,              // input signal from the right
	input      [width-1:0] in_sig_left,               // input signal from the left
	input      [width-1:0] in_sig_self,               // input signal from outside network
	output reg [width-1:0] selected_sig,              // output signal
	output reg             sig_alert,                 // wrEn for controller
	output reg [1:0]       s                          // select signals for controller
	
);

wire [width-1:0] processed_sig_self; // Input from outside the network must be filtered through an IC
wire sa_s; // Shows a change in the signal from outside the system
reg  new_l, new_r, new_s; // Lets the system know that there is an instruction to read


inputconditioner spi_self(.clk(clk),                      // makes sure the outside signal is not random noise
						.noisysignal(in_sig_self),
						.conditioned(processed_sig_self),
						.positiveedge(sa_s),
						.negativeedge(_));

	always @(posedge clk) begin
		// When the clock goes, check to see if there are any new messages that aren't x's
		// Order of importance: left, right, messages from self
		if (new_l==1'b1 && in_sig_left !== 32'bx) begin
			// These come directly through the wire without processing
			selected_sig <= in_sig_left;
			new_l <= 1'b0; // Message has been read
			sig_alert <= 1'b1; // Tell the next step there is something waiting
			s <= 2'b00; // Set source to 00 (left)
		end
		else if (new_r==1'b1 && in_sig_right !== 32'bx) begin
			// Same as for left...
			selected_sig <= in_sig_right;
			new_r <= 1'b0;
			sig_alert <= 1'b1;
			s <= 2'b10; // But source is 10 (right)
		end
		else if (new_s==1'b1 && processed_sig_self !== 32'bx) begin
			// This time we look at the processed signal
			selected_sig <= processed_sig_self;
			new_s <= 1'b0;
			sig_alert <= 1'b1;
			s <= 2'b01; // Source is 01 (self)
		end
		else begin
			// If there is no new signal to look at, set the alert LOW and
			//  send high impedence
			selected_sig <= 32'bZ;
			sig_alert <= 1'b0;
			s <= 2'bZ;
		end
	end

	// If there is a new value waiting (as given by check_w/e), set the notification HIGH
	//  This allows for reading the same instruction twice
	always @(posedge check_l) begin
		new_l <= 1'b1;
	end
	always @(posedge check_r) begin 
		new_r <= 1'b1; 
	end
	always @(posedge sa_s) begin
		// Same instruction cannot come twice from outside.
		//  TO DO: fix this?
		new_s <= 1'b1;
	end

endmodule