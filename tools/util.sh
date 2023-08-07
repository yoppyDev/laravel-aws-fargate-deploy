#!/bin/sh

set -u
. "$(cd "$(dirname "$0")/../" && pwd)/.env"

create-service()
{
 aws ecs create-service \
    --cluster ecs-hands-on \
    --service-name ecs-hands-on-laravel \
    --task-definition ecs-hands-on-for-web \
    --launch-type FARGATE \
    --desired-count 1 \
    --network-configuration "awsvpcConfiguration={subnets=${SUBNET},securityGroups=${SECURITY_GROUP},assignPublicIp=ENABLED}" \
    --profile ecs-lesson
}

build()
{
    docker build --platform=linux/amd64 \
        -t ${IMAGE_TAG}/laravel:latest \
        -f ./docker/laravel/Dockerfile .

    docker build --platform=linux/amd64 \
        -t ${IMAGE_TAG}/nginx:latest \
        -f ./docker/nginx/Dockerfile .
}

push()
{
    docker tag ${IMAGE_TAG}/laravel:latest \
        ${REGISTRY_URL}/${IMAGE_TAG}/laravel:latest

    docker tag ${IMAGE_TAG}/nginx:latest \
        ${REGISTRY_URL}/${IMAGE_TAG}/nginx:latest

    docker push ${REGISTRY_URL}/${IMAGE_TAG}/laravel:latest
    docker push ${REGISTRY_URL}/${IMAGE_TAG}/nginx:latest
}


[ "$#" -ge 1 ] || usage
$1 "${2:-""}"
exit 0
