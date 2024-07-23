#!/bin/bash

# Define variables for your image
IMAGE_NAME="cat_fastq"
IMAGE_TAG="latest"
TEMP_DIR="./temp"

# List of folders and files to include in the Docker image
INCLUDE_FILES=("../app")

# Function to check if a directory exists
directory_exists() {
  if [ -d "$1" ]; then
    return 0
  else
    return 1
  fi
}

# Create a temporary directory if it doesn't exist
if ! directory_exists "$TEMP_DIR"; then
  mkdir -p "$TEMP_DIR"
fi

# Copy specified folders and files to the temporary directory
for item in "${INCLUDE_FILES[@]}"; do
  cp -r "$item" "$TEMP_DIR"
done

# Build the Docker image with the contents of the temporary directory
docker build -t "$IMAGE_NAME:$IMAGE_TAG" .

# Check if the build was successful
if [ $? -eq 0 ]; then
  echo "Docker image $IMAGE_NAME:$IMAGE_TAG built successfully."
else
  echo "Docker image build failed."
  exit 1
fi

# Clean up the temporary directory
rm -rf "$TEMP_DIR"
