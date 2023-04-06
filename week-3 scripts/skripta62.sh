#! /bin/bash
# using the alternative file descriptor

exec 3>test13out

echo "This should display on the monitor"
echo "and this should be stored in the file " >&3
echo "Then this sholud be back on the monitor"

