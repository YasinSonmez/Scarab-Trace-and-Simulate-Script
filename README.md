# Scarab-Trace-and-Simulate-Script
## Installation
Scarab and DynamoRio needs to be installed to first trace and then simulate a command.
## Instructions
To make the files executable, run the following commands in your terminal:

```

chmod +x trace.sh

chmod +x simulate.sh

```

Next, use the `trace.sh` script to trace the command you want. The first argument should be the command to be traced, and the second argument should be the path to Scarab installation.

For example, to trace the `ls` command where Scarab is located at `~/scarab` directory, run:

```

./trace.sh ls ~/scarab

```

This will create a subfolder in the current directory with the name as the current date and time. Inside it, there will be a `trace` folder and a `simulation` folder. You can now run the Scarab simulation using the dedicated script:

```

./simulate.sh

```
