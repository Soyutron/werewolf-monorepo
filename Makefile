# ================================
# AI Werewolf - Project Makefile
# ================================

.DEFAULT_GOAL := help
DC = docker compose

# ---------------------------
# Development
# ---------------------------

dev: ## 開発環境すべて起動
	$(DC) -f docker-compose.dev.yml up --build

dev-bg: ## 開発環境をバックグラウンド起動
	$(DC) -f docker-compose.dev.yml up --build -d

dev-down: ## 開発環境停止
	$(DC) -f docker-compose.dev.yml down

logs: ## 全コンテナログ
	$(DC) logs -f

# ---------------------------
# Individual services (dev)
# ---------------------------

frontend: ## Next.js フロントエンド起動
	$(DC) -f docker-compose.dev.yml up frontend

frontend-build: ## Next.js 再ビルド（依存更新/Dockerfile変更時）
	$(DC) -f docker-compose.dev.yml rm -f frontend
	$(DC) -f docker-compose.dev.yml build --no-cache frontend
	$(DC) -f docker-compose.dev.yml up frontend

backend: ## FastAPI バックエンド起動
	$(DC) -f docker-compose.dev.yml up backend

backend-build: ## FastAPI 再ビルド（依存更新/Dockerfile変更時）
	$(DC) -f docker-compose.dev.yml rm -f backend
	$(DC) -f docker-compose.dev.yml build --no-cache backend
	$(DC) -f docker-compose.dev.yml up backend

fullstack: ## フロント＆バック同時起動
	$(DC) -f docker-compose.dev.yml up frontend backend

fullstack-build: ## フロント＆バック同時再ビルド
	$(DC) -f docker-compose.dev.yml rm -f frontend backend
	$(DC) -f docker-compose.dev.yml build --no-cache frontend backend
	$(DC) -f docker-compose.dev.yml up frontend backend

fullstack-down: ## フロント＆バックのみ停止（redisは動いたまま）
	$(DC) -f docker-compose.dev.yml down frontend backend

docs-up: ## Docusaurus 起動
	$(DC) -f docker-compose.dev.yml up docusaurus

docs-build: ## Docusaurus 再ビルド（依存更新/Dockerfile変更時）
	$(DC) -f docker-compose.dev.yml rm -f docusaurus
	$(DC) -f docker-compose.dev.yml build --no-cache docusaurus
	$(DC) -f docker-compose.dev.yml up docusaurus

# ---------------------------
# Production
# ---------------------------

prod: ## 本番環境を起動
	$(DC) -f docker-compose.prod.yml down
	$(DC) -f docker-compose.prod.yml build --no-cache
# 	$(DC) -f docker-compose.prod.yml up -d
	$(DC) -f docker-compose.prod.yml up

prod-down: ## 本番環境停止
	$(DC) -f docker-compose.prod.yml down

# ---------------------------
# Utility
# ---------------------------

gen-api: ## API 型生成
	cd apps/frontend && npx openapi-typescript http://localhost:8000/openapi.json -o types/api.ts

rebuild: ## キャッシュクリア（再ビルド用）
	$(DC) build --no-cache

clean: ## ボリューム/孤立コンテナ削除
	$(DC) down --remove-orphans
	docker volume prune -f

# ---------------------------
# Help
# ---------------------------

help: ## コマンド一覧を表示
	@echo ""
	@echo "Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' Makefile | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'
	@echo ""
