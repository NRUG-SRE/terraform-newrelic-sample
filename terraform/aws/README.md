# AWSデモ環境構築
## Terraform実行に必要な事前準備
- AWS認証情報

```shell
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
```

- `terraform.tfvars`へNew Relicライセンスキーを記述

```text
new_relic_license_key = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxNRAL"
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

- [gossm](https://github.com/gjbae1212/gossm)でEC2インスタンスに接続
```shell
gossm start
```

- デモアプリケーションの起動
```shell
sudo -i
git clone https://github.com/NRUG-SRE/terraform-newrelic-sample.git
cd terraform-newrelic-sample/app
source /root/.bash_profile
go mod tidy
go mod download
docker compose up -d
```

- ALBのヘルスチェックが通ったら`http://{ALB_DNS_NAME}/bff/tracing-demo`へアクセスする
