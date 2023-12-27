#! /usr/bin/bash
main_path=$(pwd)
input="./../tmp.txt"
input2="./../tmp2.txt"
counter=0
while IFS= read -r line; do
  ((counter++))
  echo "$line"
  if ((counter % 2 == 0)); then
    $line &
  else
    $line
  fi
done < "$input"
wait
cd $main_path
while IFS= read -r line; do
  echo "$line"
  $line
done < "$input2"
wait