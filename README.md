# Multi-Clock Command Processing System



## 1. Project Overview

This project implements a robust, synthesizable digital system designed to execute complex operations based on commands received from a master via a **UART interface**. The architecture is centered around a **System Controller (SYS_CTRL)** that orchestrates data flow between an ALU, a Register File, and communication peripherals operating across **distinct clock domains**.

The design targets functional correctness, power efficiency, and safe clock domain crossing — making it suitable as a foundation for embedded communication-driven processing systems.

---

## 2. System Architecture

The system is organized into two primary clock domains:

- **System Clock Domain** — drives the SYS_CTRL, ALU, and Register File.
- **UART Clock Domain** — derived via a Clock Divider, drives RX/TX peripherals.

Data integrity across domains is maintained through a dedicated **CDC Suite** comprising Asynchronous FIFOs, Data Synchronizers, and Reset Synchronizers.



## 2. Key Components

### 2.1 System Controller — `SYS_CTRL`
The central **Finite State Machine** of the design. It receives decoded bytes from the UART RX path, interprets multi-frame command sequences, and drives control signals to the ALU and Register File. It also routes results back through the UART TX path.
<img width="619" height="412" alt="image" src="https://github.com/user-attachments/assets/e2e895d0-5e73-4c27-928d-3663c363e0c4" />

### 2.2 ALU
Supports **14+ operations** across four categories:

| Category   | Operations                                  |
|------------|---------------------------------------------|
| Arithmetic | Add, Subtract, Multiply, Divide             |
| Logic      | AND, OR, XOR, XNOR, NOR, NAND              |
| Comparison | Equal, Not Equal, Greater Than, Less Than   |
| Shift      | Shift Left, Shift Right                     |

The ALU clock is **gated** and only enabled when an ALU operation is actively being processed, minimizing dynamic power consumption.

### 2.3 Register File
An **8 × 16** synchronous storage array used to hold:
- ALU input operands
- System configuration values
- General-purpose intermediate data

### 2.4 UART (RX / TX)
Provides full-duplex serial communication with support for:
- Configurable **parity** (None / Even / Odd)
- Configurable **prescaling** for baud rate generation

### 2.5 Clock Domain Crossing (CDC) Suite
Ensures reliable data transfer between the system and UART clock domains using:
- **Asynchronous FIFOs** — for multi-bit data transfer across domains
- **Data Synchronizers** — 2-flop synchronizers for control signals
- **Reset Synchronizers** — for safe asynchronous reset release

### 2.6 Clock Management
- **Clock Divider** — generates the UART baud clock from the system clock
- **Clock Gating Cell** — enables the ALU clock only during active computation

---

## 3. Command Protocol

The system processes commands through **multi-frame UART sequences**. Each transaction begins with a command byte followed by data frames:

| Command                     | Opcode | Frames | Frame Sequence                          |
|-----------------------------|--------|--------|-----------------------------------------|
| Register Write              | `0xAA` | 3      | `[CMD]` → `[Address]` → `[Data]`       |
| Register Read               | `0xBB` | 2      | `[CMD]` → `[Address]`                  |
| ALU Operation with Operands | `0xCC` | 4      | `[CMD]` → `[A]` → `[B]` → `[ALU_OP]` |
| ALU Operation (No Operands) | `0xDD` | 2      | `[CMD]` → `[ALU_OP]`                   |

> For `0xDD`, operands are sourced directly from the Register File (pre-loaded via `0xAA`), avoiding redundant data transmission.

---

## 4. SystemVerilog Design Constructs

This project intentionally leverages several **SystemVerilog-specific constructs** to improve code quality, readability, and synthesis reliability beyond basic RTL.

---

### 4.1 Packages for Enumerations and Constants

A dedicated **SystemVerilog package** centralizes all shared type definitions and system-wide constants. This eliminates magic numbers, ensures consistency across all modules, and makes the codebase easy to maintain and scale.

```systemverilog
package sys_pkg;



All modules import this package at the top level:

```systemverilog
import sys_pkg::*;
```

---

### 4.2 Enumerations (`enum`) for FSM States and ALU Operations

All FSMs in the design use **named `enum` types** for state encoding. This approach:
- Prevents invalid state assignments at compile time
- Makes waveform debugging significantly clearer — state names appear directly in the simulator instead of raw binary values
- Allows the synthesizer to select optimal encoding (binary, one-hot, or gray)

**SYS_CTRL FSM states:**


**UART RX FSM states:**


**UART TX FSM states:**


**ALU operation encoding:**

---

### 4.3 User-Defined Types with `typedef`

###4.4 Procedural Blocks — `always_ff` and `always_latch`

To produce **unambiguous, tool-friendly RTL**, the design uses the specialized procedural blocks introduced in SystemVerilog rather than the general-purpose `always`.

**`always_ff`** is used for all flip-flop inference. The synthesizer and lint tools verify that the block truly models sequential logic and will flag it as an error if unintended latches are inferred:



**`always_latch`** is used in specific cases where a **level-sensitive latch** is the intentional design choice — for example, within the integrated clock gating (ICG) cell to hold the enable signal stable during the clock high phase:


> Using `always_ff` and `always_latch` instead of plain `always` makes design intent explicit. EDA tools treat any mismatch — such as a latch inferred inside an `always_ff` block — as a hard error, which significantly improves RTL quality and reduces review effort.

---

### 5.5 Functions

SystemVerilog **functions** are used to encapsulate small, reusable combinational logic, keeping the main procedural blocks clean and readable.



---

## 6. Simulation Results

All modules were verified using a SystemVerilog testbench environment with directed and self-checking test cases covering both normal operation and corner cases.
<img width="878" height="314" alt="image" src="https://github.com/user-attachments/assets/395def24-d494-401b-a335-c9914f2736ac" />
<img width="887" height="417" alt="image" src="https://github.com/user-attachments/assets/f232a914-ee8e-4bd7-98fa-b6a36206eb12" />
<img width="881" height="414" alt="image" src="https://github.com/user-attachments/assets/08276b53-e3cf-4e7f-89fc-1e696c99a9ee" />
<img width="844" height="411" alt="image" src="https://github.com/user-attachments/assets/ae3c9696-2746-4587-85c6-7b8628b89b92" />
<img width="876" height="370" alt="image" src="https://github.com/user-attachments/assets/d0fa96ed-6d61-417d-93f9-3ccd4d64e750" />

<img width="590" height="61" alt="image" src="https://github.com/user-attachments/assets/11baea73-bbad-401a-971c-62db92c5830c" />


<img width="1344" height="585" alt="image" src="https://github.com/user-attachments/assets/1196c22d-58ba-45b5-bf56-eb84a579dd1e" />

### 6.1 Verified Test Scenarios

| Test Scenario                              | Result  |
|--------------------------------------------|---------|
| Register Write (`0xAA`) — 3-frame flow     | ✅ Pass |
| Register Read (`0xBB`) — 2-frame flow      | ✅ Pass |
| ALU with Operands (`0xCC`) — Add           | ✅ Pass |
| ALU with Operands (`0xCC`) — Multiply      | ✅ Pass |
| ALU with Operands (`0xCC`) — Shift Left    | ✅ Pass |
| ALU with Operands (`0xCC`) — Comparison    | ✅ Pass |
| ALU No Operands (`0xDD`) from RegFile      | ✅ Pass |
| UART even/odd parity error detection       | ✅ Pass |
| Clock domain crossing (FIFO full/empty)    | ✅ Pass |
| Async reset release via Reset Synchronizer | ✅ Pass |
| ALU clock gating — enable and disable      | ✅ Pass |
| Back-to-back command sequences             | ✅ Pass |
