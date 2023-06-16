#!/bin/bash

# Check if docker-compose is installed
command -v docker-compose >/dev/null 2>&1 || { echo >&2 "Docker Compose is required but it's not installed.  Aborting."; exit 1; }

# Copy the .env_example to .env
cp .env_example .env

# Ask the user for the OpenAI API key
read -p "Enter your OpenAI API Key: " openai_key

# Replace the placeholder with the actual OpenAI API key in the .env file
sed -i -e "s/YOUR_API_KEY/$openai_key/g" .env

# Ask the user for the OpenAI API key (Optional)
read -p "Enter your Github Token (Optional): \nAs a prerequisite, you will need to generate a "classic" personal access token with the repo and read:org scopes. See link for instructions: https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token" github_token
sed -i -e "s/YOUR_GITHUB_TOKEN/$github_token/g" .env

# FOR MACOS: If you are using a Mac, replace the sed command line with this one:
# sed -i "" -e "s/YOUR_API_KEY/$openai_key/g" .env

# Run the openssl commands
openssl rand -base64 756 > mongo-keyfile
chmod 600 mongo-keyfile

echo "Setup is complete."
