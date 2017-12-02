`include "inputconditioner.v"

module receiver_spi
#(parameter width = 32) (
	input              clk,            // Clock
	input              new_sig,        // Single bit to indicate a new signal
	input  [width-1:0] in_sig,         // input signal from other nodes
	output [width-1:0] processed_sig,  // output signal
	output             sig_alert       // wrEn for queue register
);

wire pos_edge, neg_edge;

inputconditioner debounce(.clk(clk),
							.noisysignal(in_sig),
							.conditioned(processed_sig),
							.positiveedge(sig_alert),
							.negativeedge(neg_edge));

endmodule