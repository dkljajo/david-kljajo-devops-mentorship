#!/bin/bash
# breaking out of a WHILE loop

var1=1

while [ $var1 -lt 10 ]
do
    if [ $var1 -eq 5 ]
    then
        break
    fi
    echo "Iteration: $var1"
    var1=$[ $var1 + 1 ]    
done
echo "The WHILE loop is completed"