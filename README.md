# 手順

1. composer, laravel, nginxのimageを作成
```
docker build -t ecs-hands-on/composer:latest -f ./docker/composer/Dockerfile .
docker build -t ecs-hands-on/laravel:latest -f ./docker/laravel/Dockerfile .
docker build -t ecs-hands-on/nginx:latest -f ./docker/nginx/Dockerfile .
```

2. アプリケーションの起動
```
docker-compose up -d
```
