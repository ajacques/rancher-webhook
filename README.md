# Rancher-webhook

This is a small application that listens for notifications from a Docker registry webhook and automatically upgrades the service in Rancher.

## Installation
1. Create a new API key in Rancher 
2. Use the given docker-compose.yml to create a new Rancher stack
3. Update the environment variables with the API key and Rancher URL
4. Configure your Docker Hub container to send a webhook to "https://{your_url}/docker_hub"

## Example
```
 scheduler:
  image: ajacques/rancher-webhook:latest
  environment:
    RAILS_ENV: production
    REDIS_URI: redis:6379/resque
  cap_drop:
  - ALL
  links:
  - redis:redis
  command:
  - rake
  - resque:scheduler
Agent:
  image: ajacques/rancher-webhook:latest
  environment:
    RAILS_ENV: production
    REDIS_URI: redis:6379/resque
  cap_drop:
  - ALL
  links:
  - redis:redis
worker:
  image: ajacques/rancher-webhook:latest
  environment:
    QUEUE: '*'
    RAILS_ENV: production
    RANCHER_ACCESS_KEY: {YOUR_ACCESS_KEY}
    RANCHER_SECRET_KEY: {YOUR_RANCHER_SECRET_KEY}
    RANCHER_URI: https://{YOUR_RANCHER_HOST}/v1/projects/1a5
    REDIS_URI: redis:6379/resque
  cap_drop:
  - ALL
  links:
  - redis:redis
  command:
  - rake
  - resque:work
redis:
  image: redis:3.0.7-alpine
```

## Configuration
Add the RANCHER_NON_OVERLAPPED_UPGRADES=true environment variable to any container that can't be started before it's stopped (useful if you're exposing ports from the container.)
