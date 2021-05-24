
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

Add cert to GitLab variable `REGISTRY_CRT` with cert content. In `.gitlab-ci.yml` add:

    variables:
      REGISTRY_CRT: "$REGISTRY_CRT"
    services:
      - name: docker:20-dind
        command:
            - /bin/sh
            - -c
            - echo "$REGISTRY_CRT" > /usr/local/share/ca-certificates/registry.crt && update-ca-certificates && dockerd-entrypoint.sh


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
