FROM amazonlinux:2

# Install dependencies
RUN yum install -y \
    aws-cli \
    coreutils \
    && yum clean all

# Copy the AWS Lambda Runtime Interface Emulator
ADD https://github.com/aws/aws-lambda-runtime-interface-emulator/releases/latest/download/aws-lambda-rie /usr/local/bin/aws-lambda-rie

COPY temp/app/entrypoint.sh /usr/local/bin/entrypoint.sh

# Copy the Lambda handler script into the image
COPY temp/app/lambda/app.py /var/task/app.py

# Copy the ECS entry point script
COPY temp/app/ecs/ecs_entrypoint.sh /usr/local/bin/ecs_entrypoint.sh

# Copy the Lambda entry point script
COPY temp/app/lambda/lambda_entrypoint.sh /usr/local/bin/lambda_entrypoint.sh

# Make the scripts executable
RUN chmod +x /usr/local/bin/ecs_entrypoint.sh
RUN chmod +x /usr/local/bin/lambda_entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Make the RIE and entry point scripts executable
RUN chmod +x /usr/local/bin/aws-lambda-rie

# Default entry point script for ECS
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
