module node_controller(clk,source_port,controller_enable,instruction_in,instruction_out,enable);
	input clk;
	input [1:0] source_port;
	input controller_enable;
	input [31:0] instruction_in;
	output [31:0] instruction_out;
	output [1:0] enable;
	
	parameter NODE_IP = 3'b000;
	parameter MIDPOINT_NODE = 3'b011;
	parameter NODE_IP_BITWIDTH = 3;
	
	reg [1:0] enable;
	wire [2:0] destination_node,originating_node;
	wire [31:0] instruction_out;
	
	assign destination_node = instruction_in[31:31-NODE_IP_BITWIDTH+1];
	assign originating_node = instruction_in[31-NODE_IP_BITWIDTH:31-NODE_IP_BITWIDTH-NODE_IP_BITWIDTH+1];
	assign instruction_out = instruction_in;
	
	always @ (posedge clk) begin
		if(controller_enable) begin
			if(source_port == 2'b01 && originating_node>destination_node) begin
				if((originating_node-destination_node)>MIDPOINT_NODE) begin
					enable = 2'b10;
				end else begin
					enable = 2'b00;
				end
			end else if(source_port == 2'b10) begin
				if (destination_node == originating_node) begin
					enable = 2'b01;
				end else if((destination_node-originating_node)>MIDPOINT_NODE) begin
					enable = 2'b10;
				end else begin
					enable = 2'b00;
				end
			end else if(source_port == 2'b10 || source_port == 2'b00) begin
				if (destination_node == NODE_IP) begin
					enable = 2'b01;
				end else begin
					enable = source_port;
				end
			end
		end
	end
endmodule