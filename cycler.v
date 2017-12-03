`include "dff.v"

module cycler_test();
	reg clk;
	wire s0,s1;

	cycler dut(.clk(clk), .s0(s0), .s1(s1));

	initial begin 
    	clk=0;
    end
    always #10 clk=!clk;    // 50MHz Clock

    initial begin
	    $dumpfile("cycler.vcd");
	    $dumpvars();
    	#100
    	$finish;
    end
endmodule


module cycler (
	input           clk,    // Clock
	output[1:0] reg s       // Select bits
	
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