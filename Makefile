# Default target

help:

# Define variables
IMAGE_NAME_CAT_FASTQ := cat_fastq:latest
AWS_ACCOUNT_ID := XXXXXXXXXXXXX
AWS_REGION := us-east-1
DOCKERFILE_PATH_CAT_FASTQ := ./tasks/core/cat_fastq/dockerfiles
ECS_TASK_DEFINITION_FILE := ./tasks/core/cat_fastq/ecs/app.json
LAMBDA_FUNCTION_NAME := cat_fastq
LAMBDA_ROLE_ARN := arn:aws:iam::XXXXXXXXXXXXX:role/my-lambda-role

# Default target
all: build tag push

# Build all images target
build: build-cat-fastq

# Build targets
build-cat-fastq:
	cd $(DOCKERFILE_PATH_CAT_FASTQ) && ./build.sh

# tag all images target
tag: tag-ecr-cat-fastq

# Tag targets
tag-ecr-cat-fastq:
	docker tag $(IMAGE_NAME_CAT_FASTQ) $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/$(IMAGE_NAME_CAT_FASTQ);

# Push all images target
push: push-ecr-cat-fastq

# push Images
push-ecr-cat-fastq:
	@aws ecr get-login-password --region $(AWS_REGION) | docker login --username AWS --password-stdin $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com;
	@docker push $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/$(IMAGE_NAME_CAT_FASTQ);

# Register ECS Task Definition
register-ecs-cat-fastq:
	@aws ecs register-task-definition \
		--cli-input-json file://$(ECS_TASK_DEFINITION_FILE) \
		--region $(AWS_REGION)

# Register Lambda Function
register-lambda-cat-fastq:
	aws lambda create-function \
		--function-name $(LAMBDA_FUNCTION_NAME) \
		--package-type Image \
		--code ImageUri=$(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/$(IMAGE_NAME_CAT_FASTQ) \
		--role $(LAMBDA_ROLE_ARN) \
		--region $(AWS_REGION) \
		--timeout 900

# Update Lambda Function (if already exists)
update-lambda-cat-fastq:
	aws lambda update-function-code \
		--function-name $(LAMBDA_FUNCTION_NAME) \
		--image-uri $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/$(IMAGE_NAME_CAT_FASTQ) \
		--region $(AWS_REGION)

# Clean up Lambda Function (optional)
delete-lambda-cat-fastq:
	aws lambda delete-function \
		--function-name $(LAMBDA_FUNCTION_NAME) \
		--region $(AWS_REGION)

# Help target
help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  -all                       Build, tag, and push the Docker images"
	@echo "  -build                     Build all Docker images"
	@echo "  -build-cat-fastq           Build the cat_fastq Docker image"
	@echo "  -tag                       Tag all Docker images"
	@echo "  -tag-ecr-cat-fastq         Tag the cat_fastq Docker image for ECR"
	@echo "  -push                      Push all Docker images to ECR"
	@echo "  -push-ecr-cat-fastq        Push the cat_fastq Docker image to ECR"
	@echo "  -register-ecs-cat-fastq    Register the ECS task definition"
	@echo "  -register-lambda-cat-fastq Register the Lambda function"
	@echo "  -update-lambda-cat-fastq   Update the Lambda function with a new Docker image"
	@echo "  -delete-lambda-cat-fastq   Delete the Lambda function"
	@echo "  -help                      Show this help message"