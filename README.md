# Rancher-webhook

This is a small application that listens for notifications from a Docker registry webhook and automatically upgrades the service in Rancher.

## Installation
1. Create a new API key in Rancher 
2. Use the given docker-compose.yml to create a new Rancher stack
3. Update the environment variables with the API key and Rancher URL
4. Configure your Docker Hub container to send a webhook to "https://{your_url}/docker_hub"

## Configuration
Add the RANCHER_NON_OVERLAPPED_UPGRADES=true environment variable to any container that can't be started before it's stopped (useful if you're exposing ports from the container.)