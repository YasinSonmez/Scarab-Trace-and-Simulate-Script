#! /usr/bin/bash
echo "Current path: " $main_path
main_path=$(pwd)

scarab_path=$1
echo "Scarab path: " $scarab_path

current_time=$(date +'%Y-%m-%d_%H-%M-%S')
timed_path=$main_path"/$current_time"
traces_path=$timed_path/traces
simulation_path=$timed_path/simulation

mkdir -p "$traces_path"
echo "1. Created the traces path: " $traces_path

mkdir -p "$simulation_path"
echo -e "2. Created the simulation path: " $simulation_path "\n"

echo "3. Starting tracing"
cd $traces_path
cp $main_path/../params.json $timed_path
./../../$2
echo -e "3. Tracing ended\n"

echo "4. Portabilizing the trace file started"
cd $traces_path
bash $scarab_path/utils/memtrace/run_portabilize_trace.sh
echo -e "4. Portabilizing the trace file ended \n"


base_file_name=$(basename "$2")
#cd *$base_file_name* #Find the trace file with the command name
# Find all subfolders in the main folder and sort them by creation time (oldest first)
# Then, loop through each subfolder
# Initialize a counter for the loop
counter=0
# Create a txt file to store commands
cd ${timed_path}
touch tmp.txt
find "$traces_path" -mindepth 1 -maxdepth 1 -type d -printf "%T@ %p\n" | sort -n | cut -d ' ' -f2- |
while read -r subfolder; do
    # Increment the counter
    ((counter++))
    # Perform your desired operations here, for example, echo the subfolder name
    echo "Processing subfolder $counter: $subfolder"
    # Add your additional commands here, such as copying, moving, or processing files within the subfolder.
    # Example: cp source_file destination_directory
    cd $subfolder
    trace_path="$(pwd)/trace"
    bin_path="$(pwd)/bin"
    echo "Trace path: " ${trace_path}
    echo "Bin path: " ${bin_path}
    
    simulation_path_i=${simulation_path}/Timestep_${counter}
    mkdir ${simulation_path_i}
    cd ${main_path}
    cp PARAMS.in ${simulation_path_i}
    cd ${timed_path}
    echo "cd ${simulation_path_i}" >> tmp.txt
    command="${scarab_path}/src/scarab --frontend memtrace --fetch_off_path_ops 0 --cbp_trace_r0=${trace_path} --memtrace_modules_log=${bin_path}"
    echo $command>>tmp.txt
    echo -e "5. Simulation commands are written to tmp.txt file \n"
done
cp  ${timed_path}/tmp.txt ${main_path}
<<COMMENT
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

COMMENT