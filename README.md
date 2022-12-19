# Elasticsearch Compare

A set of scripts to compare indices, aliases and mappings between two elasticsearch clusters. 

## Usage

Create config files for the clusters you want to compare.

Cluster 1 

``` bash
# ./config/dev.config
URL="https://dev.domain.com:9200"
TOKEN="dXNlcm5hbWU6cGFzc3dvcmQK"

# TOKEN is the base64 encoded version of 'username:password'
# To encode this:
# - create a file called 'token'
# - add one line in the file containing the credentials:
#	username:password
# - run: `base64 -i token`

```

Cluster 2
``` bash
# ./config/qa.config
URL="https://qa.domain.com:9200"
TOKEN="dXNlcm5hbWU6cGFzc3dvcmQK"
```

## Run
### Get the cluster info for **dev**
``` bash
./get_es_stats.sh dev
```
``` bash
Getting Elasticsearch statistics for dev (https://dev.domain.com:9200)
Getting indices.
Getting aliases.
Getting mappings.
  index1
  index2
  index3

Done.
```

### Get the cluster info for **qa**
``` bash
./get_es_stats.sh qa
```
``` bash
Getting Elasticsearch statistics for dev (https://qa.domain.com:9200)
Getting indices.
Getting aliases.
Getting mappings.
  index1
  index2
  index3

Done.
```

### Compare the two clusters:

``` bash
./es_diff.sh dev qa
```

## Windows

To run these scripts on Windows
- Download and install git for Windows: https://gitforwindows.org/
- Download jq: https://github.com/stedolan/jq/releases/download/jq-1.6/jq-win64.exe
  - rename to jq.exe
  - save a copy to C:\Program Files\Git\usr\bin
