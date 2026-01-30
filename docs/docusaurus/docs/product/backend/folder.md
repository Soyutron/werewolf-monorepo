---
sidebar_label: 'フォルダ構成'
sidebar_position: 1
---

# Clean Architecture フォルダ構成ガイド

## フォルダごとの役割まとめ

```
app/
├─ controllers/   ← HTTPの入り口（FastAPIのrouter）
├─ usecases/      ← アプリケーションのユースケース（ビジネスフロー）
├─ services/      ← ドメインロジック or 複雑な処理（純粋処理）
├─ domain/        ← ドメインモデル（Entity / ValueObject / Repository interface）
└─ infra/         ← infra実装（DB, API クライアントなど）
```


***

## 🔵 controllers/（FastAPIのエンドポイント / Router）

### 役割

- エンドポイント（REST API）の入り口
- リクエストを受け取る
- バリデーション（Pydantic Model）
- UseCase を呼び出すだけ
- HTTPレスポンスとしてまとめる


### 書くべきこと

- router
- request/response の schema


### 書かないもの

- ロジック
- DBアクセス

***

## 🟢 usecases/（アプリ全体の「操作」）

### 役割

- 「この操作をすると、何を順番に実行するか」だけを書く
- 1 ユースケース = 1 API に近い感覚
- controller から呼び出される


### 書くべきこと

ビジネスフロー

**例:**

1. DBからユーザー取得
2. パスワードハッシュ比較
3. トークン発行
4. 結果を返す

### 書かないもの

- HTTP の知識
- DB の実処理
- 複雑なドメインロジック（services に分離）

***

## 🟣 services/（ドメインロジック・アルゴリズム）

### 役割

- 純粋ロジックの置き場所
- DDD では DomainService に近い
- 「計算・ルール・判定」など


### 例

- 役職の割り当てロジック（人狼ゲーム）
- 勝敗判定
- テキスト生成の前処理
- パスワードのハッシュロジック（ビジネス側）


### 書かないもの

- 外部リソースアクセス（DB, API）
- HTTP

**⚠️ ポイント:** usecases が肥大化するのを防ぐために services を作る

***

## 🟠 domain/（DDDの中核）

### 役割

- Entity（User, GameRoom, Playerなど）
- ValueObject（Email, Role, etc）
- Repository の interface（抽象）


### ポイント

- ビジネスのルールを最も純粋に持つ場所
- infra に依存しない

***

## 🔴 infra/（実際のDB・外部APIへの実装）

### 役割

- Repository の具象実装（Postgres, SQLite, DynamoDB…）
- 外部APIクライアント
- キャッシュ（Redis）
- S3/Cloud Storage との通信
- ORM（SQLAlchemy）の model や session 管理


### 特長

- domain とは逆で、外部依存の塊
- 「実際どうアクセスするか」を担当する

***

## 🎯 全体像の依存関係（重要）

```
controllers → usecases → services → domain
              ↘ infra (repository実装)
```


### 💡 依存の原則

**上には依存して良いが、下には依存しない**

これが Clean Architecture。

***

## 🔍 人狼ゲームを例にした実装例

| フォルダ | 具体的に何を書くか |
| :-- | :-- |
| **controllers** | `/assign_roles` API の router |
| **usecases** | 役職を割り当て → DB に保存 → レスポンス構築 |
| **services** | 「役職割り当てアルゴリズム」そのもの |
| **domain** | Player, Role, GameRoom などの Entity |
| **infra** | PostgresRepository, RedisSessionStore |

