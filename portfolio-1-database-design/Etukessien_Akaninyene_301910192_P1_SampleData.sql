-- Fictional sample records for Bank/Fintech Transfer Ledger.
BEGIN;
SET LOCAL standard_conforming_strings = on;
INSERT INTO portfolio."customer" ("customer_id", "full_name", "email", "created_date") VALUES (101, 'Avery Chen', 'avery.chen@example.test', '2025-01-15');
INSERT INTO portfolio."customer" ("customer_id", "full_name", "email", "created_date") VALUES (102, 'Jordan Patel', 'jordan.patel@example.test', '2025-02-20');
INSERT INTO portfolio."account" ("account_id", "customer_id", "account_number", "account_type", "balance", "opened_date") VALUES (201, 101, 'ACCT-1001', 'checking', 1200.5, '2025-03-01');
INSERT INTO portfolio."account" ("account_id", "customer_id", "account_number", "account_type", "balance", "opened_date") VALUES (202, 102, 'ACCT-1002', 'savings', 85, '2025-04-12');
INSERT INTO portfolio."transfer" ("transfer_id", "account_id", "amount", "request_key", "status", "occurred_at") VALUES (301, 201, 125.75, 'req-001', 'posted', '2025-05-01T10:15:00Z');
INSERT INTO portfolio."transfer" ("transfer_id", "account_id", "amount", "request_key", "status", "occurred_at") VALUES (302, 202, 20, 'req-002', 'pending', '2025-05-02T11:30:00+00:00');
COMMIT;
