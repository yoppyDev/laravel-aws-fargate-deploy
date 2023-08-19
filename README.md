**ECRプッシュ**
```
sh tools/aws-ecr-login.sh

sh tools/util.sh build
sh tools/util.sh push
```


**バッチ処理**
```
sh tools/util.sh runTask
```


**デプロイ**
```
sh tools/util.sh createService
```
