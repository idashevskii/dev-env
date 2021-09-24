
# Services
- GitLab
- GitLab Runner
- GitLab Registry
- Redmine

# Prod

For prod deploys to Docker/Docker Swarm set-up standalone Docker Runner on Prod machine.

https://github.com/tiangolo/dockerswarm.rocks/blob/master/docs/gitlab-ci.md

See ./bin/prod-runner.sh

** NOTE! ** Make sure your job uses specified runner. User tags section in `.gitlab-ci.yml`

# SSL

To Generate Self Signed certs, run `./bin/ssl-init.sh`

*Note*: `.env` should be configured first.

Make generated cert trusted: https://docs.docker.com/registry/insecure/.

In ArchLinux:
    
    $ trust anchor $GITLAB_HOME/config/ssl/$GITLAB_HOST.crt

If Registry is runing on different host (e.g. also for ArchLinux):

    $ trust anchor $GITLAB_HOME/config/ssl/$GITLAB_REGISTRY_HOST.crt

## Docker-in-docker (dind)

For dind, additionaly, define corresponding serivice in `.gitlab-ci.yml` as following:

    services:
      - name: docker:dind
        entrypoint: ["dockerd-entrypoint.sh"]
        command: ["--insecure-registry", "example.com:5000"]

Note! The port of registry is not matching with gitlab port!


# GitLab Runner

https://docs.gitlab.com/runner/register/

Register:

    $ docker-compose exec gitlab-runner gitlab-runner register


# Redmine

## UTF8 Issue

In DBeaver run

    SELECT CONCAT('ALTER TABLE `', TABLE_NAME, '` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;') AS mySQL
    FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA= "redmine" AND TABLE_TYPE="BASE TABLE"

And then execute output as SQL query

## Open Source Themes

- https://github.com/mrliptontea/PurpleMine2

## Open Source Kanban

- https://git.framasoft.org/infopiiaf/redhopper




# Docker Swarm Setup

    # Manager innernal network IP
    MANAGER_ADDR="10.9.8.1"

    # On Manager:
    docker swarm init --advertise-addr $MANAGER_ADDR

    # On Nodes - use output command from prev stap. To show it again:
    docker swarm join-token worker

You may need to login to Private Registry on each node from root.

You may not login because error:

    Error saving credentials: error storing credentials - err: exit status 1, out: `Cannot autolaunch D-Bus without X11 $DISPLAY`

To solve that on Debian it is possible to remove (not recommended solution) golang-docker-credential-helpers without removing docker-compose:

    dpkg -r --ignore-depends=golang-docker-credential-helpers golang-docker-credential-helpers

