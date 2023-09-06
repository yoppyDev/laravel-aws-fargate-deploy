#!/bin/sh

set -u
. "$(cd "$(dirname "$0")/../" && pwd)/.env"


createTaskDefinition()
{
    aws ecs register-task-definition --cli-input-json file://ecs-task-definition-for-command.json
    aws ecs register-task-definition --cli-input-json file://ecs-task-definition-for-web.json
}

batch()
{
 aws ecs run-task \
    --cluster ecs-hands-on \
    --task-definition ecs-hands-on-for-command \
    --overrides '{"containerOverrides": [{"name":"laravel","command": ["sh","-c","php artisan -v"]}]}' \
    --launch-type FARGATE \
    --network-configuration "awsvpcConfiguration={subnets=[${SUBNET_1}],securityGroups=[${SECURITY_GROUP}],assignPublicIp=ENABLED}"
}

deploy()
{
 aws ecs create-service \
    --cluster ecs-hands-on \
    --service-name ecs-hands-on-laravel \
    --task-definition ecs-hands-on-for-web \
    --launch-type FARGATE \
    --desired-count 1 \
    --network-configuration "awsvpcConfiguration={subnets=[${SUBNET_1}],securityGroups=[${SECURITY_GROUP}],assignPublicIp=ENABLED}"
}


arnDeploy()
{
    aws ecs create-service \
        --cluster ecs-hands-on \
        --service-name ecs-hands-on-laravel \
        --task-definition ecs-hands-on-for-web \
        --launch-type FARGATE \
        --load-balancers `[{"containerName":"nginx","containerPort":80,"targetGroupArn":"${TARGET_GROUP_ARN}"}]` \
        --desired-count 2 \
        --network-configuration "awsvpcConfiguration={subnets=[${SUBNET_1},${SUBNET_2}],securityGroups=[${SECURITY_GROUP}],assignPublicIp=ENABLED}"
}

updateService()
{
    aws ecs update-service \
        --cluster ecs-hands-on \
        --service ecs-hands-on-laravel \
        --task-definition ecs-hands-on-for-web
}


build()
{
    docker build --platform=linux/amd64 \
        -t ${IMAGE_TAG}/composer:latest \
        -f ./docker/composer/Dockerfile .

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
