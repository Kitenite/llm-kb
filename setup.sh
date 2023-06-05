#!/bin/bash

# Check if docker-compose is installed
command -v docker-compose >/dev/null 2>&1 || { echo >&2 "Docker Compose is required but it's not installed.  Aborting."; exit 1; }

# Copy the .env_example to .env
cp .env_example .env

# Ask the user for the OpenAI API key
read -p "Enter your OpenAI API Key: " openai_key

# Replace the placeholder with the actual OpenAI API key in the .env file
sed -i -e "s/YOUR_API_KEY/$openai_key/g" .env

# Run the openssl commands
openssl rand -base64 756 > mongo-keyfile
chmod 600 mongo-keyfile

echo "Setup is complete."
