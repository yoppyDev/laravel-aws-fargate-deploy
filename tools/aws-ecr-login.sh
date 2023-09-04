#!/bin/sh

set -u
. "$(cd "$(dirname "$0")/../" && pwd)/.env"

aws ecr get-login-password --region ap-northeast-1 |
  docker login --username AWS --password-stdin "${REGISTRY_URL}"
