#! /usr/bin/bash
main_path=$(pwd)
input2="./../tmp2.txt"
while IFS= read -r line; do
  echo "$line"
  eval "$line"
done < "$input2"
wait  # Wait for all processes in the second loop to finish
