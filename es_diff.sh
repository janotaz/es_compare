#!/bin/bash

# compares the output folders created by get_es_stats.sh
#		
#	Run the script: ./get_es_stats dev
#	Run it again for the other cluster you want to compare against: ./get_es_stats qa
#
#	Compare both clusters: ./es_diff.sh dev qa
#

# variables
OUTPUT=./output

# init styles
bold=$(tput bold)
normal=$(tput sgr0)
red=$(tput setaf 1)
green=$(tput setaf 2)

# newline
printf "$normal \n"

# stop if the number of arguments does not equal 2
if (($# != 2)); then
	printf "There must be only two arguments.\n"
	exit
fi

# check if data about the first cluster to be compared exist
if ! test -d "$OUTPUT/$1"; then
	printf "No data for $red $1.\n$normal"
	exit
fi

# check if data about the second cluster to be compared exist
if ! test -d "$OUTPUT/$2"; then
	printf "No data for $red $2.\n$normal"
	exit
fi

# diff all directories recursively
diff -ry --suppress-common-lines $OUTPUT/$1 $OUTPUT/$2


