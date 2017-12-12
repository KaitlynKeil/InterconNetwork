# Implementation

From our preliminary research, it seemed like there was multiple methods in order to implement an interconnection network. We took some time to ideate a design for our simple 1D interconnection network in order to simplify the implementation process.
The first thing - what data are we passing in? We decided to make the instruction 32 bits, with the first three bits of the instruction being the IP address of the destination node (for the 1D network). We wanted to be able to pass in the maximum length of data possible, but we knew that, somewhere, we needed to keep track of the address of the destination node. For a 5-node torus network, we would only need three bits for the node - each address would be either 000, 001, 100, 011, or 100 depending on its placement in the network.

From there, we designed the top-level module as follows:

![High level schematic](https://github.com/KaitlynKeil/InterconNetwork/blob/master/inner_workings.jpg)

Our first main block is a receiver queue block, which debounces the input signal and sets a scheme for allowing instructions to pass, based on whether a signal is detected. We start off with an input conditioner which makes sure that the outside signal is not just random noise. Whenever there is a new value waiting (given by the master spi), a notification bit is set high. Based on that notification bit, the queue passes on that instruction. The order of importance is first checking the left instruction, than the right instruction, than messages from the node itself.

The next main block is the controller block. We wanted to have a way to determine whether the signal should be sent to the left node, to the right, or out (to itself). Using input information about the source port, origin node, and destination node of the instruction, the controller sets an enable output that determines the output port for the instruction.

	Enable is 2’b00 → send left
	Enable is 2’b10 → send right
	Enable is 2’b01 → send to self/output from node

The controller also sends the instruction out that was sent into it - this is just to make sure the instruction is saved and passed through the network effectively.

Our last main block is the master SPI block. Initially, we were going to use SPI memories for each of the left, right, and self outputs. However, we realized we didn’t need these, and only needed a small subset of the modules instantiated within the SPI. So we utilized the parts of the SPI that we needed (namely, the data memory and the address latch). Debugging this was complicated, and the only reason it was this complicated was to allow for further expansion. We ended up downsizing to a simpler, behavioral, implementation where, based on the enable signal, the instruction would be passed to itself, to the left node, or to the right node.

Then, from these modules, we created one node, that is passed in an instruction and passed out an instruction. This was the largest part of our debugging - although we had tested the modules separately, together, there was still things that were very incorrect. When we got one node working, we merely strung them together in order to get a 1D torus network. Debugging this was easier - we only found one logic problem with instructions being sent left instead of right when necessary, and that was a simple, focused problem to fixed.

A 2D network was similar but just required additional logic in order to send instructions left, right, up, down, or to itself. Although it is technically more complicated, because we had the basic one done, it was an easy increase in complexity.

Overall, our main crux was the fact that we overcomplicated our system to begin with, making both the receivers and the masters spis, for each node. Even when we scaled down, we still had a lot of structural Verilog, which made it hard to debug. When we moved to a behavioral-only implementation, we found that this was a lot easier to both debug and make it work. We definitely should have worked the other way around - which we were planning on doing. We were planning on moving from SPIs to ALUs to CPUs. However, it turns out this scoping of the project was difficult, and we ended up implementing a simplified version. So although we fulfilled our goal, the end result was less complex than we expected.

![Multi-node Test Output](https://github.com/KaitlynKeil/InterconNetwork/blob/master/multi_node_test_results.JPG)

# Results

Our ring network, tested with results shown above, can take an instruction at any node and will pass it the shortest route (either right or left) to the node with the IP address listed in the first 3 bits of the instruction as seen below. Since the instruction first passes through an input conditioner in case of random noise from outside the system, and then spends at least three time steps within each node it passes through, the best case scenario takes 8 clock cycles for output. For example, if Node 000 received an instruction that was being sent to 000, and no other instruction came through, the instruction would be output after 8 clock cycles. However, a few things can delay an instruction. First, instructions coming from the left take precedence, followed by the right, then anything from the input conditioner. This could delay an input from self indefinitely if there were constant inputs from the other two directions. An instruction can also be erased entirely if, while waiting to be processed, another instruction arrives at that port. These would make it infeasible for any real application. This could be fixed by implementing a stack memory for instructions, where every time a new one arrives, it is added to either the top or bottom, depending on implementation.

![Instruction Bit Breakdown](https://github.com/KaitlynKeil/InterconNetwork/blob/master/instr_pieces.jpg)

# Extensions

There are many ways to move forward from this point of our project. Primarily, we have many ideas on how to move forward with the actual implementation - of course more research/understanding could be done, but we felt that this was an obvious extension.

One of our planned stretch goals was uploading our network onto the FPGA, so that is a possible extension of this project - taking our final 1D torus network and uploading it onto the FPGA and seeing how it works in terms of hardware timing.

Another option is expanding the actual torus network to have more dimensionality. For instance, we could have tried expanding to 5D (although we probably should have started with something more feasible first, like 3D). The performance metrics for this would have been more interesting than for the simple 1D, and also have more of an overlap with the research we had done into the IBM Blue Gene/Q 5-D torus network.

Additionally, one could also expand into different networks, such as mesh or butterfly, in order to further understand their implementation as well, especially in comparison to the torus network. These have certain positive aspects and pitfalls, as does any interconnection network topology, and the topology one chooses is just dependant on which aspects of an interconnection network is most important in that system.

To further a 1D torus network, each of the nodes could have its functionality expanded in order for the network to have more complex processes. For instance, there could be ALUs, CPUs, or GPUs in each of the nodes performing more complex operations on the instructions - instead of just a simple functioning node that recognizes when an instruction belongs to that node and passes it out.

One last possibility in terms of extension is moving from a deterministic routing algorithm (where the path between source and destination is fixed) to an algorithm that has better system performance, such as an adaptive routing algorithm.
