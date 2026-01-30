# Chatwork 送信くん — データベース設計

本ページでは、Chatwork 送信くん（FastAPI + Next.js）の **公式 DB 設計** をまとめています。

## 🎯 目的

- Chatwork のルームへ **一斉送信** できる仕組みを作る
- 送信先を **グループ化して管理** できる
- 過去の送信内容を **ログとして保持** する

---

# 🗄️ データベース構成（PostgreSQL）

## 1. users（アプリユーザー）

| カラム名      | 型                      | 説明                 |
| ------------- | ----------------------- | -------------------- |
| user_id       | SERIAL PK               | ユーザー ID          |
| email         | VARCHAR(255) UNIQUE     | メールアドレス       |
| password_hash | TEXT                    | パスワードのハッシュ |
| user_name     | VARCHAR(255)            | 表示名               |
| created_at    | TIMESTAMP DEFAULT now() | 作成日時             |
| updated_at    | TIMESTAMP DEFAULT now() | 更新日時             |

---

## 2. rooms（Chatwork ルーム）

| カラム名  | 型                          | 説明                           |
| --------- | --------------------------- | ------------------------------ |
| room_id   | BIGINT PK                   | Chatwork の room_id            |
| room_name | VARCHAR(255)                | 表示用                         |
| type      | VARCHAR(50) DEFAULT 'group' | ルーム種別（デフォルト group） |

---

## 3. message_groups（宛先グループ）

| カラム名           | 型                      | 説明        |
| ------------------ | ----------------------- | ----------- |
| message_group_id   | SERIAL PK               | グループ ID |
| user_id            | INT                     | 作成者      |
| message_group_name | VARCHAR(255)            | グループ名  |
| created_at         | TIMESTAMP DEFAULT now() | 作成日時    |

---

## 4. group_rooms（グループに紐づく Chatwork ルーム）

| カラム名         | 型                          | 説明                           |
| ---------------- | --------------------------- | ------------------------------ |
| group_room_id    | SERIAL PK                   | ID                             |
| message_group_id | INT                         | グループ ID                    |
| room_id          | BIGINT                      | Chatwork の room_id            |
| room_name        | VARCHAR(255)                | 表示用                         |
| type             | VARCHAR(50) DEFAULT 'group' | ルーム種別（デフォルト group） |

---

## 5. message_logs（送信ログ）

| カラム名           | 型                      | 説明                      |
| ------------------ | ----------------------- | ------------------------- |
| message_log_id     | SERIAL PK               | ログ ID                   |
| user_id            | INT                     | 送信ユーザー ID           |
| user_name          | VARCHAR(255)            | 送信ユーザー              |
| message_group_id   | INT                     | 宛先グループ              |
| message_group_name | VARCHAR(255)            | グループ名                |
| room_id            | BIGINT                  | 送信先 room_id            |
| room_name          | VARCHAR(255)            | 送信当時のルーム名        |
| text               | TEXT                    | 実際に送信したテキスト    |
| file_name          | VARCHAR(255)            | ファイル名                |
| status             | VARCHAR(20)             | success / failed          |
| response_body      | Text                    | Chatwork API のレスポンス |
| created_at         | TIMESTAMP DEFAULT now() | 送信日時                  |

---

# 📊 ER 図（Mermaid）

以下は Docusaurus + Mermaid で動く安全な形式です。

```mermaid
erDiagram
    users {
        SERIAL user_id PK
        VARCHAR email
        TEXT password_hash
        VARCHAR user_name
        TIMESTAMP created_at
        TIMESTAMP updated_at
    }

    rooms {
        BIGINT room_id PK
        VARCHAR room_name
        VARCHAR type
    }

    message_groups {
        SERIAL message_group_id PK
        INT user_id
        VARCHAR message_group_name
        TIMESTAMP created_at
    }

    group_rooms {
        SERIAL group_room_id PK
        INT message_group_id
        BIGINT room_id
        VARCHAR room_name
        VARCHAR type
    }

    message_logs {
        SERIAL message_log_id PK
        INT user_id
        VARCHAR user_name
        INT message_group_id
        VARCHAR message_group_name
        BIGINT room_id
        VARCHAR room_name
        TEXT text
        VARCHAR file_name
        VARCHAR status
        Text response_body
        TIMESTAMP created_at
    }

    %% 関係線（FK 制約はつけないが ER 図としては関連を見せる）
    users ||--o{ message_groups : "1:N"
    users ||--o{ message_logs : "1:N"
    message_groups ||--o{ group_rooms : "1:N"
    message_groups ||--o{ message_logs : "1:N"
    rooms ||--o{ group_rooms : "1:N"
    rooms ||--o{ message_logs : "1:N"

```
