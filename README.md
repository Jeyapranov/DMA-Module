# DMA Controller UVM Verification Environment

This repository contains a robust **Universal Verification Methodology (UVM)** environment built using SystemVerilog to verify a **Direct Memory Access (DMA)** controller. The testbench utilizes **Constrained Random Verification (CRV)** and protocol-level checking to ensure maximum functional coverage and data integrity.

---

## 🚀 Key Features

* **UVM 1.2 Compliant Architecture:** Uses a structured class hierarchy including Sequences, Sequencers, Drivers, Monitors, Agents, and Environments.
* **Constrained Random Testing:** Dynamically generates random source addresses, destination addresses, and transfer sizes across 100 consecutive transactions.
* **Zero-Race Handshake Logic:** Implements a fully synchronous `valid`/`ready` handshake mechanism in the driver to avoid delta-cycle race conditions.
* **SystemVerilog Assertions (SVA):** Embedded protocol checks inside the interface layer to enforce signal stability.
* **Open-Source Waveform Flow:** Configured to automatically generate universal `.vcd` files for lightweight, high-performance visualization in **GTKWave**.

---

## 📐 Architecture Overview

The verification environment bridges the static hardware domain (RTL/Interface) with the dynamic software domain (UVM classes):

```
+--------------------------------------------------------------------------+
|                                 tb_top                                   |
|  +---------------------------+            +---------------------------+  |
|  |       dma_test            |            |       design.sv           |  |
|  |  +---------------------+  |            |     (DMA Hardware)        |  |
|  |  |      dma_env        |  |            +-------------+-------------+  |
|  |  |  +---------------+  |  |                          |                |  |
|  |  |  |   dma_agent   |  |  |                          |                |  |
|  |  |  | +-----------+ |  |  |                          |                |  |
|  |  |  | | dma_seq   | |  |  |                          |                |  |
|  |  |  | +-----+-----+ |  |  |                          |                |  |
|  |  |  |       |       |  |  |                          |                |  |
|  |  |  | +-----+-----+ |  |  |                    Virtual               |  |
|  |  |  | | dma_sqr   | |  |  |                   Interface              |  |
|  |  |  | +-----+-----+ |  |  |                  (dma_if.sv)             |  |
|  |  |  |       |       |  |  |                          |                |  |
|  |  |  | +-----+-----+ |  |  |                          |                |  |
|  |  |  | | dma_driver+----------------------------------+                |  |
|  |  |  | +-----------+ |  |  |                          |                |  |
|  |  |  |               |  |  |                          |                |  |
|  |  |  | +-----------+ |  |  |                          |                |  |
|  |  |  | |dma_monitor+----------------------------------+                |  |
|  |  |  | +-----------+ |  |  |                                           |  |
|  |  |  +---------------+  |  |                                           |  |
|  |  +---------------------+  |                                           |  |
|  +---------------------------+                                           |  |
+--------------------------------------------------------------------------+

```

---

## 📂 Repository Structure

| File Name | Category | Description |
| --- | --- | --- |
| **`design.sv`** | RTL | The actual DMA hardware design module under test. |
| **`dma_if.sv`** | Hardware | Bundles the physical pins (`clk`, `rst_n`, `valid`, `ready`, etc.) and contains protocol assertions. |
| **`dma_txn.sv`** | UVM Component | The Sequence Item class defining randomized fields (`src_addr`, `dst_addr`, `size`). |
| **`dma_seq.sv`** | UVM Component | The Sequence class that orchestrates the execution loop for transactions. |
| **`dma_driver.sv`** | UVM Component | Pulls transactions from the sequencer and drives the virtual interface synchronous to the clock. |
| **`dma_monitor.sv`** | UVM Component | Passively samples the interface wires on handshakes and translates them back to transactions. |
| **`dma_agent.sv`** | UVM Component | Container encapsulating the Sequencer, Driver, and Monitor for structural modularity. |
| **`dma_env.sv`** | UVM Component | The top-level environment wrapper holding the active agents and checking infrastructures. |
| **`dma_test.sv`** | UVM Component | Configures the environment and explicitly starts the verification scenarios. |
| **`dma_pkg.sv`** | Compilation | Package wrapper containing all essential include definitions for clean compilation. |
| **`testbench.sv`** | Top-Level | Instantiates the physical hardware, interface, clock generators, and invokes `run_test()`. |

---

## 🛠️ Compilation & Simulation Quickstart

This flow is fully optimized for **Ubuntu Linux** using the **Questa/ModelSim CLI** and **GTKWave**.

### Step 1: Compile the Design and Verification Files

Compile all underlying modules, interfaces, and packages sequentially:

```bash
vlog -L uvm +incdir+. dma_if.sv design.sv dma_pkg.sv testbench.sv

```

### Step 2: Simulate in Command-Line Mode

Run the simulation directly inside your terminal shell without starting up the heavy GUI layout. This runs the test scenario, generates the transcript dump, and records a standard Value Change Dump (`.vcd`) wave file:

```bash
vsim -c -voptargs="+acc" -L mtiUvm tb_top +UVM_TESTNAME=dma_test -do "vcd file dma.vcd; vcd add -r /tb_top/vif/*; run -all; quit"

```

### Step 3: View Waveforms in GTKWave

Open up the generated VCD wave trace cleanly inside your graphical wave analyzer tool:

```bash
gtkwave dma.vcd

```

---

## 📈 Expected Simulation Waveform Result

When inspected inside **GTKWave**, you will see the full 100-transaction sequence running at maximum efficiency.

* **Bus Alignment:** Every control and data change (`src_addr`, `dst_addr`, `size`, `valid`) aligns precisely on the rising edge (`posedge`) of the `clk`.
* **Protocol Stability:** The `valid` assertion holds fixed values consistently across clock cycles, resisting any shifting or bit flipping until the corresponding `ready` handshake cycle clears.
* **Clean Closeout:** The simulation executes without assertion bugs, delivering a completely clean UVM summary execution showing `Errors: 0` inside your terminal console output.
