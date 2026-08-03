# Day 36 Daily Log

## Topic

OpenROAD Environment Setup on Windows Using WSL2, Ubuntu, Docker Desktop, and OpenROAD Flow Scripts

## What I Learned

Today I prepared the execution environment for the OpenROAD practice phase.

OpenROAD is an open-source physical-design tool used to transform a synthesized gate-level netlist into a physically implemented design. Its main responsibilities include floorplanning, placement, Clock Tree Synthesis, routing, timing-driven optimization, and physical-design database generation.

OpenROAD itself is not the complete RTL-to-GDSII flow. The broader OpenROAD Flow Scripts environment connects multiple tools:

> RTL  
> → Yosys Synthesis  
> → OpenROAD Physical Implementation  
> → KLayout Layout Processing and Supported Verification  
> → Reports and Final Layout Outputs

Yosys performs logic synthesis. OpenROAD handles the main physical-design stages. KLayout supports layout visualization, GDS processing, and supported DRC or LVS tasks. OpenROAD Flow Scripts, or ORFS, connects the tools, design configurations, Makefile targets, logs, reports, intermediate objects, and final results.

Because my computer uses Windows, I did not attempt to install and run the complete ORFS environment directly in PowerShell. Instead, I built the following tool chain:

> Windows  
> → WSL2  
> → Ubuntu  
> → Docker Desktop  
> → ORFS Docker Container

I installed WSL and Ubuntu, created the Linux user `steph`, and verified that Ubuntu was running under WSL2. I also learned the relationship between the Windows and Linux filesystems. For example, the Windows path `C:\Users\steph` appears inside WSL as `/mnt/c/Users/steph`, while the Linux home directory is `/home/steph`.

I created the Linux workspace:

> `/home/steph/openroad-work`

Using the Linux filesystem for the active OpenROAD workspace avoids unnecessary file-access overhead from repeatedly running Linux tools on files stored under `/mnt/c`.

I installed Docker Desktop and enabled its Ubuntu WSL integration. The command `docker run hello-world` completed successfully, proving that the Ubuntu Docker client could contact the Docker daemon, download an image, create a container, and return the container output.

I then prepared the OpenROAD Flow Scripts repository. Direct Git cloning failed because the GitHub connection repeatedly disconnected during transfer. The errors included HTTP/2 cancellation, connection timeout, early EOF, and invalid index-pack output. A shallow clone using HTTP/1.1 also failed.

The successful workaround was to download the repository ZIP through the Windows Edge browser, extract it in the Windows Downloads directory, and copy it into the WSL Linux filesystem.

A directory-nesting problem occurred because a partially created `OpenROAD-flow-scripts` directory already existed. The complete extracted directory was moved out, the incomplete outer directory was removed, and the complete directory was renamed to:

> `/home/steph/openroad-work/OpenROAD-flow-scripts`

After the correction, the repository root directly contained `flow`, `docs`, `tools`, `docker`, `etc`, `README.md`, and `build_openroad.sh`.

I started the ORFS Docker environment through `flow/util/docker_shell`. Inside the container, the prompt displayed `I have no name!` because the container did not contain a username entry matching the mounted WSL user ID. This was only a container identity-display issue and did not prevent the tools from running.

The environment successfully located and executed Yosys, OpenROAD, GNU Make, and KLayout. I also inspected the official `nangate45/gcd` reference design. Its configuration identified `gcd` as the design name, `nangate45` as the platform, `gcd.v` as the RTL input, and `constraint.sdc` as the timing-constraint file.

The configuration set the core utilization target to 55% and referenced a design-specific power-distribution strategy. The SDC defined the `clk` input as `core_clock`, used a 0.46 ns clock period, specified 0.070 ns clock latency, and derived input and output delays from 20% of the clock period.

## What I Built

I completed a working OpenROAD environment on Windows.

The verified environment chain is:

> Windows  
> → WSL2 Ubuntu  
> → Docker Desktop  
> → ORFS Docker Container  
> → Yosys and OpenROAD

I created and verified the following Linux directories:

- `/home/steph/openroad-work`
- `/home/steph/openroad-work/OpenROAD-flow-scripts`

I produced the setup record:

- `04_openroad_practice/01_setup_log/setup_log.md`

The setup log records the actual installation sequence, commands, errors, workarounds, tool paths, tool versions, selected reference design, and environment status.

The following tools were verified:

- Yosys `0.67+post`
- OpenROAD `2603-771-g7cfb2105c9`
- GNU Make `4.3`
- KLayout executable at `/usr/bin/klayout`

I also verified the presence of official ORFS design platforms, including `nangate45`, `asap7`, `sky130hd`, `sky130hs`, `gf12`, `gf180`, `gf55`, and `ihp-sg13g2`.

## Key Concepts

### OpenROAD

An open-source physical-design application used for floorplanning, placement, Clock Tree Synthesis, routing, timing-driven optimization, and related implementation tasks.

### OpenROAD Flow Scripts

An automated framework that connects synthesis, physical design, layout processing, design configurations, Makefile targets, logs, reports, and final results.

### WSL2

A Windows feature that runs a Linux environment with a real Linux kernel and provides the Ubuntu environment used for the OpenROAD workflow.

### Docker Container

An isolated execution environment containing the required ORFS tools and dependencies, reducing host operating-system compatibility problems.

### Yosys

The synthesis tool that converts synthesizable RTL into a gate-level netlist mapped to a target standard-cell library.

### KLayout

A layout tool used for visualization, GDS processing, and supported physical-verification integration.

### Reference Design

An official example design with predefined RTL, timing constraints, platform data, and flow parameters used to verify and study the complete flow.

## Problems / Fixes

### Problem 1: WSL Was Not Installed

The initial `wsl --status` command reported that the Windows Subsystem for Linux was not installed.

Fix:

WSL and Ubuntu were installed with the Windows WSL installation command. Ubuntu was initialized with the user account `steph`, and `wsl -l -v` confirmed that Ubuntu used WSL version 2.

### Problem 2: Git Clone Failed Through HTTP/2

The recursive Git clone failed with an HTTP/2 stream cancellation, early EOF, and invalid index-pack output.

Fix:

A second attempt forced HTTP/1.1 and used shallow cloning to reduce the transfer size.

### Problem 3: The Shallow Clone Also Failed

The HTTP/1.1 shallow clone timed out before the Git pack completed.

Fix:

The repository was downloaded as a ZIP through the Windows browser, where the existing Windows networking and proxy configuration worked more reliably.

### Problem 4: The Downloaded Repository Was Nested Incorrectly

The complete `OpenROAD-flow-scripts-master` directory was copied into an incomplete `OpenROAD-flow-scripts` directory, producing an extra directory level.

Fix:

The complete inner directory was moved to a temporary name, the incomplete outer directory was deleted, and the complete directory was renamed to `OpenROAD-flow-scripts`.

### Problem 5: The Container Displayed `I Have No Name!`

The ORFS container could not map group ID 1000 to a stored username and displayed an anonymous-looking prompt.

Fix:

The message was identified as a container user-ID mapping issue rather than a tool failure. Yosys, OpenROAD, Make, and KLayout remained executable, so no environment repair was required.

### Problem 6: The Initial Design Search Returned No Configuration Files

The command used a maximum search depth of two, but the configuration files were stored under `designs/<platform>/<design>/config.mk`.

Fix:

The search depth was increased to three, allowing the reference-design configuration files to be located.

## Connection to VLSI / EDA / 3D IC

This setup connects the theoretical RTL-to-GDSII and STA material to a real EDA workflow.

For Physical Design, OpenROAD will allow direct inspection of floorplanning, placement, CTS, routing, utilization, congestion, timing, and physical-layout results.

For EDA/CAD, ORFS demonstrates how separate tools are connected through scripts, configuration files, Makefile targets, intermediate databases, reports, and metrics. The environment also exposes how automation must manage tool versions, filesystem paths, platforms, design inputs, and reproducibility.

For STA, the `nangate45/gcd` example already connects the RTL input to an SDC file containing a clock period, clock latency, and I/O timing constraints. Later flow stages will generate timing reports that can be interpreted using arrival time, required time, slack, skew, cell delay, and net delay.

For 3D IC, this environment establishes the conventional 2D digital implementation baseline. That baseline is necessary before studying how TSVs, interposers, chiplets, package interconnects, thermal constraints, and cross-die timing complicate the physical-design problem.

## One Sentence Summary

I established and verified a complete Windows-to-ORFS Docker toolchain that can now run official RTL-to-GDSII reference designs using Yosys, OpenROAD, KLayout, and Make.

## Next Step

Run the official `nangate45/gcd` reference design through the complete ORFS flow and record the generated synthesis, floorplan, placement, CTS, routing, timing, area, power, and DRC outputs.
