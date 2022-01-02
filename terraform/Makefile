-include .env

.PHONY: help
help: ## 各makeコマンドの説明を表示します
	@grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: plan
plan: ## 実行計画の確認
	terraform plan -var-file .tfvars

.PHONY: apply
apply: ## リソース構築
	terraform apply -auto-approve -var-file .tfvars

.PHONY: destroy
destroy: ## リソース削除
	terraform destroy -auto-approve -var-file .tfvars