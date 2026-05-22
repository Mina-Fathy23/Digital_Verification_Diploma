# FIFO Bug Detection Project

## Overview

This project focuses on detecting bugs in a faulty, encrypted FIFO (First-In-First-Out) hardware design. The primary goal is to identify and analyze functional errors in the design, improve its reliability, and demonstrate verification techniques typically used in digital hardware validation and debugging.

## Project Goals

- Analyze and understand the given encrypted faulty FIFO design.
- Develop a testbench and verification environment to stimulate the FIFO and observe its behavior.
- Detect, localize, and explain functional bugs present in the FIFO implementation.
- Document findings and suggest possible fixes.

## Process Outline

### 1. Design Analysis

- Start by analyzing the provided encrypted FIFO source files. 
- Understand the intended functional behavior of a standard FIFO (data order, overflow/underflow handling, reset, etc.).

### 2. Testbench & Verification Environment

- Construct a SystemVerilog testbench to interact with the FIFO signals (inputs/outputs, clock, reset, etc.).
- Apply different input stimulus, including normal operation, edge cases, and invalid scenarios (e.g., simultaneous read/write, empty/full conditions).
- Capture and log the FIFO outputs for analysis.

### 3. Bug Detection and Debugging

- Compare observed FIFO output and expected correct FIFO behavior.
- Use assertions and coverage metrics to check property violations.
- Isolate the conditions under which the bugs manifest.
- Analyze the design response to corner-test cases and erroneous inputs.

### 4. Documentation and Reporting

- Summarize each detected bug: description, stimulus that exposes it, and the observed faulty behavior.
- Provide possible root cause analysis for each bug.
- Suggest potential ways to fix the design, where possible.

## Tools and Technologies

- **Languages:** SystemVerilog, Verilog
- **Simulation Tools:** [Specify your simulator: ModelSim, VCS, etc.]
- **Waveform Viewing:** [Specify: GTKWave, DVE, etc.]
- **Other:** [Optional: Formal tools, scripts, or additional verification IPs]

## Deliverables

- FIFO testbench source files.
- Simulation scripts and results.
- Bug report document (listing all detected issues, evidence, and explanations).
- (Optional) Suggestions for design corrections.

## Folder Structure

```
FIFO Project/
├── Mina_Hakim_FIFO_Project.pdf      # Project documentation or report
├── README.md                        # You are here
├── [Testbench and design files]
```

## Acknowledgment

This project was completed for the Digital Verification Diploma as an exercise in advanced hardware verification and debugging methodology.

---

**For more details on the methodology or tool usage, refer to the project PDF or contact the project contributors.**
