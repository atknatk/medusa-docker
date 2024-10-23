#!/bin/bash
set -e  # Exit on any error
set -x  # Print each command before executing it
# Check if environment variables are set, if not, assign default values

export MEDUSA_ADMIN_ONBOARDING_TYPE=${MEDUSA_ADMIN_ONBOARDING_TYPE:-default}
export STORE_CORS=${STORE_CORS:-"http://localhost:8000,https://docs.medusajs.com"}
export ADMIN_CORS=${ADMIN_CORS:-"http://localhost:5173,http://localhost:9000,https://docs.medusajs.com"}
export AUTH_CORS=${AUTH_CORS:-"http://localhost:5173,http://localhost:9000,https://docs.medusajs.com"}
export REDIS_URL=${REDIS_URL:-"redis://localhost:6379"}
export JWT_SECRET=${JWT_SECRET:-supersecret}
export COOKIE_SECRET=${COOKIE_SECRET:-supersecret}
export DB_NAME=${DB_NAME:-medusa-app}
export DATABASE_URL=${DATABASE_URL:-"postgres://postgres:postgres@localhost/$DB_NAME"}
export ADMIN_USER=${ADMIN_USER:-"admin@medusa-test.com"}
export ADMIN_PASSWORD=${ADMIN_PASSWORD:-"supersecret"}


# Optionally print out the environment variables for debugging
echo "MEDUSA_ADMIN_ONBOARDING_TYPE=$MEDUSA_ADMIN_ONBOARDING_TYPE"
echo "STORE_CORS=$STORE_CORS"
echo "ADMIN_CORS=$ADMIN_CORS"
echo "AUTH_CORS=$AUTH_CORS"
echo "REDIS_URL=$REDIS_URL"
echo "JWT_SECRET=$JWT_SECRET"
echo "COOKIE_SECRET=$COOKIE_SECRET"
echo "DATABASE_URL=$DATABASE_URL"



# Path to the file that tracks installed plugins
INSTALLED_PLUGINS_FILE="/usr/src/app/.installed_plugins"

# Create the file if it doesn't exist
if [ ! -f "$INSTALLED_PLUGINS_FILE" ]; then
  touch "$INSTALLED_PLUGINS_FILE"
fi

# Handle plugin installation via environment variable
if [ -z "$PLUGINS" ]; then
  echo "No plugins provided."
else
  # Install missing plugins
  IFS=',' read -ra PLUGIN_ARRAY <<< "$PLUGINS"
  for plugin in "${PLUGIN_ARRAY[@]}"; do
    if grep -q "$plugin" "$INSTALLED_PLUGINS_FILE"; then
      echo "Plugin $plugin is already installed. Skipping."
    else
      echo "Plugin $plugin is not installed. Installing..."
      npm install "$plugin"
      echo "$plugin" >> "$INSTALLED_PLUGINS_FILE"
    fi
  done
fi

ADMIN_CREATED_FILE="/usr/src/app/.admin_created"

npm run build
npm run migraton

# Check if the admin user has already been created (based on the existence of the flag file)
if [ -f "$ADMIN_CREATED_FILE" ]; then
  echo "Admin user already exists, skipping admin user creation."
else
  echo "Admin user does not exist, creating the admin user."
  npm run user -- -e $ADMIN_USER -p $ADMIN_PASSWORD

  # Write a flag to indicate the admin user was created
  touch "$ADMIN_CREATED_FILE"
fi

npm run $1