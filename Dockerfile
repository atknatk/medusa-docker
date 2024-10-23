# Stage 1: Build stage
FROM node:20 AS builder

# Set environment variables for project setup and default values
ENV PROJECT_NAME=medusa-app
ENV ADMIN_EMAIL=admin@medusa-test.com
ENV DATABASE_URL=postgres://medusa:medusa@localhost:5432/medusa

# Install create-medusa-app globally and expect
RUN npm install -g create-medusa-app && apt-get update && apt-get install -y expect

# Set the working directory for the build process
WORKDIR /usr/src/app

# Copy the expect script into the container
COPY medusa-app /usr/src/app/medusa-app

# Create the non-root user after the project has been created
RUN useradd -ms /bin/bash medusa

# Stage 2: Production stage
FROM node:20-alpine

# Set environment variables for user creation and default values
ENV USER_NAME=medusa
ENV USER_HOME=/home/$USER_NAME
ENV PROJECT_NAME=medusa-app
RUN apk add --no-cache bash

# Create the non-root user in the production stage
RUN adduser -D -h $USER_HOME -s /bin/sh $USER_NAME

# Set the working directory for the final stage
WORKDIR /usr/src/app

# Copy the Medusa application from the builder stage
COPY --from=builder /usr/src/app/medusa-app /usr/src/app/

# Create the .medusa directory and give ownership to the non-root user
RUN mkdir -p /usr/src/app/.medusa
RUN chown -R $USER_NAME:$USER_NAME /usr/src/app

# Copy the run.sh script and make it executable
COPY ./script/run.sh /usr/src/app/run.sh
RUN chmod +x /usr/src/app/run.sh

# Install medusa-cli globally
RUN npm i -g medusa-cli

# Switch to the non-root user
USER $USER_NAME

# Expose the necessary port (Medusa uses 9000 by default)
EXPOSE 9000

# Define the entrypoint to the application
ENTRYPOINT ["/usr/src/app/run.sh", "start:prod"]
