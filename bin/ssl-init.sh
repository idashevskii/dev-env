#!/bin/bash
set -o pipefail  # trace ERR through pipes
set -o errtrace  # trace ERR through 'time command' and other functions
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/../ && pwd )"

cd "$DIR"

source ".env"

SSL_DIR="$GITLAB_HOME/config/ssl"
DIST_DIR="./dist"

mkdir -p "$SSL_DIR"
mkdir -p "$DIST_DIR"

generate(){
  host="$1"
  keyFile="$SSL_DIR/$host.key"
  bundleFile="$SSL_DIR/$host.crt"

  openssl req \
    -newkey rsa:4096 -nodes -sha256 -keyout "$keyFile" \
    -addext "subjectAltName = DNS:$host" \
    -x509 -days 365 -out "$bundleFile"

  # strip pass
  openssl rsa -in "$keyFile" -out "$keyFile"

  # copy to current context, for Dockerfile build
  cp "$bundleFile" "$DIST_DIR"
}

generate "$GITLAB_HOST"

if [ "$GITLAB_HOST" != "$GITLAB_REGISTRY_HOST" ]; then

  generate "$GITLAB_REGISTRY_HOST"

fi

