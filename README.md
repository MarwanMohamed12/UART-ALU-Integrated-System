Project Overview: Multi-Clock Command Processing SystemThis project implements a robust digital system designed to execute complex operations based on commands received from a master via a UART interface. The architecture is centered around a System Controller (SYS_CTRL) that orchestrates data flow between an ALU, a Register File, and communication peripherals across distinct clock domains.+3### Key ComponentsSystem Controller (SYS_CTRL): The central FSM that decodes UART commands and manages the execution of ALU and Register File operations.+1ALU: Supports 14+ operations including arithmetic (Add, Sub, Mult, Div), logic (AND, OR, XOR, etc.), comparisons, and shifts.Register File: An $8 \times 16$ storage unit for operands, system configurations, and general-purpose data.+1UART (RX/TX): Provides serial communication with configurable parity and prescaling.+1Clock Domain Crossing (CDC) Suite: Includes Asynchronous FIFOs, Data Synchronizers, and Reset Synchronizers to ensure data integrity between domains.+1Clock Management: Features a Clock Divider for UART timing and Clock Gating to optimize power by enabling the ALU clock only when needed

the system processes commands through multi-frame sequences:
Register Write ($0xAA$): 3 Frames 
Register Read ($0xBB$): 2 Frames 
ALU Operation with Operands ($0xCC): 4 Frames
ALU Operation with No Operands ($0xDD$): 2 Frames


