--transaction queries (deposit, withdrawl, transfer, payment)

--deposit
UPDATE BI_accounts
SET current_balance = current_balance + [amount]
WHERE user_id = [CURR_USER] AND account_type_id = (SELECT id FROM BI_account_types WHERE type_name = [CURR_SELECT]);

INSERT INTO BI_account_transactions (payee_account_id, payer_account_id, amount, transaction_date, transaction_type_id, memo, posting_date, isVoid)
VALUES (SELECT id FROM BI_accounts WHERE 
user_id = [CURR_USER] AND account_type_id = (SELECT id FROM BI_account_types WHERE type_name = [CURR_SELECT]),
SELECT id FROM BI_accounts WHERE 
user_id = [CURR_USER] AND account_type_id = (SELECT id FROM BI_account_types WHERE type_name = [CURR_SELECT]), 
+[amount], CURRENT_TIMESTAMP, 1, [memo], CURRENT_TIMESTAMP, 0);

--withdrawl
UPDATE BI_accounts
SET current_balance = current_balance - [amount]
WHERE user_id = [CURR_USER] AND account_type_id = (SELECT id FROM BI_account_types WHERE type_name = [CURR_SELECT]);

INSERT INTO BI_account_transactions (payee_account_id, payer_account_id, amount, transaction_date, transaction_type_id, memo, posting_date, isVoid)
VALUES (SELECT id FROM BI_accounts WHERE 
user_id = [CURR_USER] AND account_type_id = (SELECT id FROM BI_account_types WHERE type_name = [CURR_SELECT]),
SELECT id FROM BI_accounts WHERE 
user_id = [CURR_USER] AND account_type_id = (SELECT id FROM BI_account_types WHERE type_name = [CURR_SELECT]), 
-[amount], CURRENT_TIMESTAMP, 4, [memo], CURRENT_TIMESTAMP, 0);

--transfer
UPDATE BI_accounts
SET current_balance = current_balance - [amount]
WHERE user_id = [CURR_USER] AND account_type_id = (SELECT id FROM BI_account_types WHERE type_name = [CURR_SELECT]);

INSERT INTO BI_account_transactions (payee_account_id, payer_account_id, amount, transaction_date, transaction_type_id, memo, posting_date, isVoid)
VALUES (SELECT id FROM BI_accounts WHERE 
user_id = [USER_SELECT] AND account_type_id = (SELECT id FROM BI_account_types WHERE type_name = [CURR_SELECT]),
SELECT id FROM BI_accounts WHERE 
user_id = [CURR_USER] AND account_type_id = (SELECT id FROM BI_account_types WHERE type_name = [CURR_SELECT]), 
-[amount], CURRENT_TIMESTAMP, 3, [memo], CURRENT_TIMESTAMP, 0);

UPDATE BI_accounts
SET current_balance = current_balance + [amount]
WHERE user_id = [USER_SELECT] AND account_type_id = (SELECT id FROM BI_account_types WHERE type_name = [CURR_SELECT]);

INSERT INTO BI_account_transactions (payee_account_id, payer_account_id, amount, transaction_date, transaction_type_id, memo, posting_date, isVoid)
VALUES (SELECT id FROM BI_accounts WHERE 
user_id = [USER_SELECT] AND account_type_id = (SELECT id FROM BI_account_types WHERE type_name = [CURR_SELECT]),
SELECT id FROM BI_accounts WHERE 
user_id = [CURR_USER] AND account_type_id = (SELECT id FROM BI_account_types WHERE type_name = [CURR_SELECT]), 
+[amount], CURRENT_TIMESTAMP, 3, [memo], CURRENT_TIMESTAMP, 0);

--payment (same as transfer, except recorded as payment)
UPDATE BI_accounts
SET current_balance = current_balance - [amount]
WHERE user_id = [CURR_USER] AND account_type_id = (SELECT id FROM BI_account_types WHERE type_name = [CURR_SELECT]);

INSERT INTO BI_account_transactions (payee_account_id, payer_account_id, amount, transaction_date, transaction_type_id, memo, posting_date, isVoid)
VALUES (SELECT id FROM BI_accounts WHERE 
user_id = [USER_SELECT] AND account_type_id = (SELECT id FROM BI_account_types WHERE type_name = [CURR_SELECT]),
SELECT id FROM BI_accounts WHERE 
user_id = [CURR_USER] AND account_type_id = (SELECT id FROM BI_account_types WHERE type_name = [CURR_SELECT]), 
-[amount], CURRENT_TIMESTAMP, 2, [memo], CURRENT_TIMESTAMP, 0);

UPDATE BI_accounts
SET current_balance = current_balance + [amount]
WHERE user_id = [USER_SELECT] AND account_type_id = (SELECT id FROM BI_account_types WHERE type_name = [CURR_SELECT]);

INSERT INTO BI_account_transactions (payee_account_id, payer_account_id, amount, transaction_date, transaction_type_id, memo, posting_date, isVoid)
VALUES (SELECT id FROM BI_accounts WHERE 
user_id = [USER_SELECT] AND account_type_id = (SELECT id FROM BI_account_types WHERE type_name = [CURR_SELECT]),
SELECT id FROM BI_accounts WHERE 
user_id = [CURR_USER] AND account_type_id = (SELECT id FROM BI_account_types WHERE type_name = [CURR_SELECT]), 
+[amount], CURRENT_TIMESTAMP, 2, [memo], CURRENT_TIMESTAMP, 0);