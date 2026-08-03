# OpenROAD Environment Setup Log

## 1. Objective

Prepare a Windows-based OpenROAD Flow Scripts environment using WSL2, Ubuntu, Docker Desktop, and the official ORFS Docker container.

The target toolchain is:

> Windows  
> → WSL2  
> → Ubuntu  
> → Docker Desktop  
> → OpenROAD Flow Scripts  
> → Yosys, OpenROAD, KLayout, and GNU Make

## 2. Host Environment

- Host operating system: Windows
- WSL distribution: Ubuntu
- Ubuntu user: `steph`
- Ubuntu version: Ubuntu 26.04 LTS
- WSL version: WSL2
- WSL package version observed during installation: 2.7.11
- WSL home directory: `/home/steph`
- OpenROAD workspace: `/home/steph/openroad-work`

The WSL2 installation was verified with:

> `wsl -l -v`

Observed result:

- Distribution: Ubuntu
- State: Stopped after exiting the session
- Version: 2

## 3. Docker Desktop Verification

Docker Desktop was installed on Windows and integrated with the Ubuntu WSL distribution.

Docker container execution was verified with:

> `docker run hello-world`

Observed result:

> Hello from Docker!  
> This message shows that your installation appears to be working correctly.

This confirmed that:

- The Docker client could contact the Docker daemon.
- Docker could pull an image from Docker Hub.
- Docker could create and execute a Linux container.
- Container output could be returned to the Ubuntu terminal.

## 4. ORFS Repository Preparation

The intended repository directory was:

> `/home/steph/openroad-work/OpenROAD-flow-scripts`

### Initial Git Clone Attempt

The first command was:

> `git clone --recursive https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts.git`

The transfer failed with errors including:

> `RPC failed; curl 92 HTTP/2 stream was not closed cleanly`  
> `fatal: early EOF`  
> `fatal: fetch-pack: invalid index-pack output`

### Shallow Clone Attempt

A second command used HTTP/1.1 and shallow submodules:

> `git -c http.version=HTTP/1.1 clone --depth 1 --recurse-submodules --shallow-submodules https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts.git`

This attempt also failed because the connection timed out:

> `curl 56 Recv failure: Connection timed out`  
> `fatal: early EOF`

### Browser ZIP Workaround

The repository ZIP archive was downloaded through the Windows Edge browser and extracted under:

> `C:\Users\steph\Downloads\OpenROAD-flow-scripts-master`

The extracted directory was copied into the WSL Linux filesystem.

A nested-directory issue was created because an incomplete target directory already existed. The corrected directory sequence was:

> `cd ~/openroad-work`  
> `mv OpenROAD-flow-scripts/OpenROAD-flow-scripts-master OpenROAD-flow-scripts-complete`  
> `rm -rf ~/openroad-work/OpenROAD-flow-scripts`  
> `mv OpenROAD-flow-scripts-complete OpenROAD-flow-scripts`

The corrected repository directory directly contains:

- `flow`
- `docs`
- `tools`
- `docker`
- `etc`
- `README.md`
- `build_openroad.sh`

## 5. ORFS Docker Container

The ORFS Docker launcher was prepared with:

> `chmod +x flow/util/docker_shell`

The interactive container was started from the `flow` directory with:

> `util/docker_shell bash`

The container prompt appeared as:

> `I have no name!@docker-desktop:/OpenROAD-flow-scripts/flow$`

The messages below were observed:

> `groups: cannot find name for group ID 1000`  
> `I have no name!`

These messages indicate that the container does not contain a username entry matching the mounted WSL user ID. They did not prevent the ORFS environment or tools from running.

## 6. Tool Verification

### Yosys

Executable path:

> `/OpenROAD-flow-scripts/tools/install/yosys/bin/yosys`

Version:

> Yosys 0.67+post

Role:

- Read and elaborate RTL
- Perform logic optimization
- Map logic to the target standard-cell library
- Generate the synthesized gate-level netlist

### OpenROAD

Executable path:

> `/OpenROAD-flow-scripts/tools/install/OpenROAD/bin/openroad`

Version:

> `2603-771-g7cfb2105c9`

Role:

- Floorplanning
- Placement
- Clock Tree Synthesis
- Routing
- Parasitic-aware optimization
- Timing-driven physical implementation

### GNU Make

Version:

> GNU Make 4.3

Role:

- Control ORFS stages and targets
- Pass design and platform configurations
- Organize logs, reports, results, and intermediate objects

### KLayout

Executable path:

> `/usr/bin/klayout`

Status:

- The executable path was verified.
- The version command was not recorded in this setup session.

Role:

- Layout visualization
- GDS processing
- Supported DRC and LVS integration

## 7. Reference Design Verification

The ORFS design directories were successfully listed, including:

- `asap7`
- `gf12`
- `gf180`
- `gf55`
- `ihp-sg13g2`
- `nangate45`
- `sky130hd`
- `sky130hs`

The first selected reference design is:

> Platform: `nangate45`  
> Design: `gcd`

The design directory contains:

- `config.mk`
- `constraint.sdc`
- `grid_strategy-M1-M4-M7.tcl`
- `rules-base.json`
- `autotuner.json`

## 8. GCD Configuration Review

The configuration defines:

- Design name: `gcd`
- Platform: `nangate45`
- RTL source: `$(DESIGN_HOME)/src/gcd/gcd.v`
- SDC file: `$(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NAME)/constraint.sdc`
- Core utilization: 55%
- Placement density lower-bound add-on: 0.20
- Repeatable synthesis build enabled
- Custom PDN strategy: `grid_strategy-M1-M4-M7.tcl`

The file also sets:

> `ABC_AREA = 1`

This indicates an area-oriented ABC synthesis configuration for the example.

## 9. GCD Timing Constraint Review

The SDC file defines:

- Current design: `gcd`
- Clock name: `core_clock`
- Clock input port: `clk`
- Clock period: 0.46 ns
- I/O delay percentage: 0.20
- Clock latency: 0.070 ns

The SDC creates:

1. A physical clock on the `clk` input port
2. A virtual clock for input and output interface constraints

The non-clock input delay is derived from:

> Clock Period × I/O Delay Percentage

The output delay uses the same relationship.

## 10. Environment Status

The following environment chain was successfully verified:

> Windows  
> → WSL2 Ubuntu  
> → Docker Desktop  
> → ORFS Docker Container  
> → Yosys  
> → OpenROAD  
> → GNU Make  
> → KLayout Executable

The Day 36 OpenROAD environment objective is complete.

## 11. Next Step

Run the official `nangate45/gcd` example through the complete ORFS RTL-to-GDSII flow and record:

- Flow command
- Runtime
- Generated directory structure
- Synthesis result
- Floorplan result
- Placement result
- CTS result
- Routing result
- Timing reports
- Area and utilization metrics
- Power estimate
- DRC result
