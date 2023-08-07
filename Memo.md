**ECS**
- 環境変数は、AWS Systems Managerから取得する

**.dockerignore**
ビルド時に不要なファイルを除外する

タスク定義ファイル雛形作成コマンド
```
aws ecs register-task-definition --generate-cli-skeleton  --profile ecs-lesson
```

タスク定義
```
aws ecs register-task-definition --cli-input-json file://ecs-task-definition-for-command.json --profile ecs-lesson
aws ecs register-task-definition --cli-input-json file://ecs-task-definition-for-web.json --profile ecs-lesson
```

タスク実行
```
 aws ecs run-task \
    --cluster ecs-hands-on \
    --task-definition ecs-hands-on-for-command \
    --overrides '{"containerOverrides": [{"name":"laravel","command": ["sh","-c","php artisan -v"]}]}' \
    --launch-type FARGATE \
    --network-configuration "awsvpcConfiguration={subnets={SUBNET},securityGroups={SECURITY_GROUP},assignPublicIp=ENABLED}" \
    --profile ecs-lesson
```
