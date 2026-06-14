# Single Cycle RISC-V Processor

A simplified **32-bit Single Cycle RISC-V Processor** implemented in **Verilog** and **SystemVerilog**. This project demonstrates the implementation of components including ALU, Register File, Program Counter, Instruction Memory, Control Unit, Immediate Generator, and Datapath Integration.

## Features

- 32-bit RISC-V processor design
- Single-cycle execution
- Supports R-Type and I-Type instructions
- ALU operations:
  - ADD
  - SUB
  - AND
  - OR
  - XOR
  - SLT
  - SLL
  - SRL
- Register File with 32 registers
- Program Counter (PC)
- Instruction Memory
- Control Unit
- Immediate Generator
- Self-checking Testbench

## Supported Instructions

| Instruction | Operation |
|-------------|------------|
| ADD | Addition |
| SUB | Subtraction |
| ADDI | Add Immediate |
| AND | Bitwise AND |
| OR | Bitwise OR |
| XOR | Bitwise XOR |
| SLT | Set Less Than |
| SLL | Shift Left Logical |
| SRL | Shift Right Logical |

## Project Architecture

The processor consists of the following modules:

- ALU
- Register File
- Program Counter
- Instruction Memory
- Instruction Decoder
- Control Unit
- Immediate Generator
- Datapath Integration

## Folder Structure

```text
single-cycle-risc-v-processor/
│── src/
│   └── ALU.sv
│   └── RegisterFile.v
│   └── ProgramConter.v
│   └── InstructionFetch.v
│   └── InstructionDecoder.v
│   └── ControlUnit.v
│   └── ImmediateGenerator.v
│   └── Datapath.sv
│   └── risc_v_processor.sv
│
│── testbench/
│   └── ALU.sv
│   └── RegisterFile.sv
│   └── ProgramConter.sv
│   └── InstructionFetch.sv
│   └── InstructionDecoder.sv
│   └── ControlUnit.sv
│   └── ImmediateGenerator.sv
│   └── risc_v_processor.sv
│
│── outputs_and_waveforms/
│   ├── output.png
│   └── waveform.png
│
└── README.md
```

## Sample Program Executed

The following instructions are preloaded in instruction memory:

```assembly
addi x1, x0, 5
addi x2, x0, 7
add  x3, x1, x2
sub  x4, x3, x2
```

### Expected Register Output

```text
x1 = 5
x2 = 7
x3 = 12
x4 = 5
```

## Simulation

Simulation can be performed using:

- EDA Playground



## Technologies Used

- Verilog HDL
- SystemVerilog (Testbench)
- EDA Playground


## Author

**Srinihitha Reddy Neela**
