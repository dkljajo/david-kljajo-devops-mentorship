#!/bin/bash
# iterate through all the files in a directory
for file in /home/david/s* /home/david/snapshoot
do
    if [ -d "$file" ]
    then
        echo "$file is a directory"
    elif [ -f "$file" ]
    then
        echo "$file is a file"
    else
        echo "$file doesn't exist"
    fi
done