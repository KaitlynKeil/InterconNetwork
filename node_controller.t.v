`include "node_controller.v"

module node_controller_test ();

  // Instantiate device/module under test
  reg [1:0] source_port;
  reg [31:0] instruction_in;
  wire [1:0] enable;
  wire [31:0] instruction_out;
  
  node_controller test_node(.source_port (source_port),.instruction_in (instruction_in),.instruction_out(instruction_out),.enable(enable));
  
  task checkTestCase;
  input [1:0] source_port;
  input [31:0] instruction_in;
  input [1:0] expectedEnable;
  begin
	if (enable != expectedEnable) begin
		$display("Test Case Failed: expected %b, received %b : %b %b",expectedEnable,enable,source_port,instruction_in);
	end
  end
  endtask
		

  // Run sequence of test stimuli
  initial begin
    source_port = 2'b10; instruction_in = 32'b11011000000000000000000000000000; #20
    checkTestCase(source_port,instruction_in,2'b10); #20
    source_port = 2'b10; instruction_in = 32'b00011000000000000000000000000000; #20
    checkTestCase(source_port,instruction_in,2'b01); #20
    source_port = 2'b10; instruction_in = 32'b10111000000000000000000000000000; #20
    checkTestCase(source_port,instruction_in,2'b00); #20
    source_port = 2'b10; instruction_in = 32'b11000000000000000000000000000000; #20
    checkTestCase(source_port,instruction_in,2'b01); #20
    source_port = 2'b10; instruction_in = 32'b11010100000000000000000000000000; #20
    checkTestCase(source_port,instruction_in,2'b00); #20
	source_port = 2'b00; instruction_in = 32'b00011000000000000000000000000000; #20
    checkTestCase(source_port,instruction_in,2'b10); #20
    source_port = 2'b00; instruction_in = 32'b11011000000000000000000000000000; #20
    checkTestCase(source_port,instruction_in,2'b00); #20;
  end
endmodule    // End demorgan_test