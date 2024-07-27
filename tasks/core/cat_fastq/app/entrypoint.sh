#!/bin/sh

# Check the environment variable to determine the mode
if [ "$RUN_MODE" = "ecs" ]; then
    # Run ECS entry point
    /usr/local/bin/cat_fastq_entrypoint.sh
elif [ "$RUN_MODE" = "lambda" ]; then
    # Run Lambda entry point
    /usr/local/bin/aws-lambda-rie python3 /var/task/app.py
else
    echo "Error: RUN_MODE environment variable not set or unrecognized. Must be 'ecs' or 'lambda'."
    exit 1
fi
