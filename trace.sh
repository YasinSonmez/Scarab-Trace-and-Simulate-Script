#! /usr/bin/bash
main_path=$(pwd)
echo "Current path: " $main_path

scarab_path=$1
echo "Scarab path: " $scarab_path

# start from a certain position
start_from=$4
# Number of iterations (Number of cores)
num_timesteps=$5
last_timestep=$((start_from + num_timesteps-1))

timesteps_path=$main_path"/Timesteps_${start_from}-${last_timestep}"
# Check if the timesteps_path exists
if [ -e "$timesteps_path" ]; then
    echo "Path exists: $timesteps_path"

    # Add a twist (timestamp) to the folder name
    twist="_$(date +"%Y%m%d_%H%M%S")"

    # Create a new folder with the twisted name
    timesteps_path="${timesteps_path}${twist}"
fi

traces_path=$timesteps_path/traces
simulation_path=$timesteps_path/simulation

mkdir -p "$traces_path"
echo "1. Created the traces path: " $traces_path

mkdir -p "$simulation_path"
echo -e "2. Created the simulation path: " $simulation_path "\n"

echo "3. Starting tracing"
cp $main_path/../../params.json $timesteps_path
# run the dynamics simulation and record states
cd $traces_path
# if restart flag is true give an extra parameter to the code
if [ "$6" = "true" ]; then
    echo "Sim: 11111111111111111111111111111111111111111"
    $main_path/$2 $start_from $num_timesteps 1
else
    echo "Sim: 22222222222222222222222222222222222222222"
    $main_path/$2 $start_from $num_timesteps 
fi

# Run tracing C++ program in a loop
for ((i = start_from; i < start_from+num_timesteps; i++)); do
    echo "Running timestep $i..."
    # if restart flag is true give an extra parameter to the code
    if [ "$6" = "true" ] && [ "$i" -eq start_from ]; then
        echo "11111111111111111111111111111111111111111"
        $main_path/$3 $i 1 1 #Run tracing from ith step for 1 step
    else
        echo "2222222222222222222222222222222222222222"
        echo $num_timesteps
        $main_path/$3 $i 1 #Run tracing from ith step for 1 step
    fi
done
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
cd ${timesteps_path}
touch tmp.txt
touch tmp2.txt
find "$traces_path" -mindepth 1 -maxdepth 1 -type d -printf "%T@ %p\n" | sort -n | cut -d ' ' -f2- |
while read -r subfolder; do
    # Increment the counter
    # Perform your desired operations here, for example, echo the subfolder name
    echo "Processing subfolder $counter: $subfolder"
    # Add your additional commands here, such as copying, moving, or processing files within the subfolder.
    # Example: cp source_file destination_directory
    cd $subfolder
    trace_path="$(pwd)/trace"
    bin_path="$(pwd)/bin"
    echo "Trace path: " ${trace_path}
    echo "Bin path: " ${bin_path}
    
    current_timestep=$((start_from + counter))
    simulation_path_i=${simulation_path}/Timestep_${current_timestep}
    mkdir ${simulation_path_i}
    cd ${main_path}
    cd ..
    cp PARAMS.in ${simulation_path_i}
    cd ${timesteps_path}
    echo "cd ${simulation_path_i}" >> tmp.txt
    command="${scarab_path}/src/scarab --frontend memtrace --fetch_off_path_ops 0 --cbp_trace_r0=${trace_path} --memtrace_modules_log=${bin_path}"
    echo $command>>tmp.txt
    ((counter++))
done
echo "cd $main_path">>tmp2.txt
echo "python ./../../plot_cycles.py ${simulation_path}">>tmp2.txt
echo -e "5. Simulation commands are written to tmp.txt file \n"
cp  ${timesteps_path}/tmp.txt ${main_path}/..
cp  ${timesteps_path}/tmp2.txt ${main_path}/..