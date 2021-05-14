FROM gitlab/gitlab-runner:latest
ARG GITLAB_CRT
COPY $GITLAB_CRT /usr/local/share/ca-certificates/gitlab.crt
RUN update-ca-certificates
