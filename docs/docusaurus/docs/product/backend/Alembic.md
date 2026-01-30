# Alembic セットアップガイド

このガイドでは、FastAPI プロジェクトに Alembic を導入し、データベースマイグレーションを管理する手順を解説します。難しい知識は不要で、**モデルを作る → autogenerate → upgrade** の 3 ステップが基本です。

## STEP 1：Alembic をプロジェクトに初期化する

まず、FastAPI バックエンドディレクトリで以下のコマンドを実行します：

```bash
uv run alembic init alembic
```

このコマンドにより、以下のディレクトリ構造が作成されます：

```
alembic/
  ├── env.py
  ├── script.py.mako
  └── versions/   ← マイグレーションファイルが入るフォルダ
alembic.ini
```

これで Alembic が使える状態になります。

## STEP 2：env.py を SQLAlchemy モデルを読み込める形にする

Alembic が自動生成機能を使うには、`env.py` に「どのモデルを対象にするか」を教える必要があります。

あなたの構成では、モデルは以下のディレクトリに配置されます：

```
app/models/*.py
```

**重要**: モデルファイルが存在しないと Alembic は動作しないため、次のステップでモデルを作成します。`env.py` の完成版は後ほど提供されるので、それをコピー＆ペーストするだけで OK です。

## STEP 3：SQLAlchemy モデル（ORM）を作成する

データベース設計に基づいて、すべてのテーブルに対応する SQLAlchemy モデルを作成します。

**例（rooms テーブル）**:

```python
# app/models/rooms.py
from sqlalchemy import Column, Integer, BigInteger, String, TIMESTAMP, text
from app.core.db import Base

class Room(Base):
    __tablename__ = "rooms"

    id = Column(Integer, primary_key=True, index=True)
    room_id = Column(BigInteger, nullable=False)
    room_name = Column(String(255), nullable=False)
    type = Column(String(50), server_default="group", nullable=False)
```

このようなモデルファイルを全テーブル分作成します。「models 作って」とリクエストすれば、全ファイルを生成できます。

## STEP 4：マイグレーションファイルを作成する

モデルが完成したら、Alembic に自動生成させます：

```bash
uv run alembic revision --autogenerate -m "initial tables"
```

このコマンドにより、`versions/xxxxx_initial_tables.py` が生成されます。中身は Alembic が自動的に作成してくれます。

## STEP 5：PostgreSQL に反映（アップグレード）する

最後に、以下のコマンドでマイグレーションを実行します：

```bash
uv run alembic upgrade head
```

**実行結果**:

- ✅ テーブルが全部作成される
- ✅ 本番環境でも同じコマンドで適用できる

---

## まとめ

これで Alembic のセットアップは完了です！難しいことを知らなくても問題ありません。

**重要なポイントは以下の 3 ステップだけ**:

1. **モデルを作る** → SQLAlchemy ORM モデルを定義
2. **autogenerate** → マイグレーションファイルを自動生成
3. **upgrade** → データベースに変更を適用

このワークフローをマスターすれば、データベーススキーマの変更管理が簡単になります。
