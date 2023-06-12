#! /usr/bin/bash
echo "Current path: " $main_path
main_path=$(pwd)

scarab_path=$1
echo "Scarab path: " $scarab_path

current_time=$(date +'%Y-%m-%d_%H-%M-%S')
traces_path=$main_path"/$current_time"/traces
simulation_path=$main_path"/$current_time"/simulation

mkdir -p "$traces_path"
echo "1. Created the traces path: " $traces_path

mkdir -p "$simulation_path"
echo "2. Created the simulation path: " $simulation_path

echo "3. Starting tracing"
$scarab_path/src/build/opt/deps/dynamorio/bin64/drrun -t drcachesim -offline -outdir $traces_path -- $2
echo "3. Tracing ended"

echo "4. Portabilizing the trace file started"
cd $traces_path
bash $scarab_path/utils/memtrace/run_portabilize_trace.sh
echo "4. Portabilizing the trace file ended"

cd *$2* #Find the trace file with the command name
trace_path="$(pwd)/trace"
bin_path="$(pwd)/bin"
echo "Trace path: " ${trace_path}
echo "Bin path: " ${bin_path}

cd $main_path
cp PARAMS.in $simulation_path

echo "cd ${simulation_path}" > tmp.txt
command="${scarab_path}/src/scarab --frontend memtrace --fetch_off_path_ops 0 --cbp_trace_r0=${trace_path} --memtrace_modules_log=${bin_path}"
echo "5. Simulation commands are written to tmp.txt file"

echo $command>>tmp.txt