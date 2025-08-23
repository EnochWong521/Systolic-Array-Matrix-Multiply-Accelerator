# Systolic Array Matrix-Multiply Accelerator

## Overview
This project implements a **systolic array matrix-multiply accelerator** in **SystemVerilog**, demonstrating how pipelined processing elements (PEs) can efficiently perform high-throughput matrix multiplication.  
The design showcases concepts in **RTL design**, **datapath pipelining**, and **parallel computing architectures** often used in modern GPUs and AI accelerators.

## Architecture
- **Systolic Array:** 2D grid of Processing Elements (PEs) passing data rhythmically through the array.  
- **Processing Element (PE):**
  - Performs multiply-and-accumulate (MAC).
  - Forwards intermediate values to neighboring PEs.  
- **Pipeline:** Ensures continuous flow of operands and partial sums.  
- **Parameterizable:** Array dimensions and data width can be configured.

