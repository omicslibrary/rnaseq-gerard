#!/bin/bash

# Lambda entry point script
# This script will invoke the Lambda handler when the container is started

# Set up Lambda runtime environment
exec /usr/bin/aws lambda-runtime --handler lambda_handler --handler-mode "direct" "$@"
