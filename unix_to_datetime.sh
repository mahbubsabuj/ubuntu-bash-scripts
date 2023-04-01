#!/bin/bash

input_file="/home/mahbubsabuj/Downloads/70B3D5B6FA000012_(2).csv"
output_file="/home/mahbubsabuj/Downloads/out/70B3D5B6FA000012_(2)_output.csv"

echo "Unixtimestamp,Name,WaterMeter,Datetime" > $output_file

while read line; do
    unix_timestamp=$(echo $line | cut -d ',' -f 1)
    name=$(echo $line | cut -d ',' -f 2)
    water_meter=$(echo $line | cut -d ',' -f 3)
    datetime=$(date -u -d @$((unix_timestamp/1000)) "+%Y-%m-%d %H:%M:%S")
    echo "$unix_timestamp,$name,$water_meter,$datetime" >> $output_file
done < $input_file
