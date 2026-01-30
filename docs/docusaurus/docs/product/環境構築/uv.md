---
sidebar_label: "uv"
sidebar_position: 3
---

# uv のインストール手順（WSL Ubuntu）

uv は公式が提供している**ワンライナーでインストール**するのが最も簡単・安全です。

## ① 必要な基本パッケージを更新

```bash
sudo apt update
sudo apt install -y curl
```

## ② uv の公式インストールスクリプトを実行

uv は Rust 製の高速ツールで、以下のコマンドだけで導入できます。

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

## ③ PATH を反映する

インストール後、uv の PATH を通す必要があります。

以下を実行：

```bash
source ~/.bashrc
```

確認：

```bash
uv --version
```

→ バージョンが表示されれば成功！

## ④ 仮想環境を作成

```bash
uv venv venv
```

アクティベート：

```bash
source venv/bin/activate
```

## ⑤ パッケージ管理（pip 互換）

uv は pip より **10〜100 倍高速**。

パッケージ追加：

```bash
uv add fastapi
uv add langchain
uv add --group dev black
uv add --dev black
```
