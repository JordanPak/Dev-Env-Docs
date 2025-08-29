#!/bin/bash

# Change this to the directory that contains the directories you want to iterate through
DIR="./"

# Iterate through each directory in the main directory
for d in $DIR/*/ ; do
	# Check if the wp-content directory exists in the current directory
	if [ -d "${d}wp-content" ]; then
		# Empty the contents of the debug.log file in the wp-content directory
		echo -n "" > "${d}wp-content/debug.log"
		echo "Emptied ${d}wp-content/debug.log"
	fi
done
