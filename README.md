# Asynchronous-Fifo

## Description
This is an implementation of an asynchronous FIFO in verilog. 
1. The full flag is computed by comparing the write pointer (in gray code) with the synchronized read pointer (in gray code) in the write domain. 
2. The empty flag is computed by comparing the read pointer (in gray code) with the synchronized write pointer (in gray code) in the read domain.

## Simulation result
![result](https://github.com/ddacot/Asynchronous-Fifo/blob/main/SimulationOutput.PNG "result")
