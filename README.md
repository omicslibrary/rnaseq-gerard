# RNAseq tasks to ecs task defenitions and lambda functions
---

This repository contains the tooling to build, tag, and deploy a Docker images that correspond to individual tasks in RNAseq pipeline. The provided Makefile simplifies the build, tag, push, and deployment processes for Docker images, ECS task definitions and Lambda functions.

## Overview
---

- **Docker Images**: The individual task are defined in the task folder and the Dockerfile defining the dependencies are placed under `<tasks>/core/<task_name>/dockerfiles>`.
- **AWS ECS**: Task definition to run the Docker image as an ECS task is placed under `<tasks>/core/<task_name>/app/ecs`.
- **AWS Lambda**: Lambda Function to run the as a Docker container is defined under `<tasks>/core/<task_name>/app/lambda`.

## Project Structure
---

- **`tasks/core/cat_fastq/dockerfiles`**: Directory containing the Dockerfile and entrypoint script.
- **`tasks/core/cat_fastq/app/ecs/app.json`**: ECS task definition file.
- **`tasks/core/cat_fastq/app/ecs_entrypoint.sh`**: Entrypoint script for the Docker container.
- **`tasks/core/cat_fastq/app/lambda/main.py`**: Lambda code for the task.
- **`tasks/core/cat_fastq/app/lambda/lambda_entrypoint.py`**: Lambda entrypoint for the lambda function.

## Setup
---

### Prerequisites
---

- **AWS CLI**: Ensure you have the AWS CLI installed and configured with appropriate permissions.
- **Docker**: Ensure Docker is installed and running.
- **Make**: Ensure `make` is installed.

### Configure Variables
---

Update the Makefile with your AWS account ID, region, and other variables:

- `AWS_ACCOUNT_ID`: Your AWS account ID.
- `AWS_REGION`: Your AWS region.
- `ECS_TASK_DEFINITION_FILE`: Path to your ECS task definition file.
- `LAMBDA_FUNCTION_NAME`: Name of your Lambda function.
- `LAMBDA_ROLE_ARN`: ARN of the IAM role for your Lambda function.

## Usage
---

### Build Docker Image, Register ECS Tasks, create Lambda functions
---

To build the Docker image, use:

```sh
make build
```

We have the targets as:

```text
Usage: make [target]

Targets:
  -all                       Build, tag, and push the Docker images
  -build                     Build all Docker images
  -build-cat-fastq           Build the cat_fastq Docker image
  -tag                       Tag all Docker images
  -tag-ecr-cat-fastq         Tag the cat_fastq Docker image for ECR
  -push                      Push all Docker images to ECR
  -push-ecr-cat-fastq        Push the cat_fastq Docker image to ECR
  -register-ecs-cat-fastq    Register the ECS task definition
  -register-lambda-cat-fastq Register the Lambda function
  -update-lambda-cat-fastq   Update the Lambda function with a new Docker image
  -delete-lambda-cat-fastq   Delete the Lambda function
  -help                      Show this help message
```
---