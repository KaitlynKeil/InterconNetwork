`include "inputconditioner.v"
`include "cycler.v"

module receiver_queue
#(parameter width = 32) (
	input                  clk,            // Clock
	input      [width-1:0] in_sig_right,   // input signal from the right
	input      [width-1:0] in_sig_left,    // input signal from the left
	input      [width-1:0] in_sig_self,    // input signal from outside network
	output reg [width-1:0] selected_sig,   // output signal
	output reg             sig_alert,      // wrEn for controller
	output     [1:0]       s               // select signals for controller
	
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

inputconditioner spi_self(.clk(clk),
						.noisysignal(in_sig_self),
						.conditioned(processed_sig_self),
						.positiveedge(sa_s),
						.negativeedge(_));

cycler selector(.clk(clk), .s(s));

	always @(posedge clk) begin
		if (s===2'b10 && new_r==1'b1 && processed_sig_right !== 32'bx) begin
			selected_sig <= processed_sig_right;
			new_r <= 1'b0;
			sig_alert <= 1'b1;
		end
		else if (s===2'b01 && new_s==1'b1 && processed_sig_left !== 32'bx) begin
			selected_sig <= processed_sig_self;
			new_s <= 1'b0;
			sig_alert <= 1'b1;
		end
		else if (s===2'b00 && new_l==1'b1 && processed_sig_self !== 32'bx) begin
			selected_sig <= processed_sig_left;
			new_l <= 1'b0;
			sig_alert <= 1'b1;
		end
		else begin
			selected_sig <= 32'bZ;
			sig_alert <= 1'b0;
		end
	end
	always @(posedge sa_l) begin
		new_l <= 1'b1;
	end
	always @(posedge sa_s) begin
		new_s <= 1'b1;
	end
	always @(posedge sa_r) begin 
		new_r <= 1'b1; 
	end

endmodule