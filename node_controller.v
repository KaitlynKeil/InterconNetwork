module node_controller (clk, controller_enable_out,source_port,controller_enable,instruction_in,instruction_out,enable);
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
	assign originating_node = instruction_in[31-NODE_IP_BITWIDTH:31-NODE_IP_BITWIDTH-NODE_IP_BITWIDTH+1]; // Currently not used
	
	always @ (posedge clk) begin
		if(controller_enable) begin // only run if there is a new instruction to pass
			if(source_port == 2'b01) begin // if self is the source...
				if (destination_node == NODE_IP) begin // if self is the destination, send to output
					enable <= 2'b01;
				end else if (NODE_IP > destination_node) begin // if this node's IP address is greater than the address of the destination...
					if ((NODE_IP - destination_node) > MIDPOINT_NODE) begin // check to see which direction gets it to the other node more quickly.
						enable <= 2'b10; // send right if the distance between is greater than 1/2 the max distance (loop around)
					end else begin
						enable <= 2'b00; // send left if the distance between is less than 1/2 the max distance
					end
				end else begin // otherwise, if the destination is greater than this node's IP address...
					if ((destination_node - NODE_IP) > MIDPOINT_NODE) begin
						enable <= 2'b00; // send left if the distance between is more than 1/2 the max distance
					end else begin
						enable <= 2'b10; // send right if it is less than 1/2 the max distance
					end
				end
			end else if(source_port == 2'b10) begin // if the instruction came from the right...
				if (destination_node == NODE_IP) begin // output if this is the destination
					enable <= 2'b01;
				// end else if((destination_node-NODE_IP)>MIDPOINT_NODE) begin
				// 	enable <= 2'b10;
				end else begin
					enable <= 2'b00; // otherwise, it needs to keep going left
				end
			end else if(source_port == 2'b10 || source_port == 2'b00) begin // Anything else, either output or keep going the way
				if (destination_node == NODE_IP) begin
					enable <= 2'b01;
				end else begin
					enable <= source_port;
				end
			end
		end
		// Let the next node know what's coming
		instruction_out <= instruction_in;
		controller_enable_out <= controller_enable;
	end
endmodule