# Scarab-Trace-and-Simulate-Script
## Installation
Scarab and DynamoRio must be installed to trace and simulate a command first.
## Instructions
These scripts automate tracing with Dynamorio, simulate using Scarab, and plot the results. The `RESOURCES_DIR` environment variable must be defined as the parent directory where the scarab folder is located.

Usage:
```
./trace.sh <scarab_path> <simulation_executable> <start_from> <num_timesteps> <restart_flag> <chip_params_path> <controller_params_path> <control_sampling_time>
```
