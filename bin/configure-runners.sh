#!/bin/bash
set -o pipefail  # trace ERR through pipes
set -o errtrace  # trace ERR through 'time command' and other functions
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/../ && pwd )"

cd "$DIR"

GITLAB_HOST="gitlab.example.com"
GITLAB_URL="https://${GITLAB_HOST}:8080/"
GITLAB_TOKEN="token"
RUNNER_CONTAINER_NAME="gitlab-runner"
PATH_TO_VOLUMES="/srv"

# Step 1. Run
docker run -d \
    --name "$RUNNER_CONTAINER_NAME" \
    --restart unless-stopped \
    -v "$PATH_TO_VOLUMES/$RUNNER_CONTAINER_NAME:/etc/gitlab-runner" \
    -v /var/run/docker.sock:/var/run/docker.sock \
    gitlab/gitlab-runner:latest


# Step 2. Trust Gitlab Self-Signed SSL if needed

# Copy CRT file into container in folder $PATH_TO_VOLUMES/$RUNNER_CONTAINER_NAME/certs/${GITLAB_HOST}.crt

# Step 3. Register

docker exec -it "$RUNNER_CONTAINER_NAME" gitlab-runner register -n \
    --name "Deploy Prod" \
    --executor docker \
    --docker-image docker:latest \
    --docker-volumes /var/run/docker.sock:/var/run/docker.sock \
    --docker-volumes /certs/client \
    --docker-volumes /cache \
    --url $GITLAB_URL \
    --registration-token $GITLAB_TOKEN \
    --tag-list "deploy-prod"

# Step 3. Register DIND-based runner

echo "Optional: register DIND runner"
exit 0

docker exec -it "$RUNNER_CONTAINER_NAME" gitlab-runner register -n \
    --name "Build DIND" \
    --executor docker \
    --docker-image docker:latest \
    --docker-volumes /certs/client \
    --docker-volumes /cache \
    --docker-privileged=true \
    --url $GITLAB_URL \
    --registration-token $GITLAB_TOKEN \
    --tag-list "build-dind"

