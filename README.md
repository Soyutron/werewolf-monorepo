# AI Werewolf - Development Guide

このプロジェクトは **WSL2（Ubuntu）+ Docker + Makefile** を前提とした  
ローカル開発環境で動作します。

ドキュメントはすべて **Docusaurus** にまとめてあります。

---

## 🚀 必要な環境

### 1. WSL2（Ubuntu）

Windows 上で Linux 開発環境を提供するため、**WSL2 が必須**です。

**インストール：**

```bash
wsl --install
```

### 2. Docker Desktop

Docker は Windows 側でインストールし、  
**「WSL2 Backend を使用する」**設定をオンにしてください。

```
Docker Desktop → Settings → General
☑ Use the WSL 2 based engine
```

### 3. Make

Ubuntu 環境で Make を使用します。

```bash
sudo apt update
sudo apt install make
```

---

## 📦 プロジェクト構成

```
ai-werewolf/
├── docker-compose.dev.yml     # 開発環境
├── docker-compose.prod.yml    # 本番環境
├── Makefile                   # プロジェクト管理用コマンド
├── apps/                      # プロジェクトコード
└── docs/                      # Docusaurus（ドキュメント）
```

---

## 🛠 Makefile の使い方

このプロジェクトは Makefile を公式 CLI として使用しています。  
すべての操作を Make コマンドで行えます。

### 開発環境を起動（Next.js + FastAPI + Docs すべて）

```bash
make dev
```

### バックグラウンドで起動

```bash
make dev-bg
```

### コンテナ停止

```bash
make down
```

### ログ表示

```bash
make logs
```

### 個別起動

```bash
make frontend
make backend
make docs
```

### 利用可能なコマンド一覧

```bash
make help
```

---

## 📚 ドキュメント（Docusaurus）

このプロジェクトのドキュメントは  
`docs/` ディレクトリで管理されています。

**開発用ホットリロードで起動：**

```bash
make docs-up
```

Docusaurus は以下の URL で確認できます：

```
http://localhost:4444
```

---

## 🔧 本番環境

本番用の Docker イメージを起動するには：

```bash
make prod
```

**停止：**

```bash
make prod-down
```

---

## 💡 注意点（重要）

- **必ず WSL 内で開発してください**（VSCode は "WSL: Ubuntu" モード）。
- Windows のパス（`/mnt/c/...`）で Docker を動かすと権限問題が発生します。  
  → `/home/ユーザー名/projects` 内で実行してください。
- **Docker Desktop は WSL2 を利用するように設定してください。**
