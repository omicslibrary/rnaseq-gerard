import boto3
import os
import subprocess

s3 = boto3.client("s3")


def lambda_handler(event, context):
    """
    AWS Lambda function to concatenate FASTQ files from an S3 bucket, generate a version file,
    and upload the results back to the S3 bucket.

    Parameters:
    event (dict): Event payload containing the following keys:
        - bucket (str): The S3 bucket name where the input files are stored and where outputs will be saved.
        - input_files (list): A list of input file paths in the S3 bucket to be concatenated.

    context (object): Lambda Context runtime methods and attributes (not used in this function).

    Returns:
    dict: A dictionary with the following keys:
        - statusCode (int): The HTTP status code of the response.
        - body (str): A message indicating the result of the operation.
        - output_files (dict): Paths to the output files in the S3 bucket.
        - metadata (str): Metadata string including the version of the `cat` utility used.

    The function performs the following steps:
    1. Downloads the input files from the specified S3 bucket to the /tmp directory.
    2. Concatenates the input files into a single output file (/tmp/merged.fastq.gz).
    3. Generates a version file (/tmp/versions.yml) containing the version of the `cat` utility.
    4. Uploads the concatenated output file and the version file to the specified S3 bucket.
    """
    bucket = event["bucket"]
    input_files = event["input_files"]
    output_file = "/tmp/merged.fastq.gz"
    version_file = "/tmp/versions.yml"

    # Download input files from S3
    for file in input_files:
        s3.download_file(bucket, file, f"/tmp/{os.path.basename(file)}")

    # Concatenate files
    with open(output_file, "wb") as outfile:
        for file in input_files:
            with open(f"/tmp/{os.path.basename(file)}", "rb") as infile:
                outfile.write(infile.read())

    # Write versions.yml
    cat_version = subprocess.check_output(
        "cat --version | sed 's/^.*coreutils) //; s/ .*$//'", shell=True
    )
    metadata = f"CAT_FASTQ:\n  cat: {cat_version.decode('utf-8')}"
    with open(version_file, "w") as vf:
        vf.write(metadata)

    # Upload results to S3
    s3.upload_file(output_file, bucket, "output/merged.fastq.gz")
    s3.upload_file(version_file, bucket, "output/versions.yml")

    return {
        "statusCode": 200,
        "body": "Files merged and uploaded successfully",
        "output_files": {
            "merged_fastq": f"s3://{bucket}/output/merged.fastq.gz",
            "versions_yml": f"s3://{bucket}/output/versions.yml",
        },
        "metadata": metadata,
    }
