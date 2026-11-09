# Bank/Fintech Transfer Ledger — normalisation

The example uses the saved sample records. The full set of fields is in the design and schema.

## Starting grouped records

| account_id | transfer records (list) |
| --- | --- |
| 201 | [301] |
| 202 | [302] |


The record IDs are grouped in a list. In 1NF, each record has its own row and each cell holds one value.

## 1NF: one value per cell

| transfer.transfer_id | transfer.account_id | transfer.request_key | account.account_id | account.customer_id | account.account_number | customer.customer_id | customer.full_name |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 301 | 201 | req-001 | 201 | 101 | ACCT-1001 | 101 | Avery Chen |
| 302 | 202 | req-002 | 202 | 102 | ACCT-1002 | 102 | Jordan Patel |

Key: transfer_id.

## 2NF: depend on the whole key

transfer: account_id is a proper part of candidate key (account_id, request_key), and determines account details.

## account_example

| account.account_id | account.customer_id | account.account_number | customer.customer_id | customer.full_name |
| --- | --- | --- | --- | --- |
| 201 | 101 | ACCT-1001 | 101 | Avery Chen |
| 202 | 102 | ACCT-1002 | 102 | Jordan Patel |

## transfer_example

| transfer.transfer_id | transfer.account_id | transfer.request_key |
| --- | --- | --- |
| 301 | 201 | req-001 |
| 302 | 202 | req-002 |

## 3NF: store each entity’s details once

The entity keys determine their own descriptions. Related records keep foreign keys rather than repeating those descriptions.

## customer

| customer_id | full_name | email | created_date |
| --- | --- | --- | --- |
| 101 | Avery Chen | avery.chen@example.test | 2025-01-15 |
| 102 | Jordan Patel | jordan.patel@example.test | 2025-02-20 |

## account

| account_id | customer_id | account_number | account_type | balance | opened_date |
| --- | --- | --- | --- | --- | --- |
| 201 | 101 | ACCT-1001 | checking | 1200.5 | 2025-03-01 |
| 202 | 102 | ACCT-1002 | savings | 85 | 2025-04-12 |

## transfer

| transfer_id | account_id | amount | request_key | status | occurred_at |
| --- | --- | --- | --- | --- | --- |
| 301 | 201 | 125.75 | req-001 | posted | 2025-05-01T10:15:00+00:00 |
| 302 | 202 | 20 | req-002 | pending | 2025-05-02T11:30:00+00:00 |

## Dependencies

- customer: (customer_id) → full_name, email, created_date
- account: (account_id) → customer_id, account_number, account_type, balance, opened_date
- transfer: (transfer_id) → account_id, amount, request_key, status, occurred_at

Joining the decomposed sample tables reproduces the original 2 example rows. The design assumes the declared keys describe the relevant business dependencies.
