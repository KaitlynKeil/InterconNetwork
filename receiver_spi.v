`include "inputconditioner.v"

//The system should work for the inputs below as well as for just clk and cs, we might need two separate modules, one with sclk and one without. We'll also need the control module in both of those two to grab data when cs is driven low
module receiver_spi
#(parameter width = 32) (
	input              clk, // Clock
	input              sclk,
	input              cs,
	input  [width-1:0] in_sig,         // input signal from other nodes
	output [width-1:0] processed_sig,  // output signal
	output             sig_alert       // wrEn for queue register
);

inputconditioner debounce(.clk(clk),
							.noisysignal(in_sig),
							.conditioned(processed_sig),
							.positiveedge(sig_alert),
							.negativeedge(_));

endmodule