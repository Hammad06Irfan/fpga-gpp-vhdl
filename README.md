# Design of a Simple General-Purpose Processor (GPP)

An FPGA-based 8-bit General-Purpose Processor (GPP) datapath and control unit implemented in VHDL and Altera/Intel Quartus II. The design integrates an asynchronous reset latching system, a Moore Finite State Machine (FSM), a 4-to-16 instruction decoder, interchangeable ALU cores, and 7-segment display encoders to cycle through microcode instructions synchronized to a sequential clock.

---

## System Architecture

The datapath receives two 8-bit inputs (A and B) and sequences operations through an instruction controller driven by student ID sequencing:

                       +-------------------+
                       |    Moore FSM      | (Counts states 0 to 8,
                       |    (fsm9.vhd)     |  outputs 4-bit Student ID)
                       +---------+---------+
                                 |
                                 | current_state[3..0]
                                 v
                       +-------------------+
                       |   4:16 Decoder    |
                       |   (dec4x16.vhd)   |
                       +---------+---------+
                                 |
                                 | OP[15..0] (1-hot microcode)
                                 v
  A[7..0] ---> [ Latch 1 ] ---> A[7..0] \
                                         +--> [ ALU Core ] ---> R1[3..0], R2[3..0], neg
  B[7..0] ---> [ Latch 2 ] ---> B[7..0] /     (Problem 1/2/3)         |
                                                                      v
                                                            [ 7-Segment Decoders ]
                                                            (sseg.vhd / sseghex.vhd)

1. Storage Units: Dual 8-bit clock-synchronized latches/registers (latch.vhd / reg8.vhd) hold operands A and B.
2. Control Unit: A 9-state Moore FSM (fsm9.vhd) acts as an up-counter and student ID sequence generator, feeding a 4:16 decoder (dec4x16.vhd) to produce 16-bit one-hot microcode instruction lines (OP[15..0]).
3. Execution Unit: Modular ALU units (alu_core1.vhd, alucore2.vhd, alu_core3.vhd) execute arithmetic and logic operations selected by the active microcode line.
4. Display Unit: Segment drivers convert 4-bit nibbles and sign flags into active-low 7-segment display control signals.

---

## Project Structure

* Lab6_problem1.bdf - Top-level schematic connecting latches, FSM, decoder, ALU core, and 7-segment displays.
* latch.vhd / reg8.vhd - 8-bit input latches with active-low asynchronous reset.
* fsm9.vhd - 9-state Moore state machine cycling through states s0 to s8, emitting state tracking bits and target student ID digits (501317384).
* dec4x16.vhd - 4-to-16 active-high decoder constructed from hierarchical sub-decoders and basic logic gates.
* alu_core1.vhd - Problem 1 ALU core (standard arithmetic/bitwise set).
* alucore2.vhd - Problem 2 ALU core (extended bit manipulation, shift, rotate, and conditional sets).
* alu_core3.vhd - Problem 3 ALU core (pattern-match unit outputting boolean 'y' or 'n' on match with Student ID).
* sseg.vhd / sseghex.vhd - 7-segment decoders for upper/lower hexadecimal nibbles and negative sign indicators.
* Waveform*.vwf - Vector waveform testbenches for functional and timing simulation.

---

## Component Specifications

### 1. Control Unit (FSM & Decoder)

The Moore FSM transitions across 9 states on the rising clock edge when data_in = '1'. The 4-bit state index feeds the 4:16 decoder to generate one-hot microcode:

| State | Microcode Line (OP) | FSM Student ID Output |
| :--- | :--- | :--- |
| s0 (0000) | 0000000000000001 (0x0001) | 5 (0101) |
| s1 (0001) | 0000000000000010 (0x0002) | 0 (0000) |
| s2 (0010) | 0000000000000100 (0x0004) | 1 (0001) |
| s3 (0011) | 0000000000001000 (0x0008) | 3 (0011) |
| s4 (0100) | 0000000000010000 (0x0010) | 1 (0001) |
| s5 (0101) | 0000000000100000 (0x0020) | 7 (0111) |
| s6 (0110) | 0000000001000000 (0x0040) | 3 (0011) |
| s7 (0111) | 0000000010000000 (0x0080) | 8 (1000) |
| s8 (1000) | 0000000100000000 (0x0100) | 4 (0100) |

### 2. ALU Configurations

#### Problem 1 (alu_core1.vhd)
Standard arithmetic and boolean logic operations:
* Op 1 (0x0001): Addition (A + B)
* Op 2 (0x0002): Subtraction (A - B)
* Op 3 (0x0004): Inversion (NOT A)
* Op 4 (0x0008): Bitwise NAND (NOT (A AND B))
* Op 5 (0x0010): Bitwise NOR (NOT (A OR B))
* Op 6 (0x0020): Bitwise AND (A AND B)
* Op 7 (0x0040): Bitwise XOR (A XOR B)
* Op 8 (0x0080): Bitwise OR (A OR B)
* Op 9 (0x0100): Bitwise XNOR (NOT (A XOR B))

#### Problem 2 (alucore2.vhd)
Specialized arithmetic and bit-manipulation operations:
* Op 1 (0x0001): Shift A right by 2 bits with '1' fill ("11" & A(7 downto 2))
* Op 2 (0x0002): Difference offset ((A - B) + 4)
* Op 3 (0x0004): Maximum magnitude (max(A, B))
* Op 4 (0x0008): Nibble swap (Replace A[7..4] with B[3..0])
* Op 5 (0x0010): Increment (A + 1)
* Op 6 (0x0020): Bitwise AND (A AND B)
* Op 7 (0x0040): Upper nibble inversion ((NOT A[7..4]) & A[3..0])
* Op 8 (0x0080): Rotate B left by 3 bits (ROL)
* Op 9 (0x0100): Clear output (0x00)

#### Problem 3 (alu_core3.vhd)
ID Match Evaluator: Checks whether either hexadecimal nibble of operand A (A[7..4] or A[3..0]) matches the current student ID digit output by the FSM. Outputs 0001 ('y') on match and 0000 ('n') otherwise to the 7-segment display driver.

---

## Verification & Test Bench Data

Simulations run with inputs A = 0x73 (0111 0011) and B = 0x84 (1000 0100):

| State | Student ID | Problem 1 Output (Hex) | Problem 2 Output (Hex) | Problem 3 Output (Display) |
| :---: | :---: | :---: | :---: | :---: |
| s0 | 5 | F7 | DC | 0 ('n') |
| s1 | 0 | EF | F3 | 0 ('n') |
| s2 | 1 | 8C | 84 | 0 ('n') |
| s3 | 3 | FF | 43 | 1 ('y') |
| s4 | 1 | 08 | 74 | 0 ('n') |
| s5 | 7 | 00 | 00 | 1 ('y') |
| s6 | 3 | F7 | 83 | 1 ('y') |
| s7 | 8 | F7 | 24 | 0 ('n') |
| s8 | 4 | 08 | 00 | 0 ('n') |

*Note:* Due to the input latches sampling on clock edges, ALU outputs exhibit a 1-clock-cycle pipeline latency relative to the state transitions in waveform analysis.

---

## Compilation & Simulation Setup

1. Open Lab6.qpf in Altera Quartus II (v13.0sp1 or newer).
2. Set the desired top-level entity (Lab6_problem1.bdf) in project settings.
3. Run Full Compilation (Ctrl + L) to perform synthesis, placement, and routing.
4. Run functional simulations using the University Program VWF tool (Waveform.vwf, Waveformalu.vwf, Waveformfsm.vwf) via Processing > Start Simulation.
