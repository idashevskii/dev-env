#!/bin/bash
set -o pipefail  # trace ERR through pipes
set -o errtrace  # trace ERR through 'time command' and other functions
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/../ && pwd )"

cd "$DIR"

GITLAB_URL=https://gitlab.example.com/
GITLAB_TOKEN=the-token
PROD_MACHINE_TITLE="Project Prod Runner"


# Run
docker run -d \
    --name gitlab-runner \
    --restart unless-stopped \
    -v /home/user/gitlab-runner:/etc/gitlab-runner \
    -v /var/run/docker.sock:/var/run/docker.sock \
    gitlab/gitlab-runner:latest


# Trust Gitlab Self-Signed SSL if needed

# Copy CRT file into container in folder /home/user/gitlab-runner/gitlab.example.com.crt

# Register

docker exec -it gitlab-runner gitlab-runner register -n \
    --name "$PROD_MACHINE_TITLE" \
    --executor docker \
    --docker-image docker:latest \
    --docker-volumes /var/run/docker.sock:/var/run/docker.sock \
    --docker-volumes /certs/client \
    --docker-volumes /cache \
    --url $GITLAB_URL \
    --registration-token $GITLAB_TOKEN \
    --tag-list prod
