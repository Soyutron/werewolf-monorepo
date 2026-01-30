# UI コンポーネントの追加方法（shadcn/ui）

本プロジェクトでは UI ライブラリとして **shadcn/ui** を採用しています。

コンポーネントは必要になったタイミングで **個別に追加** してください。

## 📥 コンポーネントの追加方法

### 基本的な追加コマンド

例）Button コンポーネントを追加

```bash
npx shadcn@latest add button
```

### 自動的に行われること

追加すると、以下が自動的に行われます：

- `/components/ui/` 以下に対応コンポーネントが生成される
- 依存するスタイル・ユーティリティが自動で取り込まれる
- TypeScript 対応済みの UI がそのまま使える状態になる

## 📚 よく使うコンポーネント例

```bash
npx shadcn@latest add input
npx shadcn@latest add card
npx shadcn@latest add dropdown-menu
npx shadcn@latest add dialog
```

## 📝 注意点

- **新しいコンポーネントを追加するときは Next.js プロジェクトのルートで実行してください**
- **カスタム UI を追加したい場合は `/components/ui/` 配下のファイルを直接編集可能です**
- **プロジェクトを clone した場合は set up のために以下を実行してください：**

```bash
npx shadcn@latest init
```
