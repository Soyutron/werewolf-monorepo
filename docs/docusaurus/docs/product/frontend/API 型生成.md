# API 型生成（OpenAPI → TypeScript）

本プロジェクトでは **FastAPI の OpenAPI スキーマから Next.js 用の TypeScript 型を自動生成** しています。

型生成には `openapi-typescript` を使用しており、モノリポのルートからコマンドを実行できます。

## 🔧 型生成の前提条件

### 1. バックエンド（FastAPI）が起動していること

FastAPI が `http://localhost:8000` で動作している必要があります。

```bash
make backend      # または make dev
```

### 2. フロントエンド側に openapi-typescript がインストールされていること

`apps/frontend` に `devDependencies` としてインストールしています。

## 🛠️ 型生成コマンド（make）

バックエンドが起動していれば、以下のコマンドで型を生成できます：

```bash
make gen-api
```

### このコマンドは次を実行します：

- `apps/frontend` ディレクトリへ移動
- 最新の OpenAPI スキーマを取得
- `src/types/api.ts` に TypeScript 型を自動生成

### 実際の処理内容：

```makefile
gen-api:
	cd apps/frontend && \
	npx openapi-typescript http://localhost:8000/openapi.json \
	  -o types/api.ts
```

## 📄 出力ファイル

生成された型定義は以下に書き込まれます：

```
apps/frontend/types/api.ts
```

Next.js の API 呼び出しで安全に型を利用できるようになります。

## 📝 注意点

- **バックエンドが起動していない状態で `make gen-api` を実行すると、OpenAPI スキーマが取得できずエラーになります。**
- **API を変更した後は、必ず `make gen-api` を実行して型を更新してください。**
