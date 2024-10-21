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

# Default environment variables (can be overridden at runtime)
ENV STORE_CORS=http://localhost:8000,https://docs.medusajs.com
ENV ADMIN_CORS=http://localhost:5173,http://localhost:9000,https://docs.medusajs.com
ENV AUTH_CORS=http://localhost:5173,http://localhost:9000,https://docs.medusajs.com
ENV REDIS_URL=redis://localhost:6379
ENV JWT_SECRET=supersecret
ENV COOKIE_SECRET=supersecret
ENV DATABASE_URL=postgres://medusa:medusa@localhost:5432/medusa

# Create the non-root user in the production stage
RUN adduser -D -h $USER_HOME -s /bin/sh $USER_NAME

# Set the working directory for the final stage
WORKDIR /usr/src/app

# Copy the Medusa application from the builder stage
COPY --from=builder /usr/src/app/medusa-app /usr/src/app/

# Switch to the non-root user
USER $USER_NAME

# Expose the necessary port (Medusa uses 9000 by default)
EXPOSE 9000

# Define the entrypoint to the application
ENTRYPOINT ["npm", "start"]
