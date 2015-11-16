--testing transactions
--deposit
UPDATE BI_accounts
SET current_balance = current_balance + 101.35
WHERE id = 1;

INSERT INTO BI_account_transactions (payee_account_id, payer_account_id, amount, transaction_date, transaction_type_id, memo, posting_date, isVoid)
VALUES (1, 1, +101.35, CURRENT_TIMESTAMP, 1, "Testing, 1,2,3", CURRENT_TIMESTAMP, 0);

--withdrawl
UPDATE BI_accounts
SET current_balance = current_balance - 100.50
WHERE id = 7;

INSERT INTO BI_account_transactions (payee_account_id, payer_account_id, amount, transaction_date, transaction_type_id, memo, posting_date, isVoid)
VALUES (7, 7, -100.50, CURRENT_TIMESTAMP, 1, "Testing, 1,2,3", CURRENT_TIMESTAMP, 0);

--transfer
UPDATE BI_accounts
SET current_balance = current_balance - 100.50
WHERE id = 3;

INSERT INTO BI_account_transactions (payee_account_id, payer_account_id, amount, transaction_date, transaction_type_id, memo, posting_date, isVoid)
VALUES (5, 3, -100.50, CURRENT_TIMESTAMP, 1, "Testing, 1,2,3", CURRENT_TIMESTAMP, 0);

UPDATE BI_accounts
SET current_balance = current_balance + 100.50
WHERE id = 5;

INSERT INTO BI_account_transactions (payee_account_id, payer_account_id, amount, transaction_date, transaction_type_id, memo, posting_date, isVoid)
VALUES (5, 3, +100.50, CURRENT_TIMESTAMP, 1, "Testing, 1,2,3", CURRENT_TIMESTAMP, 0);