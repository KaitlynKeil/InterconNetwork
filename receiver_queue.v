`include "inputconditioner.v"
`include "cycler.v"

module receiver_queue
#(parameter width = 32) (
	input              clk,            // Clock
	input  [width-1:0] in_sig_right,   // input signal from the right
	input  [width-1:0] in_sig_left,    // input signal from the left
	input  [width-1:0] in_sig_self,    // input signal from outside network
	output [width-1:0] selected_sig,   // output signal
	output             sig_alert,      // wrEn for controller
	output             s               // select signals for controller
	
);

wire [width-1:0] processed_sig_left, processed_sig_right, processed_sig_self;
wire sa_l, sa_r, sa_s;
reg  new_l, new_r, new_s;

inputconditioner spi_left(.clk(clk),
						.noisysignal(in_sig_left),
						.conditioned(processed_sig_left),
						.positiveedge(sa_l),
						.negativeedge(_));

inputconditioner spi_right(.clk(clk),
						.noisysignal(in_sig_right),
						.conditioned(processed_sig_right),
						.positiveedge(sa_r),
						.negativeedge(_));

inputconditioner spi_left(.clk(clk),
						.noisysignal(in_sig_self),
						.conditioned(processed_sig_self),
						.positiveedge(sa_s),
						.negativeedge(_));

cycler selector(.clk(clk), .s(s));

always @(posedge clk) begin
	if (s===2'b10 && new_r==1'b1) begin
		selected_sig <= processed_sig_right;
		new_r <= 1'b0;
		sig_alert <= 1'b1;
	end
	else if (s===2'b01 && new_s==1'b1) begin
		selected_sig <= processed_sig_self;
		new_s <= 1'b0;
		sig_alert <= 1'b1;
	end
	else if (s===2'b00 && new_l==1'b1) begin
		selected_sig <= processed_sig_left;
		new_l <= 1'b0;
		sig_alert <= 1'b1;
	end
	else begin
		selected_sig <= 32'bZ;
		sig_alert <= 1'b0;
	end

	always @(posedge sa_l) new_l <= 1'b1;
	always @(posedge sa_s) new_s <= 1'b1;
	always @(posedge sa_r) new_r <= 1'b1;
	
	end
end

endmodule