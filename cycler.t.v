`include "cycler.v"

module cycler_test();
	reg clk;
	wire s0,s1;

	cycler dut(.clk(clk), .s({s0,s1}));

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
