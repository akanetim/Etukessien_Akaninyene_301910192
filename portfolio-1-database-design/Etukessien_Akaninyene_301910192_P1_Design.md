# Bank/Fintech Transfer Ledger — database design

My case study records customer, account, transfer.

## Users

- Banking customers
- Operations staff
- Database students

## Main operations

- Maintain customer and account records
- Record outgoing transfers
- Review transfer activity and totals

## Entities

| Entity | Information stored |
| --- | --- |
| customer | Stores a synthetic customer profile. |
| account | Stores an account owned by one customer and its current balance. |
| transfer | Records one outgoing debit request from an account. |

## customer

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| customer_id | BIGINT | PK | Yes |
| full_name | TEXT |  | Yes |
| email | TEXT | Unique | Yes |
| created_date | DATE |  | Yes |
- Unique key: (email).

## account

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| account_id | BIGINT | PK | Yes |
| customer_id | BIGINT | FK | Yes |
| account_number | TEXT | Unique | Yes |
| account_type | TEXT |  | Yes |
| balance | NUMERIC(18,2) |  | Yes |
| opened_date | DATE |  | Yes |
- customer_id → customer.customer_id
- Unique key: (account_number).

## transfer

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| transfer_id | BIGINT | PK | Yes |
| account_id | BIGINT | FK | Yes |
| amount | NUMERIC(18,2) |  | Yes |
| request_key | TEXT |  | Yes |
| status | TEXT |  | Yes |
| occurred_at | TIMESTAMPTZ |  | Yes |
- account_id → account.account_id
- Unique key: (account_id, request_key).

## Relationships and business rules

- Each customer email identifies at most one customer.
- Every account must reference an existing customer.
- An account balance must be greater than or equal to zero.
- Every transfer must reference an existing account.
- A transfer amount must be greater than zero.
- A request key may be used only once per account to prevent duplicate transfer records.

## Assumptions

- The supplied scenario contains only a Bank/Fintech label and a link, so the exercise uses a generic account-based outgoing-transfer case.
- Each transfer debits one account; recipient and payment-network details are outside this model.
- All records and benchmark rows are synthetic.
- A transfer amount is positive, while an account balance must remain nonnegative.

