# InterconNetwork

### Bryan Werth, Prava Dhulipalla, Kaitlyn Keil

## Description

We will be looking into implementing a low-level network and optimizing the various performance metrics. We will combine simulation (based on BookSim or our own version) with implementation on the FPGA. Once these are done, we can look into different forms of topology and communication regulations to find something that runs efficiently and performs accurately. Our base will be a two-dimensional torus network.

## References

Interconnection Networks: An Engineering Approach by Jose Duato, Sudhakar Yalamanchili, and Lionel Ni

Principles and Practices of Interconnection Networks by William James Dally and Brian Towles

Siddhartan Govindasamy, Professor at Olin College (you might know him)

Benjamin Hill, Professor at Olin (you might not know him; nice guy)

Yao W., Wang D., Zheng W., Guo S. (2005) [Architecture Design of a Single-chip Multiprocessor](https://link.springer.com/content/pdf/10.1007%2F3-540-27912-1_16.pdf). In: Zhang W., Tong W., Chen Z., Glowinski R. (eds) Current Trends in High Performance Computing and Its Applications. Springer, Berlin, Heidelberg

## Deliverables

### Minimum

We will implement a functional, low-level network and analyze performance metrics. As a minimum, we want to have a one-directional ring torus implementation working in simulation.

### Planned

We also want to extend the one-directional ring torus, implementing first a two-directional ring torus working in simulation as well as on FPGA as proof of concept if time allows followed by a two-dimensional torus network.

### Stretch

Our stretch goals will largely surround optimization. We could optimize traffic on the two-dimensional torus network by considering more advanced routing algorithms as well as optimization of other factors informing network latency and throughput.

## Work plan

**11/17/17**

Finish preliminary work plan

Have general idea of final project

**11/17-28/17**

Base research around network functionality and implementation

**11/28/17**

Revise and turn in work plan

*Team consultations with Ben*

**12/1/17**

Diagram of intended implementation

Simulation in BookSim

**12/5/17**

*Midpoint check-in*

First-pass implemented 

MVP functional

**12/8/17**

2D torus working

(Attempt to) Load onto hardware

**12/12/17**

*Completed project due*
