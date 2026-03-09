# UART Protocol Design and Verification with IP

## 📖 Project Overview

This repository contains the complete **RTL design, custom IPs, and SystemVerilog verification** of a UART (Universal Asynchronous Receiver/Transmitter) protocol.  

The project demonstrates full **design and verification flow**:
1. RTL design in Xilinx Vivado  
2. IP packaging for modular TX, RX, and baud-rate blocks  
3. Testbench simulation in Vivado  
4. Verification in ModelSim using SystemVerilog UVM-like environment  
5. Capture and documentation of simulation results  

The design supports configurable **baud rate, data width**, and can be easily integrated into larger systems as modular IP blocks.

---

## 🏗️ System Architecture and Design

The UART system is modular, consisting of:

- **UART Transmitter (TX)** – Serializes data from parallel input and drives the serial line.  
- **UART Receiver (RX)** – Deserializes the serial input into parallel output data.  
- **Baud Rate Generator (BRG)** – Produces timing signals for correct bit transmission.  
- **Custom IPs** – Each functional block is wrapped as an IP in Vivado.  

**Top-level integration:**
- TX, RX, and BRG IPs instantiated in a wrapper module.  
- Verified functionality with Vivado simulation before moving to ModelSim for advanced verification.  

---

## 🔬 Verification Workflow

### Vivado Simulation
- Compiled RTL modules and testbenches in Vivado.  
- Performed **functional simulation** for TX, RX, and full UART system.  
- Debugged using waveform viewer.  

### IP Wrapping
- Generated **Vivado IPs** for TX, RX, and Baud Rate Generator.  
- Integrated IPs in wrapper module for system-level testing.  
- Verified modules individually and in combination with testbench.

### ModelSim Verification
- Created **SystemVerilog verification environment** (drivers, monitors, scoreboard).  
- Ran simulations to validate correct transmission and reception of data.  
- Captured waveforms and checked parity, framing, and busy signals.  
- Verification results stored in `RTL_Design_and_Verification_Result/`.  

---

## 🛠️ Tools Used

- **Design & Synthesis:** Xilinx Vivado  
- **Verification:** ModelSim (Mentor Graphics / Siemens)  
- **Languages:** SystemVerilog, Verilog  

---

## 📁 Repository Structure
