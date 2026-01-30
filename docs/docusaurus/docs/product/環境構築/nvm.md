---
sidebar_label: 'nvm'
sidebar_position: 2
---
# Node.js セットアップガイド

**Node Version Manager(nvm)** を使う方法が最も安定・安全・便利です。

### 理由：

- Node の複数バージョンを簡単に切り替えられる
- WSL と相性が良い
- npm も自動でインストールされる
- Node の最新バージョンにも対応できる

---

## 🟢 ① nvm をインストールする

最新のnvmは下記のURLで確認できます。
https://github.com/nvm-sh/nvm?tab=readme-ov-file#install--update-script

WSL(Ubuntu) を開いて以下を実行：

```bash
sudo apt update
sudo apt install curl -y
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
```

次に、シェルを再読み込み：

```bash
source ~/.bashrc
```

動作確認：

```bash
nvm --version
```

---

## 🟢 ② Node.js をインストールする

### 例：最新の LTS（安定版）を入れる

```bash
nvm install --lts
```

### 例：特定バージョンを入れる（例: 24）

```bash
nvm install 24
```

### 使うバージョンを設定

```bash
nvm use 24
```

### デフォルト設定

```bash
nvm alias default 24
```

---

## 🟢 ③ npm の確認

Node を入れると npm は自動で付いてくる。

確認：

```bash
node -v
npm -v
```