# Observability as Codeハンズオン

## 前提条件
- AWSハンズオン環境構築が完了していること

## Terraform実行に必要な事前準備
- `terraform/handson/terraform.tfvars`へ次の情報情報を記述

```text
new_relic_api_key = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxNRAL"
new_relic_account_id = "XXXXXXX"
aws_access_key_id = ""
aws_secret_access_key = ""
```

## Terraformコマンド実行確認
- 次のコマンドが実行できることを確認できたらハンズオン実施準備ができている状態です

```shell
cd terraform/handson
terraform init
terraform plan
terraform apply
```

## ハンズオン終了後
- 次のコマンドでリソースを削除できます
- エラーが表示された場合、もう一度`terraform destroy`を実行してください

```shell
cd terraform/handson
terraform destroy
```
