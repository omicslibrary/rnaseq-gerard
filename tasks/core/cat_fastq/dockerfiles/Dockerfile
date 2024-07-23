FROM amazonlinux:2

# Install dependencies
RUN yum install -y \
    aws-cli \
    coreutils \
    && yum clean all

# Copy the ECS entry point script
COPY ecs_entrypoint.sh /usr/local/bin/ecs_entrypoint.sh

# Copy the Lambda entry point script
COPY lambda_entrypoint.sh /usr/local/bin/lambda_entrypoint.sh

# Make the scripts executable
RUN chmod +x /usr/local/bin/ecs_entrypoint.sh
RUN chmod +x /usr/local/bin/lambda_entrypoint.sh

# Default entry point script for ECS
ENTRYPOINT ["/usr/local/bin/ecs_entrypoint.sh"]
