# Bank/Fintech Transfer Ledger — ER diagram

```mermaid
erDiagram
    direction LR
    customer {
        bigint customer_id PK
        text full_name
        text email UK
        date created_date
    }
    account {
        bigint account_id PK
        bigint customer_id FK
        text account_number UK
        text account_type
        numeric balance
        date opened_date
    }
    transfer {
        bigint transfer_id PK
        bigint account_id FK
        numeric amount
        text request_key
        text status
        timestamptz occurred_at
    }
    customer ||--o{ account : "customer_id"
    account ||--o{ transfer : "account_id"
```

PK identifies a record; FK links to another table; UK marks a single-field unique value. The relationship ends show exactly one, zero or one, or zero or many records. Composite unique keys and conditional rules are listed in the schema and design.

[Diagram image](../images/Etukessien_Akaninyene_301910192_ERDiagram.png)
