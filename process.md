# Process

**Original workplan can be found [here](https://github.com/KaitlynKeil/InterconNetwork/blob/master/project_proposal.md).**

This project was introduced right before Thanksgiving Break, so we took the opportunity in order to perform preliminary research into interconnection networks, specifically into a torus network. We had decided to initially try to create a torus network because of it’s fairly straightforward topology/implementation and its opportunity to expand (e.g. from a 1D torus to a 2D torus).

After this, our proposal was due. We decided to make our MVP simulating a 5-ary 1-cube torus network through Verilog. As for possible extensions, it would be to simulating a 8-ary 2-cube torus network through Verilog, uploading onto the FPGA, and possibly writing our own ‘booksim-like’ simulator to automate the process of generate performance even further then what Verilog can immediately provide us. However, we decided not to have these as concrete deliverables, but merely stretch goals, in order to scope our project more effectively.

In order to fill in the gap we may have missed from uploading onto the FPGA, we decided to merely do additional research into the topic of interconnection networks.

Originally we were planning on also using Booksim, the network simulator, but due to difficulties and the short timescale on which we were operated, we decided to pivot to Verilog-only. We were fine with not trying to simulate a network through Booksim because we felt that learning how to code a network directly might actually teach us a lot of things about the process.

We managed to finish our original 1-D node after much debugging. This part of the process was a bit frustrating, because we felt we should be able to move much further than we had, but we kept on running in small debugging steps at random intervals, which ate up our time. We started on a 2D torus network but found that due to the increase in wires, it was very hard to debug. It also wasn’t a part of the MVP deliverable we said we were going to give, and it didn’t actually end up teaching us more about torus networks.

Throughout the process of creating the torus network, we were also supplementing our own understanding of torus networks and interconnection networks by reading up on them further.
