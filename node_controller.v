module node_controller (clk, controller_enable_out,source_port,controller_enable,instruction_in,instruction_out,enable,controller_enable_out);
	input clk;
	input [1:0] source_port;
	input controller_enable;
	input [31:0] instruction_in;
	output [31:0] instruction_out;
	output [1:0] enable;
	output controller_enable_out;
	
	parameter NODE_IP = 3'b000;
	parameter MIDPOINT_NODE = 3'b011;
	parameter NODE_IP_BITWIDTH = 3;
	
	reg [1:0] enable;
	reg controller_enable_out;
	wire [2:0] destination_node,originating_node;
	reg [31:0] instruction_out;
	wire [31:0] instruction_in;
	wire controller_enable;
	
	
	assign destination_node = instruction_in[31:31-NODE_IP_BITWIDTH+1];
	assign originating_node = instruction_in[31-NODE_IP_BITWIDTH:31-NODE_IP_BITWIDTH-NODE_IP_BITWIDTH+1];
	
	always @ (posedge clk) begin
		if(controller_enable) begin
			if(source_port == 2'b01) begin
				if (destination_node == NODE_IP) begin
					enable <= 2'b01;
				end else if (NODE_IP > destination_node) begin
					if ((NODE_IP - destination_node) > MIDPOINT_NODE) begin
						enable <= 2'b10;
					end else begin
						enable <= 2'b00;
					end
				end else begin
					if ((destination_node - NODE_IP) > MIDPOINT_NODE) begin
						enable <= 2'b00;
					end else begin
						enable <= 2'b10;
					end
				end
			end else if(source_port == 2'b10) begin
				if (destination_node == NODE_IP) begin
					enable <= 2'b01;
				end else if((destination_node-NODE_IP)>MIDPOINT_NODE) begin
					enable <= 2'b10;
				end else begin
					enable <= 2'b00;
				end
			end else if(source_port == 2'b10 || source_port == 2'b00) begin
				if (destination_node == NODE_IP) begin
					enable <= 2'b01;
				end else begin
					enable <= source_port;
				end
			end
		end
		instruction_out <= instruction_in;
		controller_enable_out <= controller_enable;
	end
endmodule