#! /usr/bin/bash
input="./tmp.txt"
while IFS= read -r line
do
  echo "$line"
  $line
done < "$input"