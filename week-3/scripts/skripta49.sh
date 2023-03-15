#!/bin/bash
#simple demonstration of the getopts command
echo
while getopts :ab:c opt 
do
    case "$opt" in
        a) echo "Found the -a option" ;; 
        b) echo "Found the -b option , with value $OPTARG" ;;
        C) echo "Found the -C option" ;;
        *) echo "UNKNOWN OPTION: $opt" ;;
    esac  
done