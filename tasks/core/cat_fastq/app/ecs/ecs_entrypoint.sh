#!/bin/bash

# Fail on any error
set -e

# Define input and output variables
INPUT_FILES=$INPUT_FILES
OUTPUT_FILE=$OUTPUT_FILE

# Download input files from S3
for file in $(aws s3 ls ${INPUT_FILES} --recursive | awk '{print $4}'); do
    aws s3 cp s3://your-bucket/${file} /tmp/$(basename ${file})
done

# Concatenate files
cat /tmp/* > /tmp/merged.fastq.gz

# Write versions.yml
cat --version | sed 's/^.*coreutils) //; s/ .*$//' > /tmp/versions.yml

# Upload results to S3
aws s3 cp /tmp/merged.fastq.gz ${OUTPUT_FILE}
aws s3 cp /tmp/versions.yml ${OUTPUT_FILE%/*}/versions.yml
