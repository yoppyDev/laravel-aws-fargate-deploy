#!/bin/sh

set -u
. "$(cd "$(dirname "$0")/../" && pwd)/.env"

aws ecr get-login-password --region us-east-1 --profile ecs-lesson |
  docker login --username AWS --password-stdin "${REGISTRY_URL}"
