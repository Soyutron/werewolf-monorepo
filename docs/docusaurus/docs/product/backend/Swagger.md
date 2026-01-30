---
sidebar_label: "Swagger"
sidebar_position: 2
---

# FastAPI の Swagger 完全ガイド

## ✅ 1. FastAPI の Swagger とは何か？

FastAPI は内部で **OpenAPI（旧 Swagger 仕様）** を自動生成します。そしてブラウザで動くドキュメントと API テスタを自動で提供します。

FastAPI が提供する UI は 2 種類：

| URL                                | 説明                       |
| ---------------------------------- | -------------------------- |
| http://localhost:8000/docs         | Swagger UI（操作しやすい） |
| http://localhost:8000/redoc        | ReDoc（読み物として優秀）  |
| http://localhost:8000/openapi.json | JSON                       |

## ✅ 2. Swagger UI の主な機能

### ✔ API の一覧が見える

`@app.get()` や `@app.post()` で定義した API が自動でリスト化されます。

### ✔ スキーマ（モデル）も自動生成

Pydantic モデル（BaseModel）を使うと自動で入力 / 出力スキーマが表示されます。

### ✔ API をそのまま試せる（Try it out）

UI 上で Request Body を入力 → 実行 → Response が返る。

### ✔ 認証ヘッダー入力もできる

FastAPI の OAuth2PasswordBearer や API Key も自動対応。

## 🔥 3. 自動生成される理由

FastAPI は以下の情報から OpenAPI JSON を自動生成します：

- 型ヒント（`str`, `int`, `List[str]`）
- Pydantic のモデル（`BaseModel`）
- エンドポイントのメタ情報

## ✨ 4. 使用例（シンプル）

```python
from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()

class User(BaseModel):
    name: str
    age: int

@app.post("/users")
def create_user(user: User):
    return {"message": "ok", "user": user}
```

→ `/docs` を開くと、POST `/users` の request body に User モデルの入力欄が自動で表示される。

## 🎨 5. Swagger UI のカスタマイズ方法

### ① タイトル・説明を変更

```python
app = FastAPI(
    title="AI Werewolf API",
    description="AI人狼ゲームの専用APIです。",
    version="1.0.0",
)
```

### ② /docs や /redoc のパスを変える（リリース用）

```python
app = FastAPI(
    docs_url="/swagger",
    redoc_url="/redoc",
    openapi_url="/openapi.json",
)
```

### ③ Swagger UI を無効化（本番向け）

```python
app = FastAPI(docs_url=None, redoc_url=None)
```

※セキュリティ上、本番で Swagger を公開しないのはよくある構成。

## 🧩 6. タグで API をグルーピングすると見やすい

```python
@app.get("/vote", tags=["game"])
def vote():
    pass

@app.post("/discuss", tags=["game"])
def discuss():
    pass

@app.post("/auth/login", tags=["auth"])
def login():
    pass
```

→ Swagger で `auth` / `game` にグループ分けされて整理される。

## 🔐 7. 認証付き API（Bearer Token）の Swagger 表示

```python
from fastapi.security import OAuth2PasswordBearer

oauth_scheme = OAuth2PasswordBearer(tokenUrl="/auth/login")

@app.get("/me")
def me(token: str = Depends(oauth_scheme)):
    return {"token": token}
```

Swagger に「**Authorize 🔒**」ボタンが追加され、トークンを入れると全 API に自動付与される。

## 📝 8. 注意点（FastAPI 初心者がよくハマる）

### ❌ response_model を正しく設定しないと Swagger の型が狂う

**悪い例：**

```python
@app.get("/users")
def get_users():
    return [{"name": "A"}]   # でも response_model を書いてない
```

Swagger では「object」のままになる。

**正解：**

```python
from typing import List

@app.get("/users", response_model=List[User])
def get_users():
    return [{"name": "A"}]
```

### ❌ Python の dict だけ返しているとスキーマが使われない

Pydantic モデルを使うべき。

### ❌ 本番で Swagger を公開しっぱなしは危険

認証テストがそのままできてしまうため、公開環境では `docs_url=None` 推奨。

## 🎯 まとめ（最重要ポイント）

- FastAPI の Swagger は **OpenAPI の自動ドキュメント**
- `/docs` で Swagger UI が見える
- Pydantic モデルから自動でスキーマ生成
- API の実行テストまで UI 上で可能
- タグ・タイトル・パス変更で柔軟にカスタマイズ
- **本番では無効化することが多い**
