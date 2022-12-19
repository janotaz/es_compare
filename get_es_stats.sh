#!/bin/bash

# destination folder for all ES config
OUTPUT=./output

# init styles
bold=$(tput bold)
normal=$(tput sgr0)
red=$(tput setaf 1)
green=$(tput setaf 2)

# newline
printf "$normal\n"

# check if jq is installed
if ! command -v jq &> /dev/null; then 
	printf "$red jq could not be found. Exiting.\n"
	exit
fi

# check if a cluster has been selected
ENV=$1
if [ -z ${ENV} ]; then
	printf "get_es_stats: try './get_es_stats.sh cluster' - where ./config/cluster.config contains the respective configuration\n"
	exit
fi

# check if the configuration file for the requested cluster exists
if ! test -f "./config/$1.config"; then
	printf "$red Configuration for environment $1 does not exist.\n$normal"
	printf "Please create: $bold./config/$1.config$normal - see $bold./config/sample.config$normal for reference\n"
	exit
fi

# load config file
source ./config/$1.config
printf "Getting ElasticSearch statistics for $bold$green$1$normal ($URL)\n" 

#printf "URL = $URL\n"
#printf "TOKEN = $TOKEN\n"

# create a directory as a placeholder for the data that will be retrieved
mkdir -p $OUTPUT/$1

# get list of indices
printf "Getting$bold indices.$normal\n" 
curl -sk -H "Content-Type: application/json" -H "Authorization: Basic $TOKEN" -X GET "$URL/_cat/indices?format=json" | jq .[].index | sort | grep -v "^\"\." | sed 's/\"//g' > $OUTPUT/$1/indices.json

# get aliases
printf "Getting$bold aliases.$normal\n" 
curl -sk -H "Content-Type: application/json" -H "Authorization: Basic $TOKEN" -X GET "$URL/*,-.*/_alias" | jq -S > $OUTPUT/$1/aliases.json

# get all mappings in one file; gets difficult to read
# curl -sk -H "Content-Type: application/json" -H "Authorization: Basic $TOKEN" -X GET "$URL/*,-.*/_mapping" | jq -S > $OUTPUT/$1/mapping.json

# create mappings dir
mkdir -p $OUTPUT/$1/mappings

# iterate over all indices and get mappings individually
printf "Getting$bold mappings.$normal\n" 
while IFS= read -r index; do
	curl -sk -H "Content-Type: application/json" -H "Authorization: Basic $TOKEN" -X GET "$URL/$index/_mapping" | jq -S > $OUTPUT/$1/mappings/$index.json
	printf "  $bold$index$normal\n" 

done < $OUTPUT/$1/indices.json

printf "$green \n"
printf "Done.\n" 
