-- Run these deliberately invalid statements one at a time, outside a transaction.
-- Each should fail at the named constraint; the sample rows should remain unchanged.

-- 1. customer pk duplicate. Expected: pk_customer, SQLSTATE 23505.
INSERT INTO portfolio."customer" ("customer_id", "full_name", "email", "created_date")
VALUES (101, 'Morgan Lee', 'morgan.lee@example.test', '2025-06-01');

-- 2. customer email duplicate. Expected: uq_customer_0, SQLSTATE 23505.
INSERT INTO portfolio."customer" ("customer_id", "full_name", "email", "created_date")
VALUES (401, 'Morgan Lee', 'avery.chen@example.test', '2025-06-02');

-- 3. customer id null. Expected: customer_id, SQLSTATE 23502.
INSERT INTO portfolio."customer" ("customer_id", "full_name", "email", "created_date")
VALUES (NULL, 'Riley Kim', 'riley.kim@example.test', '2025-06-03');

-- 4. customer name null. Expected: full_name, SQLSTATE 23502.
INSERT INTO portfolio."customer" ("customer_id", "full_name", "email", "created_date")
VALUES (402, NULL, 'casey.park@example.test', '2025-06-04');

-- 5. customer email null. Expected: email, SQLSTATE 23502.
INSERT INTO portfolio."customer" ("customer_id", "full_name", "email", "created_date")
VALUES (403, 'Casey Park', NULL, '2025-06-05');

-- 6. customer date null. Expected: created_date, SQLSTATE 23502.
INSERT INTO portfolio."customer" ("customer_id", "full_name", "email", "created_date")
VALUES (404, 'Taylor Reed', 'taylor.reed@example.test', NULL);

-- 7. account pk duplicate. Expected: pk_account, SQLSTATE 23505.
INSERT INTO portfolio."account" ("account_id", "customer_id", "account_number", "account_type", "balance", "opened_date")
VALUES (201, 101, 'ACCT-2001', 'checking', 50, '2025-06-06');

-- 8. account number duplicate. Expected: uq_account_0, SQLSTATE 23505.
INSERT INTO portfolio."account" ("account_id", "customer_id", "account_number", "account_type", "balance", "opened_date")
VALUES (501, 101, 'ACCT-1001', 'checking', 50, '2025-06-07');

-- 9. account customer missing. Expected: fk_account_0, SQLSTATE 23503.
INSERT INTO portfolio."account" ("account_id", "customer_id", "account_number", "account_type", "balance", "opened_date")
VALUES (502, 99999, 'ACCT-2002', 'checking', 50, '2025-06-08');

-- 10. account id null. Expected: account_id, SQLSTATE 23502.
INSERT INTO portfolio."account" ("account_id", "customer_id", "account_number", "account_type", "balance", "opened_date")
VALUES (NULL, 101, 'ACCT-2003', 'checking', 50, '2025-06-09');

-- 11. account customer null. Expected: customer_id, SQLSTATE 23502.
INSERT INTO portfolio."account" ("account_id", "customer_id", "account_number", "account_type", "balance", "opened_date")
VALUES (503, NULL, 'ACCT-2004', 'checking', 50, '2025-06-10');

-- 12. account number null. Expected: account_number, SQLSTATE 23502.
INSERT INTO portfolio."account" ("account_id", "customer_id", "account_number", "account_type", "balance", "opened_date")
VALUES (504, 101, NULL, 'checking', 50, '2025-06-11');

-- 13. account type null. Expected: account_type, SQLSTATE 23502.
INSERT INTO portfolio."account" ("account_id", "customer_id", "account_number", "account_type", "balance", "opened_date")
VALUES (505, 101, 'ACCT-2005', NULL, 50, '2025-06-12');

-- 14. account balance null. Expected: balance, SQLSTATE 23502.
INSERT INTO portfolio."account" ("account_id", "customer_id", "account_number", "account_type", "balance", "opened_date")
VALUES (506, 101, 'ACCT-2006', 'checking', NULL, '2025-06-13');

-- 15. account date null. Expected: opened_date, SQLSTATE 23502.
INSERT INTO portfolio."account" ("account_id", "customer_id", "account_number", "account_type", "balance", "opened_date")
VALUES (507, 101, 'ACCT-2007', 'checking', 50, NULL);

-- 16. account balance negative. Expected: account_balance_nonnegative, SQLSTATE 23514.
INSERT INTO portfolio."account" ("account_id", "customer_id", "account_number", "account_type", "balance", "opened_date")
VALUES (508, 101, 'ACCT-2008', 'checking', -1, '2025-06-14');

-- 17. transfer pk duplicate. Expected: pk_transfer, SQLSTATE 23505.
INSERT INTO portfolio."transfer" ("transfer_id", "account_id", "amount", "request_key", "status", "occurred_at")
VALUES (301, 201, 15, 'req-101', 'posted', '2025-06-15T12:00:00Z');

-- 18. transfer request duplicate. Expected: uq_transfer_0, SQLSTATE 23505.
INSERT INTO portfolio."transfer" ("transfer_id", "account_id", "amount", "request_key", "status", "occurred_at")
VALUES (601, 201, 15, 'req-001', 'posted', '2025-06-16T12:00:00Z');

-- 19. transfer account missing. Expected: fk_transfer_0, SQLSTATE 23503.
INSERT INTO portfolio."transfer" ("transfer_id", "account_id", "amount", "request_key", "status", "occurred_at")
VALUES (602, 99999, 15, 'req-102', 'posted', '2025-06-17T12:00:00Z');

-- 20. transfer id null. Expected: transfer_id, SQLSTATE 23502.
INSERT INTO portfolio."transfer" ("transfer_id", "account_id", "amount", "request_key", "status", "occurred_at")
VALUES (NULL, 201, 15, 'req-103', 'posted', '2025-06-18T12:00:00Z');

-- 21. transfer account null. Expected: account_id, SQLSTATE 23502.
INSERT INTO portfolio."transfer" ("transfer_id", "account_id", "amount", "request_key", "status", "occurred_at")
VALUES (603, NULL, 15, 'req-104', 'posted', '2025-06-19T12:00:00Z');

-- 22. transfer amount null. Expected: amount, SQLSTATE 23502.
INSERT INTO portfolio."transfer" ("transfer_id", "account_id", "amount", "request_key", "status", "occurred_at")
VALUES (604, 201, NULL, 'req-105', 'posted', '2025-06-20T12:00:00Z');

-- 23. transfer request null. Expected: request_key, SQLSTATE 23502.
INSERT INTO portfolio."transfer" ("transfer_id", "account_id", "amount", "request_key", "status", "occurred_at")
VALUES (605, 201, 15, NULL, 'posted', '2025-06-21T12:00:00Z');

-- 24. transfer status null. Expected: status, SQLSTATE 23502.
INSERT INTO portfolio."transfer" ("transfer_id", "account_id", "amount", "request_key", "status", "occurred_at")
VALUES (606, 201, 15, 'req-106', NULL, '2025-06-22T12:00:00Z');

-- 25. transfer time null. Expected: occurred_at, SQLSTATE 23502.
INSERT INTO portfolio."transfer" ("transfer_id", "account_id", "amount", "request_key", "status", "occurred_at")
VALUES (607, 201, 15, 'req-107', 'posted', NULL);

-- 26. transfer amount zero. Expected: transfer_amount_positive, SQLSTATE 23514.
INSERT INTO portfolio."transfer" ("transfer_id", "account_id", "amount", "request_key", "status", "occurred_at")
VALUES (608, 201, 0, 'req-108', 'posted', '2025-06-23T12:00:00Z');
