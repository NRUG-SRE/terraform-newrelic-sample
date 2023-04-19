# AWSデモ環境構築
## Terraform実行に必要な事前準備
- `terraform.tfvars`へNew RelicライセンスキーおよびAWSの認証情報を記述

```text
new_relic_license_key = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxNRAL"
aws_access_key_id = ""
aws_secret_access_key = ""
```

## 環境構築手順
### TerraformによるAWS環境構築
- 以下コマンドを実行
 
```shell
cd terraform/aws
terraform init
terraform plan
terraform apply
```

### インスタンスへの接続
- [gossm](https://github.com/gjbae1212/gossm)でEC2インスタンスに接続

```shell
gossm start
```

### デモアプリケーションの起動
```shell
sudo -i
git clone https://github.com/NRUG-SRE/terraform-newrelic-sample.git
cd terraform-newrelic-sample/app
go mod tidy
go mod download
docker compose build
docker compose up -d
```

### 接続確認
- ALBのヘルスチェックが通ったら`http://{ALB_DNS_NAME}/bff/tracing-demo`へアクセスする
