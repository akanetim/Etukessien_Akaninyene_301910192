# Bank/Fintech Transfer Ledger — SQL queries

## 1. Show related customer, account records (up to 20).

```sql
SELECT t0."customer_id" AS "customer_customer_id",
       t0."full_name" AS "customer_full_name",
       t1."account_id" AS "account_account_id",
       t1."account_number" AS "account_account_number"
FROM portfolio."customer" t0
JOIN portfolio."account" t1 ON t1."customer_id" = t0."customer_id"
ORDER BY t0."customer_id", t1."account_id"
LIMIT 20;
```

| customer_customer_id | customer_full_name | account_account_id | account_account_number |
| --- | --- | --- | --- |
| 101 | Avery Chen | 201 | ACCT-1001 |
| 102 | Jordan Patel | 202 | ACCT-1002 |

## 2. Find account records where customer_id matches 101 (up to 20).

```sql
SELECT * FROM portfolio."account"
WHERE "customer_id" IS NOT DISTINCT FROM 101
ORDER BY "account_id"
LIMIT 20;
```

| account_id | customer_id | account_number | account_type | balance | opened_date |
| --- | --- | --- | --- | --- | --- |
| 201 | 101 | ACCT-1001 | checking | 1200.5 | 2025-03-01 |

## 3. Count account records for each customer_id (up to 20 groups).

```sql
SELECT "customer_id", count(*) AS record_count
FROM portfolio."account"
GROUP BY "customer_id"
ORDER BY record_count DESC, "customer_id" NULLS LAST
LIMIT 20;
```

| customer_id | record_count |
| --- | --- |
| 101 | 1 |
| 102 | 1 |

## 4. Find transfer records where occurred_at matches "2025-05-01T10:15:00Z" (up to 20).

```sql
SELECT * FROM portfolio."transfer"
WHERE "occurred_at" IS NOT DISTINCT FROM '2025-05-01T10:15:00Z'
ORDER BY "transfer_id"
LIMIT 20;
```

| transfer_id | account_id | amount | request_key | status | occurred_at |
| --- | --- | --- | --- | --- | --- |
| 301 | 201 | 125.75 | req-001 | posted | 2025-05-01T10:15:00+00:00 |


## Index comparison

| Phase | Median (ms) | Three runs (ms) | Plan nodes | Buffer hits |
| --- | --- | --- | --- | --- |
| Before index | 2.432 | 7.622, 2.428, 2.432 | Sort → Seq Scan | 274 |
| After index | 0.278 | 0.271, 0.295, 0.278 | Sort → Bitmap Heap Scan → Bitmap Index Scan | 55 |

The median execution time changed from 2.432 ms to 0.278 ms. The measured plan used p2_filter_idx. The results matched in both phases. An index adds storage and write-maintenance costs; timings depend on the selected lookup and environment.

## Execution plans

### Before index, run 1

```text
Sort (actual time=7.562..7.567 rows=50 loops=1)
  Seq Scan on transfer (actual time=0.02..7.503 rows=50 loops=1)
Planning Time: 0.553 ms
Execution Time: 7.622 ms
```

### Before index, run 2

```text
Sort (actual time=2.396..2.399 rows=50 loops=1)
  Seq Scan on transfer (actual time=0.014..2.358 rows=50 loops=1)
Planning Time: 0.324 ms
Execution Time: 2.428 ms
```

### Before index, run 3

```text
Sort (actual time=2.402..2.405 rows=50 loops=1)
  Seq Scan on transfer (actual time=0.014..2.362 rows=50 loops=1)
Planning Time: 0.348 ms
Execution Time: 2.432 ms
```

### After index, run 1

```text
Sort (actual time=0.217..0.22 rows=50 loops=1)
  Bitmap Heap Scan on transfer (actual time=0.028..0.179 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.013..0.013 rows=50 loops=1)
Planning Time: 0.56 ms
Execution Time: 0.271 ms
```

### After index, run 2

```text
Sort (actual time=0.24..0.243 rows=50 loops=1)
  Bitmap Heap Scan on transfer (actual time=0.029..0.203 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.014..0.014 rows=50 loops=1)
Planning Time: 0.523 ms
Execution Time: 0.295 ms
```

### After index, run 3

```text
Sort (actual time=0.223..0.225 rows=50 loops=1)
  Bitmap Heap Scan on transfer (actual time=0.028..0.183 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.013..0.014 rows=50 loops=1)
Planning Time: 0.564 ms
Execution Time: 0.278 ms
```

## Reproduce

Use a fresh database with the Portfolio 1 schema and sample data. Run Etukessien_Akaninyene_301910192_P2_Queries.sql, then Etukessien_Akaninyene_301910192_P2_Optimisation.sql. The optimisation script creates a separate performance table and runs EXPLAIN (ANALYZE, BUFFERS).

[Query screenshot](screenshots/Etukessien_Akaninyene_301910192_P2_QueryResults.png) · [Index comparison](screenshots/Etukessien_Akaninyene_301910192_P2_IndexComparison.png)

## References

- [PostgreSQL — EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html)

