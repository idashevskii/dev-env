
# Services
- GitLab
- GitLab Runner
- GitLab Registry
- Redmine

# SSL

To Generate Self Signed certs, run `./bin/ssl-init.sh`

*Note*: `.env` should be configured first.

Make generated cert trusted: https://docs.docker.com/registry/insecure/.

In ArchLinux:
    
    $ trust anchor $GITLAB_HOME/config/ssl/$GITLAB_HOST.key

If Registry is runing on different host:

    $ trust anchor $GITLAB_HOME/config/ssl/$GITLAB_REGISTRY_HOST.key


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
