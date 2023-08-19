**ECRプッシュ**
```
sh tools/aws-ecr-login.sh

sh tools/util.sh build
sh tools/util.sh push
```

**タスク定義**
```
sh tools/util.sh createTaskDefinition
```

**バッチ処理**
```
sh tools/util.sh batch
```


**デプロイ**
```
sh tools/util.sh deploy
```
