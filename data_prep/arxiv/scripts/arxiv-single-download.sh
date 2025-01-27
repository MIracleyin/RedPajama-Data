#!/bin/bash
# for download partitions
# for single machine download

set -e

# Depend on your CPU
WORKERS=8

export DATA_DIR="./data/arxiv"

# setup partitions
python run_download.py --aws_config aws_config.ini --workers $WORKERS --target_dir $DATA_DIR --setup

# Function to process a file
process_file() {
    INPUT_FILE="$1"
    echo "Processing input file is ${INPUT_FILE}"
    python run_download.py --aws_config aws_config.ini --target_dir $DATA_DIR --input $INPUT_FILE
}

# Export the function to be used by xargs
export -f process_file

ls ${DATA_DIR}/partitions/*.txt | xargs -I {} -P ${WORKERS} -n 1 bash -c 'process_file "$@"' _ {}

