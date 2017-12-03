`include "dff.v"

module cycler (
	input            clk,    // Clock
	output reg [1:0] s       // Select bits
	
);

always @(posedge clk) begin
	if (s===2'b10) begin
		s <= 2'b01;
	end
	else if (s===2'b01) begin
		s <= 2'b00;
	end
	else begin
		s <= 2'b10;
	end
end

endmodule